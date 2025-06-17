local EHM_MainFrame = EHM.UI.MAIN_FRAME.EHM_MainFrame
-- Title Bar
local EHM_TitleBar = CreateFrame("Frame", nil, EHM_MainFrame, "BackdropTemplate")
EHM_TitleBar:SetHeight(EHM.MAIN_FRAME.TITLE_BAR.HEIGHT)
EHM_TitleBar:SetPoint("TOPLEFT", EHM_MainFrame, "TOPLEFT")
EHM_TitleBar:SetPoint("TOPRIGHT", EHM_MainFrame, "TOPRIGHT")
EHM_TitleBar:SetBackdrop({
    bgFile = EHM.BACKGROUND_POPUP,
    tile = true,
    tileSize = EHM.MAIN_FRAME.BORDER_SIZE,
    edgeSize = EHM.MAIN_FRAME.BORDER_SIZE,
    insets = { left = EHM.MAIN_FRAME.BORDER_INSET, right = EHM.MAIN_FRAME.BORDER_INSET, top = EHM.MAIN_FRAME.BORDER_INSET, bottom = EHM.MAIN_FRAME.BORDER_INSET }
})
EHM_MainFrame:SetBackdropColor(0, 0, 0, EHM.BACKGROUND_OPACITY)

-- Title
local EHM_Title = EHM_TitleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
EHM_Title:SetPoint("CENTER", EHM_TitleBar, "CENTER")
EHM_Title:SetJustifyH("CENTER")
EHM_Title:SetJustifyV("MIDDLE")
EHM_Title:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
EHM_Title:SetText("EasyHonorMoney")

EHM.UI.MAIN_FRAME.EHM_TitleBar = EHM_TitleBar

-- Close Button
local buttonSize = 24
local padding = 6
local centeredButton = -(buttonSize / 2) + padding
local closeButton = CreateFrame("Button", nil, EHM_MainFrame, "UIPanelCloseButton")
closeButton:SetSize(buttonSize, buttonSize)
closeButton:SetPoint("TOPRIGHT", EHM_MainFrame, "TOPRIGHT", centeredButton, centeredButton)
EHM_Title:SetJustifyH("CENTER")
closeButton:SetScript("OnClick", function()
    EHM_MainFrame:Hide()
end)
