TOM.previewModelFrames = {}

--[[
function TOM_GetPreviewModelFrame(index)
	return TOM.previewModelFrames[index]
end
--]]

function TOM_GetPreviewModelFrame(row, column)
	if row < 1 or row > 2 then return nil end
	if column < 1 or column > 4 then return nil end
	return TOM.previewModelFrames[(row-1)*4+column]
end

------------------
--ROW 1 COLUMN 1--
------------------
TOM_Outfit1 = CreateFrame("DressUpModel", "TOM_Outfit1", TOM_OutfitContainer, "BackdropTemplate")
TOM_Outfit1:SetSize(125, 175)
TOM_Outfit1:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_Outfit1:SetBackdropColor(0, 0, 0, 1)
TOM_Outfit1:Show()
TOM_Outfit1:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", -200, 125)
TOM_Outfit1:EnableMouse(true)
TOM_Outfit1:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit1:SetUnit("player")
TOM_Outfit1.OutfitName = TOM_Outfit1:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit1.OutfitName:ClearAllPoints()
TOM_Outfit1.OutfitName:SetPoint("BOTTOM", TOM_Outfit1, "BOTTOM", 0, 10)
TOM_Outfit1.OutfitName:Hide()
TOM_Outfit1:Hide()
TOM.previewModelFrames[1] = TOM_Outfit1

------------------
--ROW 1 COLUMN 2--
------------------
TOM_Outfit2 = CreateFrame("DressUpModel", "TOM_Outfit2", TOM_OutfitContainer, "BackdropTemplate")
TOM_Outfit2:SetSize(125, 175)
TOM_Outfit2:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_Outfit2:SetBackdropColor(0, 0, 0, 1)
TOM_Outfit2:Show()
TOM_Outfit2:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", -65, 125)
TOM_Outfit2:EnableMouse(true)
TOM_Outfit2:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit2:SetUnit("player")
TOM_Outfit2.OutfitName = TOM_Outfit2:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit2.OutfitName:ClearAllPoints()
TOM_Outfit2.OutfitName:SetPoint("BOTTOM", TOM_Outfit2, "BOTTOM", 0, 10)
TOM_Outfit2.OutfitName:Hide()
TOM_Outfit2:Hide()
TOM.previewModelFrames[2] = TOM_Outfit2

------------------
--ROW 1 COLUMN 3--
------------------
TOM_Outfit3 = CreateFrame("DressUpModel", "TOM_Outfit3", TOM_OutfitContainer, "BackdropTemplate")
TOM_Outfit3:SetSize(125, 175)
TOM_Outfit3:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_Outfit3:SetBackdropColor(0, 0, 0, 1)
TOM_Outfit3:Show()
TOM_Outfit3:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", 65, 125)
TOM_Outfit3:EnableMouse(true)
TOM_Outfit3:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit3:SetUnit("player")
TOM_Outfit3.OutfitName = TOM_Outfit3:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit3.OutfitName:ClearAllPoints()
TOM_Outfit3.OutfitName:SetPoint("BOTTOM", TOM_Outfit3, "BOTTOM", 0, 10)
TOM_Outfit3.OutfitName:Hide()
TOM_Outfit3:Hide()
TOM.previewModelFrames[3] = TOM_Outfit3

------------------
--ROW 1 COLUMN 4--
------------------
TOM_Outfit4 = CreateFrame("DressUpModel", "TOM_Outfit4", TOM_OutfitContainer, "BackdropTemplate")
TOM_Outfit4:SetSize(125, 175)
TOM_Outfit4:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_Outfit4:SetBackdropColor(0, 0, 0, 1)
TOM_Outfit4:Show()
TOM_Outfit4:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", 200, 125)
TOM_Outfit4:EnableMouse(true)
TOM_Outfit4:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit4:SetUnit("player")
TOM_Outfit4.OutfitName = TOM_Outfit4:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit4.OutfitName:ClearAllPoints()
TOM_Outfit4.OutfitName:SetPoint("BOTTOM", TOM_Outfit4, "BOTTOM", 0, 10)
TOM_Outfit4.OutfitName:Hide()
TOM_Outfit4:Hide()
TOM.previewModelFrames[4] = TOM_Outfit4

------------------
--ROW 2 COLUMN 1--
------------------
TOM_Outfit5 = CreateFrame("DressUpModel", "TOM_Outfit5", TOM_OutfitContainer, "BackdropTemplate")
TOM_Outfit5:SetSize(125, 175)
TOM_Outfit5:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_Outfit5:SetBackdropColor(0, 0, 0, 1)
TOM_Outfit5:Show()
TOM_Outfit5:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", -200, -75)
TOM_Outfit5:EnableMouse(true)
TOM_Outfit5:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit5:SetUnit("player")
TOM_Outfit5.OutfitName = TOM_Outfit5:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit5.OutfitName:ClearAllPoints()
TOM_Outfit5.OutfitName:SetPoint("BOTTOM", TOM_Outfit5, "BOTTOM", 0, 10)
TOM_Outfit5.OutfitName:Hide()
TOM_Outfit5:Hide()
TOM.previewModelFrames[5] = TOM_Outfit5

------------------
--ROW 2 COLUMN 2--
------------------
TOM_Outfit6 = CreateFrame("DressUpModel", "TOM_Outfit6", TOM_OutfitContainer, "BackdropTemplate")
TOM_Outfit6:SetSize(125, 175)
TOM_Outfit6:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_Outfit6:SetBackdropColor(0, 0, 0, 1)
TOM_Outfit6:Show()
TOM_Outfit6:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", -65, -75)
TOM_Outfit6:EnableMouse(true)
TOM_Outfit6:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit6:SetUnit("player")
TOM_Outfit6.OutfitName = TOM_Outfit6:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit6.OutfitName:ClearAllPoints()
TOM_Outfit6.OutfitName:SetPoint("BOTTOM", TOM_Outfit6, "BOTTOM", 0, 10)
TOM_Outfit6.OutfitName:Hide()
TOM_Outfit6:Hide()
TOM.previewModelFrames[6] = TOM_Outfit6

------------------
--ROW 2 COLUMN 3--
------------------
TOM_Outfit7 = CreateFrame("DressUpModel", "TOM_Outfit7", TOM_OutfitContainer, "BackdropTemplate")
TOM_Outfit7:SetSize(125, 175)
TOM_Outfit7:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_Outfit7:SetBackdropColor(0, 0, 0, 1)
TOM_Outfit7:Show()
TOM_Outfit7:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", 65, -75)
TOM_Outfit7:EnableMouse(true)
TOM_Outfit7:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit7:SetUnit("player")
TOM_Outfit7.OutfitName = TOM_Outfit7:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit7.OutfitName:ClearAllPoints()
TOM_Outfit7.OutfitName:SetPoint("BOTTOM", TOM_Outfit7, "BOTTOM", 0, 10)
TOM_Outfit7.OutfitName:Hide()
TOM_Outfit7:Hide()
TOM.previewModelFrames[7] = TOM_Outfit7

------------------
--ROW 2 COLUMN 4--
------------------
TOM_Outfit8 = CreateFrame("DressUpModel", "TOM_Outfit8", TOM_OutfitContainer, "BackdropTemplate")
TOM_Outfit8:SetSize(125, 175)
TOM_Outfit8:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background",
							edgeFile="Interface/Tooltips/UI-Tooltip-Border",
							tile=true,
							tileSize=16,
							edgeSize=16,
							insets={left=1,
									right=1,
									top=1,
									bottom=1}
})
TOM_Outfit8:SetBackdropColor(0, 0, 0, 1)
TOM_Outfit8:Show()
TOM_Outfit8:SetPoint("CENTER", TOM_OutfitContainer, "CENTER", 200, -75)
TOM_Outfit8:EnableMouse(true)
TOM_Outfit8:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit8:SetUnit("player")
TOM_Outfit8.OutfitName = TOM_Outfit8:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit8.OutfitName:ClearAllPoints()
TOM_Outfit8.OutfitName:SetPoint("BOTTOM", TOM_Outfit8, "BOTTOM", 0, 10)
TOM_Outfit8.OutfitName:Hide()
TOM_Outfit8:Hide()
TOM.previewModelFrames[8] = TOM_Outfit8