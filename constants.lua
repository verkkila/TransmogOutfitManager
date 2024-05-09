local addonName, TOM = ...

TOM.const = TOM.const or {}
TOM.const.DROPDOWN_RENAME = 1
TOM.const.DROPDOWN_DELETE = 2
TOM.const.BORDERTYPE_APPLIED = 1
TOM.const.BORDERTYPE_SELECTED = 2
-- TODO rename
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


function TOM.GetTransmogId(slot)
	if slot.hasUndo then return tonumber(slot.base)
	elseif slot.pending > 0 then return tonumber(slot.pending)
	elseif slot.applied > 0 then return tonumber(slot.applied)
	else return tonumber(slot.base) end
end

--TODO rename
local function GetEffectiveSlotId(slot)
	if slot.pending > 0 then return tonumber(slot.pending)
	elseif slot.applied > 0 then return tonumber(slot.applied)
	else return tonumber(slot.base) end
end

function TOM.IsValidName(name)
	local nameLength = string.len(name)
	if nameLength == 0 or nameLength > 15 then
		return false
	else
		return true
	end
end

--TODO: fix unmaintainable logic
function TOM.IsOutfitApplied(outfit)
	for slotId, slotName in pairs(TOM.const.SLOTID_TO_NAME) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		local equippedIdForSlot = GetEffectiveSlotId({applied=appliedSourceID, pending=0, base=baseSourceID, hasUndo=hasUndo})
		local outfitIdForSlot = GetEffectiveSlotId(outfit.data[slotName])
		if outfit.data[slotName].hasUndo then return false end
		if equippedIdForSlot ~= outfitIdForSlot then return false end
	end
	TOM.appliedOutfitName = outfit.name
	return true
end

function TOM.IsOutfitSelected(outfit)
	for slotId, slotName in pairs(TOM.const.SLOTID_TO_NAME) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		local equippedIdForSlot = TOM.GetTransmogId({applied=appliedSourceID, pending=pendingSourceID, base=baseSourceID, hasUndo=hasUndo})
		local outfitIdForSlot = TOM.GetTransmogId(outfit.data[slotName])
		if equippedIdForSlot ~= outfitIdForSlot then return false end
	end
	TOM.selectedOutfitName = outfit.name
	return true
end

