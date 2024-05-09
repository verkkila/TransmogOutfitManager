local addonName, TOM = ...

local function TOM_OutfitsButton_OnClick(self, button, down)
	if not TOM.OutfitContainer:IsVisible() then
		TOM.OutfitContainer:Show()
	else
		TOM.OutfitContainer:Hide()
	end
end

local function TOM_OutfitNameInput_OnTextChanged(self, userInput)
	TOM.SetSaveButtonStatus()
end

function TOM.SetSaveButtonStatus()
	local validName = TOM.IsValidName(TOM.OutfitNameInput:GetText())
	if TOM.appliedOutfitName and (TOM.appliedOutfitName ~= TOM.OutfitNameInput:GetText()) then
		local isOutfitDifferent = not TOM.IsWearingOutfit(TOM.appliedOutfitName)
		TOM.SaveOutfitButton:SetEnabled(validName and isOutfitDifferent)
	else
		TOM.SaveOutfitButton:SetEnabled(validName)
	end
end

local function TOM_SaveOutfitButton_OnClick(self, button, down)
	local outfitName = TOM.OutfitNameInput:GetText()
	if outfitName == "" then return end
	local slotData = {}
	for slotId, slotName in pairs(TOM.const.SLOTID_TO_NAME) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		slotData[slotName] = {base=baseSourceID, applied=appliedSourceID, pending=pendingSourceID, hasUndo=hasUndo}
	end
	if TOM.OutfitExistsByName(outfitName) > 0 then
		StaticPopupDialogs["TOM_OverwriteOutfit"].text = "Overwrite \'" .. outfitName .. "\'?"
		local dialog = StaticPopup_Show("TOM_OverwriteOutfit")
		if dialog then
			dialog.data = outfitName
			dialog.data2 = slotData
		end
	else
		TOM.SaveOutfit(outfitName, slotData)
	end
	TOM.OutfitContainer_OnShow()
end

TOM.OutfitsButton = CreateFrame("Button", nil, WardrobeFrame, "UIPanelButtonTemplate")
TOM.OutfitsButton:ClearAllPoints()
TOM.OutfitsButton:SetPoint("TOPLEFT", 3, -60)
TOM.OutfitsButton:SetSize(60, 25)
TOM.OutfitsButton:SetText("Outfits")
TOM.OutfitsButton:SetScript("OnClick", TOM_OutfitsButton_OnClick)

TOM.OutfitNameInput = CreateFrame("EditBox", nil, WardrobeFrame, "InputBoxTemplate")
TOM.OutfitNameInput:ClearAllPoints()
TOM.OutfitNameInput:SetPoint("TOPLEFT", 70, -55)
TOM.OutfitNameInput:SetSize(175, 35)
TOM.OutfitNameInput:SetAutoFocus(false)
TOM.OutfitNameInput:SetScript("OnTextChanged", TOM_OutfitNameInput_OnTextChanged)

TOM.SaveOutfitButton = CreateFrame("Button", nil, WardrobeFrame, "UIPanelButtonTemplate")
TOM.SaveOutfitButton:ClearAllPoints()
TOM.SaveOutfitButton:SetPoint("TOPLEFT", 248, -60)
TOM.SaveOutfitButton:SetSize(60, 25)
TOM.SaveOutfitButton:SetText("Save")
TOM.SaveOutfitButton:SetScript("OnClick", TOM_SaveOutfitButton_OnClick)