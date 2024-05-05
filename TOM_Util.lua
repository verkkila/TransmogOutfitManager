TOM = {}
TOM.DROPDOWN_RENAME = 1
TOM.DROPDOWN_DELETE = 2
TOM.SLOTID_TO_NAME = {
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
MyOutfits = {}

function TOM_GetTransmogId(slot)
	if slot.hasUndo then return slot.base
	elseif slot.pending ~= 0 then return slot.pending
	elseif slot.applied ~= 0 then return slot.applied
	else return slot.base end
end

function TOM_IsValidName(name)
	local nameLength = string.len(name)
	if nameLength == 0 or nameLength > 15 then
		return false
	else
		return true
	end
end

function TOM_NumSavedOutfits()
	local count = 0
	for _, outfit in pairs(MyOutfits) do
		if outfit.name then count = count + 1 end
	end
	return count
end