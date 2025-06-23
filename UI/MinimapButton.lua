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
