local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("EasyHonorMoney", {
    type = "data source",
    text = "EHM",
    icon = "Interface\\Icons\\inv_misc_coin_01",
    OnClick = function(_, button)
        if button == "LeftButton" then
            if EHM_MainFrame and _G.EHM_MainFrame:IsShown() then
                EHM_MainFrame:Hide()
            elseif EHM_MainFrame then
                EHM_MainFrame:Show()
            else
                -- EHM.debugPrint("EHM_MainFrame not loaded yet.")
            end
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("EasyHonorMoney")
        tooltip:AddLine(EHM.CHAR_COLORS.yellow .. "Left-click" .. EHM.CHAR_COLORS.reset .. " to open/close UI")
    end,
})

-- Save minimap icon position
EHM_DB = EHM_DB or {}
local icon = LibStub("LibDBIcon-1.0")
icon:Register("EasyHonorMoney", LDB, EHM_DB.minimap or {})


-- local minimapButton = CreateFrame("Button", "EHM_MinimapButton", Minimap)
-- minimapButton:SetSize(32, 32)
-- minimapButton:SetFrameStrata("MEDIUM")
-- minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
-- minimapButton:SetMovable(true)
-- minimapButton:EnableMouse(true)
-- minimapButton:RegisterForDrag("LeftButton")
-- minimapButton:SetScript("OnDragStart", minimapButton.StartMoving)
-- minimapButton:SetScript("OnDragStop", minimapButton.StopMovingOrSizing)

-- -- Icon texture
-- local tex = minimapButton:CreateTexture(nil, "BACKGROUND")
-- tex:SetAllPoints()
-- tex:SetTexture("Interface\\Icons\\INV_Misc_Coin_01") -- Use your desired icon

-- -- Click handler
-- minimapButton:SetScript("OnClick", function()
--     if EHM_MainFrame:IsShown() then
--         EHM_MainFrame:Hide()
--     else
--         EHM_MainFrame:Show()
--     end
-- end)

-- -- Tooltip
-- minimapButton:SetScript("OnEnter", function(self)
--     GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
--     GameTooltip:AddLine("EasyHonorMoney", 1, 1, 1)
--     GameTooltip:AddLine("Left-Click to open/close", 0.8, 0.8, 0.8)
--     GameTooltip:Show()
-- end)

-- minimapButton:SetScript("OnLeave", function()
--     GameTooltip:Hide()
-- end)
