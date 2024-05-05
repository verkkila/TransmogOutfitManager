local function TOM_OutfitsButton_OnClick(self, button, down)
	if not TOM_OutfitContainer:IsVisible() then TOM_OutfitContainer:Show()
	else TOM_OutfitContainer:Hide() end
end

local function TOM_OutfitNameInput_OnEscapePressed(self)
	self:ClearFocus()
end

local function TOM_SaveOutfitButton_OnClick(self, button, down)
	print(button, down)
end

TOM_OutfitsButton = CreateFrame("Button", "TOM_OutfitsButton", WardrobeFrame, "UIPanelButtonTemplate")
TOM_OutfitsButton:ClearAllPoints()
TOM_OutfitsButton:SetPoint("TOPLEFT", 3, -60)
TOM_OutfitsButton:SetSize(60, 25)
TOM_OutfitsButton:SetText("Outfits")
TOM_OutfitsButton:SetScript("OnClick", TOM_OutfitsButton_OnClick)

TOM_OutfitNameInput = CreateFrame("EditBox", "TOM_OutfitNameInput", WardrobeFrame, "InputBoxTemplate")
TOM_OutfitNameInput:ClearAllPoints()
TOM_OutfitNameInput:SetPoint("TOPLEFT", 70, -55)
TOM_OutfitNameInput:SetSize(175, 35)
TOM_OutfitNameInput:SetAutoFocus(false)

TOM_SaveOutfitButton = CreateFrame("Button", "TOM_SaveOutfitButton", WardrobeFrame, "UIPanelButtonTemplate")
TOM_SaveOutfitButton:ClearAllPoints()
TOM_SaveOutfitButton:SetPoint("TOPLEFT", 248, -60)
TOM_SaveOutfitButton:SetSize(60, 25)
TOM_SaveOutfitButton:SetText("Save")
TOM_SaveOutfitButton:SetScript("OnClick", TOM_SaveOutfitButton_OnClick)

TOM_OutfitContainer = CreateFrame("Frame", "TOM_OutfitContainer", WardrobeFrame, "CollectionsBackgroundTemplate")
TOM_OutfitContainer:ClearAllPoints()
TOM_OutfitContainer:SetPoint("CENTER", UIParent)
TOM_OutfitContainer:SetSize(600, 500)
TOM_OutfitContainer:SetFrameLevel(6)
TOM_OutfitContainer:SetMovable(true)
TOM_OutfitContainer:EnableMouse(true)
TOM_OutfitContainer:RegisterForDrag("LeftButton")
TOM_OutfitContainer:SetScript("OnDragStart", function(self, button)
	self:StartMoving()
end)
TOM_OutfitContainer:SetScript("OnDragStop", function(self, button)
	self:StopMovingOrSizing()
end)
TOM_OutfitContainer:Hide()
--ROW 1 COLUMN 1
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
TOM_Outfit1:SetUnit("player")

--ROW 1 COLUMN 2
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
TOM_Outfit2:SetUnit("player")

--ROW 1 COLUMN 3
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
TOM_Outfit3:SetUnit("player")

--ROW 1 COLUMN 4
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
TOM_Outfit4:SetUnit("player")

--ROW 2 COLUMN 1
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
TOM_Outfit5:SetUnit("player")

--ROW 2 COLUMN 2
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
TOM_Outfit6:SetUnit("player")

--ROW 2 COLUMN 3
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
TOM_Outfit7:SetUnit("player")

--ROW 2 COLUMN 4
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
TOM_Outfit8:SetUnit("player")