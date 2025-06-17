local EHM_MainFrame = EHM.UI.MAIN_FRAME.EHM_MainFrame
local EHM_TitleBar = EHM.UI.MAIN_FRAME.EHM_TitleBar

-- Title Bar
local EHM_MainBodyFrame = CreateFrame("Frame", nil, EHM_MainFrame, "BackdropTemplate")
EHM_MainBodyFrame:SetHeight(EHM_MainFrame:GetHeight() - EHM_TitleBar:GetHeight() + (EHM.MAIN_FRAME.BORDER_INSET * 2 - 2))
EHM_MainBodyFrame:SetPoint("BOTTOMLEFT", EHM_MainFrame, "BOTTOMLEFT")
EHM_MainBodyFrame:SetPoint("BOTTOMRIGHT", EHM_MainFrame, "BOTTOMRIGHT")
EHM_MainBodyFrame:SetBackdrop({
    -- bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",  -- Background texture
    -- edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",         -- Border texture
    tile = true,
    tileSize = EHM.MAIN_FRAME.BORDER_SIZE,
    edgeSize = EHM.MAIN_FRAME.BORDER_SIZE,
    insets = { left = EHM.MAIN_FRAME.BORDER_INSET, right = EHM.MAIN_FRAME.BORDER_INSET, top = EHM.MAIN_FRAME.BORDER_INSET, bottom = EHM.MAIN_FRAME.BORDER_INSET }
})
-- EHM_MainFrame:SetBackdropColor(0, 0, 0, 0.9)

EHM.UI.MAIN_FRAME.BODY.EHM_MainBodyFrame = EHM_MainBodyFrame