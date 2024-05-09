local addonName, TOM = ...

TransmogOutfitManagerDB = TransmogOutfitManagerDB or {}
TOM.DB = TOM.DB or {}

local numOutfits = nil

local function validateOutfit(outfit)
    --TODO: validate data and metadata
    return outfit.name ~= nil
end

function TOM.DB.Init()
    TOM.DB._sources = {}
    TOM.DB._sources.charDB = TransmogOutfitManagerDB
    --TOM.DB_source.accDB = TransmogOutfitManagerDBAccount
end

function TOM.DB.OutfitExists(index)
    --additional validation, possibly an enum result
    return TOM.DB._sources.charDB[index] ~= nil
end

function TOM.DB.GetOutfit(index)
    return TOM.DB._sources.charDB[index]
end

function TOM.DB.GetAllOutfits()
    local i = 0
    local max = TOM.DB.NumSavedOutfits()
    return  function()
                i = i + 1
                if i <= max then return TOM.DB._sources.charDB[i] end
            end
end

function TOM.DB.SaveOutfit(outfitName, outfitData)
    --TODO: add metadata
    local outfit = {name = outfitName, data = outfitData}
    if validateOutfit(outfit) then
	    table.insert(TOM.DB._sources.charDB, outfit)
        numOutfits = numOutfits + 1
    end
end

function TOM.DB.RenameOutfit(oldName, newName)
    local outfitIndex = TOM.DB.OutfitExistsByName(oldName)
    if outfitIndex > 0 then
        TOM.DB._sources.charDB[outfitIndex].name = newName
    end
    return outfitIndex
end

function TOM.DB.DeleteOutfitByName(outfitName)
    local outfitIndex = TOM.DB.OutfitExistsByName(outfitName)
    if outfitIndex > 0 and table.remove(TOM.DB._sources.charDB, outfitIndex) then
        numOutfits = max(0, numOutfits - 1)
    end
end

function TOM.DB.OverwriteOutfit(outfitName, newData)
    --data validation, return values
    local outfitIndex = TOM.DB.OutfitExistsByName(outfitName)
    if outfitIndex > 0 then
        TOM.DB._sources.charDB[outfitIndex].data = newData
    end
end

function TOM.DB.NumSavedOutfits()
    --if outfits have been counted then return that count, otherwise do manual count
    if numOutfits then
        return numOutfits
    end
    return TOM.CountOutfits()
end

function TOM.DB.OutfitExistsByName(name)
	for index, outfit in ipairs(TOM.DB._sources.charDB) do
		if outfit.name == name then return index end
	end
	return 0
end

--is checking by name necessary here?
function TOM.DB.IsWearingOutfit(outfitName)
	for _, outfit in pairs(TOM.DB._sources.charDB) do
		if outfit.name == outfitName then
			return TOM.IsOutfitSelected(outfit)
		end
	end
	return false
end

function TOM.DB.CountOutfits()
    numOutfits = 0
    for _, outfit in pairs(TOM.DB._sources.charDB) do
        if validateOutfit(outfit) then
            numOutfits = numOutfits + 1
        end
    end
end