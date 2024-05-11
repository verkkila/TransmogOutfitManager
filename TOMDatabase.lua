local addonName, TOM = ...

TransmogOutfitManagerDB = TransmogOutfitManagerDB or {}
TransmogOutfitManagerDBAccount = TransmogOutfitManagerDBAccount or {}
TOM.DB = TOM.DB or {}

local numOutfits = nil

--[[
metadata = TABLE
    owner = TABLE
        name = STRING
        realm = STRING
        class = STRING
    favoritedOn = TABLE
    createdAt = NUMBER
    modifiedAt = NUMBER
]]--
TOM.DB.Keys = {
    ["OWNER"] = "owner",
    ["OWNER_NAME"] = "name",
    ["OWNER_REALM"] = "realm",
    ["OWNER_CLASS"] = "class",
    ["FAVORITED_ON"] = "favoritedOn",
    ["CREATED_AT"] = "createdAt",
    ["MODIFIED_AT"] = "modifiedAt"
}

local function validateOutfit(outfit)
    --TODO: validate data and metadata
    return outfit.name ~= nil
end

local function getDefaultMetadata()
    local m = {}
    local now = GetServerTime()
    local myName = UnitName("player")
    local myRealm = GetRealmName()
    local myClass = select(2, UnitClass("player"))

    --this syntax is horrible
    m[TOM.DB.Keys["OWNER"]] = {}
    m[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_NAME"]] = myName
    m[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_REALM"]] = myRealm
    m[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_CLASS"]] = myClass
    m[TOM.DB.Keys["FAVORITED_ON"]] = {}
    m[TOM.DB.Keys["CREATED_AT"]] = now
    m[TOM.DB.Keys["MODIFIED_AT"]] = now
    return m
end

local function outfitInAccountDB(charOutfit)
    local myName = UnitName("player")
    local myRealm = GetRealmName()
    local myClass = select(2, UnitClass("player"))

    for _, accOutfit in pairs(TOM.DB._sources.accDB) do
        if accOutfit and accOutfit.metadata and accOutfit.name == charOutfit.name then
            return accOutfit.metadata[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_NAME"]] == myName and
                   accOutfit.metadata[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_REALM"]] == myRealm and
                   accOutfit.metadata[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_CLASS"]] == myClass
        end
    end
    return false
end

local function migrateOutfits()
    local count = 0
    for _, outfit in pairs(TOM.DB._sources.charDB) do
        if not outfitInAccountDB(outfit) then
            count = count + 1
            tinsert(TOM.DB._sources.accDB, {name = outfit.name, data = outfit.data, metadata = getDefaultMetadata()})
        end
    end
    return count
end

function TOM.DB.Init()
    TOM.DB._sources = {}
    TOM.DB._sources.charDB = TransmogOutfitManagerDB
    TOM.DB._sources.accDB = TransmogOutfitManagerDBAccount
    local migrated = migrateOutfits()
    print(migrated)
end

function TOM.DB.OutfitExists(index)
    --additional validation, possibly an enum result
    return TOM.DB._sources.accDB[index] ~= nil
end

function TOM.DB.GetOutfit(index)
    return TOM.DB._sources.accDB[index]
end

function TOM.DB.GetOutfitByName(outfitName)
    for _, outfit in pairs(TOM.DB._sources.accDB) do
       if outfit.name == outfitName then return outfit end
    end
    return nil
end

function TOM.DB.GetAllOutfits()
    local i = 0
    local max = TOM.DB.NumSavedOutfits()
    return  function()
                i = i + 1
                if i <= max then return TOM.DB._sources.accDB[i] end
            end
end

function TOM.DB.GetOutfitMetadata(outfitName, key)
    local outfit = TOM.DB.GetOutfitByName(outfitName)
    if outfit and outfit.metadata then
        return outfit.metadata[key]
    end
end

function TOM.DB.SetOutfitMetadata(outfitName, key, value)
    local outfit = TOM.DB.GetOutfitByName(outfitName)
    if outfit and outfit.metadata then
        outfit.metadata[key] = value
    end
end

function TOM.DB.SaveOutfit(outfitName, outfitData)
    --TODO: add metadata
    local outfit = {name = outfitName, data = outfitData, metadata = getDefaultMetadata()}
    if validateOutfit(outfit) then
	    table.insert(TOM.DB._sources.accDB, outfit)
        numOutfits = numOutfits + 1
    end
end

function TOM.DB.RenameOutfit(oldName, newName)
    local outfitIndex = TOM.DB.OutfitExistsByName(oldName)
    if outfitIndex > 0 then
        TOM.DB._sources.accDB[outfitIndex].name = newName
    end
    return outfitIndex
end

--is there a use case for returning the new count?
function TOM.DB.DeleteOutfitByName(outfitName)
    local outfitIndex = TOM.DB.OutfitExistsByName(outfitName)
    if outfitIndex > 0 and table.remove(TOM.DB._sources.accDB, outfitIndex) then
        numOutfits = max(0, numOutfits - 1)
        return true
    end
    return false
end

function TOM.DB.OverwriteOutfit(outfitName, newData)
    --data validation, return values
    local outfitIndex = TOM.DB.OutfitExistsByName(outfitName)
    if outfitIndex > 0 then
        TOM.DB._sources.accDB[outfitIndex].data = newData
    end
    return outfitIndex
end

function TOM.DB.NumSavedOutfits()
    --if outfits have been counted then return that count, otherwise do manual count
    if numOutfits then
        return numOutfits
    end
    return TOM.CountOutfits()
end

function TOM.DB.OutfitExistsByName(name)
	for index, outfit in ipairs(TOM.DB._sources.accDB) do
		if outfit.name == name then return index end
	end
	return 0
end

function TOM.DB.CountOutfits()
    numOutfits = 0
    for _, outfit in pairs(TOM.DB._sources.accDB) do
        if validateOutfit(outfit) then
            numOutfits = numOutfits + 1
        end
    end
    return numOutfits
end