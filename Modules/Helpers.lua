function EHM.HM_GetEquipSlot(itemID)
    local itemEquipLoc = select(9, GetItemInfo(itemID)) -- e.g., "INVTYPE_CLOAK"
    return EHM.CHAR_SLOT_INDEX[itemEquipLoc], itemEquipLoc
end

function EHM.HM_GetOriginalItemId(equipSlot)
    local originalItemID

    local originalLink = GetInventoryItemLink("player", equipSlot)
    if originalLink then
        originalItemID = tonumber(originalLink:match("item:(%d+):"))
    end

    return originalItemID
end

function EHM.HM_EquipOriginalItem(originalItemID, equipSlot)
    local delayEquip = 0.8 -- delay for bag processing
    local C = C_Container

    if not originalItemID then return end

    C_Timer.After(delayEquip, function()
        local currentLink = GetInventoryItemLink("player", equipSlot)
        local currentID = currentLink and tonumber(currentLink:match("item:(%d+):"))
        
        if currentID == originalItemID then
            EHM.NotificationsWarning("Original item already equipped.")
            return
        end

        -- Check if it's a two-handed weapon
        local _, equipLoc = EHM.HM_GetEquipSlot(originalItemID)
        local isTwoHand = (equipLoc == "INVTYPE_2HWEAPON")
        local twoHandIndex = EHM.CHAR_SLOT_INDEX[INVTYPE_2WEAPON]
        local offHandIndex = EHM.CHAR_SLOT_INDEX[INVTYPE_OFFHAND]

        -- If trying to equip 2H weapon into main-hand, clear off-hand
        if isTwoHand and equipSlot == twoHandIndex then
            local offhandLink = GetInventoryItemLink("player", offHandIndex)
            if offhandLink then
                PickupInventoryItem(offHandIndex)
                PutItemInBackpack() -- or C_Container.PutItemInBackpack() for Retail/MoP Classic
            end
        end

        -- Find and equip the item from bags
        for bag = 0, 4 do
            for slot = 1, C.GetContainerNumSlots(bag) do
                local link = C.GetContainerItemLink(bag, slot)
                if link then
                    local foundID = tonumber(link:match("item:(%d+):"))
                    if foundID == originalItemID then
                        C.PickupContainerItem(bag, slot)
                        EquipCursorItem(equipSlot)
                        return
                    end
                end
            end
        end

        EHM.NotificationsError("Original item not found in bags.")
    end)
end

function EHM.HM_GetAllCurrencyItemsAtVendor(externCurrencyIndex)
    externCurrencyIndex = externCurrencyIndex or EHM.HONOR_INDEX
    local honorItems = {}
    
    for i = 1, GetMerchantNumItems() do
        local itemLink = GetMerchantItemLink(i)
        if itemLink then
            local itemID = tonumber(itemLink:match("item:(%d+):"))
            local costInfoCount = GetMerchantItemCostInfo(i)

            for j = 1, costInfoCount do
                local _, amount, currencyLink = GetMerchantItemCostItem(i, j)
                local currencyID = tonumber(currencyLink and currencyLink:match("currency:(%d+)"))
                local sellingPrice = EHM.GetRealTimePriceItem(itemID)
                local gold, silver, copper = EHM.SplitMoney(sellingPrice)
                local count = math.floor(4000 / amount)

                local sellingPriceFor4k = count * (
                    (gold or 0) * 10000 +
                    (silver or 0) * 100 +
                    (copper or 0)
                )

                local gold4k = math.floor(sellingPriceFor4k / 10000)
                local silver4k = math.floor((sellingPriceFor4k % 10000) / 100)
                local copper4k = sellingPriceFor4k % 100
                
                if currencyID == externCurrencyIndex then -- Honor Points ID
                    honorItems[itemID] = {
                        index = i,
                        itemID = itemID,
                        honor = amount,
                        link = itemLink,
                        sellingPrice = sellingPrice,
                        money = {
                            gold = gold,
                            silver = silver,
                            copper = copper,
                        },
                        sellingPriceFor4k = sellingPriceFor4k,
                        moneyFor4k = {
                            gold = gold4k,
                            silver = silver4k,
                            copper = copper4k,
                        },
                        countItemsFor4k = count,
                    }
                end
            end
        end
    end
    return honorItems
end
