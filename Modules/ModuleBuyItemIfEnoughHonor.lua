local MAX_BUY_PER_BATCH = 12
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

local function BuyItemsIfEnoughHonor(itemID, countItems, callback)
    EHM.LOADERS.buy = true
    EHM.IsClosedMerchant = false -- reset on new call
    local itemData = EHM.Items[itemID]
    
    if GetMerchantNumItems() == 0 then
        EHM.Notifications(" Please talk to merchant.")
        if callback then callback(false) end
        return
    end

    local slot = FindMerchantSlotByItemID(itemID)
    if not slot then
        EHM.NotificationsWarning(" Item not found at merchant.")
        if callback then callback(false) end
        return
    end
    local playerHonor = EHM.GetPlayerHonor()
    local cost = itemData.price
    local canAfford = playerHonor >= cost

    if not canAfford then
        EHM.NotificationsWarning(string.format("You don't have enough honor to buy \"%s: %s%s\".", itemData.name, itemData.price, EHM.GetHonorIcon().honorIcon))
    end

    local honor = GetCurrencyInfo(EHM.HONOR_INDEX).quantity
    local remaining = math.min(countItems, math.floor(honor / cost))
    local bought = 0

    local function BuyBatch()
        if EHM.IsClosedMerchant then
            EHM.NotificationsWarning("Purchase cancelled (merchant closed).")
            if callback then callback(false) end
            return
        end
        local batchCount = math.min(MAX_BUY_PER_BATCH, remaining - bought)

        local function BuyNextInBatch(i)
            if EHM.IsClosedMerchant then
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
    C_Timer.After(1, function()
        EHM.LOADERS.buy = false
    end)
end

EHM.MODULES.BuyItemsIfEnoughHonor = BuyItemsIfEnoughHonor