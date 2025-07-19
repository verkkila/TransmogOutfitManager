local addonName, TOM = ...

local currentPage = 1
local BORDERTYPE_APPLIED = 1
local BORDERTYPE_SELECTED = 2

local function rctoindex(row, column)
	return (row - 1) * TOM.Display.COLS + column
end

function TOM.Display.Init()
	TOM.Core.SetDisplay(TOM.Display.ModelFrames, TOM.Display.ROWS, TOM.Display.COLS)
end

function TOM.Display.UpdateSaveButton()
	local validName = TOM.Core.IsValidName(TOM.Input.OutfitNameBox:GetText())
	if TOM.Core.appliedOutfit and (TOM.Core.appliedOutfit.name ~= TOM.Input.OutfitNameBox:GetText()) then
		local isOutfitDifferent = not TOM.Core.IsOutfitSelected(TOM.Core.appliedOutfit)
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

--these could return true if the page was changed and false if it was not
function TOM.Display.PreviousPage()
	if currentPage > 1 then
		currentPage = currentPage - 1
		TOM.Input.NextPageButton:SetEnabled(true)
	end
	TOM.Display.Redraw()
	TOM.Display.UpdatePageText()
end

function TOM.Display.NextPage()
	if currentPage < math.ceil(TOM.Core.GetNumOutfits() / 8) then
		currentPage = currentPage + 1
		TOM.Input.PreviousPageButton:SetEnabled(true)
	end
	if currentPage == TOM.Display.NumPages() then TOM.Input.NextPageButton:SetEnabled(false) end
	TOM.Display.Redraw()
	TOM.Display.UpdatePageText()
end

function TOM.Display.GetCurrentPage()
	return currentPage
end

function TOM.Display.NumPages()
	return math.max(1, math.ceil(TOM.Core.GetNumOutfits() / 8))
end

--prevents selecting other outfits while a dialog box is open
function TOM.Display.Lock()
	TOM.Display._locked = true
end

function TOM.Display.Unlock()
	TOM.Display._locked = false
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
	modelFrame:SetBackdrop(backdrop)
	modelFrame:SetBackdropColor(0, 0, 0, 1)
end

local function doBorders(outfit, row, column)
	if TOM.Core.IsOutfitApplied(outfit) then
		TOM.Display.SetModelBorder(row, column, BORDERTYPE_APPLIED)
	elseif TOM.Core.IsOutfitSelected(outfit) then
		TOM.Display.SetModelBorder(row, column, BORDERTYPE_SELECTED)
	else
		TOM.Display.SetModelBorder(row, column)
	end
end

function TOM.Display.RedrawBorders()
	for row = 1, 2 do
		for column = 1, 4 do
			local outfit = TOM.Core.GetOutfit(TOM.Display.GetCurrentPage(), row, column)
			if outfit then
				doBorders(outfit, row, column)
			end
		end
	end
end

function TOM.Display.Redraw(self)
	TOM.Display.UpdatePageText()
	TOM.Display.UpdatePageButtons()
	if TOM.Display.GetCurrentPage() > TOM.Display.NumPages() then TOM.Input.PreviousPageButton:Click("LeftButton") end
	TOM.Core.appliedOutfit = nil
	for row = 1, 2 do
		for column = 1, 4 do
			local modelFrame = TOM.Display.GetModelFrame(row, column)
			if not modelFrame then
				--DebugPrint("nil modelFrame on row", row, " column", column)
				return
			end
			local outfit = TOM.Core.GetOutfit(TOM.Display.GetCurrentPage(), row, column)
			if outfit then
				doBorders(outfit, row, column)
				modelFrame:Show()
				modelFrame.OutfitName:SetText(outfit.name)
				modelFrame.OutfitName:Show()
				modelFrame:Undress()
				for invSlotName, invSlotData in pairs(outfit.data) do
					local transmogId = TOM.Core.GetTransmogId(invSlotData)
					if transmogId > 0 then
						modelFrame:TryOn(transmogId)
					end
				end
				modelFrame.FavIcon:SetShown(TOM.Core.IsFavorited(modelFrame))
			else
				modelFrame:Hide()
			end
		end
	end
end

local function containerOnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonname = ...
		if addonName == addonname then
			TOM.DB.Init()
			TOM.Core.Init()
			TOM.Display.Init()
			TOM.Input.Init()
			TOM.Display.Container:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "TRANSMOGRIFY_SUCCESS" then
		TOM.Display.Redraw()
	elseif event == "TRANSMOGRIFY_UPDATE" then
		--causes tons of redraws when a set is selected, optimize this in the future
		--possibly use a counter and only redraw on the last one
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