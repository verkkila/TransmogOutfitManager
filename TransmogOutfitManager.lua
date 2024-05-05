local DROPDOWN_RENAME = 1
local DROPDOWN_DELETE = 2
local slotIdToName = {[1] = "HEADSLOT",
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
					  [19] = "TABARDSLOT"}
local outfitFrames = {}
local activeModelFrame = nil
MyOutfits = {}

local function getTransmogId(slot)
	if slot.hasUndo then return slot.base
	elseif slot.pending ~= 0 then return slot.pending
	elseif slot.applied ~= 0 then return slot.applied
	else return slot.base end
end

local function TOM_OutfitContainer_OnShow()
	local nextFrame = 1
	for i = 1, 8 do outfitFrames[i]:Hide() end
	for _, outfit in pairs(MyOutfits) do
		outfitFrames[nextFrame]:Show()
		outfitFrames[nextFrame].OutfitName:SetText(outfit.name)
		outfitFrames[nextFrame].OutfitName:Show()
		outfitFrames[nextFrame]:Undress()
		for invSlotName, invSlotData in pairs(outfit.data) do
			print(invSlotName, invSlotData.pending, invSlotData.base, invSlotData.applied)
			local transmogId = getTransmogId(invSlotData)
			if transmogId > 0 then
				outfitFrames[nextFrame]:TryOn(tonumber(transmogId))
			end
		end
		nextFrame = nextFrame + 1
		if nextFrame > 8 then nextFrame = 1 end
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

local function isValidName(name)
	local nameLength = string.len(name)
	if nameLength == 0 or nameLength > 15 then
		return false
	else
		return true
	end
end

local function TOM_OutfitNameInput_OnTextChanged(self, userInput)
	TOM_SaveOutfitButton:SetEnabled(isValidName(TOM_OutfitNameInput:GetText()))
end

local function TOM_SaveOutfitButton_OnClick(self, button, down)
	local outfitName = TOM_OutfitNameInput:GetText()
	if outfitName == "" then return end
	local slotData = {}
	for slotId, slotName in pairs(slotIdToName) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		slotData[slotName] = {base=baseSourceID, applied=appliedSourceID, pending=pendingSourceID, hasUndo=hasUndo}
	end
	table.insert(MyOutfits, {name=outfitName, data=slotData})
	TOM_OutfitContainer_OnShow()
end

local function TOM_Outfit_OnMouseDown(self, button)
	if button == "LeftButton" then
		local outfitName = GetMouseFocus().OutfitName:GetText()
		if not outfitName then return end
		local outfitData = nil
		for _, outfit in pairs(MyOutfits) do
			if outfitName == outfit.name then
				for invSlotName, invSlotData in pairs(outfit.data) do
					local transmogLoc = TransmogUtil.CreateTransmogLocation(invSlotName, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
					C_Transmog.ClearPending(transmogLoc)
					local _, _, _, canTransmog = C_Transmog.GetSlotInfo(transmogLoc)
					local id = getTransmogId(invSlotData)
					if canTransmog and id then
						C_Transmog.SetPending(transmogLoc, TransmogUtil.CreateTransmogPendingInfo(Enum.TransmogPendingType.Apply, id))
					end
				end
			end
		end
	elseif button == "RightButton" then
		activeModelFrame = GetMouseFocus()
		ToggleDropDownMenu(1, nil, TOM_OutfitDropdownMenu, GetMouseFocus():GetName(), 0, 0)
	end
end

local function renameOutfit(newName)
	for _, outfit in pairs(MyOutfits) do
		if outfit.name == activeModelFrame.OutfitName:GetText() then
			activeModelFrame.OutfitName:SetText(newName)
			outfit.name = newName
		end
	end
end

local function deleteOutfit()
	for i, outfit in ipairs(MyOutfits) do
		if MyOutfits[i].name == activeModelFrame.OutfitName:GetText() then
			MyOutfits[i] = nil
			activeModelFrame:Hide()
			TOM_OutfitContainer_OnShow()
		end
	end
end

local function onDropdownMenuItemClicked(selectedItem)
	if selectedItem.value == DROPDOWN_RENAME then
		StaticPopup_Show("TOM_RenameOutfit")
	elseif selectedItem.value == DROPDOWN_DELETE then
		StaticPopupDialogs["TOM_DeleteOutfit"].text = "Delete outfit \'"..activeModelFrame.OutfitName:GetText().."\'?"
		StaticPopup_Show("TOM_DeleteOutfit")
	end
end

local function TOM_OutfitDropdownMenu_Handler()
	local renameMenuItem = {}
	renameMenuItem.text = "Rename"
	renameMenuItem.value = 1
	renameMenuItem.notCheckable = true
	renameMenuItem.func = onDropdownMenuItemClicked
	local deleteMenuItem = {}
	deleteMenuItem.text = "Delete"
	deleteMenuItem.value = 2
	deleteMenuItem.notCheckable = true
	deleteMenuItem.func = onDropdownMenuItemClicked
	UIDropDownMenu_AddButton(renameMenuItem)
	UIDropDownMenu_AddButton(deleteMenuItem)
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
TOM_OutfitNameInput:SetScript("OnTextChanged", TOM_OutfitNameInput_OnTextChanged)

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
TOM_OutfitContainer:SetScript("OnEvent", TOM_OnEvent)
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
TOM_Outfit1:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit1:SetUnit("player")
TOM_Outfit1.OutfitName = TOM_Outfit1:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit1.OutfitName:ClearAllPoints()
TOM_Outfit1.OutfitName:SetPoint("BOTTOM", TOM_Outfit1, "BOTTOM", 0, 10)
TOM_Outfit1.OutfitName:Hide()
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
TOM_Outfit2:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit2:SetUnit("player")
TOM_Outfit2.OutfitName = TOM_Outfit2:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit2.OutfitName:ClearAllPoints()
TOM_Outfit2.OutfitName:SetPoint("BOTTOM", TOM_Outfit2, "BOTTOM", 0, 10)
TOM_Outfit2.OutfitName:Hide()
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
TOM_Outfit3:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit3:SetUnit("player")
TOM_Outfit3.OutfitName = TOM_Outfit3:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit3.OutfitName:ClearAllPoints()
TOM_Outfit3.OutfitName:SetPoint("BOTTOM", TOM_Outfit3, "BOTTOM", 0, 10)
TOM_Outfit3.OutfitName:Hide()
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
TOM_Outfit4:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit4:SetUnit("player")
TOM_Outfit4.OutfitName = TOM_Outfit4:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit4.OutfitName:ClearAllPoints()
TOM_Outfit4.OutfitName:SetPoint("BOTTOM", TOM_Outfit4, "BOTTOM", 0, 10)
TOM_Outfit4.OutfitName:Hide()
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
TOM_Outfit5:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit5:SetUnit("player")
TOM_Outfit5.OutfitName = TOM_Outfit5:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit5.OutfitName:ClearAllPoints()
TOM_Outfit5.OutfitName:SetPoint("BOTTOM", TOM_Outfit5, "BOTTOM", 0, 10)
TOM_Outfit5.OutfitName:Hide()
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
TOM_Outfit6:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit6:SetUnit("player")
TOM_Outfit6.OutfitName = TOM_Outfit6:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit6.OutfitName:ClearAllPoints()
TOM_Outfit6.OutfitName:SetPoint("BOTTOM", TOM_Outfit6, "BOTTOM", 0, 10)
TOM_Outfit6.OutfitName:Hide()
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
TOM_Outfit7:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit7:SetUnit("player")
TOM_Outfit7.OutfitName = TOM_Outfit7:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit7.OutfitName:ClearAllPoints()
TOM_Outfit7.OutfitName:SetPoint("BOTTOM", TOM_Outfit7, "BOTTOM", 0, 10)
TOM_Outfit7.OutfitName:Hide()
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
TOM_Outfit8:SetScript("OnMouseDown", TOM_Outfit_OnMouseDown)
TOM_Outfit8:SetUnit("player")
TOM_Outfit8.OutfitName = TOM_Outfit8:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM_Outfit8.OutfitName:ClearAllPoints()
TOM_Outfit8.OutfitName:SetPoint("BOTTOM", TOM_Outfit8, "BOTTOM", 0, 10)
TOM_Outfit8.OutfitName:Hide()
TOM_Outfit8:Hide()
outfitFrames[8] = TOM_Outfit8

TOM_OutfitDropdownMenu = CreateFrame("Frame", "TOM_OutfitDropdownMenu", TOM_OutfitContainer, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(TOM_OutfitDropdownMenu, TOM_OutfitDropdownMenu_Handler, "MENU")
TOM_OutfitDropdownMenu:Hide()

StaticPopupDialogs["TOM_RenameOutfit"] = {
	text = "Enter new name for outfit",
	button1 = "Rename",
	button2 = "Cancel",
	enterClicksFirstButton = true,
	hasEditBox = true,
	OnShow = function(self, data)
		self.button1:Disable()
	end,
	EditBoxOnTextChanged = function(self, data)
		if isValidName(self:GetText()) then
			self:GetParent().button1:Enable()
		end
	end,
	OnAccept = function(self, data, data2)
		renameOutfit(self.editBox:GetText())
	end,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}

StaticPopupDialogs["TOM_DeleteOutfit"] = {
	text = "---",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
		deleteOutfit()
	end,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}