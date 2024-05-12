local addonName, TOM = ...
--TODO: add documentation

TransmogOutfitManagerOptions = TransmogOutfitManagerOptions or {}

TOM.Core = TOM.Core or {}

--need to bind the display frames to do reverse lookup (for mouse interaction)
local currentDisplay = {}
local ROWS = 0
local COLS = 0

--{{name, metadata, dbIndex}, {...}}
--not really a cache, just an abstraction layer
--should only contain outfits that are valid to display (class)
--maps directly to display, first position in cache = page 1, row 1 column 1 on display
local cache = {}
local cacheSize = 0

local SLOTID_TO_NAME = {
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

local function getVisibleSlotId(slot)
	if slot.pending > 0 then return tonumber(slot.pending)
	elseif slot.applied > 0 then return tonumber(slot.applied)
	else return tonumber(slot.base) end
end

local function prctoindex(p, r, c)
	return ((p - 1) * (ROWS * COLS)) + ((r - 1) * COLS + c)
end

local function rctoindex(r, c)
	return ((r - 1) * COLS + c)
end

local function getFullPlayerName(name, realm)
	local charName = name or UnitName("player")
	local charRealm = realm or GetRealmName()
	return strjoin("-", charName, charRealm)
end

--sort by favorites before non-favorites
local function favcmp(a, b)
	if not b then return true end
	local fullName = getFullPlayerName()
	local aFavoritedOn, bFavoritedOn = a.metadata.favoritedOn, b.metadata.favoritedOn
	local aIsFavorited, bIsFavorited = false, false
	for _, name in pairs(aFavoritedOn) do
		if name == fullName then aIsFavorited = true end
	end
	for _, name in pairs(bFavoritedOn) do
		if name == fullName then bIsFavorited = true end
	end
	--if both or neither are favorited, compare by timestamp
	if (aIsFavorited and bIsFavorited) or (not aIsFavorited and not bIsFavorited) then
		return a.metadata.createdAt < b.metadata.createdAt
	end
	return aIsFavorited and not bIsFavorited
end

local function isValidOutfitForPlayer(dbIndex)
	local myName, myRealm, myClass = TOM.Core.GetPlayerInfo()
	if TOM.DB.GetOutfitMetadata(dbIndex, TOM.DB.Keys["OWNER_CLASS"]) == myClass then
		if not TOM.Options.shareOutfits then
			return TOM.DB.GetOutfitMetadata(dbIndex, TOM.DB.Keys["OWNER_NAME"]) == myName
		end
		return true
	end
end

local function buildCache()
	local myName, myRealm, myClass = TOM.Core.GetPlayerInfo()
	wipe(cache)
	cacheSize = 0
	for index = 1, TOM.DB.NumSavedOutfits() do
		local outfit = TOM.DB.GetOutfit(index)
		if isValidOutfitForPlayer(index) then
			cacheSize = cacheSize + 1
			cache[cacheSize] = {name = outfit.name, metadata = outfit.metadata, dbIndex = index}
		end
	end
	sort(cache, favcmp)
end

function TOM.Core.Init()
	TOM.Options = TransmogOutfitManagerOptions
	buildCache()
end

--just do this for now, can optimize later
function TOM.Core.Refresh()
	buildCache()
end

function TOM.Core.GetPlayerInfo()
	return UnitName("player"), GetRealmName(), select(2, UnitClass("player"))
end

function TOM.Core.OutfitExists(outfitName, charName, charRealm, charClass)
	return TOM.DB.OutfitExists(outfitName, charName, charRealm, charClass)
end

function TOM.Core.GetOwner(modelFrame)
	local outfit, cacheIndex = TOM.Core.GetOutfitByFrame(modelFrame)
	local cacheEntry = cache[cacheIndex]
	if outfit and cacheEntry then
		local owner = TOM.DB.GetOutfitMetadata(cacheEntry.dbIndex, TOM.DB.Keys["OWNER"])
		return owner.name, owner.realm, owner.class
	end
end

function TOM.Core.GenerateSlotData()
	local slotData = {}
	for slotId, slotName in pairs(SLOTID_TO_NAME) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		slotData[slotName] = {base=baseSourceID, applied=appliedSourceID, pending=pendingSourceID, hasUndo=hasUndo}
	end
	return slotData
end

--by definition we cannot save outfits that are not applicable to our character so we can directly cache it
function TOM.Core.SaveOutfit(outfitName, outfitData)
	local data = outfitData or TOM.Core.GenerateSlotData()
	local index = TOM.DB.SaveOutfit(outfitName, data)
	if index > 0 then
		local outfit = TOM.DB.GetOutfit(index)
		tinsert(cache, {name = outfit.name, metadata = outfit.metadata, dbIndex = index})
		cacheSize = cacheSize + 1
	end
end

function TOM.Core.RenameOutfit(modelFrame, newName)
	local outfit, cacheIndex = TOM.Core.GetOutfitByFrame(modelFrame)
	local cacheEntry = cache[cacheIndex]
	if outfit and cacheEntry then
		if TOM.DB.RenameOutfit(cacheEntry.dbIndex, newName) then
			TOM.DB.SetOutfitMetadata(cacheEntry.dbIndex, TOM.DB.Keys["MODIFIED_AT"], GetServerTime())
			cacheEntry.name = newName
			return true
		end
	end
	return false
end

function TOM.Core.OverwriteOutfit(outfitInfo)
	if not outfitInfo.name or not outfitInfo.charName or not outfitInfo.charRealm or not outfitInfo.charClass then
		return false
	end
	local dbIndex = TOM.DB.OverwriteOutfit(outfitInfo.name, outfitInfo.charName, outfitInfo.charRealm, outfitInfo.charClass, TOM.Core.GenerateSlotData())
	if dbIndex > 0 then
		TOM.DB.SetOutfitMetadata(dbIndex, TOM.DB.Keys["MODIFIED_AT"], GetServerTime())
	end
end

function TOM.Core.DeleteOutfit(modelFrame)
	local outfit, cacheIndex = TOM.Core.GetOutfitByFrame(modelFrame)
	local cacheEntry = cache[cacheIndex]
	if cacheEntry.name == outfit.name and cacheEntry.metadata == outfit.metadata then
		if TOM.DB.DeleteOutfit(cacheEntry.dbIndex) then
			tremove(cache, cacheIndex)
			for _, entry in pairs(cache) do
				if entry.dbIndex > cacheEntry.dbIndex then entry.dbIndex = entry.dbIndex - 1 end
			end
			cacheSize = cacheSize - 1
		end
	end
end

function TOM.Core.GetNumOutfits()
	return cacheSize
end

function TOM.Core.GetOutfit(page, row, column)
	local cacheEntry = cache[prctoindex(page, row, column)]
	if cacheEntry then
		return TOM.DB.GetOutfit(cacheEntry.dbIndex)
	end
end

function TOM.Core.GetOutfitByFrame(modelFrame)
	for offset, frame in ipairs(currentDisplay) do
		if modelFrame == frame then
			local cacheIndex = ((TOM.Display.GetCurrentPage() - 1) * (ROWS * COLS)) + offset
			return TOM.DB.GetOutfit(cache[cacheIndex].dbIndex), cacheIndex
		end
	end
end

function TOM.Core.ResetDisplay()
	wipe(currentDisplay)
	ROWS = 0
	COLS = 0
end

function TOM.Core.SetDisplay(modelFrameArray, rows, columns)
	currentDisplay = modelFrameArray
	ROWS = rows
	COLS = columns
end

function TOM.Core.IsFavorited(modelFrame)
	local fullName = getFullPlayerName()
	local outfit, cacheIndex = TOM.Core.GetOutfitByFrame(modelFrame)
	local cacheEntry = cache[cacheIndex]
	if outfit and cacheEntry then
		local favoritedOn = TOM.DB.GetOutfitMetadata(cacheEntry.dbIndex, TOM.DB.Keys["FAVORITED_ON"])
		for _, name in pairs(favoritedOn) do
			if name == fullName then
				return true
			end
		end
		return false
	end
end

--returns true when set, false when unset
function TOM.Core.ToggleFavorite(modelFrame)
	local fullName = getFullPlayerName()
	local outfit, cacheIndex = TOM.Core.GetOutfitByFrame(modelFrame)
	local cacheEntry = cache[cacheIndex]
	if outfit and cacheEntry then
		local favoritedOn = TOM.DB.GetOutfitMetadata(cacheEntry.dbIndex, TOM.DB.Keys["FAVORITED_ON"])
		for index, name in pairs(favoritedOn) do
			if name == fullName then
				tremove(favoritedOn, index)
				sort(cache, favcmp)
				return false
			end
		end
		tinsert(favoritedOn, fullName)
		sort(cache, favcmp)
		return true
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

--TODO: fix these
function TOM.Core.IsOutfitApplied(outfit)
	for slotId, slotName in pairs(SLOTID_TO_NAME) do
		if slotName ~= "TABARDSLOT" and slotName ~= "SHIRTSLOT" then
			local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
			local equippedIdForSlot = getVisibleSlotId({applied=appliedSourceID, pending=0, base=baseSourceID, hasUndo=hasUndo})
			local outfitIdForSlot = getVisibleSlotId(outfit.data[slotName])
			if outfit.data[slotName].hasUndo then return false end
			if equippedIdForSlot ~= outfitIdForSlot then return false end
		end
	end
	TOM.Core.appliedOutfit = outfit
	return true
end

function TOM.Core.IsOutfitSelected(outfit)
	for slotId, slotName in pairs(SLOTID_TO_NAME) do
		if slotName ~= "TABARDSLOT" and slotName ~= "SHIRTSLOT" then
			local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
			local equippedIdForSlot = TOM.Core.GetTransmogId({applied=appliedSourceID, pending=pendingSourceID, base=baseSourceID, hasUndo=hasUndo})
			local outfitIdForSlot = TOM.Core.GetTransmogId(outfit.data[slotName])
			if equippedIdForSlot ~= outfitIdForSlot then return false end
		end
	end
	return true
end