local EHM_BodyContent = EHM.UI.MAIN_FRAME.BODY.EHM_BodyContent
-- Example: Merchants View
local EHM_MerchantsView = CreateFrame("Frame", nil, EHM_BodyContent)
EHM_MerchantsView:SetSize(EHM_BodyContent:GetWidth(), EHM_BodyContent:GetHeight())
EHM_MerchantsView:SetAllPoints()
EHM_MerchantsView:Hide()

local merchantsText = EHM_MerchantsView:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
merchantsText:SetPoint("TOP", EHM_BodyContent, "TOP", 0, EHM.SidebarContent.paddingTitleTop)
merchantsText:SetJustifyH("CENTER")
merchantsText:SetJustifyV("MIDDLE")
merchantsText:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
merchantsText:SetText(EHM.SidebarNavigation.merchants.title)

local function ButtonOnEnterIcon(self, merchantData, mapInfo, mapTexture)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()

    if merchantData.name and merchantData.title then
        GameTooltip:AddLine(merchantData.name, 1, 1, 1)
        GameTooltip:AddLine(merchantData.title, 1, 1, 1)
        GameTooltip:AddLine("Location: " .. mapInfo.name, 1, 1, 1)
        GameTooltip:AddLine("Zone: " .. mapTexture.zone, 1, 1, 1)
                    
        local fontString = _G["GameTooltipTextLeft1"]
        if fontString then
            fontString:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE") -- default size is ~12
        end
    else
        GameTooltip:AddLine("No sell value info available", 1, 0, 0)
    end
                
    GameTooltip:Show()
end


local function ButtonOnLeaveIcon()
    GameTooltip:Hide()
end

-- Make playerFaction as top-level variable
local playerFaction = UnitFactionGroup("player") or EHM.FACTION.Neutral
local factionIcon = EHM.GetFactionIcon(playerFaction).factionIcon
local factionWidth = 90
if playerFaction == EHM.FACTION.Horde then
    factionWidth = 70
elseif playerFaction == EHM.FACTION.Alliance then
    factionWidth = 90
end

EHM.CreateActionButtons(
    EHM_MerchantsView,
    {
        { name = string.format("%s %s", playerFaction, factionIcon), command = nil, disabled = true, width = factionWidth, height = 24 },
    },
    21,
    -36
)

function EHM_MerchantsView:ShowMerchants()
    buttons = {}
    for _, btn in ipairs(buttons) do
        btn:Hide()
    end
    wipe(buttons)

    local xStart, yStart = 20, -75
    local btnSize = 48
    local spacing = 10
    local maxButtonsPerRow = 6
    local currentX, currentY = xStart, yStart
    local buttonsInRow = 0
    -- For estimated gold/4k honor
    local honorToUse = 4000
    local totalGold, totalSilver, totalCopper = 0, 0, 0
    local itemsBought, totalSellValue = 0, 0

    for merchantID, merchantData in pairs(EHM.Merchants) do
        if merchantData and (not merchantData.faction or merchantData.faction == playerFaction) then
            local mapInfo = C_Map.GetMapInfo(merchantData.mapID)
            local mapTexture = EHM.MAP_ICONS[merchantData.mapID]
            local race = merchantData.race or EHM.RACE_ICONS["Human"]
            local raceIconPath = EHM.RACE_ICONS[race.name].iconPath[merchantData.gender]

            local btn = CreateFrame("Button", "EHM_HonorItemBtn"..merchantID, EHM_MerchantsView, "SecureActionButtonTemplate")
            btn:SetSize(btnSize, btnSize)
            btn:SetPoint("TOPLEFT", EHM_MerchantsView, "TOPLEFT", currentX, currentY)
            -- btn:SetNormalTexture(GetItemIcon(merchantID))
            btn:SetNormalTexture(raceIconPath)
            btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
            btn:Show()

            if mapTexture then
                local iconSize = 16
                if not btn.mapIcon then
                    btn.mapIcon = btn:CreateTexture(nil, "OVERLAY")
                    btn.mapIcon:SetSize(iconSize, iconSize)
                    btn.mapIcon:SetPoint("TOPRIGHT", btn, "TOPRIGHT", (iconSize / 4), (iconSize / 4))
                    btn.mapIcon:SetTexture(mapTexture.path)
                    
                    local mask = btn:CreateMaskTexture()
                    mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask") -- built-in circular mask
                    mask:SetSize(iconSize, iconSize)
                    mask:SetPoint("TOPRIGHT", btn.mapIcon)
                    btn.mapIcon:AddMaskTexture(mask)
                end
                btn.mapIcon:Show()
                if btn.mapIconBorder then
                    btn.mapIconBorder:Show()
                end
            end

            if not btn.border then
                btn.border = CreateFrame("Frame", nil, btn, BackdropTemplateMixin and "BackdropTemplate" or nil)
                btn.border:SetPoint("TOPLEFT", btn, "TOPLEFT", -2, 2)
                btn.border:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 2, -2)
                btn.border:SetBackdrop({
                    edgeFile = "Interface\\Buttons\\WHITE8X8",
                    edgeSize = 2,
                })
                btn.border:SetBackdropColor(0, 0, 0, 0)
            end
            btn.border:SetBackdropBorderColor(0, 0, 0, 0)
            btn.border:Show()

            btn:SetScript("OnClick", function()
                if not TomTom or not merchantData.mapID or not merchantData.x or not merchantData.y then
                    EHM.NotificationsWarning("TomTom is not installed. This addon relies on TomTom for waypoint support—please install it to use this feature.")
                    return
                end

                -- Get current zone map ID
                local mapID = C_Map.GetBestMapForUnit("player")
                if not mapID then
                    EHM.debugPrint("Failed to get current map ID.")
                    return
                end

                if btn.currentWaypoint then
                    TomTom:RemoveWaypoint(btn.currentWaypoint)
                    btn.currentWaypoint = nil
                    EHM.NotificationsError("Waypoint removed for:", merchantData.name)
                else
                    -- Remove all existing waypoints (Cataclysm Classic-compatible)
                    if TomTom.waypoints then
                        for mapID, waypointList in pairs(TomTom.waypoints) do
                            for uid, waypoint in pairs(waypointList) do
                                TomTom:RemoveWaypoint(waypoint)
                            end
                        end
                    end

                    TomTom:AddWaypoint(merchantData.mapID, merchantData.x / 100, merchantData.y / 100, {
                        title = merchantData.name or "Merchant",
                        persistent = false,
                        minimap = true,
                        world = true,
                    })
                end
            end)
            
            if not btn.merchantNameText then
                btn.merchantNameText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                btn.merchantNameText:SetPoint("TOP", btn, "BOTTOM", -8, -8)
            end
            btn.merchantNameText:SetTextColor(1,1,1)

            -- Create info icon for gold estimate popup
            if not btn.infoIcon then
                btn.infoIcon = btn:CreateTexture(nil, "OVERLAY")
                btn.infoIcon:SetSize(14, 14)
                btn.infoIcon:SetPoint("RIGHT", btn, "RIGHT", 6, -6)
                btn.infoIcon:SetTexture("Interface\\COMMON\\help-i") -- Default WoW info icon
            end
            btn.infoIcon:SetShown(true)

            btn:SetScript("OnEnter", function(self)
                ButtonOnEnterIcon(self, merchantData, mapInfo, mapTexture)
            end)

            btn:SetScript("OnLeave", function()
                ButtonOnLeaveIcon()
            end)

            btn:Show()
            table.insert(buttons, btn)

            buttonsInRow = buttonsInRow + 1
            currentX = currentX + btnSize + spacing
            if buttonsInRow >= maxButtonsPerRow then
                buttonsInRow = 0
                currentX = xStart
                currentY = currentY - btnSize - 30
            end

            foundAny = true
        end
    end
end

EHM.EHM_SideBarViews[EHM.SidebarNavigation.merchants.key] = EHM_MerchantsView