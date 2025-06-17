local EHM_MainBodyFrame = EHM.UI.MAIN_FRAME.BODY.EHM_MainBodyFrame
local EHM_SideBar = EHM.UI.MAIN_FRAME.BODY.EHM_SideBar

-- BodyContent
local EHM_BodyContent = CreateFrame("Frame", nil, EHM_MainBodyFrame, "BackdropTemplate")
EHM_BodyContent:SetWidth(EHM_MainBodyFrame:GetWidth() - EHM_SideBar:GetWidth() + (EHM.MAIN_FRAME.BORDER_INSET * 2 - 2))
EHM_BodyContent:SetHeight(EHM_MainBodyFrame:GetHeight())
EHM_BodyContent:SetPoint("TOPRIGHT")
EHM_BodyContent:SetPoint("BOTTOMRIGHT")
EHM_BodyContent:SetBackdrop({
    bgFile = EHM.BACKGROUND_POPUP,
    edgeSize = EHM.MAIN_FRAME.BORDER_SIZE,
    insets = { left = EHM.MAIN_FRAME.BORDER_INSET, right = EHM.MAIN_FRAME.BORDER_INSET, top = EHM.MAIN_FRAME.BORDER_INSET, bottom = EHM.MAIN_FRAME.BORDER_INSET }
})
EHM_BodyContent:SetBackdropColor(0, 0, 0, EHM.BACKGROUND_OPACITY)

EHM.UI.MAIN_FRAME.BODY.EHM_BodyContent = EHM_BodyContent