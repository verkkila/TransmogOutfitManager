TOM.previewModelFrames = {}

function TOM_GetPreviewModelFrame(row, column)
	if row < 1 or row > 2 then return nil end
	if column < 1 or column > 4 then return nil end
	return TOM.previewModelFrames[(row-1)*4+column]
end

------------------
--ROW 1 COLUMN 1--
------------------
TOM_PreviewModel_R1C1 = CreateFrame("DressUpModel", "TOM_PreviewModel_R1C1", TOM_OutfitContainer, "BackdropTemplate")
TOM_PreviewModel_R1C1:SetSize(125, 175)
TOM_PreviewModel_R1C1:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_PreviewModel_R1C1:SetBackdropColor(0, 0, 0, 1)
TOM_PreviewModel_R1C1:Show()
TOM_PreviewModel_R1C1:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", -200, 125)
TOM_PreviewModel_R1C1:EnableMouse(true)
TOM_PreviewModel_R1C1:SetScript("OnMouseDown", TOM_PreviewModel_OnMouseDown)
TOM_PreviewModel_R1C1:SetUnit("player")
TOM_PreviewModel_R1C1.OutfitName = TOM_PreviewModel_R1C1:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_PreviewModel_R1C1.OutfitName:ClearAllPoints()
TOM_PreviewModel_R1C1.OutfitName:SetPoint("BOTTOM", TOM_PreviewModel_R1C1, "BOTTOM", 0, 10)
TOM_PreviewModel_R1C1.OutfitName:Hide()
TOM_PreviewModel_R1C1:Hide()
TOM.previewModelFrames[1] = TOM_PreviewModel_R1C1

------------------
--ROW 1 COLUMN 2--
------------------
TOM_PreviewModel_R1C2 = CreateFrame("DressUpModel", "TOM_PreviewModel_R1C2", TOM_OutfitContainer, "BackdropTemplate")
TOM_PreviewModel_R1C2:SetSize(125, 175)
TOM_PreviewModel_R1C2:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_PreviewModel_R1C2:SetBackdropColor(0, 0, 0, 1)
TOM_PreviewModel_R1C2:Show()
TOM_PreviewModel_R1C2:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", -65, 125)
TOM_PreviewModel_R1C2:EnableMouse(true)
TOM_PreviewModel_R1C2:SetScript("OnMouseDown", TOM_PreviewModel_OnMouseDown)
TOM_PreviewModel_R1C2:SetUnit("player")
TOM_PreviewModel_R1C2.OutfitName = TOM_PreviewModel_R1C2:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_PreviewModel_R1C2.OutfitName:ClearAllPoints()
TOM_PreviewModel_R1C2.OutfitName:SetPoint("BOTTOM", TOM_PreviewModel_R1C2, "BOTTOM", 0, 10)
TOM_PreviewModel_R1C2.OutfitName:Hide()
TOM_PreviewModel_R1C2:Hide()
TOM.previewModelFrames[2] = TOM_PreviewModel_R1C2

------------------
--ROW 1 COLUMN 3--
------------------
TOM_PreviewModel_R1C3 = CreateFrame("DressUpModel", "TOM_PreviewModel_R1C3", TOM_OutfitContainer, "BackdropTemplate")
TOM_PreviewModel_R1C3:SetSize(125, 175)
TOM_PreviewModel_R1C3:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_PreviewModel_R1C3:SetBackdropColor(0, 0, 0, 1)
TOM_PreviewModel_R1C3:Show()
TOM_PreviewModel_R1C3:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", 65, 125)
TOM_PreviewModel_R1C3:EnableMouse(true)
TOM_PreviewModel_R1C3:SetScript("OnMouseDown", TOM_PreviewModel_OnMouseDown)
TOM_PreviewModel_R1C3:SetUnit("player")
TOM_PreviewModel_R1C3.OutfitName = TOM_PreviewModel_R1C3:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_PreviewModel_R1C3.OutfitName:ClearAllPoints()
TOM_PreviewModel_R1C3.OutfitName:SetPoint("BOTTOM", TOM_PreviewModel_R1C3, "BOTTOM", 0, 10)
TOM_PreviewModel_R1C3.OutfitName:Hide()
TOM_PreviewModel_R1C3:Hide()
TOM.previewModelFrames[3] = TOM_PreviewModel_R1C3

------------------
--ROW 1 COLUMN 4--
------------------
TOM_PreviewModel_R1C4 = CreateFrame("DressUpModel", "TOM_PreviewModel_R1C4", TOM_OutfitContainer, "BackdropTemplate")
TOM_PreviewModel_R1C4:SetSize(125, 175)
TOM_PreviewModel_R1C4:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_PreviewModel_R1C4:SetBackdropColor(0, 0, 0, 1)
TOM_PreviewModel_R1C4:Show()
TOM_PreviewModel_R1C4:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", 200, 125)
TOM_PreviewModel_R1C4:EnableMouse(true)
TOM_PreviewModel_R1C4:SetScript("OnMouseDown", TOM_PreviewModel_OnMouseDown)
TOM_PreviewModel_R1C4:SetUnit("player")
TOM_PreviewModel_R1C4.OutfitName = TOM_PreviewModel_R1C4:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_PreviewModel_R1C4.OutfitName:ClearAllPoints()
TOM_PreviewModel_R1C4.OutfitName:SetPoint("BOTTOM", TOM_PreviewModel_R1C4, "BOTTOM", 0, 10)
TOM_PreviewModel_R1C4.OutfitName:Hide()
TOM_PreviewModel_R1C4:Hide()
TOM.previewModelFrames[4] = TOM_PreviewModel_R1C4

------------------
--ROW 2 COLUMN 1--
------------------
TOM_PreviewModel_R2C1 = CreateFrame("DressUpModel", "TOM_PreviewModel_R2C1", TOM_OutfitContainer, "BackdropTemplate")
TOM_PreviewModel_R2C1:SetSize(125, 175)
TOM_PreviewModel_R2C1:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_PreviewModel_R2C1:SetBackdropColor(0, 0, 0, 1)
TOM_PreviewModel_R2C1:Show()
TOM_PreviewModel_R2C1:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", -200, -75)
TOM_PreviewModel_R2C1:EnableMouse(true)
TOM_PreviewModel_R2C1:SetScript("OnMouseDown", TOM_PreviewModel_OnMouseDown)
TOM_PreviewModel_R2C1:SetUnit("player")
TOM_PreviewModel_R2C1.OutfitName = TOM_PreviewModel_R2C1:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_PreviewModel_R2C1.OutfitName:ClearAllPoints()
TOM_PreviewModel_R2C1.OutfitName:SetPoint("BOTTOM", TOM_PreviewModel_R2C1, "BOTTOM", 0, 10)
TOM_PreviewModel_R2C1.OutfitName:Hide()
TOM_PreviewModel_R2C1:Hide()
TOM.previewModelFrames[5] = TOM_PreviewModel_R2C1

------------------
--ROW 2 COLUMN 2--
------------------
TOM_PreviewModel_R2C2 = CreateFrame("DressUpModel", "TOM_PreviewModel_R2C2", TOM_OutfitContainer, "BackdropTemplate")
TOM_PreviewModel_R2C2:SetSize(125, 175)
TOM_PreviewModel_R2C2:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_PreviewModel_R2C2:SetBackdropColor(0, 0, 0, 1)
TOM_PreviewModel_R2C2:Show()
TOM_PreviewModel_R2C2:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", -65, -75)
TOM_PreviewModel_R2C2:EnableMouse(true)
TOM_PreviewModel_R2C2:SetScript("OnMouseDown", TOM_PreviewModel_OnMouseDown)
TOM_PreviewModel_R2C2:SetUnit("player")
TOM_PreviewModel_R2C2.OutfitName = TOM_PreviewModel_R2C2:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_PreviewModel_R2C2.OutfitName:ClearAllPoints()
TOM_PreviewModel_R2C2.OutfitName:SetPoint("BOTTOM", TOM_PreviewModel_R2C2, "BOTTOM", 0, 10)
TOM_PreviewModel_R2C2.OutfitName:Hide()
TOM_PreviewModel_R2C2:Hide()
TOM.previewModelFrames[6] = TOM_PreviewModel_R2C2

------------------
--ROW 2 COLUMN 3--
------------------
TOM_PreviewModel_R2C3 = CreateFrame("DressUpModel", "TOM_PreviewModel_R2C3", TOM_OutfitContainer, "BackdropTemplate")
TOM_PreviewModel_R2C3:SetSize(125, 175)
TOM_PreviewModel_R2C3:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_PreviewModel_R2C3:SetBackdropColor(0, 0, 0, 1)
TOM_PreviewModel_R2C3:Show()
TOM_PreviewModel_R2C3:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", 65, -75)
TOM_PreviewModel_R2C3:EnableMouse(true)
TOM_PreviewModel_R2C3:SetScript("OnMouseDown", TOM_PreviewModel_OnMouseDown)
TOM_PreviewModel_R2C3:SetUnit("player")
TOM_PreviewModel_R2C3.OutfitName = TOM_PreviewModel_R2C3:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_PreviewModel_R2C3.OutfitName:ClearAllPoints()
TOM_PreviewModel_R2C3.OutfitName:SetPoint("BOTTOM", TOM_PreviewModel_R2C3, "BOTTOM", 0, 10)
TOM_PreviewModel_R2C3.OutfitName:Hide()
TOM_PreviewModel_R2C3:Hide()
TOM.previewModelFrames[7] = TOM_PreviewModel_R2C3

------------------
--ROW 2 COLUMN 4--
------------------
TOM_PreviewModel_R2C4 = CreateFrame("DressUpModel", "TOM_PreviewModel_R2C4", TOM_OutfitContainer, "BackdropTemplate")
TOM_PreviewModel_R2C4:SetSize(125, 175)
TOM_PreviewModel_R2C4:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_PreviewModel_R2C4:SetBackdropColor(0, 0, 0, 1)
TOM_PreviewModel_R2C4:Show()
TOM_PreviewModel_R2C4:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", 200, -75)
TOM_PreviewModel_R2C4:EnableMouse(true)
TOM_PreviewModel_R2C4:SetScript("OnMouseDown", TOM_PreviewModel_OnMouseDown)
TOM_PreviewModel_R2C4:SetUnit("player")
TOM_PreviewModel_R2C4.OutfitName = TOM_PreviewModel_R2C4:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_PreviewModel_R2C4.OutfitName:ClearAllPoints()
TOM_PreviewModel_R2C4.OutfitName:SetPoint("BOTTOM", TOM_PreviewModel_R2C4, "BOTTOM", 0, 10)
TOM_PreviewModel_R2C4.OutfitName:Hide()
TOM_PreviewModel_R2C4:Hide()
TOM.previewModelFrames[8] = TOM_PreviewModel_R2C4