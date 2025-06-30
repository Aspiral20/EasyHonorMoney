-- Create Object
local LDB = LibStub("LibDataBroker-1.1")
local Broker_LDB;
Broker_LDB = LDB:NewDataObject(EHM.ADDON_NAME, {
    type = "launcher",
    text = EHM.ADDON_NAME,
    icon = "Interface\\Icons\\inv_misc_coin_01",
    OnClick = function(_, button)
        if button == "LeftButton" then
            if EHM_MainFrame and _G.EHM_MainFrame:IsShown() then
                EHM_MainFrame:Hide()
            elseif EHM_MainFrame then
                EHM_MainFrame:Show()
            end
        end
    end,
    OnEnter = function(self)
    end,
    OnLeave = function(self)
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine(EHM.ADDON_NAME)
        tooltip:AddLine(EHM.CHAR_COLORS.yellow .. "Left-click" .. EHM.CHAR_COLORS.reset .. " to open/close UI")
    end,
})

local loadedFrame = CreateFrame("Frame");
loadedFrame:RegisterEvent("ADDON_LOADED");
-- loadedFrame:RegisterEvent("PLAYER_LOGIN");
-- loadedFrame:RegisterEvent("PLAYER_LOGOUT")
-- loadedFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
-- loadedFrame:RegisterEvent("LOADING_SCREEN_ENABLED");
-- loadedFrame:RegisterEvent("LOADING_SCREEN_DISABLED");
-- if WeakAuras.IsRetail() then
--   loadedFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
--   loadedFrame:RegisterEvent("PLAYER_PVP_TALENT_UPDATE");
-- else
--   loadedFrame:RegisterEvent("CHARACTER_POINTS_CHANGED");
--   loadedFrame:RegisterEvent("SPELLS_CHANGED");
-- end
loadedFrame:SetScript("OnEvent", function(self, event, addonName)
    if(event == "ADDON_LOADED") then
        if(EHM.AVAILABLE_ADDONS[addonName]) then
            ---@type WeakAurasSaved
            EHM_DB = EHM_DB or {}
            EHM_DB.minimap = EHM_DB.minimap or {}
            -- Defines the action squelch period after login
            -- Stored in SavedVariables so it can be changed by the user if they find it necessary
            -- EHM_DB.login_squelch_time = db.login_squelch_time or 10;

            -- Deprecated fields with *lots* of data, clear them out
            -- EHM_DB.iconCache = nil;
            -- EHM_DB.iconHash = nil;
            -- EHM_DB.tempIconCache = nil;
            -- EHM_DB.dynamicIconCache = db.dynamicIconCache or {};

            -- EHM_DB.displays = EHM_DB.displays or {};
            -- EHM_DB.registered = EHM_DB.registered or {};
            -- EHM_DB.features = EHM_DB.features or {}
            -- EHM_DB.migrationCutoff = EHM_DB.migrationCutoff or 730
            -- EHM_DB.historyCutoff = EHM_DB.historyCutoff or 730

            -- Private.SyncParentChildRelationships();
            -- local isFirstUIDValidation = db.dbVersion == nil or db.dbVersion < 26;
            -- Private.ValidateUniqueDataIds(isFirstUIDValidation);

            -- if db.lastArchiveClear == nil then
            --     db.lastArchiveClear = time();
            -- elseif db.lastArchiveClear < time() - 2505600 --[[29 days]] then
            --     db.lastArchiveClear = time();
            --     Private.CleanArchive(db.historyCutoff, db.migrationCutoff);
            -- end
            EHM_DB.minimap = EHM_DB.minimap or { hide = false };
            if LibStub and LibStub("LibDBIcon-1.0", true) and LDB then
                local LDBIcon = LibStub("LibDBIcon-1.0")
                
                if not LDBIcon:IsRegistered(EHM.ADDON_NAME) then
                    LDBIcon:Register(EHM.ADDON_NAME, Broker_LDB, EHM_DB.minimap)
                end
            end
        end
    end
end)