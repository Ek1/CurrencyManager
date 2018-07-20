--------------------------------------------
-- English localization for Currency Manager
-- Author: Onigar
-- Version: 1.5.0
--------------------------------------------

-- all language convertable strings
local strings = {

	CM_ADDON_LONG_NAME				= "Currency Manager", 						-- works ok
	
	CM_CHAR_VAR_FIXED				= "Fixed",
	CM_CHAR_VAR_EMPTY				= "Empty",
	CM_CHAR_VAR_NONE				= "None",

	CM_PREFIX_ONLY					= "[CM] Only ", 							-- works ok
	CM_PREFIX_WITHDREW				= "[CM] Withdrew: ", 						-- works ok
	CM_PREFIX_DEPOSITED				= "[CM] Deposited: ", 						-- works ok
	CM_POSTFIX_GOLD					= " Gold", 									-- works ok
	CM_POSTFIX_GOLD_AVAILABLE		= " Gold available in the bank", 			-- works ok
	CM_POSTFIX_TEL_VAR				= " Tel Var Stones",						-- works ok
	CM_POSTFIX_TEL_VAR_AVAILABLE	= " Tel Var Stones available in the bank",	-- works ok
	CM_POSTFIX_AP					= " Alliance Points",						-- works ok
	CM_POSTFIX_AP_AVAILABLE			= " Alliance Points available in the bank",	-- works ok
	CM_POSTFIX_WRIT_VOUCHERS		= " Writ Vouchers",							-- works ok
	CM_POSTFIX_WRIT_VOUCH_AVAILABLE	= " Writ Vouchers available in the bank",	-- works ok

	CM_ADDON_DESCRIPTION			= "Automatic Management of Character Bankable Currencies",	-- works ok

	CM_MANAGEMENT_TYPE_TIP			= "Select the Management Type",
	CM_POSTFIX_MANAGEMENT_TYPE		= " Management Type",						-- works ok
	CM_POSTFIX_FIXED_AMOUNT			= " Fixed Amount",							-- works ok

	CM_PREFIX_GOLD_TITLE			= "Gold:",									-- works ok
	CM_GOLD_FIXED_AMOUNT_TIP		= "Enter the Gold to keep in your Bag",						-- TBD does not display

	CM_PREFIX_TEL_VAR_TITLE			= "Tel Var Stones:",						-- works ok
	CM_TEL_VAR_FIXED_AMOUNT_TIP		= "Enter the Tel Var Stones to keep in your Bag",			-- TBD does not display
	CM_TEL_VAR_MULTIPLIER_NOTE		= "Note: Multiplier Amounts are, 100 = x2, 1,000 = x3, 10,000 = x4",	-- works ok

	CM_AP_TITLE						= "Alliance Points:",						-- works ok
	CM_AP_FIXED_AMOUNT_TIP			= "Enter the Alliance Points to keep in your Bag",			-- TBD does not display

	CM_WRIT_VOUCHER_TITLE			= "Writ Vouchers:",							-- works ok
	CM_WRIT_FIXED_AMOUNT_TIP		= "Enter the Writ Vouchers to keep in your Bag",			-- TBD does not display

	CM_MANAGEMENT_TYPE_OPTIONS		= "Management Type Options",
	CM_MAN_TYPE_FIXED_DESC			= " = Will keep preset amount in Bag",
	CM_MAN_TYPE_EMPTY_DESC			= " = All in Bag to Bank",
	CM_MAN_TYPE_NONE_DESC			= " = No Management (Default)",
	
	CM_ACCOUNT_WIDE_TITLE			= "Use Account Wide Settings",
	CM_ACCOUNT_WIDE_TIP				= "When set from [OFF] to [ON] it loads the Account Wide Settings and saves the Settings for all Characters, the reverse works the same way",

}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end