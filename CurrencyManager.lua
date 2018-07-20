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
	Description = "When accessing a bank the currencies betwean the character and the bank are managed per add-on's setup.",
	Version = "18.07.14",
	--SavedVarsVersion = 1,
	License = "CC BY-NC-SA: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International",
	git = "vbn",
	www = "http://www.esoui.com/downloads/info1998-CurrencyManager.html#info"
}
-- set to CurrencyManager.Title for first use by Initialize()
local name = CurrencyManager.Title
local characterVar = {}
local charSettings = {}

-- Default Setting is to take no action allowing the User to define Currency Transfer Rules
local defaultCharacterVariables = {
		accountWide 					= false,
		goldManagementType				= GetString(CM_CHAR_VAR_NONE),
		goldFixedAmount					= 5000,
		telVarStonesManagementType		= GetString(CM_CHAR_VAR_NONE),
		telVarStonesFixedAmount			= 100,
		alliancePointsManagementType	= GetString(CM_CHAR_VAR_NONE),
		alliancePointsFixedAmount		= 5000,
		writVouchersManagementType		= GetString(CM_CHAR_VAR_NONE),
		writVouchersFixedAmount			= 0,
}


local function TransferGold()

	--	Initialize variable for transfer amount.
	local transferAmount = 0
	--	Get amount character has in bag
	local goldBag = GetCurrentMoney()
	--	Get amount in bank
	local goldBank = GetBankedMoney()
	
	
	--	Get transfer amount based on management type
	if characterVar.goldManagementType == GetString(CM_CHAR_VAR_FIXED) then				--	Fixed management:
		transferAmount = goldBag - characterVar.goldFixedAmount
	elseif characterVar.goldManagementType == GetString(CM_CHAR_VAR_EMPTY) then			--	Empty management:
		transferAmount = goldBag
	else																				--	None, no management:
		transferAmount = 0
	end

	--	Using the transfer amount value(+/-) request a deposit or a withdrawal
	if transferAmount < 0 then
		transferAmount = math.abs(transferAmount)
		if transferAmount > goldBank then
			d(GetString(CM_PREFIX_ONLY) .. goldBank .. GetString(CM_POSTFIX_GOLD_AVAILABLE))
			transferAmount = goldBank
		end
		WithdrawCurrencyFromBank(CURT_MONEY, transferAmount)
		if transferAmount > 0 then
			d(GetString(CM_PREFIX_WITHDREW) .. transferAmount .. GetString(CM_POSTFIX_GOLD))
		end
	else
		DepositCurrencyIntoBank(CURT_MONEY, transferAmount)
		if transferAmount > 0 then
			d(GetString(CM_PREFIX_DEPOSITED) .. transferAmount .. GetString(CM_POSTFIX_GOLD))
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
		transferAmount = bagTelVarStones - characterVar.telVarStonesFixedAmount
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
			d(GetString(CM_PREFIX_DEPOSITED) .. transferAmount .. GetString(CM_POSTFIX_TEL_VAR))
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
		transferAmount = alliancePointsBag - characterVar.alliancePointsFixedAmount
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
			d(GetString(CM_PREFIX_DEPOSITED) .. transferAmount .. GetString(CM_POSTFIX_AP))
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
		transferAmount = writVouchersBag - characterVar.writVouchersFixedAmount
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
			d(GetString(CM_PREFIX_DEPOSITED) .. transferAmount .. GetString(CM_POSTFIX_WRIT_VOUCHERS))
		end
	end
end


local function CreateSettingsMenu()

	local LAM = LibStub("LibAddonMenu-2.0")

	local panelData = {
		type = "panel",
		-- name = the title you see in the list of addons when displayed by "Settings, Addons" 
		name = GetString(CM_ADDON_LONG_NAME),
		-- displayName = the title at the top of the addon panel
		displayName = "|c4a9300" .. GetString(CM_ADDON_LONG_NAME) .. "|r",
		author = CurrencyManager.Author,
		version = CurrencyManager.Version,
		registerForRefresh = true,
		registerForDefaults = true,
		website = CurrencyManager.www
	}
	LAM:RegisterAddonPanel("CurrencyManagerPanel", panelData)

	local optionsData = {
		
		{
            type = "description",
			text = ZO_HIGHLIGHT_TEXT:Colorize(GetString(CM_ADDON_DESCRIPTION)),
            width = "full"
        },

		-- Account Wide Settings
		-- divider
        {	type = "divider", width = "full" },
		{
			type = "checkbox",
			name = GetString(CM_ACCOUNT_WIDE_TITLE),
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
		
		-- Gold Management
		-- divider
        {	type = "divider", width = "full" },
		{
			type = "dropdown",
			name = "|cffff24" .. GetString(CM_PREFIX_GOLD_TITLE) .. "|r" .. GetString(CM_POSTFIX_MANAGEMENT_TYPE),
			tooltip = GetString(CM_MANAGEMENT_TYPE_TIP),
			default = defaultCharacterVariables.goldManagementType,
			choices = {GetString(CM_CHAR_VAR_FIXED), GetString(CM_CHAR_VAR_EMPTY), GetString(CM_CHAR_VAR_NONE)},
		 
			getFunc = 	function()
							return characterVar.goldManagementType
						end,
			setFunc = 	function(choice)
							characterVar.goldManagementType = choice
						end,
		},
		{
			type = "editbox",
			name = "|cffff24" .. GetString(CM_PREFIX_GOLD_TITLE) .. "|r" .. GetString(CM_POSTFIX_FIXED_AMOUNT),
			tooltip = GetString(CM_GOLD_FIXED_AMOUNT_TIP),
			default = defaultCharacterVariables.goldFixedAmount,
			
			getFunc = 	function() 
							return characterVar.goldFixedAmount 
						end,
			setFunc = 	function(choice)
							characterVar.goldFixedAmount = choice
						end,
		},
		
		-- Tel Var Stones Management
		-- divider
        {	type = "divider", width = "full" },
		{
			type = "dropdown",
			name = "|c2492ff" .. GetString(CM_PREFIX_TEL_VAR_TITLE) .. "|r" .. GetString(CM_POSTFIX_MANAGEMENT_TYPE),
			tooltip = GetString(CM_MANAGEMENT_TYPE_TIP),
			default = defaultCharacterVariables.telVarStonesManagementType,
			choices = {GetString(CM_CHAR_VAR_FIXED), GetString(CM_CHAR_VAR_EMPTY), GetString(CM_CHAR_VAR_NONE)},
		 
			getFunc = 	function()
							return characterVar.telVarStonesManagementType
						end,
			setFunc = 	function(choice)
							characterVar.telVarStonesManagementType = choice
						end,
		},
		{
			type = "editbox",
			name = "|c2492ff" .. GetString(CM_PREFIX_TEL_VAR_TITLE) .. "|r" .. GetString(CM_POSTFIX_FIXED_AMOUNT),
			tooltip = GetString(CM_TEL_VAR_FIXED_AMOUNT_TIP),
			default = defaultCharacterVariables.telVarStonesFixedAmount,
			
			getFunc = 	function() 
							return characterVar.telVarStonesFixedAmount 
						end,
			setFunc = 	function(choice)
							characterVar.telVarStonesFixedAmount = choice
						end,
		},
		{
            type = "description",
            text = GetString(CM_TEL_VAR_MULTIPLIER_NOTE),
            width = "full"
        },
		
		-- Alliance Points Management
		-- divider
        {	type = "divider", width = "full" },
		{
			type = "dropdown",
			name = "|c24ff24" .. GetString(CM_AP_TITLE) .. "|r" .. GetString(CM_POSTFIX_MANAGEMENT_TYPE),
			tooltip = GetString(CM_MANAGEMENT_TYPE_TIP),
			default = defaultCharacterVariables.alliancePointsManagementType,
			choices = {GetString(CM_CHAR_VAR_FIXED), GetString(CM_CHAR_VAR_EMPTY), GetString(CM_CHAR_VAR_NONE)},
		 
			getFunc = 	function()
							return characterVar.alliancePointsManagementType
						end,
			setFunc = 	function(choice)
							characterVar.alliancePointsManagementType = choice
						end,
		},
		{
			type = "editbox",
			name = "|c24ff24" .. GetString(CM_AP_TITLE) .. "|r" .. GetString(CM_POSTFIX_FIXED_AMOUNT),
			tooltip = GetString(CM_AP_FIXED_AMOUNT_TIP),
			default = defaultCharacterVariables.alliancePointsFixedAmount,
			
			getFunc = 	function() 
							return characterVar.alliancePointsFixedAmount 
						end,
			setFunc = 	function(choice)
							characterVar.alliancePointsFixedAmount = choice
						end,
		},
		
		-- Writ Voucher Management
		-- divider
        {	type = "divider", width = "full" },
		{
			type = "dropdown",
			name = "|cffff90" .. GetString(CM_WRIT_VOUCHER_TITLE) .. "|r" .. GetString(CM_POSTFIX_MANAGEMENT_TYPE),
			tooltip = GetString(CM_MANAGEMENT_TYPE_TIP),
			default = defaultCharacterVariables.writVouchersManagementType,
			choices = {GetString(CM_CHAR_VAR_FIXED), GetString(CM_CHAR_VAR_EMPTY), GetString(CM_CHAR_VAR_NONE)},
		 
			getFunc = 	function()
							return characterVar.writVouchersManagementType
						end,
			setFunc = 	function(choice)
							characterVar.writVouchersManagementType = choice
						end,
		},
		{
			type = "editbox",
			name = "|cffff90" .. GetString(CM_WRIT_VOUCHER_TITLE) .. "|r" .. GetString(CM_POSTFIX_FIXED_AMOUNT),
			tooltip = GetString(CM_WRIT_FIXED_AMOUNT_TIP),
			default = defaultCharacterVariables.writVouchersFixedAmount,
			
			getFunc = 	function() 
							return characterVar.writVouchersFixedAmount 
						end,
			setFunc = 	function(choice)
							characterVar.writVouchersFixedAmount = choice
						end,
		},
		-- divider
        {	type = "divider", width = "full" },
        {
            type = "description",
			text = ZO_HIGHLIGHT_TEXT:Colorize(GetString(CM_MANAGEMENT_TYPE_OPTIONS)),
            width = "full"
        },
		{
            type = "description",
            text = "|c5cb700" .. GetString(CM_CHAR_VAR_FIXED) .. "|r" .. GetString(CM_MAN_TYPE_FIXED_DESC),
            width = "full"
        },
        {
            type = "description",
            text = "|c5cb700" .. GetString(CM_CHAR_VAR_EMPTY) .. "|r" .. GetString(CM_MAN_TYPE_EMPTY_DESC),
            width = "full"
        },
		{
            type = "description",
            text = "|c5cb700" .. GetString(CM_CHAR_VAR_NONE) .. "|r" .. GetString(CM_MAN_TYPE_NONE_DESC),
            width = "full"
        },
		-- divider
        {	type = "divider", width = "full" },
	}
	LAM:RegisterOptionControls("CurrencyManagerPanel", optionsData)
end

local function OnBankOpen(event)
	TransferGold()
	TransferTelVarStones()
	TransferAlliancePoints()
	TransferWritVouchers()
end

local function getSettings()
	if charSettings.byAccount.accountWide then
		return charSettings.byAccount
	else
		return charSettings.byChar
	end
end

local function Initialize()
	--	Connect with Account Wide saved Variables
	--  ZO_SavedVars:NewAccountWide(savedVariableTable, version, namespace, defaults, profile, displayName) 
	charSettings.byAccount = ZO_SavedVars:NewAccountWide("CurrencyManagerSettings", 3, nil, defaultCharacterVariables)

	--	Connect with Character Based saved Variables
	--  ZO_SavedVars:NewCharacterNameSettings(savedVariableTable, version, namespace, defaults, profile)
	--  ZO_SavedVars:NewCharacterIdSettings(savedVariableTable, version, namespace, defaults, profile)
	--  Note: 
	--  NewCharacterNameSettings saves readable char name in the addon saved var file
	--  NewCharacterIdSettings saves a numeric id instead of the char name in the addon saved var file
	charSettings.byChar = ZO_SavedVars:NewCharacterNameSettings("CurrencyManagerSettings", 3, nil, defaultCharacterVariables)

	-- Use Character or Account Wide Settings
	characterVar = getSettings()
	
	--	Generate Settings Menu
	CreateSettingsMenu()

	--	Register listener(s) for event(s)
	EVENT_MANAGER:RegisterForEvent("CurrencyManagerBankOpen", EVENT_OPEN_BANK, OnBankOpen)

	--	Cleanup:
	--	After our event has loaded, do not need to listen for further calls.
	EVENT_MANAGER:UnregisterForEvent(name, EVENT_ADD_ON_LOADED)

end

local function OnAddOnLoaded(event, addonLoading)
	if addonLoading ~= CurrencyManager.Title then
		Initialize()
	end
end
EVENT_MANAGER:RegisterForEvent(name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
