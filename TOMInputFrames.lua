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
	local validName = TOM.Core.IsValidName(TOM.OutfitNameInput:GetText())
	if TOM.appliedOutfitName and (TOM.appliedOutfitName ~= TOM.OutfitNameInput:GetText()) then
		local isOutfitDifferent = not TOM.Core.IsWearingOutfit(TOM.appliedOutfitName)
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
	if TOM.Core.GetOutfitByName(outfitName) > 0 then
		StaticPopupDialogs["TOM_OverwriteOutfit"].text = "Overwrite \'" .. outfitName .. "\'?"
		local dialog = StaticPopup_Show("TOM_OverwriteOutfit")
		if dialog then
			dialog.data = outfitName
			dialog.data2 = slotData
		end
	else
		TOM.Core.SaveOutfit(outfitName, slotData)
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

local function renameDialogOnAccept(self, oldName)
	local newName = self.editBox:GetText()
	if TOM.Core.RenameOutfit(oldName, newName) then
		--RenameOutfit returns index so could fetch the new name instead of using editbox
		TOM.activeModelFrame.OutfitName:SetText(newName)
	end
end

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
		if TOM.Core.IsValidName(self:GetText()) then
			self:GetParent().button1:SetEnabled(TOM.Core.GetOutfitByName(self:GetText()) == 0)
		end
	end,
	OnAccept = renameDialogOnAccept,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}

local function deleteDialogOnAccept(self, name)
	TOM.Core.DeleteOutfit(name)
	TOM.OutfitContainer_OnShow()
end

StaticPopupDialogs["TOM_DeleteOutfit"] = {
	text = "---",
	button1 = "Yes",
	button2 = "No",
	OnAccept = deleteDialogOnAccept,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}

local function overwriteDialogOnAccept(self, name, data)
	TOM.Core.OverwriteOutfit(name, data)
	TOM.OutfitContainer_OnShow()
end

StaticPopupDialogs["TOM_OverwriteOutfit"] = {
	text = "---",
	button1 = "Yes",
	button2 = "No",
	OnAccept = overwriteDialogOnAccept,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}