local addonName, TOM = ...

TOM.Display = TOM.Display or {}
TOM.Display.ModelFrames = {}
TOM.Display.Backdrops = {}
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

local function addOutfitNameText(modelFrame)
	modelFrame.OutfitName = modelFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	modelFrame.OutfitName:ClearAllPoints()
	modelFrame.OutfitName:SetPoint("BOTTOM", modelFrame, "BOTTOM", 0, 10)
	modelFrame.OutfitName:Hide()
end

local function modelFrameOnMouseDown(self, button)
	if button == "LeftButton" then
		local outfitName = GetMouseFocus().OutfitName:GetText()
		if not outfitName then return end
		local index = TOM.Core.GetOutfitByName(outfitName)
		if index == 0 then return end
		for invSlotName, invSlotData in pairs(TOM.Core.GetOutfitData(index)) do
			local transmogLoc = TransmogUtil.CreateTransmogLocation(invSlotName, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
			C_Transmog.ClearPending(transmogLoc)
			local _, _, _, canTransmog = C_Transmog.GetSlotInfo(transmogLoc)
			local id = TOM.Core.GetTransmogId(invSlotData)
			if canTransmog and id then
				C_Transmog.SetPending(transmogLoc, TransmogUtil.CreateTransmogPendingInfo(Enum.TransmogPendingType.Apply, id))
			end
		end
		TOM.Display.Redraw()
	elseif button == "RightButton" then
		TOM.activeModelFrame = GetMouseFocus()
		ToggleDropDownMenu(1, nil, TOM.Input.OutfitDropdown, "cursor", 3, -3)
	end
end

local function setupModelFrame(modelFrame, row, col)
	modelFrame:SetSize(TOM.const.MODEL_WIDTH, TOM.const.MODEL_HEIGHT)
	modelFrame:SetBackdrop(TOM.Display.Backdrops.default)
	--TODO: clean up position calculations
	modelFrame:SetPoint("CENTER", TOM.Display.Container, "CENTER", (col - 3) * (TOM.const.SPACING + TOM.const.MODEL_WIDTH) + ((TOM.const.SPACING + TOM.const.MODEL_WIDTH) * 0.5) + TOM.const.OFFSET_X,
														   (-1 * (row - 1) * (TOM.const.SPACING + TOM.const.MODEL_HEIGHT)) + ((TOM.const.SPACING + TOM.const.MODEL_HEIGHT) * 0.5) + TOM.const.OFFSET_Y
	)
	modelFrame:EnableMouse(true)
	modelFrame:SetScript("OnMouseDown", modelFrameOnMouseDown)
	modelFrame:SetUnit("player")
	addOutfitNameText(modelFrame)
	--TOM_AddOwnerNameText(modelFrame)
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

for r = 1, TOM.const.ROWS do
	for c = 1, TOM.const.COLS do
		tinsert(TOM.Display.ModelFrames, CreateFrame("DressUpModel", nil, TOM.Display.Container, "BackdropTemplate"))
		local modelFrame = TOM.Display.ModelFrames[(r - 1) * TOM.const.COLS + c]
		setupModelFrame(modelFrame, r, c)
	end
end

