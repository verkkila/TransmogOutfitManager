local addonName, TOM = ...

TransmogOutfitManagerDB = TransmogOutfitManagerDB or {}

local numOutfits = nil

local function TOM_ValidateOutfitSchema(outfit)
    --TODO: validate data and metadata
    return outfit.name ~= nil
end

function TOM.OutfitExists(index)
    --additional validation, possibly an enum result
    return TransmogOutfitManagerDB[index] ~= nil
end

function TOM.GetOutfit(index)
    return TransmogOutfitManagerDB[index]
end

function TOM.GetAllOutfits()
    local i = 0
    local max = TOM.NumSavedOutfits()
    return  function()
                i = i + 1
                if i <= max then return TransmogOutfitManagerDB[i] end
            end
end

function TOM.SaveOutfit(outfitName, outfitData)
    --TODO: add metadata
    local outfit = {name = outfitName, data = outfitData}
    if TOM_ValidateOutfitSchema(outfit) then
	    table.insert(TransmogOutfitManagerDB, outfit)
        numOutfits = numOutfits + 1
    end
end

function TOM.RenameOutfit(oldName, newName)
    local outfitIndex = TOM.OutfitExistsByName(oldName)
    if outfitIndex > 0 then
        TransmogOutfitManagerDB[outfitIndex].name = newName
    end
    return outfitIndex
end

function TOM.DeleteOutfitByName(outfitName)
    local outfitIndex = TOM.OutfitExistsByName(outfitName)
    if outfitIndex > 0 and table.remove(TransmogOutfitManagerDB, outfitIndex) then
        numOutfits = max(0, numOutfits - 1)
    end
end

function TOM.OverwriteOutfit(outfitName, newData)
    --data validation, return values
    local outfitIndex = TOM.OutfitExistsByName(outfitName)
    if outfitIndex > 0 then
        TransmogOutfitManagerDB[outfitIndex].data = newData
    end
end

function TOM.NumSavedOutfits()
    --if outfits have been counted then return that count, otherwise do manual count
    if numOutfits then
        return numOutfits
    end
    return TOM.CountOutfits()
end

function TOM.OutfitExistsByName(name)
	for index, outfit in ipairs(TransmogOutfitManagerDB) do
		if outfit.name == name then return index end
	end
	return 0
end

function TOM.IsWearingOutfit(outfitName)
	for _, outfit in pairs(TransmogOutfitManagerDB) do
		if outfit.name == outfitName then
			return TOM.IsOutfitSelected(outfit)
		end
	end
	return false
end

--TODO: do this only once when savedvariables is loaded
function TOM.CountOutfits()
    numOutfits = 0
    for _, outfit in pairs(TransmogOutfitManagerDB) do
        if TOM_ValidateOutfitSchema(outfit) then
            numOutfits = numOutfits + 1
        end
    end
end