local currentPage = 1
--local numPages = math.ceil(TOM_NumSavedOutfits() / 8)
local tempMaxPages = 5

function TOM_SetPageText()
	--TOM_OutfitContainer.CurrentPage:SetText(string.format("Page %d / %d", currentPage, math.ceil(TOM_NumSavedOutfits() / 8)))
	TOM_OutfitContainer.PageText:SetText(string.format("Page %d / %d", currentPage, tempMaxPages))
end

local function TOM_PreviousPageButton_OnClick()
	if currentPage > 1 then
		currentPage = currentPage - 1
		TOM_NextPageButton:SetEnabled(true)
	end
	if currentPage == 1 then TOM_PreviousPageButton:SetEnabled(false) end
	TOM_SetPageText()
end

local function TOM_NextPageButton_OnClick()
	--if currentPage < math.ceil(TOM_NumSavedOutfits() / 8) then
	if currentPage < tempMaxPages then
		currentPage = currentPage + 1
		TOM_PreviousPageButton:SetEnabled(true)
	end
	if currentPage == tempMaxPages then TOM_NextPageButton:SetEnabled(false) end
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

TOM_OutfitContainer.PageText = TOM_OutfitContainer:CreateFontString("TOM_CurrentPageLabel", "OVERLAY", "GameTooltipText")
TOM_OutfitContainer.PageText:ClearAllPoints()
TOM_OutfitContainer.PageText:SetPoint("CENTER", TOM_OutfitContainer, "BOTTOM", -40, 40)
TOM_SetPageText()