EHM = {
    MODULES = {},
    UI = {
        COMPONENTS = {},
        MAIN_FRAME = {
            BODY = {}
        }
    },
    EHM_SideBarViews = {},
}
-- Debug
EHM.DEBUG_MODE = false  -- Set to false to disable debug prints

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, event, addonName)
    if event == "ADDON_LOADED" and EHM.AVAILABLE_ADDONS[addonName] then
        -- Ensure DB table exists
        if not EHM_DB then
            EHM_DB = {}
        end

        -- Fallback item
        if not EHM_DB.USED_ITEM and next(EHM.Items) then
            local fallbackIndex = next(EHM.Items)
            EHM_DB.USED_ITEM = EHM.Items[fallbackIndex]
        end

        
        -- 🔁 Also call a short timer in case of honor updates after buying
        -- if EHM_HonorVendor and EHM_HonorVendor:IsShown() then
        --     C_Timer.After(0.1, function()
        --         EHM_HonorVendor:BuildPopup()
        --     end)
        -- end
    end
end)