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

local function IsItemAdded(itemID)
    if not EHM_DB or not EHM_DB.USED_ITEM then return false end
    for _, id in ipairs(EHM_DB.USED_ITEM) do
        if id == itemID then return true end
    end
    return false
end

local function GetPlayerHonor()
    local honorPoints = 0
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(390) -- Honor ID
    if currencyInfo then honorPoints = currencyInfo.quantity or 0 end
    return honorPoints
end

local function GetMerchantItemID(merchantIndex)
    local link = GetMerchantItemLink(merchantIndex)
    if not link then return nil end
    local itemID = tonumber(link:match("item:(%d+):"))
    return itemID
end

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

function EHM_HonorVendor:BuildPopup()
    -- Clear old buttons
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
    buttons = {}

    local playerHonor = GetPlayerHonor()
    local foundAny = false

    local xStart, yStart = 20, -80
    local btnSize = 48
    local spacing = 10
    local maxButtonsPerRow = 6
    local currentX, currentY = xStart, yStart
    local buttonsInRow = 0

    for i = 1, GetMerchantNumItems() do
        local itemID = GetMerchantItemID(i)
        local itemData = EHM.Items[itemID]

        if itemID and itemData then
            local canAfford = playerHonor >= itemData.price
            local added = IsItemAdded(itemID)

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
                --     print("|cffff0000You don't have enough Honor points to buy this item.|r")
                    return
                end
                if IsItemAdded(itemID) then
                --     print("|cff00ff00Item already added to DB.|r")
                    return
                end
                EHM_DB.USED_ITEM = EHM.Items[itemID]
                -- print(string.format(
                --     "|cff00ff00[EHM]|r Set %s (ID: %d) as your selected item.",
                --     itemData.name or "Unknown", itemID
                -- ))
                EHM_HonorVendor:BuildPopup() -- <- add this
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
if not EHM_HonorVendor.actionButtons then
    EHM_HonorVendor.actionButtons = {}

    local bagUpdateFrame = CreateFrame("Frame")
    bagUpdateFrame:RegisterEvent("BAG_UPDATE")
    bagUpdateFrame:RegisterEvent("BAG_UPDATE_DELAYED")

    -- Define your actions but leave Buy button text empty for now (update it later)
    local actions = {
        { name = "Buy",   command = function() SlashCmdList["EHM_B"]("") end },
        { name = "Equip", command = function() SlashCmdList["EHM_E"]("") end },
        { name = "Sell",  command = function() SlashCmdList["EHM_S"]("") end },
    }

    local startX = 15
    local spacing = 75

    -- Create buttons once
    for i, data in ipairs(actions) do
        local btn = CreateFrame("Button", nil, EHM_HonorVendor.content, "UIPanelButtonTemplate")
        btn:SetSize(65, 24)
        btn:SetPoint("TOPLEFT", EHM_HonorVendor.content, "TOPLEFT", startX + (i - 1) * spacing, -39)
        btn:SetText(data.name)
        btn:SetScript("OnClick", data.command)
        EHM_HonorVendor.actionButtons[#EHM_HonorVendor.actionButtons + 1] = btn
    end

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



-- local freeBagSlots = EHM.GetFreeBagSlots()
-- local equipBtn = CreateFrame("Button", nil, EHM_HonorVendor, "UIPanelButtonTemplate")
-- closeBtn:SetHeight(buttonsSize)
-- closeBtn:SetText("Buy(" .. freeBagSlots .. ")")
-- closeBtn:SetPoint("TOPLEFT", EHM_HonorVendor, "TOPLEFT", -8, -8)
-- closeBtn:SetScript("OnClick", function()
    
-- end)