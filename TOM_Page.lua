local currentPage = 1
--local numPages = math.ceil(TOM_NumSavedOutfits() / 8)

function TOM_SetPageText()
	TOM_OutfitContainer.PageText:SetText(string.format("Page %d / %d", currentPage, math.ceil(TOM_NumSavedOutfits() / 8)))
end

function TOM_GetCurrentPage()
	return currentPage
end

function TOM_NumPages()
	return math.ceil(TOM_NumSavedOutfits() / 8)
end

function TOM_SetPageButtons()
	if currentPage == 1 then
		TOM_PreviousPageButton:SetEnabled(false)
		if TOM_NumPages() > 1 then
			TOM_NextPageButton:SetEnabled(true)
		end
	end
	if currentPage == TOM_NumPages() then
		TOM_NextPageButton:SetEnabled(false)
	else
		TOM_NextPageButton:SetEnabled(true)
	end
end

local function TOM_PreviousPageButton_OnClick(self, button, down)
	if button ~= "LeftButton" then return end
	if currentPage > 1 then
		currentPage = currentPage - 1
		TOM_NextPageButton:SetEnabled(true)
	end
	if currentPage == 1 then TOM_PreviousPageButton:SetEnabled(false) end
	TOM_OutfitContainer_OnShow()
	TOM_SetPageText()
end

local function TOM_NextPageButton_OnClick(self, button, down)
	if button ~= "LeftButton" then return end
	if currentPage < math.ceil(TOM_NumSavedOutfits() / 8) then
		currentPage = currentPage + 1
		TOM_PreviousPageButton:SetEnabled(true)
	end
	if currentPage == TOM_NumPages() then TOM_NextPageButton:SetEnabled(false) end
	TOM_OutfitContainer_OnShow()
	TOM_SetPageText()
end

TOM_PreviousPageButton = CreateFrame("Button", "TOM_PreviousPageButton", TOM_OutfitContainer, "CollectionsPrevPageButton")
TOM_PreviousPageButton:ClearAllPoints()
TOM_PreviousPageButton:SetPoint("CENTER", TOM_OutfitContainer, "BOTTOM", 20, 40)
TOM_PreviousPageButton:SetScript("OnClick", TOM_PreviousPageButton_OnClick)
TOM_PreviousPageButton:SetEnabled(false)

TOM_NextPageButton = CreateFrame("Button", "TOM_NextPageButton", TOM_OutfitContainer, "CollectionsNextPageButton")
TOM_NextPageButton:ClearAllPoints()
TOM_NextPageButton:SetPoint("CENTER", TOM_OutfitContainer, "BOTTOM", 60, 40)
TOM_NextPageButton:SetScript("OnClick", TOM_NextPageButton_OnClick)
if TOM_NumSavedOutfits() <= 8 then TOM_NextPageButton:SetEnabled(false) end -- feels hacky

TOM_OutfitContainer.PageText = TOM_OutfitContainer:CreateFontString("TOM_PageText", "OVERLAY", "GameTooltipText")
TOM_OutfitContainer.PageText:ClearAllPoints()
TOM_OutfitContainer.PageText:SetPoint("CENTER", TOM_OutfitContainer, "BOTTOM", -40, 40)