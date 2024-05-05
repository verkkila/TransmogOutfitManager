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

local function TOM_OutfitNameInput_OnTextChanged(self, userInput)
	TOM_SaveOutfitButton:SetEnabled(TOM_IsValidName(TOM_OutfitNameInput:GetText()) and TOM_NumSavedOutfits() < 8)
end

local function TOM_SaveOutfitButton_OnClick(self, button, down)
	local outfitName = TOM_OutfitNameInput:GetText()
	if outfitName == "" then return end
	local slotData = {}
	for slotId, slotName in pairs(TOM.SLOTID_TO_NAME) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		slotData[slotName] = {base=baseSourceID, applied=appliedSourceID, pending=pendingSourceID, hasUndo=hasUndo}
	end
	table.insert(MyOutfits, {name=outfitName, data=slotData})
	if TOM_NumSavedOutfits() >= 8 then TOM_SaveOutfitButton:SetEnabled(false) end -- Remove this when paging is implemented
	TOM_OutfitContainer_OnShow()
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