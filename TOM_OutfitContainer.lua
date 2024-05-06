local addonName, TOM = ...

function TOM.OutfitContainer_OnShow(self)
	TOM.SetPageText()
	TOM.SetPageButtons()
	if TOM.GetCurrentPage() > TOM.NumPages() then TOM.PreviousPageButton:Click("LeftButton") end
	for row = 1, 2 do
		for column = 1, 4 do
			local index = ((TOM.GetCurrentPage() - 1) * 8) + ((row - 1) * 4 + column) --quite the expression
			local outfit = TransmogOutfitManagerDB[index]
			if outfit then
				TOM.GetPreviewModelFrame(row, column):Show()
				TOM.GetPreviewModelFrame(row, column).OutfitName:SetText(outfit.name)
				TOM.GetPreviewModelFrame(row, column).OutfitName:Show()
				TOM.GetPreviewModelFrame(row, column):Undress()
				for invSlotName, invSlotData in pairs(outfit.data) do
					local transmogId = TOM.GetTransmogId(invSlotData)
					if transmogId > 0 then
						TOM.GetPreviewModelFrame(row, column):TryOn(transmogId)
					end
				end
			else
				TOM.GetPreviewModelFrame(row, column):Hide()
			end
		end
	end
end

function TOM.PreviewModel_OnMouseDown(self, button)
	if button == "LeftButton" then
		local outfitName = GetMouseFocus().OutfitName:GetText()
		if not outfitName then return end
		local outfitData = nil
		for _, outfit in pairs(TransmogOutfitManagerDB) do
			if outfitName == outfit.name then
				for invSlotName, invSlotData in pairs(outfit.data) do
					local transmogLoc = TransmogUtil.CreateTransmogLocation(invSlotName, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
					C_Transmog.ClearPending(transmogLoc)
					local _, _, _, canTransmog = C_Transmog.GetSlotInfo(transmogLoc)
					local id = TOM.GetTransmogId(invSlotData)
					if canTransmog and id then
						C_Transmog.SetPending(transmogLoc, TransmogUtil.CreateTransmogPendingInfo(Enum.TransmogPendingType.Apply, id))
					end
				end
			end
		end
	elseif button == "RightButton" then
		TOM.activeModelFrame = GetMouseFocus()
		ToggleDropDownMenu(1, nil, TOM.OutfitDropdownMenu, "cursor", 3, -3)
	end
end

local function onDropdownMenuItemClicked(self, arg1, arg2)
	if arg1 == TOM.DROPDOWN_RENAME then
		StaticPopup_Show("TOM_RenameOutfit")
	elseif arg1 == TOM.DROPDOWN_DELETE then
		StaticPopupDialogs["TOM_DeleteOutfit"].text = "Delete outfit \'" .. TOM.activeModelFrame.OutfitName:GetText() .. "\'?"
		StaticPopup_Show("TOM_DeleteOutfit")
	end
end

local function initDropdownMenu(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.func = onDropdownMenuItemClicked
	info.notCheckable = true
	info.text, info.arg1 = "Rename", TOM.DROPDOWN_RENAME
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Delete", TOM.DROPDOWN_DELETE
	UIDropDownMenu_AddButton(info)
end

TOM.OutfitContainer = CreateFrame("Frame", nil, WardrobeFrame, "CollectionsBackgroundTemplate")
TOM.OutfitContainer:ClearAllPoints()
TOM.OutfitContainer:SetPoint("TOPLEFT", WardrobeFrame, "TOPRIGHT", 10, 0)
TOM.OutfitContainer:SetSize(600, 500)
TOM.OutfitContainer:SetFrameLevel(6)
TOM.OutfitContainer:SetMovable(true)
TOM.OutfitContainer:EnableMouse(true)
TOM.OutfitContainer:RegisterForDrag("LeftButton")
TOM.OutfitContainer:SetScript("OnShow", TOM.OutfitContainer_OnShow)
TOM.OutfitContainer:SetScript("OnDragStart", function(self, button)
	self:StartMoving()
end)
TOM.OutfitContainer:SetScript("OnDragStop", function(self, button)
	self:StopMovingOrSizing()
end)
TOM.OutfitContainer:SetScript("OnHide", function(self) -- prevent "sticky" frame if it's hidden while dragging
	self:StopMovingOrSizing()
end)
TOM.OutfitContainer:Hide()
--Context menu frame must be named, TODO: add check to make sure frame doesn't already exist
TOM.OutfitDropdownMenu = CreateFrame("Frame", "TransmogOutfitManagerOutfitDropdown", TOM.OutfitContainer, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(TOM.OutfitDropdownMenu, initDropdownMenu, "MENU")