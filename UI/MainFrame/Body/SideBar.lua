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
local sbTitle = EHM_SideBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
sbTitle:SetPoint("TOP", EHM_SideBar, "TOP", 0, EHM.SidebarContent.paddingTitleTop)
sbTitle:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
sbTitle:SetText("Options")

-- Navigation
local paddingTop = 18
local buttonWidth = EHM.MAIN_FRAME.BODY.SIDE_BAR.WIDTH - (2 * 12)
local function CreateSidebarButton(label, viewKey, order)
    local btn = EHM.AddonButton(EHM_SideBar, label, buttonWidth, 24, function()
        EHM.ShowView(viewKey)
    end)
    btn:SetPoint("TOP", sbTitle, "BOTTOM", 0, -(order * 28) + paddingTop)

    return btn
end

CreateSidebarButton(
    EHM.SidebarNavigation.items.label,
    EHM.SidebarNavigation.items.key,
    EHM.SidebarNavigation.items.order
)
CreateSidebarButton(
    EHM.SidebarNavigation.merchants.label,
    EHM.SidebarNavigation.merchants.key,
    EHM.SidebarNavigation.merchants.order
)

EHM.UI.MAIN_FRAME.BODY.EHM_SideBar = EHM_SideBar