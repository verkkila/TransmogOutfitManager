local addonName, TOM = ...
-- TODO refactor this module

TOM.previewModelFrames = {}
local ROWS = 2
local COLS = 4
local MODEL_WIDTH = 125
local MODEL_HEIGHT = 175
local SPACING = 10
local OFFSET_X = 0
local OFFSET_Y = 15
local backdrops = {}
backdrops["default"] = {
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
backdrops["selected"] = {
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
backdrops["applied"] = {
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

function TOM.GetPreviewModelFrame(row, column)
	if row < 1 or row > 2 then return nil end
	if column < 1 or column > 4 then return nil end
	return TOM.previewModelFrames[(row-1)*4+column]
end

function TOM.SetBorderByModelPosition(row, column, borderType)
	local backdrop = backdrops.default
	if borderType == TOM.BORDERTYPE_APPLIED then backdrop = backdrops.applied end
	if borderType == TOM.BORDERTYPE_SELECTED then backdrop = backdrops.selected end
	local modelFrame = TOM.previewModelFrames[(row - 1) * COLS + column]
	TOM.previewModelFrames[(row-1)*4+column]:SetBackdrop(backdrop)
	TOM.previewModelFrames[(row-1)*4+column]:SetBackdropColor(0, 0, 0, 1)
end

local function TOM_AddOutfitNameText(modelFrame)
	modelFrame.OutfitName = modelFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	modelFrame.OutfitName:ClearAllPoints()
	modelFrame.OutfitName:SetPoint("BOTTOM", modelFrame, "BOTTOM", 0, 10)
	modelFrame.OutfitName:Hide()
end

local function TOM_SetupModel(modelFrame, row, col)
	modelFrame:SetSize(MODEL_WIDTH, MODEL_HEIGHT)
	modelFrame:SetBackdrop(backdrops.default)
	modelFrame:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", (col - 3) * (SPACING + MODEL_WIDTH) + ((SPACING + MODEL_WIDTH) * 0.5) + OFFSET_X, -- TODO: clean these up
														   (-1 * (row - 1) * (SPACING + MODEL_HEIGHT)) + ((SPACING + MODEL_HEIGHT) * 0.5) + OFFSET_Y
	)
	modelFrame:EnableMouse(true)
	modelFrame:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
	modelFrame:SetUnit("player")
	TOM_AddOutfitNameText(modelFrame)
	modelFrame:Hide()
end

for r = 1, ROWS do
	for c = 1, COLS do
		tinsert(TOM.previewModelFrames, CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate"))
		--TOM.previewModelFrames[(r - 1) * COLS + c] = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
		local modelFrame = TOM.previewModelFrames[(r - 1) * COLS + c]
		TOM_SetupModel(modelFrame, r, c)
	end
end