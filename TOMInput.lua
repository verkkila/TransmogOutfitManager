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
	TOM.Display.Redraw()
end

local function shareOutfitsButtonOnClick(self, button, down)
	if button ~= "LeftButton" then return end
	TOM.Options.shareOutfits = TOM.Input.ShareOutfitsButton:GetChecked()
	TOM.Core.Refresh()
	TOM.Display.Redraw()
end

local function sortOutfitsButtonOnClick(self, button, down)
	ToggleDropDownMenu(1, nil, TOM.Input.SortOutfitsDropdown, "cursor", 3, -3)
end

local function onDropdownMenuItemClicked(self, arg1, arg2)
	if arg1 == DROPDOWN_TOGGLEFAVORITE then
		local res = TOM.Core.ToggleFavorite(TOM.Display.selectedModelFrame)
		if res ~= nil then
			TOM.Display.selectedModelFrame.FavIcon:SetShown(res)
			TOM.Display.Redraw()
		end
	elseif arg1 == DROPDOWN_RENAME then
		StaticPopup_Show("TransmogOutfitManager_RenameDialog")
	elseif arg1 == DROPDOWN_DELETE then
		local outfitName = TOM.Core.GetOutfitByFrame(TOM.Display.selectedModelFrame).name
		StaticPopupDialogs["TransmogOutfitManager_DeleteDialog"].text = "Delete outfit \'" .. outfitName .. "\'?"
		StaticPopup_Show("TransmogOutfitManager_DeleteDialog")
	elseif arg1 == DROPDOWN_SORT_ASCENDING then
		print("1")
	elseif arg1 == DROPDOWN_SORT_DESCENDING then
		print("2")
	elseif arg1 == DROPDOWN_SORT_NAME then
		print("3")
	elseif arg1 == DROPDOWN_SORT_CREATEDAT then
		print("4")
	elseif arg1 == DROPDOWN_SORT_MODIFIEDAT then
		print("5")
	end
end

local function initOutfitDropdown(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.func = onDropdownMenuItemClicked
	info.notCheckable = true
	info.text, info.arg1 = "Set favorite", DROPDOWN_TOGGLEFAVORITE
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Rename", DROPDOWN_RENAME
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Delete", DROPDOWN_DELETE
	UIDropDownMenu_AddButton(info)
end

local function initSortDropdown(frame, level, menuList)
	local info, titles = UIDropDownMenu_CreateInfo(), UIDropDownMenu_CreateInfo()
	info.func = onDropdownMenuItemClicked
	titles.isTitle, titles.notCheckable = true, true
	titles.text = "Type"
	UIDropDownMenu_AddButton(titles)
	info.text, info.arg1 = "Ascending", DROPDOWN_SORT_ASCENDING
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Descending", DROPDOWN_SORT_DESCENDING
	UIDropDownMenu_AddButton(info)
	titles.text = "Parameter"
	UIDropDownMenu_AddButton(titles)
	info.text, info.arg1 = "Name", DROPDOWN_SORT_NAME
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Date created", DROPDOWN_SORT_CREATEDAT
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Last modification", DROPDOWN_SORT_MODIFIEDAT
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
TOM.Input.SortOutfitsButton:SetScript("OnClick", sortOutfitsButtonOnClick)