local function EquipItemsByItemID(itemID, equipSlotName, callback)
    local C = C_Container
    local equipSlot = EHM.CHAR_SLOT_INDEX[equipSlotName]
    local itemsToEquip = {}

    -- Store original item link in the slot
    local originalItemLink = GetInventoryItemLink("player", equipSlot)
    local originalItemID = originalItemLink and tonumber(originalItemLink:match("item:(%d+):"))

    -- Accept equipSlotName like "INVTYPE_CLOAK" and convert it to numeric slot
    if not equipSlot then
        EHM.NotificationsError("Invalid equip slot:", equipSlotName)
        if callback then callback(false) end
        return
    end

    -- Debug:
    -- EHM.debugPrint(equipSlot, equipSlotName, originalItemLink, originalItemID)
    
    -- Find all matching items in bags
    for bag = 0, 4 do
        for slot = 1, C.GetContainerNumSlots(bag) do
            local link = C.GetContainerItemLink(bag, slot)
            if link then
                local foundID = tonumber(link:match("item:(%d+):"))
                if foundID == itemID then
                    table.insert(itemsToEquip, {bag = bag, slot = slot})
                end
            end
        end
    end

    if #itemsToEquip == 0 then
        EHM.Notifications("No items found with itemID:", itemID)
        if callback then callback(false) end
        return
    end

    local function ReEquipOriginal()
        if not originalItemID then
            if callback then callback(true) end
            return
        end

        for bag = 0, 4 do
            for slot = 1, C.GetContainerNumSlots(bag) do
                local link = C.GetContainerItemLink(bag, slot)
                if link then
                    local foundID = tonumber(link:match("item:(%d+):"))
                    if foundID == originalItemID then
                        C.PickupContainerItem(bag, slot)
                        EquipCursorItem(equipSlot)
                        if callback then callback(true) end
                        return
                    end
                end
            end
        end

        EHM.Notifications("Original item not found to re-equip.")
        if callback then callback(true) end
    end

    local function EquipNext()
        if #itemsToEquip == 0 then
            C_Timer.After(0.5, ReEquipOriginal)
            return
        end

        local item = table.remove(itemsToEquip, 1)
        C.PickupContainerItem(item.bag, item.slot)
        EquipCursorItem(equipSlot)

        if StaticPopup1 and StaticPopup1:IsVisible() then
            StaticPopup1Button1:Click("LeftButton", true)
        end

        C_Timer.After(0.4, EquipNext)
    end

    EquipNext()
end

local function EquipItemsByItemID_SeparateCall(itemID, isAutoMode)
    local isAutoMode = isAutoMode or false
    EHM.LOADERS.equip = true

    local C = C_Container

    local equipSlot = EHM.HM_GetEquipSlot(itemID)
    if not equipSlot then
        EHM.Notifications("Unknown equip slot for itemID:", itemID)
        return
    end

    -- Save currently equipped item ID and locate it in bag (if possible)
    local originalBag, originalSlot

    local originalItemID = EHM.HM_GetOriginalItemId(equipSlot)
    -- Collect all matching items from bags
    local itemsToEquip = {}
    for bag = 0, 4 do
        for slot = 1, C.GetContainerNumSlots(bag) do
            local link = C.GetContainerItemLink(bag, slot)
            if link then
                local foundID = tonumber(link:match("item:(%d+):"))
                if foundID == itemID then
                    table.insert(itemsToEquip, {bag = bag, slot = slot})
                elseif foundID == originalItemID then
                    originalBag, originalSlot = bag, slot
                end
            end
        end
    end

    if #itemsToEquip == 0 then
        EHM.NotificationsError("No items found with itemID:", itemID)
        return
    end

    -- Equip all matching items one by one
    for _, item in ipairs(itemsToEquip) do
        C.PickupContainerItem(item.bag, item.slot)
        EquipCursorItem(equipSlot)

        -- Handle confirmation popup
        if StaticPopup1 and StaticPopup1:IsVisible() then
            StaticPopup1Button1:Click("LeftButton", true)
        end
    end

    -- Re-equip the original item if needed
    if not isAutoMode then
        EHM.HM_EquipOriginalItem(originalItemID, equipSlot)
    end
    EHM.LOADERS.equip = false
end

EHM.MODULES.EquipItemsByItemID = EquipItemsByItemID
EHM.MODULES.EquipItemsByItemID_SeparateCall = EquipItemsByItemID_SeparateCall