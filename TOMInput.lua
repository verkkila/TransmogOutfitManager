local addonName, TOM = ...


local DROPDOWN_TOGGLEFAVORITE = 1
local DROPDOWN_RENAME = 2
local DROPDOWN_DELETE = 3

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
	if TOM.Display.GetCurrentPage() > 1 then
		TOM.Display.PreviousPage()
		TOM.Input.NextPageButton:SetEnabled(true)
	end
	if TOM.Display.GetCurrentPage() == 1 then TOM.Input.PreviousPageButton:SetEnabled(false) end
	TOM.Display.Redraw()
	TOM.Display.UpdatePageText()
end

local function nextPageButtonOnClick(self, button, down)
	if button ~= "LeftButton" then return end
	if TOM.Display.GetCurrentPage() < math.ceil(TOM.Core.GetNumOutfits() / 8) then
		TOM.Display.NextPage()
		TOM.Input.PreviousPageButton:SetEnabled(true)
	end
	if TOM.Display.GetCurrentPage() == TOM.Display.NumPages() then TOM.Input.NextPageButton:SetEnabled(false) end
	TOM.Display.Redraw()
	TOM.Display.UpdatePageText()
end

local function saveOutfitButtonOnClick(self, button, down)
	local outfitName = TOM.Input.OutfitNameBox:GetText()
	if outfitName == "" then return end
	local myName, myRealm, myClass = TOM.Core.GetPlayerInfo()
	if not TOM.Core.OutfitExists(outfitName, myName, myRealm, myClass) then
		local slotData = TOM.Core.GenerateSlotData()
		TOM.Core.SaveOutfit(outfitName, slotData)
	else
		StaticPopupDialogs["TOM_OverwriteOutfit"].text = "Overwrite \'" .. outfitName .. "\'?"
		local dialog = StaticPopup_Show("TOM_OverwriteOutfit")
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
end


local function onDropdownMenuItemClicked(self, arg1, arg2)
	if arg1 == DROPDOWN_TOGGLEFAVORITE then
		local res = TOM.Core.ToggleFavorite(TOM.Display.selectedModelFrame)
		if res ~= nil then
			TOM.Display.selectedModelFrame.FavIcon:SetShown(res)
			TOM.Display.Redraw()
		end
	elseif arg1 == DROPDOWN_RENAME then
		local dialog = StaticPopup_Show("TOM_RenameOutfit")
		if dialog then
			--is this necessary anymore?
		end
	elseif arg1 == DROPDOWN_DELETE then
		local outfitName = TOM.Core.GetOutfitByFrame(TOM.Display.selectedModelFrame).name
		StaticPopupDialogs["TOM_DeleteOutfit"].text = "Delete outfit \'" .. outfitName .. "\'?"
		local dialog = StaticPopup_Show("TOM_DeleteOutfit")
		if dialog then
			dialog.data = TOM.Display.selectedModelFrame
		end
	end
end

local function initDropdownMenu(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.func = onDropdownMenuItemClicked
	info.notCheckable = true
	info.text, info.arg1 = "Toggle favorite", DROPDOWN_TOGGLEFAVORITE
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Rename", DROPDOWN_RENAME
	UIDropDownMenu_AddButton(info)
	info.text, info.arg1 = "Delete", DROPDOWN_DELETE
	UIDropDownMenu_AddButton(info)
end

function TOM.Input.Init()
	TOM.Input.ShareOutfitsButton:SetChecked(TOM.Options.shareOutfits)
	UIDropDownMenu_Initialize(TOM.Input.OutfitDropdown, initDropdownMenu, "MENU")
end

TOM.Input.OutfitsButton:SetScript("OnClick", outfitsButtonOnClick)
TOM.Input.OutfitNameBox:SetScript("OnTextChanged", outfitNameInputOnTextChanged)
TOM.Input.SaveOutfitButton:SetScript("OnClick", saveOutfitButtonOnClick)
TOM.Input.PreviousPageButton:SetScript("OnClick", previousPageButtonOnClick)
TOM.Input.NextPageButton:SetScript("OnClick", nextPageButtonOnClick)
TOM.Input.ShareOutfitsButton:SetScript("OnClick", shareOutfitsButtonOnClick)