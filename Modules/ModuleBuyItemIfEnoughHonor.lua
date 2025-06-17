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

local function BuyItemsIfEnoughHonor(itemID, countItems, callback)
    if GetMerchantNumItems() == 0 then
        print("Please talk to vendor!")
        if callback then callback(false) end
        return
    end

    local slot = FindMerchantSlotByItemID(itemID)
    if not slot then
        print("Item not found at vendor")
        if callback then callback(false) end
        return
    end

    local honor = GetCurrencyInfo(EHM.HONOR_INDEX).quantity
    local cost = EHM.Items[itemID].price
    local remaining = math.min(countItems, math.floor(honor / cost))
    local bought = 0

    local function BuyBatch()
        local batchCount = math.min(MAX_BUY_PER_BATCH, remaining - bought)

        local function BuyNextInBatch(i)
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

    -- if remaining <= 0 then
    --     print("Not enough honor or items requested is zero")
    --     if callback then callback(false) end
    --     return
    -- end

    BuyBatch()
end

-- local function BuyItemsIfEnoughHonor_SeparateCall(itemID)
-- end

EHM.MODULES.BuyItemsIfEnoughHonor = BuyItemsIfEnoughHonor
-- EHM.MODULES.BuyItemsIfEnoughHonor_SeparateCall = BuyItemsIfEnoughHonor_SeparateCall