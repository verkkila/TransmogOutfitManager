function TOM_OutfitContainer_OnShow(self)
	TOM_SetPageText()
	TOM_SetPageButtons()
	if TOM_GetCurrentPage() > TOM_NumPages() then TOM_PreviousPageButton:Click("LeftButton") end
	for row = 1, 2 do
		for column = 1, 4 do
			local index = ((TOM_GetCurrentPage() - 1) * 8) + ((row - 1) * 4 + column) --quite the expression
			local outfit = MyOutfits[index]
			if outfit then
				TOM_GetPreviewModelFrame(row, column):Show()
				TOM_GetPreviewModelFrame(row, column).OutfitName:SetText(outfit.name)
				TOM_GetPreviewModelFrame(row, column).OutfitName:Show()
				TOM_GetPreviewModelFrame(row, column):Undress()
				for invSlotName, invSlotData in pairs(outfit.data) do
					local transmogId = TOM_GetTransmogId(invSlotData)
					if transmogId > 0 then
						TOM_GetPreviewModelFrame(row, column):TryOn(transmogId)
					end
				end
			else
				TOM_GetPreviewModelFrame(row, column):Hide()
			end
		end
	end
end

function TOM_PreviewModel_OnMouseDown(self, button)
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
					local id = TOM_GetTransmogId(invSlotData)
					if canTransmog and id then
						C_Transmog.SetPending(transmogLoc, TransmogUtil.CreateTransmogPendingInfo(Enum.TransmogPendingType.Apply, id))
					end
				end
			end
		end
	elseif button == "RightButton" then
		TOM.activeModelFrame = GetMouseFocus()
		ToggleDropDownMenu(1, nil, TOM_OutfitDropdownMenu, GetMouseFocus():GetName(), 0, 0)
	end
end

local function onDropdownMenuItemClicked(selectedItem)
	if selectedItem.value == TOM.DROPDOWN_RENAME then
		StaticPopup_Show("TOM_RenameOutfit")
	elseif selectedItem.value == TOM.DROPDOWN_DELETE then
		StaticPopupDialogs["TOM_DeleteOutfit"].text = "Delete outfit \'" .. TOM.activeModelFrame.OutfitName:GetText() .. "\'?"
		StaticPopup_Show("TOM_DeleteOutfit")
	end
end

local function TOM_OutfitDropdownMenu_Init()
	local renameMenuItem = {
					text = "Rename",
					value = TOM.DROPDOWN_RENAME,
					notCheckable = true,
					func = onDropdownMenuItemClicked
	}
	local deleteMenuItem = {
					text = "Delete",
					value = TOM.DROPDOWN_DELETE,
					notCheckable = true,
					func = onDropdownMenuItemClicked
	}
	UIDropDownMenu_AddButton(renameMenuItem)
	UIDropDownMenu_AddButton(deleteMenuItem)
end

TOM_OutfitContainer = CreateFrame("Frame", "TOM_OutfitContainer", WardrobeFrame, "CollectionsBackgroundTemplate")
TOM_OutfitContainer:ClearAllPoints()
TOM_OutfitContainer:SetPoint("TOPLEFT", WardrobeFrame, "TOPRIGHT", 10, 0)
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

TOM_OutfitDropdownMenu = CreateFrame("Frame", "TOM_OutfitDropdownMenu", TOM_OutfitContainer, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(TOM_OutfitDropdownMenu, TOM_OutfitDropdownMenu_Init, "MENU")
TOM_OutfitDropdownMenu:Hide()