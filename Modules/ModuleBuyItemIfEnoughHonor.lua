local MAX_BUY_PER_BATCH = 15
local BUY_DELAY = 0.1 -- seconds between buys
local BATCH_DELAY = 0.5 -- delay after batch to avoid vendor limit

local function FindMerchantSlotByItemID(itemID)
    local count = GetMerchantNumItems()
    for slot = 1, count do
        local link = GetMerchantItemLink(slot)
        if link then
            local id = tonumber(string.match(link, "item:(%d+):"))
            if id == itemID then
                return slot
            end
        end
    end
    return nil
end

EHM.MerchantEventFrame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_CLOSED" then
        isCancelled = true
    end
end)

local function BuyItemsIfEnoughHonor(itemID, countItems, callback)
    isCancelled = false -- reset on new call
    
    if GetMerchantNumItems() == 0 then
        EHM.Notifications(" Please talk to vendor.")
        if callback then callback(false) end
        return
    end

    local slot = FindMerchantSlotByItemID(itemID)
    if not slot then
        EHM.Notifications(" Item not found at vendor.")
        if callback then callback(false) end
        return
    end

    local honor = GetCurrencyInfo(EHM.HONOR_INDEX).quantity
    local cost = EHM.Items[itemID].price
    local remaining = math.min(countItems, math.floor(honor / cost))
    local bought = 0

    local function BuyBatch()
        if isCancelled then
            EHM.NotificationsWarning("Purchase cancelled (merchant closed).")
            if callback then callback(false) end
            return
        end
        local batchCount = math.min(MAX_BUY_PER_BATCH, remaining - bought)

        local function BuyNextInBatch(i)
            if isCancelled then
                EHM.NotificationsWarning("Purchase cancelled during batch.")
                if callback then callback(false) end
                return
            end

            if i > batchCount then
                if bought < remaining then
                    -- Delay before next batch
                    C_Timer.After(BATCH_DELAY, BuyBatch)
                else
                    -- Finished buying all
                    if callback then callback(true) end
                end
                return
            end

            BuyMerchantItem(slot, 1)
            bought = bought + 1

            C_Timer.After(BUY_DELAY, function()
                BuyNextInBatch(i + 1)
            end)
        end

        BuyNextInBatch(1)
    end

    BuyBatch()
end

EHM.MODULES.BuyItemsIfEnoughHonor = BuyItemsIfEnoughHonor