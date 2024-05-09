local addonName, TOM = ...

local currentPage = 1
local BORDERTYPE_APPLIED = 1
local BORDERTYPE_SELECTED = 2

local function rctoindex(row, column)
	return (row - 1) * TOM.Display.COLS + column
end

function TOM.Display.UpdateSaveButton()
	local validName = TOM.Core.IsValidName(TOM.Input.OutfitNameBox:GetText())
	if TOM.appliedOutfitName and (TOM.appliedOutfitName ~= TOM.Input.OutfitNameBox:GetText()) then
		local isOutfitDifferent = not TOM.Core.IsWearingOutfit(TOM.appliedOutfitName)
		TOM.Input.SaveOutfitButton:SetEnabled(validName and isOutfitDifferent)
	else
		TOM.Input.SaveOutfitButton:SetEnabled(validName)
	end
end

function TOM.Display.UpdatePageText()
	TOM.Display.Container.PageText:SetText(string.format("Page %d / %d", TOM.Display.GetCurrentPage(), TOM.Display.NumPages()))
end

function TOM.Display.UpdatePageButtons()
	if TOM.Display.GetCurrentPage() == 1 then
		TOM.Input.PreviousPageButton:SetEnabled(false)
		if TOM.Display.NumPages() > 1 then
			TOM.Input.NextPageButton:SetEnabled(true)
		end
	end
	if TOM.Display.GetCurrentPage() == TOM.Display.NumPages() then
		TOM.Input.NextPageButton:SetEnabled(false)
	else
		TOM.Input.NextPageButton:SetEnabled(true)
	end
end

--bounds check, return shouldDisable
function TOM.Display.PreviousPage()
	currentPage = currentPage - 1
end

function TOM.Display.NextPage()
	currentPage = currentPage + 1
end

function TOM.Display.GetCurrentPage()
	return currentPage
end

function TOM.Display.NumPages()
	return math.max(1, math.ceil(TOM.Core.GetNumOutfits() / 8))
end

function TOM.Display.GetModelFrame(row, column)
	if row < 1 or row > 2 then return nil end
	if column < 1 or column > 4 then return nil end
	return TOM.Display.ModelFrames[rctoindex(row, column)]
end

function TOM.Display.SetModelBorder(row, column, borderType)
	local backdrop = TOM.Display.Backdrops.default
	if borderType == BORDERTYPE_APPLIED then backdrop = TOM.Display.Backdrops.applied end
	if borderType == BORDERTYPE_SELECTED then backdrop = TOM.Display.Backdrops.selected end
	local modelFrame = TOM.Display.ModelFrames[rctoindex(row, column)]
	TOM.Display.ModelFrames[rctoindex(row, column)]:SetBackdrop(backdrop)
	TOM.Display.ModelFrames[rctoindex(row, column)]:SetBackdropColor(0, 0, 0, 1)
end

function TOM.Display.RedrawBorders()
	local page = TOM.Display.GetCurrentPage()
	for row = 1, 2 do
		for column = 1, 4 do
			if TOM.Core.OutfitExists(page, row, column) then
				local outfit = TOM.Core.GetOutfit(page, row, column)
				if TOM.Core.IsOutfitApplied(outfit) then
					TOM.Display.SetModelBorder(row, column, BORDERTYPE_APPLIED)
				elseif TOM.Core.IsOutfitSelected(outfit) then
					TOM.Display.SetModelBorder(row, column, BORDERTYPE_SELECTED)
				else
					TOM.Display.SetModelBorder(row, column)
				end
			end
		end
	end
end

--TODO split this function into several smaller ones
function TOM.Display.Redraw(self)
	TOM.Display.UpdatePageText()
	TOM.Display.UpdatePageButtons()
	if TOM.Display.GetCurrentPage() > TOM.Display.NumPages() then TOM.Input.PreviousPageButton:Click("LeftButton") end
	TOM.Core.ResetDisplay()
	for row = 1, 2 do
		for column = 1, 4 do
			if TOM.Core.OutfitExists(TOM.Display.GetCurrentPage(), row, column) then
				local outfit = TOM.Core.GetOutfit(TOM.Display.GetCurrentPage(), row, column)
				--loosely keep track of what outfit is where
				TOM.Core.DisplayOutfit(outfit.name, page, row, column)
				if TOM.Core.IsOutfitApplied(outfit) then
					TOM.Display.SetModelBorder(row, column, BORDERTYPE_APPLIED)
				elseif TOM.Core.IsOutfitSelected(outfit) then
					TOM.Display.SetModelBorder(row, column, BORDERTYPE_SELECTED)
				else
					TOM.Display.SetModelBorder(row, column)
				end
				TOM.Display.GetModelFrame(row, column):Show()
				TOM.Display.GetModelFrame(row, column).OutfitName:SetText(outfit.name)
				TOM.Display.GetModelFrame(row, column).OutfitName:Show()
				TOM.Display.GetModelFrame(row, column):Undress()
				for invSlotName, invSlotData in pairs(outfit.data) do
					local transmogId = TOM.Core.GetTransmogId(invSlotData)
					if transmogId > 0 then
						TOM.Display.GetModelFrame(row, column):TryOn(transmogId)
					end
				end
			else
				TOM.Display.GetModelFrame(row, column):Hide()
			end
		end
	end
end

local function containerOnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonname = ...
		if addonName == addonname then
			TOM.DB.Init()
			TOM.DB.CountOutfits()
			TOM.Display.Container:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "TRANSMOGRIFY_SUCCESS" then
		TOM.Display.Redraw()
	elseif event == "TRANSMOGRIFY_UPDATE" then
		TOM.Display.RedrawBorders()
		TOM.Display.UpdateSaveButton()
	end
end

TOM.Display.Container:SetScript("OnEvent", containerOnEvent)
TOM.Display.Container:SetScript("OnShow", TOM.Display.Redraw)
TOM.Display.Container:SetScript("OnDragStart", function(self, button)
	self:StartMoving()
end)
TOM.Display.Container:SetScript("OnDragStop", function(self, button)
	self:StopMovingOrSizing()
end)
TOM.Display.Container:SetScript("OnHide", function(self) -- prevent "sticky" frame if it's hidden while dragging
	self:StopMovingOrSizing()
end)
TOM.Display.Container:Hide()
--Context menu frame must be named, TODO: add check to make sure frame doesn't already exist