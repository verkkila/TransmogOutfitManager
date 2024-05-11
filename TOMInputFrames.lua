local addonName, TOM = ...

TOM.Input = TOM.Input or {}

TOM.Input.OutfitsButton = CreateFrame("Button", nil, WardrobeFrame, "UIPanelButtonTemplate")
TOM.Input.OutfitsButton:ClearAllPoints()
TOM.Input.OutfitsButton:SetPoint("TOPLEFT", 3, -60)
TOM.Input.OutfitsButton:SetSize(60, 25)
TOM.Input.OutfitsButton:SetText("Outfits")

TOM.Input.OutfitNameBox = CreateFrame("EditBox", nil, WardrobeFrame, "InputBoxTemplate")
TOM.Input.OutfitNameBox:ClearAllPoints()
TOM.Input.OutfitNameBox:SetPoint("TOPLEFT", 70, -55)
TOM.Input.OutfitNameBox:SetSize(175, 35)
TOM.Input.OutfitNameBox:SetAutoFocus(false)

TOM.Input.SaveOutfitButton = CreateFrame("Button", nil, WardrobeFrame, "UIPanelButtonTemplate")
TOM.Input.SaveOutfitButton:ClearAllPoints()
TOM.Input.SaveOutfitButton:SetPoint("TOPLEFT", 248, -60)
TOM.Input.SaveOutfitButton:SetSize(60, 25)
TOM.Input.SaveOutfitButton:SetText("Save")

TOM.Input.PreviousPageButton = CreateFrame("Button", nil, TOM.Display.Container, "CollectionsPrevPageButton")
TOM.Input.PreviousPageButton:ClearAllPoints()
TOM.Input.PreviousPageButton:SetPoint("CENTER", TOM.Display.Container, "BOTTOM", 20, 40)
TOM.Input.PreviousPageButton:SetEnabled(false)

TOM.Input.NextPageButton = CreateFrame("Button", nil, TOM.Display.Container, "CollectionsNextPageButton")
TOM.Input.NextPageButton:ClearAllPoints()
TOM.Input.NextPageButton:SetPoint("CENTER", TOM.Display.Container, "BOTTOM", 60, 40)
TOM.Input.NextPageButton:SetEnabled(false)

TOM.Input.OutfitDropdown = CreateFrame("Frame", "TransmogOutfitManagerOutfitDropdown", TOM.Display.Container, "UIDropDownMenuTemplate")

local function renameDialogOnAccept(self, oldName)
	local newName = self.editBox:GetText()
	if TOM.Core.RenameOutfit(TOM.Display.selectedModelFrame, newName) then
		TOM.Display.selectedModelFrame.OutfitName:SetText(newName)
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
			self:GetParent().button1:SetEnabled(TOM.Core.GetOutfitByFrame(TOM.Display.selectedModelFrame).name ~= self:GetText())
		end
	end,
	OnAccept = renameDialogOnAccept,
	OnShow = TOM.Display.Lock,
	OnHide = TOM.Display.Unlock,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}

local function deleteDialogOnAccept(self, name)
	TOM.Core.DeleteOutfit(name)
	TOM.Display.Redraw()
end

StaticPopupDialogs["TOM_DeleteOutfit"] = {
	text = "---",
	button1 = "Yes",
	button2 = "No",
	OnAccept = deleteDialogOnAccept,
	OnShow = TOM.Display.Lock,
	OnHide = TOM.Display.Unlock,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}

local function overwriteDialogOnAccept(self, name, data)
	TOM.Core.OverwriteOutfit(name, data)
	TOM.Display.Redraw()
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