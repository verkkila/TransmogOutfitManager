local addonName, TOM = ...

local DROPDOWN_TOGGLEFAVORITE = 1
local DROPDOWN_RENAME = 2
local DROPDOWN_DELETE = 3

local DROPDOWN_SORT_ASCENDING = 4
local DROPDOWN_SORT_DESCENDING = 5
local DROPDOWN_SORT_NAME = 6
local DROPDOWN_SORT_CREATEDAT = 7
local DROPDOWN_SORT_MODIFIEDAT = 8

local function outfitsButtonOnClick(self, button, down)
	if not TOM.Display.Container:IsVisible() then
		TOM.Display.Container:Show()
	else
		TOM.Display.Container:Hide()
	end
end

local function outfitNameInputOnTextChanged(self, userInput)
	TOM.Display.UpdateSaveButton()
end

local function previousPageButtonOnClick(self, button, down)
	if button ~= "LeftButton" then return end
	TOM.Display.PreviousPage()
end

local function nextPageButtonOnClick(self, button, down)
	if button ~= "LeftButton" then return end
	TOM.Display.NextPage()
end

local function saveOutfitButtonOnClick(self, button, down)
	local outfitName = TOM.Input.OutfitNameBox:GetText()
	if outfitName == "" then return end
	local myName, myRealm, myClass = TOM.Core.GetPlayerInfo()
	if not TOM.Core.OutfitExists(outfitName, myName, myRealm, myClass) then
		TOM.Core.SaveOutfit(outfitName)
	else
		StaticPopupDialogs["TransmogOutfitManager_OverwriteDialog"].text = "Overwrite \'" .. outfitName .. "\'?"
		local dialog = StaticPopup_Show("TransmogOutfitManager_OverwriteDialog")
		if dialog then
			dialog.data = {name = outfitName, charName = myName, charRealm = myRealm, charClass = myClass}
		end
	end
	TOM.Core.SortCache()
	TOM.Display.Redraw()
end

local function shareOutfitsButtonOnClick(self, button, down)
	if button ~= "LeftButton" then return end
	TOM.Options.shareOutfits = TOM.Input.ShareOutfitsButton:GetChecked()
	TOM.Core.Refresh()
	TOM.Display.Redraw()
end

local function filterOutfitsOnTextChanged(self, userInput)
	TOM.Core.filterText = self:GetText()
	if self:GetText() ~= "" then
		self.Instructions:SetAlpha(0)
	else
		self.Instructions:SetAlpha(1)
	end
	TOM.Core.Refresh()
	TOM.Display.Redraw()
end

local function sortOutfitsButtonOnClick(self, button, down)
	ToggleDropDownMenu(1, nil, TOM.Input.SortOutfitsDropdown, "cursor", 3, -3)
end

local function onOutfitDropdownMenuItemClicked(self, arg1, arg2, checked)
	if arg1 == DROPDOWN_TOGGLEFAVORITE then
		local res = TOM.Core.ToggleFavorite(TOM.Display.selectedModelFrame)
		if res ~= nil then
			TOM.Display.selectedModelFrame.FavIcon:SetShown(res)
			TOM.Core.SortCache()
			TOM.Display.Redraw()
		end
	elseif arg1 == DROPDOWN_RENAME then
		StaticPopup_Show("TransmogOutfitManager_RenameDialog")
	elseif arg1 == DROPDOWN_DELETE then
		local outfitName = TOM.Core.GetOutfitByFrame(TOM.Display.selectedModelFrame).name
		StaticPopupDialogs["TransmogOutfitManager_DeleteDialog"].text = "Delete outfit \'" .. outfitName .. "\'?"
		StaticPopup_Show("TransmogOutfitManager_DeleteDialog")
	end
end

--not clean
local function onSortDropdownMenuItemClicked(self, arg1, arg2, checked)
	if arg1 == DROPDOWN_SORT_ASCENDING then
		TOM.Core.sortState.ascending = true
		TOM.Core.sortState.descending = false
	elseif arg1 == DROPDOWN_SORT_DESCENDING then
		TOM.Core.sortState.descending = true
		TOM.Core.sortState.ascending = false
	elseif arg1 == DROPDOWN_SORT_NAME then
		TOM.Core.sortState.name = true
		TOM.Core.sortState.createdAt = false
		TOM.Core.sortState.modifiedAt = false
	elseif arg1 == DROPDOWN_SORT_CREATEDAT then
		TOM.Core.sortState.createdAt = true
		TOM.Core.sortState.name = false
		TOM.Core.sortState.modifiedAt = false
	elseif arg1 == DROPDOWN_SORT_MODIFIEDAT then
		TOM.Core.sortState.modifiedAt = true
		TOM.Core.sortState.name = false
		TOM.Core.sortState.createdAt = false
	end
	--UIDropDownMenu_Initialize(TOM.Input.SortOutfitsDropdown, initSortDropdown, "MENU")
	TOM.Core.SortCache()
	TOM.Display.Redraw()
end

local function initOutfitDropdown(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.func = onOutfitDropdownMenuItemClicked
	info.notCheckable = true
	info.text, info.arg1 = "Set favorite", DROPDOWN_TOGGLEFAVORITE
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Rename", DROPDOWN_RENAME
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Delete", DROPDOWN_DELETE
	UIDropDownMenu_AddButton(info)
end

--not clean
local function initSortDropdown(frame, level, menuList)
	local info, titles = UIDropDownMenu_CreateInfo(), UIDropDownMenu_CreateInfo()
	info.func = onSortDropdownMenuItemClicked
	titles.isTitle, titles.notCheckable = true, true
	titles.text = "Type"
	UIDropDownMenu_AddButton(titles)
	info.text, info.arg1, info.checked = "Ascending", DROPDOWN_SORT_ASCENDING, TOM.Core.sortState.ascending
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1, info.checked = "Descending", DROPDOWN_SORT_DESCENDING, TOM.Core.sortState.descending
	UIDropDownMenu_AddButton(info)
	titles.text = "Parameter"
	UIDropDownMenu_AddButton(titles)
	info.text, info.arg1, info.checked = "Name", DROPDOWN_SORT_NAME, TOM.Core.sortState.name
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1, info.checked = "Date created", DROPDOWN_SORT_CREATEDAT, TOM.Core.sortState.createdAt
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1, info.checked = "Last modification", DROPDOWN_SORT_MODIFIEDAT, TOM.Core.sortState.modifiedAt
	UIDropDownMenu_AddButton(info)
end

function TOM.Input.Init()
	TOM.Input.ShareOutfitsButton:SetChecked(TOM.Options.shareOutfits)
	UIDropDownMenu_Initialize(TOM.Input.OutfitDropdown, initOutfitDropdown, "MENU")
	UIDropDownMenu_Initialize(TOM.Input.SortOutfitsDropdown, initSortDropdown, "MENU")
end

TOM.Input.OutfitsButton:SetScript("OnClick", outfitsButtonOnClick)
TOM.Input.OutfitNameBox:SetScript("OnTextChanged", outfitNameInputOnTextChanged)
TOM.Input.SaveOutfitButton:SetScript("OnClick", saveOutfitButtonOnClick)
TOM.Input.PreviousPageButton:SetScript("OnClick", previousPageButtonOnClick)
TOM.Input.NextPageButton:SetScript("OnClick", nextPageButtonOnClick)
TOM.Input.ShareOutfitsButton:SetScript("OnClick", shareOutfitsButtonOnClick)
TOM.Input.FilterOutfitsBox:SetScript("OnTextChanged", filterOutfitsOnTextChanged)
TOM.Input.SortOutfitsButton:SetScript("OnClick", sortOutfitsButtonOnClick)