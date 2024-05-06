local function renameOutfit(newName)
	for _, outfit in pairs(MyOutfits) do
		if outfit.name == TOM.activeModelFrame.OutfitName:GetText() then
			TOM.activeModelFrame.OutfitName:SetText(newName)
			outfit.name = newName
		end
	end
end

local function deleteOutfit()
	for i, outfit in ipairs(MyOutfits) do
		if MyOutfits[i].name == TOM.activeModelFrame.OutfitName:GetText() then
			table.remove(MyOutfits, i)
			TOM_OutfitContainer_OnShow()
		end
	end
end

local function overwriteOutfit(self, outfitName, slotData)
	for _, outfit in pairs(MyOutfits) do
		if outfit.name == outfitName then
			outfit.data = slotData
			TOM_OutfitContainer_OnShow()
		end
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
		if TOM_IsValidName(self:GetText()) then
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