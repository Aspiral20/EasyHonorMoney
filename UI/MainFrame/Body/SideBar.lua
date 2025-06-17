local EHM_MainBodyFrame = EHM.UI.MAIN_FRAME.BODY.EHM_MainBodyFrame

-- Sidebar
local EHM_SideBar = CreateFrame("Frame", nil, EHM_MainBodyFrame, "BackdropTemplate")
EHM_SideBar:SetWidth(EHM.MAIN_FRAME.BODY.SIDE_BAR.WIDTH)
EHM_SideBar:SetPoint("TOPLEFT")
EHM_SideBar:SetPoint("BOTTOMLEFT")
EHM_SideBar:SetBackdrop({
    bgFile = EHM.BACKGROUND_POPUP,
    tile = true,
    tileSize = EHM.MAIN_FRAME.BORDER_SIZE,
    edgeSize = EHM.MAIN_FRAME.BORDER_SIZE,
    insets = { left = EHM.MAIN_FRAME.BORDER_INSET, right = EHM.MAIN_FRAME.BORDER_INSET, top = EHM.MAIN_FRAME.BORDER_INSET, bottom = EHM.MAIN_FRAME.BORDER_INSET }
})
EHM_SideBar:SetBackdropColor(0, 0, 0, EHM.BACKGROUND_OPACITY)

-- SubTitle for Sidebar
local sbTitle = EHM_SideBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
sbTitle:SetPoint("TOP", EHM_SideBar, "TOP", 0, -12)
sbTitle:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
sbTitle:SetText("Options")

EHM.UI.MAIN_FRAME.BODY.EHM_SideBar = EHM_SideBar