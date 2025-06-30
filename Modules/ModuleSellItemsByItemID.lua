local MAX_SELL_PER_BATCH = 15
local SELL_DELAY = 0  -- safe minimum delay between items
local BATCH_DELAY = 0.01 -- slight delay between batches

local function SellItemsByItemID(itemID, itemData, callback)
    if GetMerchantNumItems() == 0 then
        EHM.Notifications("Please speak with a merchant!")
        if callback then callback(false) end
        return
    end

    itemData = itemData or { itemName = "Item", vendorPrice = 0 }
    local itemName = itemData.itemName
    local vendorPrice = itemData.vendorPrice

    local totalGoldEarned = 0
    local soldCount = 0
    local soldInBatch = 0

    local function SellNext()
        if soldInBatch >= MAX_SELL_PER_BATCH then
            soldInBatch = 0
            C_Timer.After(BATCH_DELAY, SellNext)
            return
        end

        for bag = 0, 4 do
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                local link = C_Container.GetContainerItemLink(bag, slot)
                if link then
                    local foundID = tonumber(link:match("item:(%d+):"))
                    if foundID == itemID then
                        -- Sell this item
                        C_Container.UseContainerItem(bag, slot)
                        soldCount = soldCount + 1
                        soldInBatch = soldInBatch + 1
                        totalGoldEarned = totalGoldEarned + vendorPrice

                        -- Short delay before checking next
                        -- C_Timer.After(SELL_DELAY, SellNext)
                        SellNext()
                        return
                    end
                end
            end
        end

        -- If we reached here, nothing more to sell
        -- local g = math.floor(totalGoldEarned / 10000)
        -- local s = math.floor((totalGoldEarned % 10000) / 100)
        -- local c = totalGoldEarned % 100
        -- EHM.Notifications(string.format("Sold %d × %s, earned %dg %ds %dc", soldCount, itemName, g, s, c))

        if callback then callback(true) end
    end

    -- Start selling process
    SellNext()
end

local isSellingCancelled = false

-- Reuse eventFrame from previous buy function, but extend it:
EHM.MerchantEventFrame:HookScript("OnEvent", function(self, event)
    if event == "MERCHANT_CLOSED" then
        isSellingCancelled = true
        isCancelled = true -- if also running buy at same time
    end
end)

local function SellItemsByItemID_SeparateCall(itemID)
    if GetMerchantNumItems() == 0 then
        EHM.Notifications(" Please speak with a merchant before selling items.")
        return
    end
    
    isSellingCancelled = false

    local C = C_Container
    local vendorPrice = 0
    local soldCount = 0
    local totalGoldEarned = 0
    local itemsToSell = {}

    -- Step 1: Collect matching items
    for bag = 0, 4 do
        for slot = 1, C.GetContainerNumSlots(bag) do
            local link = C.GetContainerItemLink(bag, slot)
            if link then
                local foundID = tonumber(link:match("item:(%d+):"))
                if foundID == itemID then
                    local itemInfo = C.GetContainerItemInfo(bag, slot)
                    if itemInfo and not itemInfo.hasLoot then
                        table.insert(itemsToSell, { bag = bag, slot = slot, link = link })
                    end
                end
            end
        end
    end

    local totalItems = #itemsToSell

    -- Step 2: Sell items one by one with short delay
    local function SellNext()
        if #itemsToSell == 0 or isSellingCancelled then
            local g = math.floor(totalGoldEarned / 10000)
            local s = math.floor((totalGoldEarned % 10000) / 100)
            local c = totalGoldEarned % 100
            local goldString = EHM.FormatGoldWithIcons(g, s, c)

            if isSellingCancelled and #itemsToSell > 0 then
                EHM.NotificationsWarning(string.format(" Selling cancelled early — sold %d/%d × itemID %d, earned %s", soldCount, totalItems, itemID, goldString))
            else
                EHM.Notifications(string.format("Sold %d × itemID %d, earned %s", soldCount, itemID, goldString))
            end
            return
        end

        local item = table.remove(itemsToSell, 1)
        C.UseContainerItem(item.bag, item.slot)
        vendorPrice = select(11, GetItemInfo(item.link)) or 0
        totalGoldEarned = totalGoldEarned + vendorPrice
        soldCount = soldCount + 1

        -- 🔁 Feedback every 10 items
        if soldCount % 10 == 0 or #itemsToSell == 0 then
            local g = math.floor(totalGoldEarned / 10000)
            local s = math.floor((totalGoldEarned % 10000) / 100)
            local c = totalGoldEarned % 100
            local bar = EHM.GetProgressBar(soldCount, totalItems)
            EHM.Notifications(string.format("%s %d/%d sold — %s earned", bar, soldCount, totalItems, EHM.FormatGoldWithIcons(g, s, c)))
        end

        C_Timer.After(0.15, SellNext)
    end

    SellNext()
end

EHM.MODULES.SellItemsByItemID = SellItemsByItemID
EHM.MODULES.SellItemsByItemID_SeparateCall = SellItemsByItemID_SeparateCall