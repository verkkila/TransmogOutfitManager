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
TOM.Input.OutfitNameBox:SetSize(173, 35)
TOM.Input.OutfitNameBox:SetAutoFocus(false)

TOM.Input.SaveOutfitButton = CreateFrame("Button", nil, WardrobeFrame, "UIPanelButtonTemplate")
TOM.Input.SaveOutfitButton:ClearAllPoints()
TOM.Input.SaveOutfitButton:SetPoint("TOPLEFT", 245, -60)
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

TOM.Input.ShareOutfitsButton = CreateFrame("CheckButton", nil, TOM.Display.Container, "ChatConfigCheckButtonTemplate")
TOM.Input.ShareOutfitsButton:ClearAllPoints()
TOM.Input.ShareOutfitsButton:SetPoint("CENTER", TOM.Display.Container, "TOPLEFT", 60, -30)
TOM.Input.ShareOutfitsButton.Text:SetText("Show outfits from other characters")

TOM.Input.FilterOutfitsBox = CreateFrame("EditBox", nil, TOM.Display.Container, "SearchBoxTemplate")
TOM.Input.FilterOutfitsBox:ClearAllPoints()
TOM.Input.FilterOutfitsBox:SetPoint("LEFT", TOM.Display.Container, "TOPRIGHT", -289, -28)
TOM.Input.FilterOutfitsBox:SetSize(120, 35)
TOM.Input.FilterOutfitsBox:SetAutoFocus(false)

TOM.Input.SortOutfitsButton = CreateFrame("Button", nil, TOM.Display.Container, "UIMenuButtonStretchTemplate")
TOM.Input.SortOutfitsButton:ClearAllPoints()
TOM.Input.SortOutfitsButton:SetPoint("RIGHT", TOM.Display.Container, "TOPRIGHT", -110, -29)
TOM.Input.SortOutfitsButton:SetSize(50, 22)
TOM.Input.SortOutfitsButton:SetText("Sort")

TOM.Input.OutfitDropdown = CreateFrame("Frame", "TransmogOutfitManager_OutfitDropdown", TOM.Display.Container, "UIDropDownMenuTemplate")

local function renameDialogOnAccept(self)
	local newName = self.editBox:GetText()
	if TOM.Core.RenameOutfit(TOM.Display.selectedModelFrame, newName) then
		TOM.Display.selectedModelFrame.OutfitName:SetText(newName)
	end
end

local function renameDialogOnTextChanged(self)
	if not TOM.Core.IsValidName(self:GetText()) then
		self:GetParent().button1:SetEnabled(false)
		return
	end
	local owner = TOM.Core.GetOwner(TOM.Display.selectedModelFrame)
	if owner then
		local outfitExists = TOM.Core.OutfitExists(self:GetText(), owner.name, owner.realm, owner.class)
		if outfitExists then
			self:GetParent().button1:SetEnabled(false)
			return
		end
	end
	self:GetParent().button1:SetEnabled(true)
end

StaticPopupDialogs["TransmogOutfitManager_RenameDialog"] = {
	text = "Enter new name for outfit",
	button1 = "Rename",
	button2 = "Cancel",
	enterClicksFirstButton = true,
	hasEditBox = true,
	OnShow = function(self, data)
		self.button1:Disable()
	end,
	EditBoxOnTextChanged = renameDialogOnTextChanged,
	OnAccept = renameDialogOnAccept,
	OnShow = TOM.Display.Lock,
	OnHide = TOM.Display.Unlock,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}

local function deleteDialogOnAccept(self)
	TOM.Core.DeleteOutfit(TOM.Display.selectedModelFrame)
	TOM.Display.Redraw()
end

StaticPopupDialogs["TransmogOutfitManager_DeleteDialog"] = {
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

local function overwriteDialogOnAccept(self, outfitInfo)
	TOM.Core.OverwriteOutfit(outfitInfo)
	TOM.Display.Redraw()
end

StaticPopupDialogs["TransmogOutfitManager_OverwriteDialog"] = {
	text = "---",
	button1 = "Yes",
	button2 = "No",
	OnAccept = overwriteDialogOnAccept,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}