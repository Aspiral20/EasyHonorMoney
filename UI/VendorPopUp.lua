local PopUpWidth = 400
local PopUpHeight = 160

local MinimizedPopUpWidth = 56
local MinimizedPopUpHeight = 36

local EHM_HonorVendor = CreateFrame("Frame", "EHM_HonorVendor", UIParent, "BackdropTemplate")
EHM_HonorVendor:SetSize(PopUpWidth, PopUpHeight)
EHM_HonorVendor:SetPoint("TOP")
EHM_HonorVendor:SetBackdrop({
    bgFile = EHM.BACKGROUND_POPUP,
    tile = true,
    tileSize = EHM.MAIN_FRAME.BORDER_SIZE,
    edgeSize = EHM.MAIN_FRAME.BORDER_SIZE,
    insets = { left = EHM.MAIN_FRAME.BORDER_INSET, right = EHM.MAIN_FRAME.BORDER_INSET, top = EHM.MAIN_FRAME.BORDER_INSET, bottom = EHM.MAIN_FRAME.BORDER_INSET }
})
EHM_MainFrame:SetBackdropColor(0, 0, 0, EHM.BACKGROUND_OPACITY)
EHM_HonorVendor:Hide()
EHM_HonorVendor:SetMovable(true)
EHM_HonorVendor:EnableMouse(true)
EHM_HonorVendor:RegisterForDrag("LeftButton")
EHM_HonorVendor:SetScript("OnDragStart", EHM_HonorVendor.StartMoving)
EHM_HonorVendor:SetScript("OnDragStop", EHM_HonorVendor.StopMovingOrSizing)

-- Container for minimize buttons
EHM_HonorVendor.content = CreateFrame("Frame", nil, EHM_HonorVendor)
EHM_HonorVendor.content:SetAllPoints()

-- Title fontstring
local titleText = "Honor Items Available"
local title = EHM_HonorVendor:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
title:SetPoint("TOP", 0, -14)
title:SetText(titleText)

local buttons = {}

local minimized = false -- track minimize state

local faction = UnitFactionGroup("player")
local honorIconPath = "Interface\\ICONS\\pvpcurrency-honor-" .. string.lower(faction or "alliance")

-- Buttons options
local buttonsSize = 20
local buttonsY = -8

-- Minimize button
local minimizeBtn = CreateFrame("Button", nil, EHM_HonorVendor, "UIPanelButtonTemplate")
minimizeBtn:SetSize(buttonsSize, buttonsSize)
minimizeBtn:SetPoint("TOPRIGHT", EHM_HonorVendor, "TOPRIGHT", -30, buttonsY)
minimizeBtn:SetText("-")
local minimized = false

minimizeBtn:SetScript("OnClick", function()
    minimized = not minimized
    if minimized then
        EHM_HonorVendor.content:Hide()
        EHM_HonorVendor:SetSize(MinimizedPopUpWidth, MinimizedPopUpHeight) -- shrink size when minimized
        minimizeBtn:SetText("+")
        title:SetText(nil)
    else
        EHM_HonorVendor.content:Show()
        EHM_HonorVendor:SetSize(PopUpWidth, PopUpHeight)
        EHM_HonorVendor:BuildPopup()
        minimizeBtn:SetText("-")
        title:SetText(titleText)
    end
end)

local closeBtn = CreateFrame("Button", nil, EHM_HonorVendor, "UIPanelButtonTemplate")
closeBtn:SetSize(buttonsSize, buttonsSize)
closeBtn:SetText("x")
closeBtn:SetPoint("TOPRIGHT", EHM_HonorVendor, "TOPRIGHT", buttonsY, buttonsY)
closeBtn:SetScript("OnClick", function()
    EHM_HonorVendor:Hide()
end)

honorIcon = "|T" .. honorIconPath .. ":14:14:0:0|t"

function EHM_HonorVendor:BuildPopup()
    -- Clear old buttons after changing "EHM_DB.USED_ITEM"
    for _, btn in ipairs(buttons) do
        btn:Hide()
        btn:SetScript("OnClick", nil)
        if btn.border then
            btn.border:Hide()
        end
        if btn.honorIcon then
            btn.honorIcon:Hide()
        end
    end
    
    local playerHonor = EHM.GetPlayerHonor()
    local foundAny = false

    local xStart, yStart = 20, -80
    local btnSize = 48
    local spacing = 10
    local maxButtonsPerRow = 6
    local currentX, currentY = xStart, yStart
    local buttonsInRow = 0
    -- For estimated gold/4k honor
    local honorToUse = 4000
    local totalGold, totalSilver, totalCopper = 0, 0, 0
    local itemsBought, totalSellValue = 0, 0

    for i = 1, GetMerchantNumItems() do
        local itemID = EHM.GetMerchantItemID(i)
        local itemData = EHM.Items[itemID]

        if itemID and itemData then
            local canAfford = playerHonor >= itemData.price

            local btn = CreateFrame("Button", "EHM_HonorItemBtn"..itemID, EHM_HonorVendor.content, "SecureActionButtonTemplate")
            btn:SetSize(btnSize, btnSize)
            btn:SetPoint("TOPLEFT", EHM_HonorVendor, "TOPLEFT", currentX, currentY)
            btn:SetNormalTexture(GetItemIcon(itemID))
            btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

            btn:GetNormalTexture():SetDesaturated(not canAfford)

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
            if EHM_DB and EHM_DB.USED_ITEM and EHM_DB.USED_ITEM.index == itemID then
                btn.border:SetBackdropBorderColor(0, 1, 0, 1) -- Green border
            else
                btn.border:SetBackdropBorderColor(0, 0, 0, 0) -- Transparent border
            end
            btn.border:Show()

            btn:SetScript("OnClick", function()
                if not canAfford then
                -- You don't have enough Honor points to buy this item.
                    return
                end
                if EHM.IsItemAdded(itemID) then
                -- Item already added to DB.
                    return
                end
                EHM.SetUsedItem(itemID)
            end)

            if not btn.priceText then
                btn.priceText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                btn.priceText:SetPoint("TOP", btn, "BOTTOM", -8, -8)
            end
            btn.priceText:SetText(itemData.price)
            btn.priceText:SetTextColor(canAfford and 1 or 0, canAfford and 1 or 0, canAfford and 1 or 0)

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

    if not foundAny then
        title:SetText("No Honor Items for sale")
    else
        title:SetText("Honor Items Available")
    end

    return foundAny
end

local function GetNPCIDFromGUID(guid)
    if not guid then return nil end
    local _, _, _, _, _, npcID = strsplit("-", guid)
    return tonumber(npcID)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("MERCHANT_SHOW")
eventFrame:RegisterEvent("MERCHANT_CLOSED")
eventFrame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        local guid = UnitGUID("npc")
        local npcID = GetNPCIDFromGUID(guid)

        if npcID and EHM.Merchants[npcID] then
            local hasHonorItems = EHM_HonorVendor:BuildPopup()
            if hasHonorItems then
            -- Ensure it's not minimized when reopening
                minimized = false
                if EHM_HonorVendor.content then
                    EHM_HonorVendor.content:Show()
                    EHM_HonorVendor:SetSize(PopUpWidth, PopUpHeight)
                end
                if minimizeBtn then
                    minimizeBtn:SetText("–")
                end
                EHM_HonorVendor:Show()
            else
                EHM_HonorVendor:Hide()
            end
        else
            EHM_HonorVendor:Hide()
        end
    elseif event == "MERCHANT_CLOSED" then
        EHM_HonorVendor:Hide()
    end
end)

-- Action Buttons
-- Ensure the button frame exists only once
EHM.CreateActionButtons(
    EHM_HonorVendor,
    {
        { name = "Buy",   command = function() SlashCmdList[EHM.COMMANDS.BUY.key]("") end },
        { name = "Equip", command = function() SlashCmdList[EHM.COMMANDS.EQUIP.key]("") end },
        { name = "Sell",  command = function() SlashCmdList[EHM.COMMANDS.SELL.key]("") end },
    },
    15,
    -39,
    75,
    function(buttons)
        local bagUpdateFrame = CreateFrame("Frame")
        bagUpdateFrame:RegisterEvent("BAG_UPDATE")
        bagUpdateFrame:RegisterEvent("BAG_UPDATE_DELAYED")
        
        -- Update Buy button text whenever bag changes
        local function UpdateBuyButton()
            local freeBagSlots = EHM.GetFreeBagSlots()
            local buyButton = EHM_HonorVendor.actionButtons[1] -- Buy button is first
            if buyButton then
                buyButton:SetText("Buy (" .. freeBagSlots .. ")")
            end
        end

        bagUpdateFrame:SetScript("OnEvent", function(self, event, ...)
            UpdateBuyButton()
        end)

        -- Also update once right after creating buttons
        UpdateBuyButton()
    end
)

-- Update vendor popup on BAG_UPDATE or currency change
-- local honorUpdateFrame = CreateFrame("Frame")
-- honorUpdateFrame:RegisterEvent("BAG_UPDATE")
-- honorUpdateFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

-- honorUpdateFrame:SetScript("OnEvent", function()
--     if EHM_HonorVendor and EHM_HonorVendor:IsShown() then
--         EHM_HonorVendor:BuildPopup()
--     end
-- end)


-- local freeBagSlots = EHM.GetFreeBagSlots()
-- local equipBtn = CreateFrame("Button", nil, EHM_HonorVendor, "UIPanelButtonTemplate")
-- closeBtn:SetHeight(buttonsSize)
-- closeBtn:SetText("Buy(" .. freeBagSlots .. ")")
-- closeBtn:SetPoint("TOPLEFT", EHM_HonorVendor, "TOPLEFT", -8, -8)
-- closeBtn:SetScript("OnClick", function()
    
-- end)