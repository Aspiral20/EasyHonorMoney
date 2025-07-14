function VendorGoldStatistic()
    -- Example usage:
    -- local itemID = 28379
    -- local honorCost = EHM.GetRealTimeHonorCostForItem(itemID)
    -- local copper = EHM.GetRealTimePriceItem(itemID)

    -- if honorCost then
    --     print("Item costs " .. honorCost .. " honor points. And sell price is " .. GetCoinTextureString(copper) .. ".")
    -- else
    --     print("Honor cost not found (maybe not at vendor?).")
    -- end

    local honorTable = EHM.HM_GetAllHonorItemsAtVendor()
    if honorTable then
        local sortedItems = EHM.GetItemsSortedByPrice(honorTable, "sellingPriceFor4k")
        for id, item in pairs(sortedItems) do
            print(string.format("ItemID %d %s costs %d%s (Merchant slot %d), selling price: %s, profit: x%d = %s / 4k%s", id, item.link, item.honor, EHM.GetHonorIcon().honorIcon, item.index, GetCoinTextureString(item.sellingPrice), item.countItemsFor4k, GetCoinTextureString(item.sellingPriceFor4k), EHM.GetHonorIcon().honorIcon))
        end
    else
        EHM.NotificationsWarning("Not found items, speak with any honor vendor")
    end
end

EHM.MODULES.VendorGoldStatistic = VendorGoldStatistic
