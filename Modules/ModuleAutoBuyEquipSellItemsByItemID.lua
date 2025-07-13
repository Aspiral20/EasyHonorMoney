local MAX_ITEMS = 12

local function GetItemNameByID(itemID)
    local itemName = GetItemInfo(itemID)
    if not itemName then
        print("Item not cached:", itemID)
    end
    return itemName
end

local function HasHonor(itemHonorPrice)
    return (EHM.GetPlayerHonor() or 0) > itemHonorPrice
end

local function WaitUntilReady(callback)
    C_Timer.After(1, function()
        if EHM.LOADERS.autoBSE then
            WaitUntilReady(callback)
        else
            callback()
        end
    end)
end

local function AutoBuyEquipSellItems(itemID)
    EHM.IsClosedMerchant = false
    local itemData = EHM.Items[itemID]
    local equipSlot = EHM.HM_GetEquipSlot(itemID)
    if not equipSlot then
        EHM.Notifications("Unknown equip slot for itemID:", itemID)
        return
    end
    local originalItemID = EHM.HM_GetOriginalItemId(equipSlot)

    if not itemData.name then return end

    local function SellStep()
        if EHM.IsClosedMerchant then
            EHM.NotificationsWarning("Purchase cancelled (merchant closed).")
            return
        end
        EHM.LOADERS.autoBSE = true
        EHM.MODULES.SellItemsByItemID_SeparateCall(itemID, true)
        C_Timer.After(1, function()
            EHM.LOADERS.autoBSE = false
        end)
        WaitUntilReady(function()
            if HasHonor(itemData.price) or EHM.HasItemInBags(itemID) then
                StartStep()
            else
                -- Equip Back Original Item
                EHM.LOADERS.autoBSE = true
                EHM.HM_EquipOriginalItem(originalItemID, equipSlot)
                C_Timer.After(1, function()
                    EHM.LOADERS.autoBSE = false
                end)

                -- Sell last Item
                WaitUntilReady(function()
                    if EHM.HasItemInBags(itemID) then
                        SellStep()
                    end
                    EHM.NotificationsWarning("Stopped: No more honor or items.")
                end)
            end
        end)
    end

    local function EquipStep()
        if EHM.IsClosedMerchant then
            EHM.NotificationsWarning("Purchase cancelled (merchant closed).")
            return
        end
        EHM.LOADERS.autoBSE = true
        EHM.MODULES.EquipItemsByItemID_SeparateCall(itemID, true)
        C_Timer.After(1, function()
            EHM.LOADERS.autoBSE = false
        end)
        WaitUntilReady(SellStep)
    end

    local function BuyStep()
        if EHM.IsClosedMerchant then
            EHM.NotificationsWarning("Purchase cancelled (merchant closed).")
            return
        end
        local freeBagSlots = EHM.GetFreeBagSlots()
        EHM.LOADERS.autoBSE = true
        EHM.MODULES.BuyItemsIfEnoughHonor(itemID, freeBagSlots)
        C_Timer.After(1, function()
            EHM.LOADERS.autoBSE = false
        end)
        WaitUntilReady(EquipStep)
    end

    function StartStep()
        if EHM.IsClosedMerchant then
            EHM.NotificationsWarning("Purchase cancelled (merchant closed).")
            return
        end
        local hasItems = EHM.HasItemInBags(itemID)
        local freeSlots = EHM.GetFreeBagSlots()
        local hasHonor = HasHonor(itemData.price)

        if freeSlots == 0 and hasItems then
            -- If bags are full but we still have items, prioritize cleanup
            EquipStep()
        elseif hasItems then
            -- No honor, but still items to handle
            EquipStep()
        elseif hasHonor and freeSlots > 0 then
            -- Normal cycle
            BuyStep()
        else
            -- Equip Back Original Item
            EHM.LOADERS.autoBSE = true
            EHM.HM_EquipOriginalItem(originalItemID, equipSlot)
            C_Timer.After(1, function()
                EHM.LOADERS.autoBSE = false
            end)
            -- Sell last Item
            WaitUntilReady(function()
                if EHM.HasItemInBags(itemID) then
                    SellStep()
                end
                EHM.NotificationsWarning("Stopped: No more honor or items to process.")
            end)
        end
    end

    StartStep()
end

EHM.MODULES.AutoBuyEquipSellItems = AutoBuyEquipSellItems
