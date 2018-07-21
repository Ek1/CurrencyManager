--	CurrencyManager by Onigar & Ek1
--[[This software is provided under the following CreativeCommons license:

	Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

You are free to:
 	Share — copy and redistribute the material in any medium or format
 	Adapt — remix, transform, and build upon the material
The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

Attribution
You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

NonCommercial
You may not use the material for commercial purposes.

ShareAlike
If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

No additional restrictions
You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

Notices:
You do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation.

No warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.

You can read the full license at: https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
]]

local CurrencyManager = {
	Title = "Currency manager",
	Author = "Onigar & Ek1",
	Description = "When accessing a bank the currencies betwean the character and the bank are managed per add-on's settings.",
	Version = "18.07.21",
	SavedVarsVersion = 21,
	License = "CC BY-NC-SA: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International",
	git = "https://github.com/Ek1/CurrencyManager",
	www = "http://www.esoui.com/downloads/info1998-CurrencyManager"
}
-- set to CurrencyManager.Title for first use by Initialize()
local characterVar = {}
local charSettings = {}
local bankerRepresentsHowManyCharacters = {}

-- Default Setting is to take no action allowing the User to define Currency Transfer Rules
local defaultCharacterVariables = {
	accountWide 			= false,
	manageGold				= false,
	manageGoldOption		= "Shares",
	goldFixedAmount			= 10000,
	goldPercentage			= 50,
	goldShares				= GetNumCharacters(),
	manageTelVar			= false,
	telVarFixed				= 100,
	manageAlliancePoints	= false,
	alliancePointsFixed		= 0,
	manageWritVouchers		= false,
	writVouchersFixed		= 0
}

local function TransferGold()

	-- Fixed management:
	if characterVar.manageGoldOption == "Fixed" then

	-- Initialize variable for transfer amount.
		local transferAmount = GetCurrentMoney() - characterVar.goldFixedAmount

	-- Using the transfer amount value(+/-) request a deposit or a withdrawal
		if transferAmount < 0 then
			transferAmount = math.abs(transferAmount)
			WithdrawCurrencyFromBank(CURT_MONEY, transferAmount)
			d(CurrencyManager.Title .. ": " .. GetString(CM_PREFIX_WITHDREW) .. transferAmount  .. GetString(CM_POSTFIX_GOLD))
		elseif 0 < transferAmount then
			DepositCurrencyIntoBank(CURT_MONEY, transferAmount)
			d(CurrencyManager.Title .. ": " .. GetString(CM_PREFIX_DEPOSITED)  .. transferAmount  .. GetString(CM_POSTFIX_GOLD))
		end
	end
	
	-- Percentage management
	if characterVar.manageGoldOption == "Percentage" then

		local total = GetBankedMoney() + GetCurrentMoney()
		local cashToBe = math.floor (total * (characterVar.goldPercentage/100) )

		--	Too little cash, withdrawing some.
		if GetCurrentMoney() < cashToBe then
			local transferAmount = cashToBe - GetCurrentMoney()
			WithdrawCurrencyFromBank(CURT_MONEY, transferAmount)
			d(CurrencyManager.Title .. ": " .. GetString(CM_PREFIX_WITHDREW) .. transferAmount .. GetString(CM_POSTFIX_GOLD))
		elseif cashToBe < GetCurrentMoney() then
			-- Too much cash, depositing some to bank.
			local transferAmount = GetCurrentMoney() - cashToBe
			DepositCurrencyIntoBank(CURT_MONEY, transferAmount)
			d(CurrencyManager.Title .. ": " .. GetString(CM_PREFIX_DEPOSITED)  .. transferAmount  .. GetString(CM_POSTFIX_GOLD))
		end
	end
	
	-- Shares management
	if characterVar.manageGoldOption == "Shares" then
		local totalGold = GetBankedMoney() + GetCurrentMoney()
		-- Variable that represents how big deal the banker is holding
		local everyoneElsesShareOnBanker = 0
		-- Maybe only one charter
		if GetNumCharacters() == 1 then
			everyoneElsesShareOnBanker = math.floor (1/2 * totalGold)
		else
		-- Maybe this character gets reduced or increased shares.
			everyoneElsesShareOnBanker = math.floor ((characterVar.goldShares / GetNumCharacters() ) * totalGold )
		end
		if GetBankedMoney() < everyoneElsesShareOnBanker then
			-- Carrying too much cash, counting how much should be deposited to bank 
			transferAmount = everyoneElsesShareOnBanker - GetBankedMoney()
			DepositCurrencyIntoBank(CURT_MONEY, transferAmount)
			d(CurrencyManager.Title .. ": " .. GetString(CM_PREFIX_DEPOSITED) .. transferAmount  .. GetString(CM_POSTFIX_GOLD))
		-- Using double if instead of if-else as then we can forget fractions
		elseif  everyoneElsesShareOnBanker < GetBankedMoney() then
			-- Carrying too little cash, counting how much should be withdrawing from bank
			transferAmount = GetBankedMoney() - everyoneElsesShareOnBanker
			WithdrawCurrencyFromBank(CURT_MONEY, transferAmount)
			d(CurrencyManager.Title .. ": " .. GetString(CM_PREFIX_WITHDREW).. transferAmount .. GetString(CM_POSTFIX_GOLD))
		end
	end
end

local function TransferTelVarStones()

	--	Initialize variable for transfer amount.
	local transferAmount = 0
	--	Get amount character has in bag
	local bagTelVarStones = GetCarriedCurrencyAmount(CURT_TELVAR_STONES)
	--	Get amount in bank
	local bankTelVarStones = GetBankedCurrencyAmount(CURT_TELVAR_STONES)

	--	Get transfer amount based on management type
	if characterVar.telVarStonesManagementType == GetString(CM_CHAR_VAR_FIXED) then		--	Fixed management:
		transferAmount = bagTelVarStones - characterVar.telVarFixed
	elseif characterVar.telVarStonesManagementType == GetString(CM_CHAR_VAR_EMPTY) then	--	Empty management:
		transferAmount = bagTelVarStones
	else																				--	None, no management:
		transferAmount = 0
	end

	--	Using the transfer amount value(+/-) request a deposit or a withdrawal
	if transferAmount < 0 then
		transferAmount = math.abs(transferAmount)
		if transferAmount > bankTelVarStones then
			d(GetString(CM_PREFIX_ONLY) .. bankTelVarStones .. GetString(CM_POSTFIX_TEL_VAR_AVAILABLE))
			transferAmount = bankTelVarStones
		end
		WithdrawCurrencyFromBank(CURT_TELVAR_STONES, transferAmount)
		if transferAmount > 0 then
			d(GetString(CM_PREFIX_WITHDREW) .. transferAmount .. GetString(CM_POSTFIX_TEL_VAR))
		end
	else
		DepositCurrencyIntoBank(CURT_TELVAR_STONES, transferAmount)
		if transferAmount > 0 then
			d(GetString(CM_PREFIX_DEPOSITEDED) .. transferAmount .. GetString(CM_POSTFIX_TEL_VAR))
		end
	end
end

local function TransferAlliancePoints()

	--	Initialize variable for transfer amount.
	local transferAmount = 0
	--	Get amount character has in bag
	local alliancePointsBag = GetCarriedCurrencyAmount(CURT_ALLIANCE_POINTS)
	--	Get amount in bank
	local alliancePointsBank = GetBankedCurrencyAmount(CURT_ALLIANCE_POINTS)

	--	Get transfer amount based on management type
	if characterVar.alliancePointsManagementType == GetString(CM_CHAR_VAR_FIXED) then	--	Fixed management:
		transferAmount = alliancePointsBag - characterVar.alliancePointsFixed
	elseif characterVar.alliancePointsManagementType == GetString(CM_CHAR_VAR_EMPTY) then	--	Empty management:
		transferAmount = alliancePointsBag
	else																				--	None, no management:
		transferAmount = 0
	end

	--	Using the transfer amount value(+/-) request a deposit or a withdrawal
	if transferAmount < 0 then
		transferAmount = math.abs(transferAmount)
		if transferAmount > alliancePointsBank then
			d(GetString(CM_PREFIX_ONLY) .. alliancePointsBank .. GetString(CM_POSTFIX_AP_AVAILABLE))
			transferAmount = alliancePointsBank
		end
		WithdrawCurrencyFromBank(CURT_ALLIANCE_POINTS, transferAmount)
		if transferAmount > 0 then
			d(GetString(CM_PREFIX_WITHDREW) .. transferAmount .. GetString(CM_POSTFIX_AP))
		end
	else
		DepositCurrencyIntoBank(CURT_ALLIANCE_POINTS, transferAmount)
		if transferAmount > 0 then
			d(GetString(CM_PREFIX_DEPOSITEDED) .. transferAmount .. GetString(CM_POSTFIX_AP))
		end
	end
end

local function TransferWritVouchers()

	--	Initialize variable for transfer amount.
	local transferAmount = 0
	--	Get amount character has in bag
	local writVouchersBag = GetCarriedCurrencyAmount(CURT_WRIT_VOUCHERS)
	--	Get amount in bank
	local writVouchersBank = GetBankedCurrencyAmount(CURT_WRIT_VOUCHERS)

	--	Get transfer amount based on management type
	if characterVar.writVouchersManagementType == GetString(CM_CHAR_VAR_FIXED) then		--	Fixed management:
		transferAmount = writVouchersBag - characterVar.writVouchersFixed
	elseif characterVar.writVouchersManagementType == GetString(CM_CHAR_VAR_EMPTY) then	--	Empty management:
		transferAmount = writVouchersBag
	else																				--	None, no management:
		transferAmount = 0
	end

	--	Using the transfer amount value(+/-) request a deposit or a withdrawal
	if transferAmount < 0 then
		transferAmount = math.abs(transferAmount)
		if transferAmount > writVouchersBank then
			d(GetString(CM_PREFIX_ONLY) .. writVouchersBank .. GetString(CM_POSTFIX_WRIT_VOUCH_AVAILABLE))
			transferAmount = writVouchersBank
		end
		WithdrawCurrencyFromBank(CURT_WRIT_VOUCHERS, transferAmount)
		if transferAmount > 0 then
			d(GetString(CM_PREFIX_WITHDREW) .. transferAmount .. GetString(CM_POSTFIX_WRIT_VOUCHERS))
		end
	else
		DepositCurrencyIntoBank(CURT_WRIT_VOUCHERS, transferAmount)
		if transferAmount > 0 then
			d(GetString(CM_PREFIX_DEPOSITEDED) .. transferAmount .. GetString(CM_POSTFIX_WRIT_VOUCHERS))
		end
	end
end

local function CreateSettingsMenu()

	local LAM = LibStub("LibAddonMenu-2.0")

	local panelData = {
		type = "panel",
		-- name = the title you see in the list of addons when displayed by "Settings, Addons" 
		name = CurrencyManager.Title,
		author = CurrencyManager.Author,
		version = CurrencyManager.Version,
		registerForRefresh = true,
		registerForDefaults = true,
		website = CurrencyManager.www
	}
	LAM:RegisterAddonPanel("CurrencyManagerPanel", panelData)

	local optionsData = {
	
		-- divider
        {	type = "divider"},
		
		-- Account Wide Settings
		{	name = "Account wide settings",
			type = "checkbox",
			tooltip = GetString(CM_ACCOUNT_WIDE_TIP),
			default = defaultCharacterVariables.accountWide,
			getFunc = 	function() 
							return charSettings.byAccount.accountWide
						end,
			setFunc = 	function(value) 
							charSettings.byAccount.accountWide = value 
						end,
			requiresReload = true,
		},

		-- divider
        {	type = "divider"},
	
		-- Gold Management
		{	name = "Manage |cffff24gold|r",
			type = "dropdown",
			tooltip = "Should the add-on handle gold and in what way",
			width = "half",
			default = defaultCharacterVariables.manageGold,
			choices = {"No", "Fixed", "Percentage", "Shares"},
			getFunc = 	function()
							if characterVar.manageGold then
								return characterVar.manageGoldOption
							else
								characterVar.manageGoldOption = "No"
								return characterVar.manageGoldOption
							end
						end,
			setFunc = 	function(choice)
							characterVar.manageGoldOption = choice
							if choice == "No" then
								characterVar.manageGold = false
							else
								characterVar.manageGold = true
							end
						end,
		},
		{	name = "Gold kept in bag",
			type = "editbox",
			width = "half",
			tooltip = GetString(CM_GOLD_FIXED_AMOUNT_TIP),
			default = defaultCharacterVariables.goldFixedAmount,
			getFunc = 	function() 
							return characterVar.goldFixedAmount 
						end,
			setFunc = 	function(choice)
							characterVar.goldFixedAmount = choice
						end,
			disabled = function() return not (characterVar.manageGoldOption == "Fixed") end
		},
		{	name = "From total",
			type = "slider",
			width = "half",
			tooltip = "What percentage is kept on charater of total gold",
			default = defaultCharacterVariables.goldPercentage,
			min = 1,
			max = 100,
			getFunc = 	function()
							return characterVar.goldPercentage 
						end,
			setFunc = 	function(choice)
							characterVar.goldPercentage = choice
						end,
			disabled = function() return not (characterVar.manageGoldOption == "Percentage") end
		},
		{	name = "Banker represents",
			type = "dropdown",
			tooltip = "Bank is holding other characters cut of the pot but you can also increase the cut for this character by reducing how many characters the banker represents. " .. GetNumCharacters()-1 .. " means that banker has half of total money while " .. (GetNumCharacters()-1)/2 .. " 25% and " .. (GetNumCharacters()-1)*2 .. " 75%. If bank reprents one character then only " .. math.floor(1/(GetNumCharacters()-1)*100) .. "% of gold is kept in there.",
			width = "half",
			default = (GetNumCharacters()-1),
			choices = {1, (GetNumCharacters()-1)/2, GetNumCharacters()-1, (GetNumCharacters()-1)*2},
			getFunc = 	function()
							return characterVar.goldShares
						end,
			setFunc = 	function(choice)
							characterVar.goldShares = choice
						end,
			disabled = function() return not (characterVar.manageGoldOption == "Shares") end
		},
		-- divider
        {	type = "divider"},
		-- Tel Var stones management
		{	name = "Manage |c2492ffTel Var|r stones",
			type = "checkbox",
			tooltip = GetString(CM_MANAGEMENT_TYPE_TIP),
			default = defaultCharacterVariables.manageTelVar,
			getFunc = function() 
						return characterVar.manageTelVar 
						end,
			setFunc = function(value) 
						characterVar.manageTelVar = value 
						end,
			width = "half"
		},
		{	name = "|c2492ffStones|r kept in bag",
			type = "dropdown",
			tooltip = "Ammount of |c2492ffTel Var|r stones kept in bag." .. GetString(CM_TEL_VAR_MULTIPLIER_NOTE),
			default = defaultCharacterVariables.telVarFixed,
			choices = {0,100,1000,10000},
			getFunc = 	function()
							return characterVar.telVarFixed
						end,
			setFunc = 	function(choice)
							characterVar.telVarFixed = choice
						end,
			width = "half",
			disabled = function() return not characterVar.manageTelVar end
		},
		-- divider
        {	type = "divider"},
		-- Alliance Points Management
		{	name = "Manage |c24ff24alliance|r points",
			type = "checkbox",
			tooltip = GetString(CM_MANAGEMENT_TYPE_TIP),
			default = defaultCharacterVariables.manageAlliancePoints,
			getFunc = function() 
						return characterVar.manageAlliancePoints 
						end,
			setFunc = function(value) 
						characterVar.manageAlliancePoints = value 
						end,
			width = "half"
		},
		{
			type = "editbox",
			name = "|c24ff24" .. GetString(CM_AP_TITLE) .. "|r" .. GetString(CM_POSTFIX_FIXED_AMOUNT),
			tooltip = GetString(CM_AP_FIXED_AMOUNT_TIP),
			default = defaultCharacterVariables.alliancePointsFixed,
			getFunc = 	function() 
							return characterVar.alliancePointsFixed 
						end,
			setFunc = 	function(choice)
							characterVar.alliancePointsFixed = choice
						end,
			width = "half",
			disabled = function() return not characterVar.manageAlliancePoints end
		},
		-- divider
        {	type = "divider"	},
		-- Writ Voucher Management
		{	name = "Manage |cffff90writ vouchers|r",
			type = "checkbox",
			tooltip = GetString(CM_MANAGEMENT_TYPE_TIP),
			default = defaultCharacterVariables.manageWritVouchers,
			getFunc = 	function()
							return characterVar.manageWritVouchers
						end,
			setFunc = 	function(choice)
							characterVar.manageWritVouchers = choice
						end,
			width = "half"
		},
		{	name = "|cffff90" .. GetString(CM_WRIT_VOUCHER_TITLE) .. "|r" .. GetString(CM_POSTFIX_FIXED_AMOUNT),
			type = "editbox",
			tooltip = GetString(CM_WRIT_FIXED_AMOUNT_TIP),
			default = defaultCharacterVariables.writVouchersFixed,
			
			getFunc = 	function() 
							return characterVar.writVouchersFixed 
						end,
			setFunc = 	function(choice)
							characterVar.writVouchersFixed = choice
						end,
			width = "half",
			disabled = function() return not characterVar.manageWritVouchers end
		},
	}
	LAM:RegisterOptionControls("CurrencyManagerPanel", optionsData)
end

local function OnBankOpen(event)
	if characterVar.manageGold then
		TransferGold() end
	if characterVar.manageTelVar then
		TransferTelVarStones() end
	if characterVar.manageAlliancePoints then
		TransferAlliancePoints() end
	if characterVar.manageWritVouchers then
		TransferWritVouchers() end
end

local function getSettings()
	if charSettings.byAccount.accountWide then
		return charSettings.byAccount
	else
		return charSettings.byChar
	end
end

local function OnAddOnLoaded(event, addonLoading)
	if addonLoading ~= CurrencyManager.Title then
		--	Connect with Account Wide saved Variables
		--  ZO_SavedVars:NewAccountWide(savedVariableTable, version, namespace, defaults, profile, displayName) 
		charSettings.byAccount = ZO_SavedVars:NewAccountWide("CurrencyManagerSettings", 3, nil, defaultCharacterVariables)

	--[[Connect with Character Based saved Variables
		ZO_SavedVars:NewCharacterNameSettings(savedVariableTable, version, namespace, defaults, profile)
		ZO_SavedVars:NewCharacterIdSettings(savedVariableTable, version, namespace, defaults, profile)
		Note: 
		NewCharacterNameSettings saves readable char name in the addon saved var file
		NewCharacterIdSettings saves a numeric id instead of the char name in the addon saved var file]]
		charSettings.byChar = ZO_SavedVars:NewCharacterNameSettings("CurrencyManagerSettings", 3, nil, defaultCharacterVariables)

		-- Use Character or Account Wide Settings
		characterVar = getSettings()
		
		--	Generate Settings Menu
		CreateSettingsMenu()

		--	Register listener(s) for event(s)
		EVENT_MANAGER:RegisterForEvent("CurrencyManagerBankOpen", EVENT_OPEN_BANK, OnBankOpen)

		--	After our event has loaded, do not need to listen for further calls.
		EVENT_MANAGER:UnregisterForEvent(CurrencyManager.Title, EVENT_ADD_ON_LOADED)
	end
end
EVENT_MANAGER:RegisterForEvent(CurrencyManager.Title, EVENT_ADD_ON_LOADED, OnAddOnLoaded)