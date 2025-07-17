local width = EHM.VENDOR_POPUP.WIDTH
local height = EHM.VENDOR_POPUP.STATISTIC.HEIGHT

local VendorStatistic = CreateFrame("Frame", nil, EHM.EHM_HonorVendor, "BackdropTemplate")
VendorStatistic:SetPoint("TOP", EHM.EHM_HonorVendor, "TOP", 0, -(EHM.EHM_HonorVendor:GetHeight() - (EHM.MAIN_FRAME.BORDER_INSET * 2 - 2)))

VendorStatistic:SetWidth(EHM.EHM_HonorVendor:GetWidth())
VendorStatistic:SetHeight(height)
-- VendorStatistic:SetPoint("TOPRIGHT")
-- VendorStatistic:SetPoint("BOTTOMRIGHT")

VendorStatistic:SetBackdrop({
    bgFile = EHM.BACKGROUND_POPUP,
    tile = true,
    tileSize = EHM.MAIN_FRAME.BORDER_SIZE,
    edgeSize = EHM.MAIN_FRAME.BORDER_SIZE,
    insets = { left = EHM.MAIN_FRAME.BORDER_INSET, right = EHM.MAIN_FRAME.BORDER_INSET, top = EHM.MAIN_FRAME.BORDER_INSET, bottom = EHM.MAIN_FRAME.BORDER_INSET }
})
VendorStatistic:SetBackdropColor(0, 0, 0, EHM.BACKGROUND_OPACITY)
VendorStatistic:Hide()
VendorStatistic:EnableMouse(true)
VendorStatistic:RegisterForDrag("LeftButton")
-- VendorStatistic:SetScript("OnDragStart", EHM.EHM_HonorVendor.StartMoving)
-- VendorStatistic:SetScript("OnDragStop", EHM.EHM_HonorVendor.StopMovingOrSizing)
-- VendorStatistic:Show()

-- Dragging child moves parent
VendorStatistic:SetScript("OnDragStart", function()
    EHM.EHM_HonorVendor:StartMoving()
end)
VendorStatistic:SetScript("OnDragStop", function()
    EHM.EHM_HonorVendor:StopMovingOrSizing()
end)

-- Title fontstring
local titleText = "Merchant Statistic"
local title = VendorStatistic:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -14)
title:SetText(titleText)

local rowHeight = 28

-- Header row
local headers = {
    { text = "ItemID", width = 60 },
    { text = "Honor", width = 70 },
    { text = "Merchant Slot", width = 110 },
    { text = "Sell", width = 100 },
    { text = "Items/4k", width = 100 },
    { text = "Sell/4k", width = 140 },
}

local function GetHeaderByName(name)
    for i, header in ipairs(headers) do
        if header.text == name then
            return header
        end
    end
    return nil -- not found
end

local headerFrame = CreateFrame("Frame", nil, VendorStatistic)
headerFrame:SetSize(width - 20, 30)
headerFrame:SetPoint("TOPLEFT", VendorStatistic, "TOPLEFT", 10, -30)

local xOffset = 0
for i, header in ipairs(headers) do
    local headerText = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    headerText:SetPoint("LEFT", headerFrame, "LEFT", xOffset, 0)
    headerText:SetWidth(header.width or 60)
    headerText:SetJustifyH("LEFT")

    if header.text == "Honor" or header.text == "Items/4k" or header.text == "Sell/4k" then
        headerText:SetText(string.format("%s%s", header.text, EHM.GetHonorIcon().honorIcon))
    else
        headerText:SetText(header.text)
    end

    xOffset = xOffset + header.width
end


local function CreateVendorStatisticScrollFrame(parent)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -60)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -30, 10)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(parent:GetWidth() - 40, 1)
    scrollFrame:SetScrollChild(content)

    return scrollFrame, content
end


local function AddItemRow(parent, index, itemData)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(parent:GetWidth() - 20, rowHeight)
    row:SetPoint("TOPLEFT", 0, -((index - 1) * rowHeight))

    -- ItemID
    local idText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    idText:SetPoint("LEFT", row, "LEFT", 0, 0)
    idText:SetWidth(GetHeaderByName("ItemID").width)
    idText:SetJustifyH("LEFT")
    idText:SetText(itemData.itemID)

    -- Honor
    local honorText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    honorText:SetPoint("LEFT", idText, "RIGHT", 0, 0)
    honorText:SetWidth(GetHeaderByName("Honor").width)
    honorText:SetJustifyH("LEFT")
    honorText:SetText(string.format("%d%s", itemData.honor, EHM.GetHonorIcon().honorIcon))

    -- MerchantSlot
    local merchantSlot = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    merchantSlot:SetPoint("LEFT", honorText, "RIGHT", 0, 0)
    merchantSlot:SetWidth(GetHeaderByName("Merchant Slot").width)
    merchantSlot:SetJustifyH("LEFT")
    merchantSlot:SetText(itemData.index)

    -- Sell
    local sellText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sellText:SetPoint("LEFT", merchantSlot, "RIGHT", 0, 0)
    sellText:SetWidth(GetHeaderByName("Sell").width)
    sellText:SetJustifyH("LEFT")
    sellText:SetText(string.format("%s", GetCoinTextureString(itemData.sellingPrice)))

    -- Items / 4k
    local itemsProfitText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    itemsProfitText:SetPoint("LEFT", sellText, "RIGHT", 0, 0)
    itemsProfitText:SetWidth(GetHeaderByName("Items/4k").width)
    itemsProfitText:SetJustifyH("LEFT")
    itemsProfitText:SetText(string.format("x%d", itemData.countItemsFor4k))

    -- Sell / 4k
    local profitText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    profitText:SetPoint("LEFT", itemsProfitText, "RIGHT", 0, 0)
    profitText:SetWidth(GetHeaderByName("Sell/4k").width)
    profitText:SetJustifyH("LEFT")
    profitText:SetText(string.format("%s", GetCoinTextureString(itemData.sellingPriceFor4k)))

    -- Tooltip on row
    row:SetScript("OnEnter", function()
        GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
        if itemData.link then
            GameTooltip:SetHyperlink(itemData.link)
        else
            GameTooltip:SetText("No link available")
        end
        GameTooltip:Show()
    end)
    row:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    return row
end

local scrollFrame, contentFrame = CreateVendorStatisticScrollFrame(VendorStatistic)

function EHM.RenderVendorStatistic(force)
    if EHM.CACHE_RENDER_UI.VENDOR_POPUP.STATISTIC and not force then
        return -- Already rendered, skip unless forced
    end

    EHM.CACHE_RENDER_UI.VENDOR_POPUP.STATISTIC = true

    local honorTable = EHM.HM_GetAllCurrencyItemsAtVendor()
    if not honorTable then
        EHM.NotificationsWarning("Not found honor items!")
        return
    end

    local sortedItems = EHM.GetItemsSortedByPrice(honorTable, "sellingPriceFor4k", true)
    local index = 1

    -- Clear previous rows
    for _, child in ipairs({ contentFrame:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end

    for _, itemData in pairs(sortedItems) do
        AddItemRow(contentFrame, index, itemData)
        index = index + 1
    end

    contentFrame:SetHeight(index * rowHeight)
end

EHM.VendorStatistic = VendorStatistic