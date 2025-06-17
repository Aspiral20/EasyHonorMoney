-- Create UI frame
EHM_MainFrame = CreateFrame("Frame", "EHM_MainFrame", UIParent, "BackdropTemplate")
EHM_MainFrame:SetSize(EHM.MAIN_FRAME.WIDTH, EHM.MAIN_FRAME.HEIGHT)
EHM_MainFrame:SetPoint("CENTER")

-- No border / no background
EHM_MainFrame:SetBackdrop(nil)

-- Allow dragging if needed
EHM_MainFrame:SetMovable(true)
EHM_MainFrame:EnableMouse(true)
EHM_MainFrame:RegisterForDrag("LeftButton")
EHM_MainFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
EHM_MainFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

EHM_MainFrame:Hide()
-- Custom background and border
EHM_MainFrame:SetBackdrop({
    -- bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",  -- Background texture
    -- edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",         -- Border texture
    tile = false,
    tileSize = EHM.MAIN_FRAME.BORDER_SIZE,
    edgeSize = EHM.MAIN_FRAME.BORDER_SIZE,
    insets = { left = EHM.MAIN_FRAME.BORDER_INSET, right = EHM.MAIN_FRAME.BORDER_INSET, top = EHM.MAIN_FRAME.BORDER_INSET, bottom = EHM.MAIN_FRAME.BORDER_INSET }
})
-- Background color (black, 50% opacity)
-- EHM_MainFrame:SetBackdropColor(0, 0, 0, 0.9)
-- Set border color (light blue)
-- EHM_MainFrame:SetBackdropBorderColor(0, 0.6, 1.0)

EHM.UI.MAIN_FRAME.EHM_MainFrame = EHM_MainFrame