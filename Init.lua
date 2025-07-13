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
EHM.ADDON_NAME = "EasyHonorMoney"
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
    end
end)