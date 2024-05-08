local addonName, TOM = ...

local function renameOutfit(self, oldName, newName)
	if TOM.RenameOutfit(oldName, newName) then
		TOM.activeModelFrame.OutfitName:SetText(newName)
	end
end

local function deleteOutfit(self, outfitName)
	TOM.DeleteOutfitByName(outfitName)
	TOM.OutfitContainer_OnShow()
end

local function overwriteOutfit(self, outfitName, slotData)
	TOM.OverwriteOutfit(outfitName, slotData)
	TOM.OutfitContainer_OnShow()
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
		if TOM.IsValidName(self:GetText()) then
			self:GetParent().button1:SetEnabled(TOM.OutfitExistsByName(self:GetText()) == 0)
		end
	end,
	OnAccept = function(self, data, data2)
		renameOutfit(self, data, self.editBox:GetText())
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
	OnAccept = function(self, data)
		deleteOutfit(self, data)
	end,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}

StaticPopupDialogs["TOM_OverwriteOutfit"] = {
	text = "---",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, data, data2)
		overwriteOutfit(self, data, data2)
	end,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3
}