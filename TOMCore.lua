local addonName, TOM = ...
--TODO: add documentation

TOM.Core = TOM.Core or {}

TOM.Core.currentView = {}

local function getVisibleSlotId(slot)
	if slot.pending > 0 then return tonumber(slot.pending)
	elseif slot.applied > 0 then return tonumber(slot.applied)
	else return tonumber(slot.base) end
end

local function prctoindex(p, r, c)
	return ((p - 1) * 8) + ((r - 1) * 4 + c)
end

--very simple operation handlers for now
function TOM.Core.SaveOutfit(outfitName, outfitData)
	return TOM.DB.SaveOutfit(outfitName, outfitData)
end

--this shouldn't rely on the old name
function TOM.Core.RenameOutfit(oldName, newName)
	return TOM.DB.RenameOutfit(oldName, newName)
end

function TOM.Core.OverwriteOutfit(outfitName, outfitData)
	return TOM.DB.OverwriteOutfit(outfitName, outfitData)
end

function TOM.Core.DeleteOutfit(outfitName)
	return TOM.DB.DeleteOutfitByName(outfitName)
end

function TOM.Core.GetNumOutfits()
	return TOM.DB.NumSavedOutfits()
end

--is there an outfit for this position of the display
function TOM.Core.OutfitExists(page, row, column)
	return TOM.DB.OutfitExists(prctoindex(page, row, column))
end

--get outfit for this position
function TOM.Core.GetOutfit(page, row, column)
	return TOM.DB.GetOutfit(prctoindex(page, row, column))
end

--this should be an iterator
function TOM.Core.GetOutfitData(index)
	if TOM.DB.OutfitExists(index) then
		return TOM.DB.GetOutfit(index).data
	end
end

function TOM.Core.GetOutfitByName(outfitName)
	return TOM.DB.OutfitExistsByName(outfitName)
end

function TOM.Core.ResetDisplay()

end

function TOM.Core.DisplayOutfit(outfitName, page, row, column)
	TOM.Core.currentView[outfitName] = TOM.Display.GetModelFrame(row, column)
end

function TOM.Core.GetOutfitNameByFrame(previewModelFrame)
	for name, frame in pairs(TOM.Core.currentView) do
		if frame == previewModelFrame then return name end
	end
end

function TOM.Core.GetTransmogId(slot)
	if slot.hasUndo then return tonumber(slot.base)
	elseif slot.pending > 0 then return tonumber(slot.pending)
	elseif slot.applied > 0 then return tonumber(slot.applied)
	else return tonumber(slot.base) end
end

function TOM.Core.IsValidName(name)
	local nameLength = string.len(name)
	if nameLength == 0 or nameLength > 15 then
		return false
	else
		return true
	end
end

--TODO: fix unmaintainable logic, param should be a name, index or similar
function TOM.Core.IsOutfitApplied(outfit)
	for slotId, slotName in pairs(TOM.const.SLOTID_TO_NAME) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		local equippedIdForSlot = getVisibleSlotId({applied=appliedSourceID, pending=0, base=baseSourceID, hasUndo=hasUndo})
		local outfitIdForSlot = getVisibleSlotId(outfit.data[slotName])
		if outfit.data[slotName].hasUndo then return false end
		if equippedIdForSlot ~= outfitIdForSlot then return false end
	end
	TOM.appliedOutfitName = outfit.name
	return true
end

function TOM.Core.IsOutfitSelected(outfit)
	for slotId, slotName in pairs(TOM.const.SLOTID_TO_NAME) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		local equippedIdForSlot = TOM.Core.GetTransmogId({applied=appliedSourceID, pending=pendingSourceID, base=baseSourceID, hasUndo=hasUndo})
		local outfitIdForSlot = TOM.Core.GetTransmogId(outfit.data[slotName])
		if equippedIdForSlot ~= outfitIdForSlot then return false end
	end
	TOM.selectedOutfitName = outfit.name
	return true
end

--includes pending changes on the paperdoll
function TOM.Core.IsWearingOutfit(outfitName)
	local index = TOM.DB.OutfitExistsByName(outfitName)
	if index > 0 then return TOM.Core.IsOutfitSelected(TOM.DB.GetOutfit(index)) end
	return false -- false negative, outfit doesnt actually exist
end