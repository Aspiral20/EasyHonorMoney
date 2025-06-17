-- local MAX_SELL_PER_BATCH = 15
-- local SELL_DELAY = 0.1  -- delay between each item sold
-- local BATCH_DELAY = 0.5 -- delay between batches

-- local function SellItemsByItemID(itemID, itemData, callback)
--     if GetMerchantNumItems() == 0 then
--         print("Please speak with vendor to open merchant items!")
--         if callback then callback(false) end
--         return
--     end

--     itemData = itemData or {itemName = "Item", vendorPrice = 0}
--     local itemName = itemData.itemName
--     local vendorPrice = itemData.vendorPrice

--     local totalGoldEarned = 0
--     local soldCount = 0
--     local itemsToSell = {}

--     -- Collect items
--     for bag = 0, 4 do
--         for slot = 1, C_Container.GetContainerNumSlots(bag) do
--             local link = C_Container.GetContainerItemLink(bag, slot)
--             if link then
--                 local foundID = tonumber(link:match("item:(%d+):"))
--                 if foundID == itemID then
--                     table.insert(itemsToSell, {bag = bag, slot = slot})
--                 end
--             end
--         end
--     end

--     if #itemsToSell == 0 then
--         print("No items found to sell:", itemName)
--         if callback then callback(false) end
--         return
--     end

--     local function SellItemsLoop() end -- forward declare

--     local function SellBatch(batch)
--         local index = 1

--         local function SellNext()
--             if index > #batch then
--                 -- wait before next batch
--                 C_Timer.After(BATCH_DELAY, SellItemsLoop)
--                 return
--             end

--             local info = batch[index]
--             index = index + 1

--             C_Container.UseContainerItem(info.bag, info.slot)
--             soldCount = soldCount + 1
--             totalGoldEarned = totalGoldEarned + vendorPrice

--             C_Timer.After(SELL_DELAY, SellNext)
--         end

--         SellNext()
--     end

--     function SellItemsLoop()
--         if #itemsToSell == 0 then
--             local gold = math.floor(totalGoldEarned / 10000)
--             local silver = math.floor((totalGoldEarned % 10000) / 100)
--             local copper = totalGoldEarned % 100
--             print(string.format("Sold %d × %s, earned %dg %ds %dc", soldCount, itemName, gold, silver, copper))
--             if callback then callback(true) end
--             return
--         end

--         local batch = {}
--         for i = 1, MAX_SELL_PER_BATCH do
--             local item = table.remove(itemsToSell, 1)
--             if not item then break end
--             table.insert(batch, item)
--         end

--         SellBatch(batch)
--     end

--     SellItemsLoop()
-- end

local MAX_SELL_PER_BATCH = 15
local SELL_DELAY = 0  -- safe minimum delay between items
local BATCH_DELAY = 0.01 -- slight delay between batches

local function SellItemsByItemID(itemID, itemData, callback)
    if GetMerchantNumItems() == 0 then
        print("Please speak with a vendor!")
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
        -- print(string.format("Sold %d × %s, earned %dg %ds %dc", soldCount, itemName, g, s, c))

        if callback then callback(true) end
    end

    -- Start selling process
    SellNext()
end

local function SellItemsByItemID_SeparateCall(itemID)
    if GetMerchantNumItems() == 0 then
        print("Please speak with a vendor before selling items.")
        return
    end

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
        if #itemsToSell == 0 then
            local g = math.floor(totalGoldEarned / 10000)
            local s = math.floor((totalGoldEarned % 10000) / 100)
            local c = totalGoldEarned % 100
            print(string.format("Sold %d × itemID %d, earned %s", soldCount, itemID, EHM.FormatGoldString(g, s, c)))
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
            print(string.format("%s %d/%d sold — %s earned", bar, soldCount, totalItems, EHM.FormatGoldString(g, s, c)))
        end

        C_Timer.After(0.15, SellNext)
    end

    SellNext()
end

EHM.MODULES.SellItemsByItemID = SellItemsByItemID
EHM.MODULES.SellItemsByItemID_SeparateCall = SellItemsByItemID_SeparateCall