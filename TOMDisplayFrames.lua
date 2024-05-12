local addonName, TOM = ...

TOM.Display = TOM.Display or {}
TOM.Display.ModelFrames = {}
TOM.Display.Backdrops = {}
TOM.Display.ROWS = 2
TOM.Display.COLS = 4
TOM.Display._locked = false
--this is not ideal
TOM.Display.Backdrops["default"] = {
	bgFile="Interface/Tooltips/UI-Tooltip-Background",
	edgeFile="Interface\\Addons\\TransmogOutfitManager\\assets\\border-default.blp",
	tile=true,
	tileSize=16,
	edgeSize=16,
	insets={
		left=1,
		right=1,
		top=1,
		bottom=1}
}
TOM.Display.Backdrops["selected"] = {
	bgFile="Interface/Tooltips/UI-Tooltip-Background",
	edgeFile="Interface\\Addons\\TransmogOutfitManager\\assets\\border-selected.blp",
	tile=true,
	tileSize=16,
	edgeSize=16,
	insets={
		left=1,
		right=1,
		top=1,
		bottom=1}
}
TOM.Display.Backdrops["applied"] = {
	bgFile="Interface/Tooltips/UI-Tooltip-Background",
	edgeFile="Interface\\Addons\\TransmogOutfitManager\\assets\\border-applied.blp",
	tile=true,
	tileSize=16,
	edgeSize=16,
	insets={
		left=1,
		right=1,
		top=1,
		bottom=1}
}

local MODEL_WIDTH = 125
local MODEL_HEIGHT = 175
local SPACING = 10
local OFFSET_X = 0
local OFFSET_Y = 15

local function addOutfitNameText(modelFrame)
	modelFrame.OutfitName = modelFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	modelFrame.OutfitName:ClearAllPoints()
	modelFrame.OutfitName:SetPoint("BOTTOM", modelFrame, "BOTTOM", 0, 10)
	modelFrame.OutfitName:Hide()
end

local function addFavoriteIcon(modelFrame)
	modelFrame.FavIcon = modelFrame:CreateTexture()
	modelFrame.FavIcon:SetPoint("TOPLEFT", -6, 6)
	modelFrame.FavIcon:SetSize(24, 24)
	modelFrame.FavIcon:SetTexture("Interface/Collections/Collections.blp")
	modelFrame.FavIcon:SetTexCoord(0.1875, 0.234375, 0.015625, 0.0625)
	modelFrame.FavIcon:Hide()
end

local function tryCreateTransmogInfo(outfit)
	ret = {}
	for invSlotName, invSlotData in pairs(outfit.data) do
		local loc = TransmogUtil.CreateTransmogLocation(invSlotName, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
		local _, _, _, canTransmog = C_Transmog.GetSlotInfo(loc)
		local id = TOM.Core.GetTransmogId(invSlotData)
		if canTransmog and id then
			local pInfo = TransmogUtil.CreateTransmogPendingInfo(Enum.TransmogPendingType.Apply, id)
			if pInfo.Init and pInfo.transmogID > 0 and pInfo.type then
				tinsert(ret, {location = loc, pendingInfo = pInfo})
			else
				return nil
			end
		end
	end
	return ret
end

--needs rework
local function modelFrameOnMouseDown(self, button)
	if TOM.Display._locked then return end
	TOM.Display.selectedModelFrame = GetMouseFocus()
	if button == "LeftButton" then
		local outfit = TOM.Core.GetOutfitByFrame(TOM.Display.selectedModelFrame)
		if not outfit then return end
		local transmogInfo = tryCreateTransmogInfo(outfit)
		if transmogInfo then
			for _, info in pairs(transmogInfo) do
				C_Transmog.ClearPending(info.location)
				C_Transmog.SetPending(info.location, info.pendingInfo)
			end
		else
			UIErrorsFrame:AddMessage("You cannot transmogrify this set", 1, 0, 0)
		end
	elseif button == "RightButton" then
		ToggleDropDownMenu(1, nil, TOM.Input.OutfitDropdown, "cursor", 3, -3)
	end
end

local function setupModelFrame(modelFrame, row, col)
	modelFrame:SetSize(MODEL_WIDTH, MODEL_HEIGHT)
	modelFrame:SetBackdrop(TOM.Display.Backdrops.default)
	--TODO: clean up position calculations
	modelFrame:SetPoint("CENTER", TOM.Display.Container, "CENTER", (col - 3) * (SPACING + MODEL_WIDTH) + ((SPACING + MODEL_WIDTH) * 0.5) + OFFSET_X,
														   (-1 * (row - 1) * (SPACING + MODEL_HEIGHT)) + ((SPACING + MODEL_HEIGHT) * 0.5) + OFFSET_Y
	)
	modelFrame:EnableMouse(true)
	modelFrame:SetScript("OnMouseDown", modelFrameOnMouseDown)
	modelFrame:SetUnit("player")
	addOutfitNameText(modelFrame)
	addFavoriteIcon(modelFrame)
	--addOwnerNameText(modelFrame)
	modelFrame:Hide()
end

TOM.Display.Container = CreateFrame("Frame", nil, WardrobeFrame, "CollectionsBackgroundTemplate")
TOM.Display.Container:ClearAllPoints()
TOM.Display.Container:SetPoint("TOPLEFT", WardrobeFrame, "TOPRIGHT", 10, 0)
TOM.Display.Container:SetSize(600, 500)
TOM.Display.Container:SetFrameLevel(6)
TOM.Display.Container:SetMovable(true)
TOM.Display.Container:EnableMouse(true)
TOM.Display.Container:RegisterForDrag("LeftButton")
TOM.Display.Container:RegisterEvent("TRANSMOGRIFY_SUCCESS")
TOM.Display.Container:RegisterEvent("TRANSMOGRIFY_UPDATE")
TOM.Display.Container:RegisterEvent("ADDON_LOADED")
TOM.Display.Container.PageText = TOM.Display.Container:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.Display.Container.PageText:ClearAllPoints()
TOM.Display.Container.PageText:SetPoint("CENTER", TOM.Display.Container, "BOTTOM", -40, 40)

for r = 1, TOM.Display.ROWS do
	for c = 1, TOM.Display.COLS do
		tinsert(TOM.Display.ModelFrames, CreateFrame("DressUpModel", nil, TOM.Display.Container, "BackdropTemplate"))
		local modelFrame = TOM.Display.ModelFrames[(r - 1) * TOM.Display.COLS + c]
		setupModelFrame(modelFrame, r, c)
	end
end

