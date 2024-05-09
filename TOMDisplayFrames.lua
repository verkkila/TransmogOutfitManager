local addonName, TOM = ...

TOM.previewModelFrames = {}
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

local function rctoindex(row, column)
	return (row - 1) * TOM.const.COLS + column
end

function TOM.GetPreviewModelFrame(row, column)
	if row < 1 or row > 2 then return nil end
	if column < 1 or column > 4 then return nil end
	return TOM.previewModelFrames[rctoindex(row, column)]
end

function TOM.SetBorderByModelPosition(row, column, borderType)
	local backdrop = backdrops.default
	if borderType == TOM.const.BORDERTYPE_APPLIED then backdrop = backdrops.applied end
	if borderType == TOM.const.BORDERTYPE_SELECTED then backdrop = backdrops.selected end
	local modelFrame = TOM.previewModelFrames[rctoindex(row, column)]
	TOM.previewModelFrames[rctoindex(row, column)]:SetBackdrop(backdrop)
	TOM.previewModelFrames[rctoindex(row, column)]:SetBackdropColor(0, 0, 0, 1)
end

local function TOM_AddOutfitNameText(modelFrame)
	modelFrame.OutfitName = modelFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	modelFrame.OutfitName:ClearAllPoints()
	modelFrame.OutfitName:SetPoint("BOTTOM", modelFrame, "BOTTOM", 0, 10)
	modelFrame.OutfitName:Hide()
end

local function TOM_SetupModel(modelFrame, row, col)
	modelFrame:SetSize(TOM.const.MODEL_WIDTH, TOM.const.MODEL_HEIGHT)
	modelFrame:SetBackdrop(backdrops.default)
	--TODO: clean up position calculations
	modelFrame:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", (col - 3) * (TOM.const.SPACING + TOM.const.MODEL_WIDTH) + ((TOM.const.SPACING + TOM.const.MODEL_WIDTH) * 0.5) + TOM.const.OFFSET_X,
														   (-1 * (row - 1) * (TOM.const.SPACING + TOM.const.MODEL_HEIGHT)) + ((TOM.const.SPACING + TOM.const.MODEL_HEIGHT) * 0.5) + TOM.const.OFFSET_Y
	)
	modelFrame:EnableMouse(true)
	modelFrame:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
	modelFrame:SetUnit("player")
	TOM_AddOutfitNameText(modelFrame)
	modelFrame:Hide()
end

for r = 1, TOM.const.ROWS do
	for c = 1, TOM.const.COLS do
		tinsert(TOM.previewModelFrames, CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate"))
		local modelFrame = TOM.previewModelFrames[rctoindex(r, c)]
		TOM_SetupModel(modelFrame, r, c)
	end
end