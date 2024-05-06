local addonName, TOM = ...
-- TODO refactor this module

TOM.previewModelFrames = {}

function TOM.GetPreviewModelFrame(row, column)
	if row < 1 or row > 2 then return nil end
	if column < 1 or column > 4 then return nil end
	return TOM.previewModelFrames[(row-1)*4+column]
end

function TOM.SetBorderByModelPosition(row, column, borderType)
	local borderFile = "Interface\\Addons\\TransmogOutfitManager\\assets\\border-default.blp"
	if borderType == TOM.BORDERTYPE_APPLIED then borderFile = "Interface\\Addons\\TransmogOutfitManager\\assets\\border-applied.blp" end
	if borderType == TOM.BORDERTYPE_SELECTED then borderFile = "Interface\\Addons\\TransmogOutfitManager\\assets\\border-selected.blp" end
	TOM.previewModelFrames[(row-1)*4+column]:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
															edgeFile=borderFile,
															tile=true,
															tileSize=16,
															edgeSize=16,
															insets={
																left=1,
																right=1,
																top=1,
																bottom=1}}
	)
	TOM.previewModelFrames[(row-1)*4+column]:SetBackdropColor(0, 0, 0, 1)
end

local backdrop = {
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
------------------
--ROW 1 COLUMN 1--
------------------
TOM.PreviewModel_R1C1 = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
TOM.PreviewModel_R1C1:SetSize(125, 175)
TOM.PreviewModel_R1C1:SetBackdrop(backdrop)
TOM.PreviewModel_R1C1:SetBackdropColor(0, 0, 0, 1)
TOM.PreviewModel_R1C1:Show()
TOM.PreviewModel_R1C1:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", -200, 125)
TOM.PreviewModel_R1C1:EnableMouse(true)
TOM.PreviewModel_R1C1:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
TOM.PreviewModel_R1C1:SetUnit("player")
TOM.PreviewModel_R1C1.OutfitName = TOM.PreviewModel_R1C1:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.PreviewModel_R1C1.OutfitName:ClearAllPoints()
TOM.PreviewModel_R1C1.OutfitName:SetPoint("BOTTOM", TOM.PreviewModel_R1C1, "BOTTOM", 0, 10)
TOM.PreviewModel_R1C1.OutfitName:Hide()
TOM.PreviewModel_R1C1:Hide()
TOM.previewModelFrames[1] = TOM.PreviewModel_R1C1

------------------
--ROW 1 COLUMN 2--
------------------
TOM.PreviewModel_R1C2 = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
TOM.PreviewModel_R1C2:SetSize(125, 175)
TOM.PreviewModel_R1C2:SetBackdrop(backdrop)
TOM.PreviewModel_R1C2:SetBackdropColor(0, 0, 0, 1)
TOM.PreviewModel_R1C2:Show()
TOM.PreviewModel_R1C2:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", -65, 125)
TOM.PreviewModel_R1C2:EnableMouse(true)
TOM.PreviewModel_R1C2:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
TOM.PreviewModel_R1C2:SetUnit("player")
TOM.PreviewModel_R1C2.OutfitName = TOM.PreviewModel_R1C2:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.PreviewModel_R1C2.OutfitName:ClearAllPoints()
TOM.PreviewModel_R1C2.OutfitName:SetPoint("BOTTOM", TOM.PreviewModel_R1C2, "BOTTOM", 0, 10)
TOM.PreviewModel_R1C2.OutfitName:Hide()
TOM.PreviewModel_R1C2:Hide()
TOM.previewModelFrames[2] = TOM.PreviewModel_R1C2

------------------
--ROW 1 COLUMN 3--
------------------
TOM.PreviewModel_R1C3 = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
TOM.PreviewModel_R1C3:SetSize(125, 175)
TOM.PreviewModel_R1C3:SetBackdrop(backdrop)
TOM.PreviewModel_R1C3:SetBackdropColor(0, 0, 0, 1)
TOM.PreviewModel_R1C3:Show()
TOM.PreviewModel_R1C3:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", 65, 125)
TOM.PreviewModel_R1C3:EnableMouse(true)
TOM.PreviewModel_R1C3:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
TOM.PreviewModel_R1C3:SetUnit("player")
TOM.PreviewModel_R1C3.OutfitName = TOM.PreviewModel_R1C3:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.PreviewModel_R1C3.OutfitName:ClearAllPoints()
TOM.PreviewModel_R1C3.OutfitName:SetPoint("BOTTOM", TOM.PreviewModel_R1C3, "BOTTOM", 0, 10)
TOM.PreviewModel_R1C3.OutfitName:Hide()
TOM.PreviewModel_R1C3:Hide()
TOM.previewModelFrames[3] = TOM.PreviewModel_R1C3

------------------
--ROW 1 COLUMN 4--
------------------
TOM.PreviewModel_R1C4 = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
TOM.PreviewModel_R1C4:SetSize(125, 175)
TOM.PreviewModel_R1C4:SetBackdrop(backdrop)
TOM.PreviewModel_R1C4:SetBackdropColor(0, 0, 0, 1)
TOM.PreviewModel_R1C4:Show()
TOM.PreviewModel_R1C4:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", 200, 125)
TOM.PreviewModel_R1C4:EnableMouse(true)
TOM.PreviewModel_R1C4:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
TOM.PreviewModel_R1C4:SetUnit("player")
TOM.PreviewModel_R1C4.OutfitName = TOM.PreviewModel_R1C4:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.PreviewModel_R1C4.OutfitName:ClearAllPoints()
TOM.PreviewModel_R1C4.OutfitName:SetPoint("BOTTOM", TOM.PreviewModel_R1C4, "BOTTOM", 0, 10)
TOM.PreviewModel_R1C4.OutfitName:Hide()
TOM.PreviewModel_R1C4:Hide()
TOM.previewModelFrames[4] = TOM.PreviewModel_R1C4

------------------
--ROW 2 COLUMN 1--
------------------
TOM.PreviewModel_R2C1 = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
TOM.PreviewModel_R2C1:SetSize(125, 175)
TOM.PreviewModel_R2C1:SetBackdrop(backdrop)
TOM.PreviewModel_R2C1:SetBackdropColor(0, 0, 0, 1)
TOM.PreviewModel_R2C1:Show()
TOM.PreviewModel_R2C1:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", -200, -75)
TOM.PreviewModel_R2C1:EnableMouse(true)
TOM.PreviewModel_R2C1:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
TOM.PreviewModel_R2C1:SetUnit("player")
TOM.PreviewModel_R2C1.OutfitName = TOM.PreviewModel_R2C1:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.PreviewModel_R2C1.OutfitName:ClearAllPoints()
TOM.PreviewModel_R2C1.OutfitName:SetPoint("BOTTOM", TOM.PreviewModel_R2C1, "BOTTOM", 0, 10)
TOM.PreviewModel_R2C1.OutfitName:Hide()
TOM.PreviewModel_R2C1:Hide()
TOM.previewModelFrames[5] = TOM.PreviewModel_R2C1

------------------
--ROW 2 COLUMN 2--
------------------
TOM.PreviewModel_R2C2 = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
TOM.PreviewModel_R2C2:SetSize(125, 175)
TOM.PreviewModel_R2C2:SetBackdrop(backdrop)
TOM.PreviewModel_R2C2:SetBackdropColor(0, 0, 0, 1)
TOM.PreviewModel_R2C2:Show()
TOM.PreviewModel_R2C2:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", -65, -75)
TOM.PreviewModel_R2C2:EnableMouse(true)
TOM.PreviewModel_R2C2:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
TOM.PreviewModel_R2C2:SetUnit("player")
TOM.PreviewModel_R2C2.OutfitName = TOM.PreviewModel_R2C2:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.PreviewModel_R2C2.OutfitName:ClearAllPoints()
TOM.PreviewModel_R2C2.OutfitName:SetPoint("BOTTOM", TOM.PreviewModel_R2C2, "BOTTOM", 0, 10)
TOM.PreviewModel_R2C2.OutfitName:Hide()
TOM.PreviewModel_R2C2:Hide()
TOM.previewModelFrames[6] = TOM.PreviewModel_R2C2

------------------
--ROW 2 COLUMN 3--
------------------
TOM.PreviewModel_R2C3 = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
TOM.PreviewModel_R2C3:SetSize(125, 175)
TOM.PreviewModel_R2C3:SetBackdrop(backdrop)
TOM.PreviewModel_R2C3:SetBackdropColor(0, 0, 0, 1)
TOM.PreviewModel_R2C3:Show()
TOM.PreviewModel_R2C3:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", 65, -75)
TOM.PreviewModel_R2C3:EnableMouse(true)
TOM.PreviewModel_R2C3:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
TOM.PreviewModel_R2C3:SetUnit("player")
TOM.PreviewModel_R2C3.OutfitName = TOM.PreviewModel_R2C3:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.PreviewModel_R2C3.OutfitName:ClearAllPoints()
TOM.PreviewModel_R2C3.OutfitName:SetPoint("BOTTOM", TOM.PreviewModel_R2C3, "BOTTOM", 0, 10)
TOM.PreviewModel_R2C3.OutfitName:Hide()
TOM.PreviewModel_R2C3:Hide()
TOM.previewModelFrames[7] = TOM.PreviewModel_R2C3

------------------
--ROW 2 COLUMN 4--
------------------
TOM.PreviewModel_R2C4 = CreateFrame("DressUpModel", nil, TOM.OutfitContainer, "BackdropTemplate")
TOM.PreviewModel_R2C4:SetSize(125, 175)
TOM.PreviewModel_R2C4:SetBackdrop(backdrop)
TOM.PreviewModel_R2C4:SetBackdropColor(0, 0, 0, 1)
TOM.PreviewModel_R2C4:Show()
TOM.PreviewModel_R2C4:SetPoint("CENTER", TOM.OutfitContainer, "CENTER", 200, -75)
TOM.PreviewModel_R2C4:EnableMouse(true)
TOM.PreviewModel_R2C4:SetScript("OnMouseDown", TOM.PreviewModel_OnMouseDown)
TOM.PreviewModel_R2C4:SetUnit("player")
TOM.PreviewModel_R2C4.OutfitName = TOM.PreviewModel_R2C4:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.PreviewModel_R2C4.OutfitName:ClearAllPoints()
TOM.PreviewModel_R2C4.OutfitName:SetPoint("BOTTOM", TOM.PreviewModel_R2C4, "BOTTOM", 0, 10)
TOM.PreviewModel_R2C4.OutfitName:Hide()
TOM.PreviewModel_R2C4:Hide()
TOM.previewModelFrames[8] = TOM.PreviewModel_R2C4