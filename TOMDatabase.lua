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

function getDefaultMetadata()
    local m = {}
    local now = GetServerTime()
    local myName, myRealm, myClass = TOM.Core.GetPlayerInfo()

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

local function outfitInAccountDB(outfit)
    local myName = UnitName("player")
    local myRealm = GetRealmName()
    local myClass = select(2, UnitClass("player"))

    for _, accOutfit in pairs(TOM.DB._sources.accDB) do
        if accOutfit and accOutfit.metadata and accOutfit.name == outfit.name then
            return accOutfit.metadata[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_NAME"]] == myName and
                   accOutfit.metadata[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_REALM"]] == myRealm and
                   accOutfit.metadata[TOM.DB.Keys["OWNER"]][TOM.DB.Keys["OWNER_CLASS"]] == myClass
        end
    end
    return false
end

local function migrateOutfits()
    local count = 0
    for index, outfit in ipairs(TOM.DB._sources.charDB) do
        if not outfitInAccountDB(outfit) then
            count = count + 1
            tinsert(TOM.DB._sources.accDB, {name = outfit.name, data = outfit.data, metadata = getDefaultMetadata()})
        end
    end
    --think this through 100%
    wipe(TOM.DB._sources.charDB)
    return count
end

function TOM.DB.Init()
    TOM.DB._sources = {}
    TOM.DB._sources.charDB = TransmogOutfitManagerDB
    TOM.DB._sources.accDB = TransmogOutfitManagerDBAccount
    migrateOutfits()
    TOM.DB.CountOutfits()
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

function isValidKey(key)
    for k, v in pairs(TOM.DB.Keys) do
        if v == key then return true end
    end
    return false
end

function TOM.DB.GetOutfitMetadata(index, key)
    if not isValidKey(key) then return nil end
    local outfit = TOM.DB._sources.accDB[index]
    if outfit and outfit.metadata then
        if key == TOM.DB.Keys["OWNER_NAME"] or
           key == TOM.DB.Keys["OWNER_REALM"] or
           key == TOM.DB.Keys["OWNER_CLASS"] then
            return outfit.metadata[TOM.DB.Keys["OWNER"]][key]
        else
            return outfit.metadata[key]
        end
    end
end

--should also do type checking here, i.e. dont allow setting modifiedAt as string etc.
function TOM.DB.SetOutfitMetadata(index, key, value)
    if not isValidKey(key) then return false end
    local outfit = TOM.DB._sources.accDB[index]
    if outfit and outfit.metadata then
        if key == TOM.DB.Keys["OWNER_NAME"] or
           key == TOM.DB.Keys["OWNER_REALM"] or
           key == TOM.DB.Keys["OWNER_CLASS"] then
            outfit.metadata[TOM.DB.Keys["OWNER"]][key] = value
        else
            outfit.metadata[key] = value
        end
        return true
    end
    return false
end

function TOM.DB.SaveOutfit(outfitName, outfitData)
    local outfit = {name = outfitName, data = outfitData, metadata = getDefaultMetadata()}
    if not outfitInAccountDB(outfit) then
        tinsert(TOM.DB._sources.accDB, outfit)
        numOutfits = numOutfits + 1
        print("table.getn(accDB) = ", table.getn(TOM.DB._sources.accDB), " numOutfits = ", numOutfits)
        return numOutfits
    end
    return 0
end

function TOM.DB.RenameOutfit(index, newName)
    local outfit = TOM.DB._sources.accDB[index]
    if outfit then
        outfit.name = newName
        return true
    end
    return false
end

function TOM.DB.DeleteOutfit(index)
    local res = tremove(TOM.DB._sources.accDB, index)
    if res then
        numOutfits = numOutfits - 1
        print(table.getn(TOM.DB._sources.accDB), numOutfits)
    end
    return res ~= nil
end

function TOM.DB.NumSavedOutfits()
    --if outfits have been counted then return that count, otherwise do manual count
    if numOutfits then
        return numOutfits
    end
    return TOM.CountOutfits()
end

function TOM.DB.CountOutfits()
    numOutfits = 0
    for _, outfit in pairs(TOM.DB._sources.accDB) do
        --if validate then increment count otherwise tremove it
        numOutfits = numOutfits + 1
    end
    return numOutfits
end