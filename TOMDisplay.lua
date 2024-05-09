local addonName, TOM = ...

function TOM.OutfitContainer_RedrawBorders()
	for row = 1, 2 do
		for column = 1, 4 do
			local index = ((TOM.GetCurrentPage() - 1) * 8) + ((row - 1) * 4 + column)
			if TOM.DB.OutfitExists(index) then
				local outfit = TOM.DB.GetOutfit(index)
				if TOM.IsOutfitApplied(outfit) then
					TOM.SetBorderByModelPosition(row, column, TOM.const.BORDERTYPE_APPLIED)
				elseif TOM.IsOutfitSelected(outfit) then
					TOM.SetBorderByModelPosition(row, column, TOM.const.BORDERTYPE_SELECTED)
				else
					TOM.SetBorderByModelPosition(row, column)
				end
			end
		end
	end
end

function TOM.OutfitContainer_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonname = ...
		if addonName == addonname then
			TOM.DB.Init()
			TOM.DB.CountOutfits()
			TOM.OutfitContainer:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "TRANSMOGRIFY_SUCCESS" then
		TOM.OutfitContainer_RedrawBorders()
	elseif event == "TRANSMOGRIFY_UPDATE" then
		TOM.OutfitContainer_RedrawBorders()
		TOM.SetSaveButtonStatus()
	end
end

--TODO split this function into several smaller ones
function TOM.OutfitContainer_OnShow(self)
	--TOM.DB.CountOutfits()
	TOM.SetPageText()
	TOM.SetPageButtons()
	if TOM.GetCurrentPage() > TOM.NumPages() then TOM.PreviousPageButton:Click("LeftButton") end
	for row = 1, 2 do
		for column = 1, 4 do
			local index = ((TOM.GetCurrentPage() - 1) * 8) + ((row - 1) * 4 + column) --quite the expression
			if TOM.DB.OutfitExists(index) then
				local outfit = TOM.DB.GetOutfit(index)
				if TOM.IsOutfitApplied(outfit) then
					TOM.SetBorderByModelPosition(row, column, TOM.const.BORDERTYPE_APPLIED)
				elseif TOM.IsOutfitSelected(outfit) then
					TOM.SetBorderByModelPosition(row, column, TOM.const.BORDERTYPE_SELECTED)
				else
					TOM.SetBorderByModelPosition(row, column)
				end
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
		for outfit in TOM.DB.GetAllOutfits() do
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
		TOM.OutfitContainer_OnShow()
	elseif button == "RightButton" then
		TOM.activeModelFrame = GetMouseFocus()
		ToggleDropDownMenu(1, nil, TOM.OutfitDropdownMenu, "cursor", 3, -3)
	end
end

local function onDropdownMenuItemClicked(self, arg1, arg2)
	if arg1 == TOM.const.DROPDOWN_RENAME then
		local dialog = StaticPopup_Show("TOM_RenameOutfit")
		if dialog then
			dialog.data = TOM.activeModelFrame.OutfitName:GetText()
		end
	elseif arg1 == TOM.const.DROPDOWN_DELETE then
		local outfitName = TOM.activeModelFrame.OutfitName:GetText()
		StaticPopupDialogs["TOM_DeleteOutfit"].text = "Delete outfit \'" .. outfitName .. "\'?"
		local dialog = StaticPopup_Show("TOM_DeleteOutfit")
		if dialog then
			dialog.data = outfitName
		end
	end
end

local function initDropdownMenu(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.func = onDropdownMenuItemClicked
	info.notCheckable = true
	info.text, info.arg1 = "Rename", TOM.const.DROPDOWN_RENAME
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Delete", TOM.const.DROPDOWN_DELETE
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
TOM.OutfitContainer:RegisterEvent("TRANSMOGRIFY_SUCCESS")
TOM.OutfitContainer:RegisterEvent("TRANSMOGRIFY_UPDATE")
TOM.OutfitContainer:RegisterEvent("ADDON_LOADED")
TOM.OutfitContainer:SetScript("OnEvent", TOM.OutfitContainer_OnEvent)
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