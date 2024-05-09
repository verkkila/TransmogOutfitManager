local addonName, TOM = ...

--is it better to put these in their respective files?
TOM.const = TOM.const or {}
TOM.const.DROPDOWN_RENAME = 1
TOM.const.DROPDOWN_DELETE = 2
TOM.const.BORDERTYPE_APPLIED = 1
TOM.const.BORDERTYPE_SELECTED = 2
TOM.const.SLOTID_TO_NAME = {
		[1] = "HEADSLOT",
		[3] = "SHOULDERSLOT",
		[4] = "SHIRTSLOT",
		[5] = "CHESTSLOT",
		[6] = "WAISTSLOT",
		[7] = "LEGSSLOT",
		[8] = "FEETSLOT",
		[9] = "WRISTSLOT",
		[10] = "HANDSSLOT",
		[15] = "BACKSLOT",
		[16] = "MAINHANDSLOT",
		[17] = "SECONDARYHANDSLOT",
		[18] = "RANGEDSLOT",
		[19] = "TABARDSLOT"
}
TOM.const.ROWS = 2
TOM.const.COLS = 4
TOM.const.MODEL_WIDTH = 125
TOM.const.MODEL_HEIGHT = 175
TOM.const.SPACING = 10
TOM.const.OFFSET_X = 0
TOM.const.OFFSET_Y = 15