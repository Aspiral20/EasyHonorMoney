local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and EHM.AVAILABLE_ADDONS[addonName] then
        -- Optional welcome message
        EHM.Notifications("Loaded. Type " .. EHM.CHAR_COLORS.gold .. "/ehm" .. EHM.CHAR_COLORS.reset .. " to open panel or use minimap button.")
        -- Unregister event to prevent future triggers
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
