-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("ADDON_LOADED")

-- frame:SetScript("OnEvent", function(self, event, arg1)
--     if arg1 == "EasyHonorMoney" then
--         print("Current honor:", amount)
--     end
-- end)

EHM = {
    MODULES = {},
    UI = {
        COMPONENTS = {},
        MAIN_FRAME = {
            BODY = {}
        }
    }
}
-- Debug
EHM.DEBUG_MODE = true  -- Set to false to disable debug prints