local EHM_BodyContent = EHM.UI.MAIN_FRAME.BODY.EHM_BodyContent
-- Example: Items View
local EHM_ItemsView = CreateFrame("Frame", nil, EHM_BodyContent)
EHM_ItemsView:SetSize(EHM_BodyContent:GetWidth(), EHM_BodyContent:GetHeight())
EHM_ItemsView:SetAllPoints()
EHM_ItemsView:Hide()

local EHM_ItemsTitle = EHM_ItemsView:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
EHM_ItemsTitle:SetPoint("TOP", EHM_BodyContent, "TOP", 0, EHM.SidebarContent.paddingTitleTop)
EHM_ItemsTitle:SetJustifyH("CENTER")
EHM_ItemsTitle:SetJustifyV("MIDDLE")
EHM_ItemsTitle:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
EHM_ItemsTitle:SetText(EHM.SidebarNavigation.items.title)

EHM.CreateActionButtons(
    EHM_ItemsView,
    nil,
    14,
    -36
)
-- print(EHM_DB.USED_ITEM and EHM.DUMP(EHM_DB.USED_ITEM))
buttons = {}
function EHM_ItemsView:ShowItems()
    -- Clear old buttons after changing "EHM_DB.USED_ITEM"
    for _, btn in ipairs(buttons) do
        btn:Hide()
        btn:SetScript("OnClick", nil)
        if btn.border then
            btn.border:SetBackdropBorderColor(0, 0, 0, 0) -- reset to transparent here
        end
        if btn.honorIcon then
            btn.honorIcon:Hide()
        end
    end
    table.wipe(buttons)
    local honorIconPath = "Interface\\ICONS\\pvpcurrency-honor-" .. string.lower(faction or "alliance")

    local playerHonor = EHM.GetPlayerHonor()

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

    local SortedItems = EHM.GetItemsSortedByPrice(EHM.Items)

    for key, item in pairs(SortedItems) do
        local itemID = item.index
        local itemData = EHM.Items[itemID]
        if itemData then
            local btn = CreateFrame("Button", "EHM_HonorItemBtn"..itemID, EHM_ItemsView.content, "SecureActionButtonTemplate")
            btn:SetSize(btnSize, btnSize)
            btn:SetPoint("TOPLEFT", EHM_ItemsView, "TOPLEFT", currentX, currentY)
            btn:SetNormalTexture(GetItemIcon(itemID))
            btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

            btn:GetNormalTexture()

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
            
            if EHM_DB and EHM_DB.USED_ITEM and tonumber(EHM_DB.USED_ITEM.index) == tonumber(itemID) then
                btn.border:SetBackdropBorderColor(0, 1, 0, 1) -- Green border
            else
                btn.border:SetBackdropBorderColor(0, 0, 0, 0) -- Transparent border
            end

            btn.border:Show()

            btn:SetScript("OnClick", function()
                if EHM.IsItemAdded(itemID) then
                    return
                end
                EHM.SetUsedItem(itemID)
            end)

            if not btn.priceText then
                btn.priceText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                btn.priceText:SetPoint("TOP", btn, "BOTTOM", -8, -8)
            end
            btn.priceText:SetText(itemData.price)
            btn.priceText:SetTextColor(1,1,1)

            if not btn.honorIcon then
                btn.honorIcon = btn:CreateTexture(nil, "OVERLAY")
                btn.honorIcon:SetSize(14, 14)
                btn.honorIcon:SetPoint("LEFT", btn.priceText, "RIGHT", 2, 0)
                btn.honorIcon:SetTexture(honorIconPath)
            end
            btn.honorIcon:SetShown(true)

            -- Create info icon for gold estimate popup
            if not btn.infoIcon then
                btn.infoIcon = btn:CreateTexture(nil, "OVERLAY")
                btn.infoIcon:SetSize(14, 14)
                btn.infoIcon:SetPoint("RIGHT", btn, "RIGHT", 6, -6)
                btn.infoIcon:SetTexture("Interface\\COMMON\\help-i") -- Default WoW info icon
            end
            btn.infoIcon:SetShown(true)

            -- Tooltip logic
            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:ClearLines()

                if itemData.money and itemData.price > 0 then
                    local count = math.floor(honorToUse / itemData.price)
                    local totalCopper = count * (
                        (itemData.money.gold or 0) * 10000 +
                        (itemData.money.silver or 0) * 100 +
                        (itemData.money.copper or 0)
                    )

                    local g = math.floor(totalCopper / 10000)
                    local s = math.floor((totalCopper % 10000) / 100)
                    local c = totalCopper % 100

                    local honorIcon = "|T" .. honorIconPath .. ":14:14:0:0|t"
                    GameTooltip:AddLine(itemData.name, 1, 1, 1)
                    GameTooltip:AddLine(string.format("x%d = %s / 4k%s", count, EHM.FormatGoldWithIcons(g, s, c), honorIcon), 1, 0.82, 0)
                    GameTooltip:AddLine(string.format("Vendor: %s", itemData.merchant.name), 1, 1, 1)
                    
                    local fontString = _G["GameTooltipTextLeft1"]
                    if fontString then
                        fontString:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE") -- default size is ~12
                    end
                else
                    GameTooltip:AddLine("No sell value info available", 1, 0, 0)
                end
                GameTooltip:Show()
            end)

            btn:SetScript("OnLeave", function()
                GameTooltip:Hide()
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

C_Timer.After(1, function()
    -- safe to run after full load
    EHM_ItemsView:ShowItems()
end)

-- Create a frame for events
-- local updateFrame = CreateFrame("Frame")

-- -- Function to refresh the UI state
-- local function RefreshItemsView()
--     if EHM.EHM_SideBarViews and EHM.EHM_SideBarViews.items then
--         EHM.EHM_SideBarViews.items:ShowItems()
--     end
-- end

-- -- Listen to ADDON_LOADED for initial refresh
-- updateFrame:RegisterEvent("ADDON_LOADED")
-- updateFrame:SetScript("OnEvent", function(self, event, arg1)
--     if event == "ADDON_LOADED" and arg1 == "EasyHonorMoneyDev" then
--         RefreshItemsView()
--         -- If you want, unregister ADDON_LOADED after first call
--         self:UnregisterEvent("ADDON_LOADED")
--     end
-- end)

-- -- Custom event for when USED_ITEM changes
-- updateFrame:RegisterEvent("EHM_USED_ITEM_CHANGED")

-- -- Update handler for custom event
-- updateFrame:SetScript("OnEvent", function(self, event, arg1)
--     if event == "EHM_USED_ITEM_CHANGED" then
--         RefreshItemsView()
--     elseif event == "ADDON_LOADED" and arg1 == "EasyHonorMoneyDev" then
--         RefreshItemsView()
--         self:UnregisterEvent("ADDON_LOADED")
--     end
-- end)




EHM.EHM_SideBarViews[EHM.SidebarNavigation.items.key] = EHM_ItemsView