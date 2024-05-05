local validSlots = {1,3,4,5,6,7,8,9,10,15,16,17,18,19}
local outfitFrames = {}
MyOutfits = {}

local function TOM_OutfitContainer_OnShow()
	local numOutfits = table.getn(MyOutfits)
	i = 1
	for outfitName, slotInfoList in pairs(MyOutfits) do
		if i > 8 then return end
		print("Applying outfit " .. outfitName .. " to frame " .. outfitFrames[i]:GetName())
		outfitFrames[i]:Show()
		for slotId, slotData in pairs(slotInfoList) do
			outfitFrames[i]:TryOn(slotData.applied)
		end
		i = i + 1
	end
end

local function TOM_OutfitsButton_OnClick(self, button, down)
	if not TOM_OutfitContainer:IsVisible() then
		TOM_OutfitContainer:Show()
	else
		TOM_OutfitContainer:Hide()
	end
end

local function TOM_OutfitNameInput_OnEscapePressed(self)
	self:ClearFocus()
end

local function TOM_SaveOutfitButton_OnClick(self, button, down)
	local outfitName = TOM_OutfitNameInput:GetText()
	if outfitName == "" then return end
	MyOutfits[outfitName] = {}
	for i, slot in ipairs(validSlots) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID=slot, type=0, modification=0})
		local slotStr = tostring(slot)
		MyOutfits[outfitName][slotStr] = {base=baseSourceID, applied=appliedSourceID, pending=pendingSourceID, hasUndo=hasUndo}
	end
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
TOM_OutfitContainer:SetScript("OnShow", TOM_OutfitContainer_OnShow)
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
TOM_Outfit1:Hide()
outfitFrames[1] = TOM_Outfit1

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
TOM_Outfit2:Hide()
outfitFrames[2] = TOM_Outfit2

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
TOM_Outfit3:Hide()
outfitFrames[3] = TOM_Outfit3

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
TOM_Outfit4:Hide()
outfitFrames[4] = TOM_Outfit4

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
TOM_Outfit5:Hide()
outfitFrames[5] = TOM_Outfit5

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
TOM_Outfit6:Hide()
outfitFrames[6] = TOM_Outfit6

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
TOM_Outfit7:Hide()
outfitFrames[7] = TOM_Outfit7

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
TOM_Outfit8:Hide()
outfitFrames[8] = TOM_Outfit8