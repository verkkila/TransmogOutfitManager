local addonName, TOM = ...

local currentPage = 1
--local numPages = math.ceil(TOM.NumSavedOutfits() / 8)

function TOM.SetPageText()
	TOM.OutfitContainer.PageText:SetText(string.format("Page %d / %d", currentPage, TOM.NumPages()))
end

function TOM.GetCurrentPage()
	return currentPage
end

function TOM.NumPages()
	return math.max(1, math.ceil(TOM.NumSavedOutfits() / 8))
end

function TOM.SetPageButtons()
	if currentPage == 1 then
		TOM.PreviousPageButton:SetEnabled(false)
		if TOM.NumPages() > 1 then
			TOM.NextPageButton:SetEnabled(true)
		end
	end
	if currentPage == TOM.NumPages() then
		TOM.NextPageButton:SetEnabled(false)
	else
		TOM.NextPageButton:SetEnabled(true)
	end
end

local function TOM_PreviousPageButton_OnClick(self, button, down)
	if button ~= "LeftButton" then return end
	if currentPage > 1 then
		currentPage = currentPage - 1
		TOM.NextPageButton:SetEnabled(true)
	end
	if currentPage == 1 then TOM.PreviousPageButton:SetEnabled(false) end
	TOM.OutfitContainer_OnShow()
	TOM.SetPageText()
end

local function TOM_NextPageButton_OnClick(self, button, down)
	if button ~= "LeftButton" then return end
	if currentPage < math.ceil(TOM.NumSavedOutfits() / 8) then
		currentPage = currentPage + 1
		TOM.PreviousPageButton:SetEnabled(true)
	end
	if currentPage == TOM.NumPages() then TOM.NextPageButton:SetEnabled(false) end
	TOM.OutfitContainer_OnShow()
	TOM.SetPageText()
end

TOM.PreviousPageButton = CreateFrame("Button", nil, TOM.OutfitContainer, "CollectionsPrevPageButton")
TOM.PreviousPageButton:ClearAllPoints()
TOM.PreviousPageButton:SetPoint("CENTER", TOM.OutfitContainer, "BOTTOM", 20, 40)
TOM.PreviousPageButton:SetScript("OnClick", TOM_PreviousPageButton_OnClick)
TOM.PreviousPageButton:SetEnabled(false)

TOM.NextPageButton = CreateFrame("Button", nil, TOM.OutfitContainer, "CollectionsNextPageButton")
TOM.NextPageButton:ClearAllPoints()
TOM.NextPageButton:SetPoint("CENTER", TOM.OutfitContainer, "BOTTOM", 60, 40)
TOM.NextPageButton:SetScript("OnClick", TOM_NextPageButton_OnClick)
if TOM.NumSavedOutfits() <= 8 then TOM.NextPageButton:SetEnabled(false) end -- feels hacky

TOM.OutfitContainer.PageText = TOM.OutfitContainer:CreateFontString(nil, "OVERLAY", "GameTooltipText")
TOM.OutfitContainer.PageText:ClearAllPoints()
TOM.OutfitContainer.PageText:SetPoint("CENTER", TOM.OutfitContainer, "BOTTOM", -40, 40)