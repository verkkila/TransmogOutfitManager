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
	local slotData = {}
	for slotId, slotName in pairs(TOM.Core.SLOTID_TO_NAME) do
		local baseSourceID, _, appliedSourceID, _, pendingSourceID, _, hasUndo, _, _ = C_Transmog.GetSlotVisualInfo({slotID = slotId, type = 0, modification = 0})
		slotData[slotName] = {base=baseSourceID, applied=appliedSourceID, pending=pendingSourceID, hasUndo=hasUndo}
	end
	TOM.Core.SaveOutfit(outfitName, slotData)
	--need to rethink overwrite logic
	--possibly pass outfit name and metadata, then fetch slotdata again
	--[[
	if TOM.Core.GetOutfitByName(outfitName) > 0 then
		StaticPopupDialogs["TOM_OverwriteOutfit"].text = "Overwrite \'" .. outfitName .. "\'?"
		local dialog = StaticPopup_Show("TOM_OverwriteOutfit")
		if dialog then
			dialog.data = outfitName
			dialog.data2 = slotData
		end
	else
		TOM.Core.SaveOutfit(outfitName, slotData)
	end
	]]--
	TOM.Display.Redraw()
end

--[[
local function getFavoritedText(outfitName)
	if TOM.Core.IsOutfitFavorited(outfitName) then return "Remove" end
	return "Set"
end
]]--

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
			--this feels a bit risky
			--dialog.data = ???
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
	UIDropDownMenu_Initialize(TOM.Input.OutfitDropdown, initDropdownMenu, "MENU")
end

TOM.Input.OutfitsButton:SetScript("OnClick", outfitsButtonOnClick)
TOM.Input.OutfitNameBox:SetScript("OnTextChanged", outfitNameInputOnTextChanged)
TOM.Input.SaveOutfitButton:SetScript("OnClick", saveOutfitButtonOnClick)
TOM.Input.PreviousPageButton:SetScript("OnClick", previousPageButtonOnClick)
TOM.Input.NextPageButton:SetScript("OnClick", nextPageButtonOnClick)