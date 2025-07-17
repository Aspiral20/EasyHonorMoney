local EHM_BodyContent = EHM.UI.MAIN_FRAME.BODY.EHM_BodyContent
-- Example: Items View
local EHM_ItemCheckView = CreateFrame("Frame", nil, EHM_BodyContent)
EHM_ItemCheckView:SetSize(EHM_BodyContent:GetWidth(), EHM_BodyContent:GetHeight())
EHM_ItemCheckView:SetAllPoints()
EHM_ItemCheckView:Hide()

local EHM_ItemCheckTitle = EHM_ItemCheckView:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
EHM_ItemCheckTitle:SetPoint("TOP", EHM_BodyContent, "TOP", 0, EHM.SidebarContent.paddingTitleTop)
EHM_ItemCheckTitle:SetJustifyH("CENTER")
EHM_ItemCheckTitle:SetJustifyV("MIDDLE")
EHM_ItemCheckTitle:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
EHM_ItemCheckTitle:SetText(EHM.SidebarNavigation.item_check.title)

EHM.EHM_SideBarViews[EHM.SidebarNavigation.item_check.key] = EHM_ItemCheckView

local frame = EHM_ItemCheckView
local honorToUse = 4000
local defaultIconPath = "Interface\\Icons\\INV_Misc_QuestionMark"

-- Input for item ID or link
frame.itemInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
frame.itemInput:SetSize(150, 24)
frame.itemInput:SetPoint("TOP", frame, "TOP", 0, -36)
frame.itemInput:SetPoint("CENTER", frame, "CENTER", 0, 0)
frame.itemInput:SetAutoFocus(false)
function HandleItemIDInput(itemID)
    local itemName, itemLink, itemRarity, itemLevel, _, itemType, itemSubType, _, itemEquipLoc, itemIcon = GetItemInfo(itemID)
    if itemName then
        frame.itemInputIcon:SetText(string.format("|T%s:14|t", itemIcon))
    else
        EHM.NotificationsWarning("Item not cached yet. Waiting...")
    end
end

frame.itemInput:SetScript("OnEnterPressed", function(self)
    local text = self:GetText()
    local itemID = tonumber(text:match("item:(%d+)") or text)  -- handles both full links and raw IDs

    if itemID then
        HandleItemIDInput(itemID)
    else
        EHM.NotificationsError("Invalid item ID or link.")
    end
    self:ClearFocus()
end)

frame.itemTitleInput = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
frame.itemTitleInput:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
frame.itemTitleInput:SetPoint("LEFT", frame.itemInput, "LEFT", -100, 0)
frame.itemTitleInput:SetText("ItemID/Link")

frame.itemInputIcon = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
frame.itemInputIcon:SetFont(EHM.TITLE_FONT, 14, "OUTLINE")
frame.itemInputIcon:SetPoint("LEFT", frame.itemInput, "LEFT", -22, -1)
frame.itemInputIcon:SetText(string.format("|T%s:14|t", defaultIconPath))

-- Enable shift-click linking
hooksecurefunc("ChatEdit_InsertLink", function(link)
    if frame.itemInput and frame.itemInput:HasFocus() then
        frame.itemInput:Insert(link)
        local icon = GetItemIcon(link)
        frame.itemInputIcon:SetText(string.format("|T%s:14|t", icon))
    end
end)

-- Input for honor amount
frame.honorInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
frame.honorInput:SetSize(35, 24)
frame.honorInput:SetPoint("LEFT", frame.itemInput, "RIGHT", 10, 0)
frame.honorInput:SetAutoFocus(false)
frame.honorInput:SetNumeric(true)
frame.honorInput:SetText("0")

frame.honorInputIcon = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
frame.honorInputIcon:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
frame.honorInputIcon:SetPoint("LEFT", frame.honorInput, "RIGHT", 2, -1)
frame.honorInputIcon:SetText(string.format("%s/x1", EHM.GetHonorIcon().honorIcon))

-- Copper/silver/gold inputs
local function CreateMoneyInput(label, anchor, xOffset)
    local box = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    box:SetSize(30, 24)
    box:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", xOffset, -10)
    box:SetAutoFocus(false)
    box:SetNumeric(true)
    box:SetText("0")
    
    local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetFont(EHM.TITLE_FONT, 12, "OUTLINE")
    lbl:SetPoint("LEFT", box, "RIGHT", 2, 0)
    lbl:SetText(label)

    return box
end

-- frame.goldInput = CreateMoneyInput(EHM.MONEY_ICONS.gold, frame.itemInput, 0)
-- frame.silverInput = CreateMoneyInput(EHM.MONEY_ICONS.silver, frame.itemInput, 60)
-- frame.copperInput = CreateMoneyInput(EHM.MONEY_ICONS.copper, frame.itemInput, 120)

-- Submit button
frame.searchBtn = EHM.AddonButton(frame, "Check", 80, 24)
-- frame.searchBtn:SetPoint("TOP", frame.goldInput, "BOTTOM", 20, -10)
frame.searchBtn:SetPoint("TOP", frame.itemInputIcon, "BOTTOM", 0, -10)
frame.searchBtn:SetPoint("LEFT", frame.itemInputIcon, "RIGHT")

local resultIconSize = 35

-- Result area
frame.resultText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
-- frame.resultText:SetPoint("TOP", frame, "TOP", 0, -(resultIconSize + 155))
frame.resultText:SetPoint("TOP", frame.searchBtn, "BOTTOM", 0, -(resultIconSize + 40))
frame.resultText:SetPoint("LEFT", frame.itemInputIcon, "RIGHT")

frame.resultIcon = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
frame.resultIcon:SetFont(EHM.TITLE_FONT, resultIconSize, "OUTLINE")
frame.resultIcon:SetPoint("TOP", frame.resultText, "TOP", 0, resultIconSize + 15)
frame.resultIcon:SetPoint("CENTER", frame.resultText, "CENTER")

frame.searchBtn:SetScript("OnClick", function()
    local input = frame.itemInput:GetText()
    local itemID = tonumber(input:match("item:(%d+)") or input)
    if not itemID then
        frame.resultText:SetText("Not found ItemID/Link")
        frame.resultIcon:SetText(string.format("|T%s:14|t", defaultIconPath))
        return
    end
    
    local itemName, itemLink, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
    if not itemName then
        frame.resultText:SetText("Item not found.")
        frame.resultIcon:SetText(string.format("|T%s:14|t", defaultIconPath))
        return
    end

    local price = tonumber(frame.honorInput:GetText()) or 0
    if not price or price == 0 then
        frame.resultText:SetText("Honor per item can not be empty(0).")
        frame.resultIcon:SetText(string.format("|T%s:14|t", defaultIconPath))
        return
    end

    -- local g = tonumber(frame.goldInput:GetText()) or 0
    -- local s = tonumber(frame.silverInput:GetText()) or 0
    -- local c = tonumber(frame.copperInput:GetText()) or 0
    
    -- if g == 0 and s == 0 and c == 0 then
    --     frame.resultText:SetText("Money values(" .. EHM.MONEY_ICONS.gold .. EHM.MONEY_ICONS.silver .. EHM.MONEY_ICONS.copper .. ") can not be empty(0).")
    --     frame.resultIcon:SetText(string.format("|T%s:14|t", defaultIconPath))
    --     return
    -- end
    
    local copper = EHM.GetRealTimePriceItem(itemID)
    local g, s, c = EHM.SplitMoney(copper)
    
    local count = math.floor(honorToUse / price)
    local totalCopper = count * (
        (g or 0) * 10000 +
        (s or 0) * 100 +
        (c or 0)
    )
    
    local finalG = math.floor(totalCopper / 10000)
    local finalS = math.floor((totalCopper % 10000) / 100)
    local finalC = totalCopper % 100

    frame.resultIcon:SetText(string.format("|T%s:14|t", itemIcon))
    -- frame.resultText:SetText(string.format("%s\nID: %d\n" .. EHM.CHAR_COLORS.gold .. " x%d = %s / 4k%s" .. EHM.CHAR_COLORS.reset, itemName, itemID, count, EHM.FormatGoldWithIcons(finalG, finalS, finalC), EHM.GetHonorIcon().honorIcon))
    frame.resultText:SetText(string.format("%s\nID: %d\n Item cost: %s \n" .. EHM.CHAR_COLORS.gold .. " x%d = %s / 4k%s" .. EHM.CHAR_COLORS.reset, itemName, itemID, GetCoinTextureString(copper), count, EHM.FormatGoldWithIcons(finalG, finalS, finalC), EHM.GetHonorIcon().honorIcon))
end)