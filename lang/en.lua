--------------------------------------------
-- English localization for Currency Manager
-- Author: Onigar
-- Version: 1.5.0
--------------------------------------------

-- all language convertable strings
local strings = {

	CM_ADDON_LONG_NAME				= "Currency manager", 						-- works ok
	
	CM_CHAR_VAR_FIXED				= "Fixed",
	CM_CHAR_VAR_EMPTY				= "Empty",
	CM_CHAR_VAR_NONE				= "None",

	CM_PREFIX_ONLY					= " Only ", 							-- works ok
	CM_PREFIX_WITHDREW				= " withdrew ", 						-- works ok
	CM_PREFIX_DEPOSITED				= " deposited ", 						-- works ok
	CM_POSTFIX_GOLD					= " gold ", 									-- works ok
	CM_POSTFIX_GOLD_AVAILABLE		= " gold available in the bank", 			-- works ok
	CM_POSTFIX_TEL_VAR				= " Tel Var stones",						-- works ok
	CM_POSTFIX_TEL_VAR_AVAILABLE	= " Tel Var stones available in the bank",	-- works ok
	CM_POSTFIX_AP					= " Alliance points",						-- works ok
	CM_POSTFIX_AP_AVAILABLE			= " Alliance points available in the bank",	-- works ok
	CM_POSTFIX_WRIT_VOUCHERS		= " Writ vouchers",							-- works ok
	CM_POSTFIX_WRIT_VOUCH_AVAILABLE	= " Writ vouchers available in the bank",	-- works ok

	CM_ADDON_DESCRIPTION			= "Automatic management of character bankable currencies",	-- works ok

	CM_MANAGEMENT_TYPE_TIP			= "Select the management type",
	CM_POSTFIX_MANAGEMENT_TYPE		= " Management type",						-- works ok
	CM_POSTFIX_FIXED_AMOUNT			= " Fixed amount",							-- works ok

	CM_PREFIX_GOLD_TITLE			= "Gold:",									-- works ok
	CM_GOLD_FIXED_AMOUNT_TIP		= "Enter the Gold to keep in your Bag",						-- TBD does not display

	CM_PREFIX_TEL_VAR_TITLE			= "Tel Var stones:",						-- works ok
	CM_TEL_VAR_FIXED_AMOUNT_TIP		= "Enter the Tel Var stones to keep in your Bag",			-- TBD does not display
	CM_TEL_VAR_MULTIPLIER_NOTE		= "Multiplier amounts are, 100 = x2, 1,000 = x3, 10,000 = x4",	-- works ok

	CM_AP_TITLE						= "Alliance points:",						-- works ok
	CM_AP_FIXED_AMOUNT_TIP			= "Enter the alliance points to keep in your bag",			-- TBD does not display

	CM_WRIT_VOUCHER_TITLE			= "Writ Vouchers:",							-- works ok
	CM_WRIT_FIXED_AMOUNT_TIP		= "Enter the Writ Vouchers to keep in your bag",			-- TBD does not display

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