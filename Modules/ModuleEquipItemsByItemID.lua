-- local MAX_EQUIP_PER_BATCH = 15
-- local EQUIP_DELAY = 0.1
-- local BATCH_DELAY = 0.5

-- local function EquipItemsByItemID(itemID, equipSlotName, callback)
--     local equipSlot = EHM.CHAR_SLOT_INDEX[equipSlotName]
--     if not equipSlot then
--         print("Invalid equip slot:", equipSlotName)
--         if callback then callback(false) end
--         return
--     end

--     local originalItemLink = GetInventoryItemLink("player", equipSlot)
--     local originalItemID = originalItemLink and tonumber(originalItemLink:match("item:(%d+):"))

--     local itemsToEquip = {}
--     for bag = 0, 4 do
--         for slot = 1, C_Container.GetContainerNumSlots(bag) do
--             local link = C_Container.GetContainerItemLink(bag, slot)
--             if link then
--                 local foundID = tonumber(link:match("item:(%d+):"))
--                 if foundID == itemID then
--                     table.insert(itemsToEquip, {bag = bag, slot = slot})
--                 end
--             end
--         end
--     end

--     local function EquipItemsLoop() end  -- Declare early

--     local function EquipBatch(batch)
--         local index = 1

--         local function EquipNext()
--             if index > #batch then
--                 C_Timer.After(BATCH_DELAY, EquipItemsLoop)
--                 return
--             end

--             local info = batch[index]
--             index = index + 1

--             ClearCursor()
--             C_Container.PickupContainerItem(info.bag, info.slot)
--             EquipCursorItem(equipSlot)

--             if StaticPopup1 and StaticPopup1:IsVisible() then
--                 StaticPopup1Button1:Click("LeftButton", true)
--             end

--             C_Timer.After(EQUIP_DELAY, EquipNext)
--         end

--         EquipNext()
--     end

--     function EquipItemsLoop()
--         if #itemsToEquip == 0 then
--             if callback then callback(true) end
--             return
--         end

--         local batch = {}
--         for i = 1, MAX_EQUIP_PER_BATCH do
--             local item = table.remove(itemsToEquip, 1)
--             if not item then break end
--             table.insert(batch, item)
--         end

--         EquipBatch(batch)
--     end

--     EquipItemsLoop()
-- end

local function EquipItemsByItemID(itemID, equipSlotName, callback)
    local C = C_Container
    local equipSlot = EHM.CHAR_SLOT_INDEX[equipSlotName]
    local itemsToEquip = {}

    -- Store original item link in the slot
    local originalItemLink = GetInventoryItemLink("player", equipSlot)
    local originalItemID = originalItemLink and tonumber(originalItemLink:match("item:(%d+):"))

    -- Accept equipSlotName like "INVTYPE_CLOAK" and convert it to numeric slot
    if not equipSlot then
        print("Invalid equip slot:", equipSlotName)
        if callback then callback(false) end
        return
    end

    -- Debug:
    -- print(equipSlot, equipSlotName, originalItemLink, originalItemID)

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
        print("No items found with itemID:", itemID)
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
                        print("Re-equipped original item.")
                        if callback then callback(true) end
                        return
                    end
                end
            end
        end

        print("Original item not found to re-equip.")
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

local function EquipItemsByItemID_SeparateCall(itemID)
    local C = C_Container
    local CHAR_SLOT_INDEX = EHM.CHAR_SLOT_INDEX
    local delayEquip = 0.4 -- 0.1 for many items, 0.4 for few(1-5)

    -- Determine correct equip slot from itemID
    local function GetEquipSlot(itemID)
        local itemEquipLoc = select(9, GetItemInfo(itemID)) -- e.g., "INVTYPE_CLOAK"
        return CHAR_SLOT_INDEX[itemEquipLoc], itemEquipLoc
    end

    local equipSlot, equipLoc = GetEquipSlot(itemID)
    if not equipSlot then
        print("Unknown equip slot for itemID:", itemID)
        return
    end

    -- Save currently equipped item ID and locate it in bag (if possible)
    local originalItemID
    local originalBag, originalSlot

    local originalLink = GetInventoryItemLink("player", equipSlot)
    if originalLink then
        originalItemID = tonumber(originalLink:match("item:(%d+):"))
    end
    
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
        print("No items found with itemID:", itemID)
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
    if originalItemID then
        C_Timer.After(delayEquip, function()
            local currentLink = GetInventoryItemLink("player", equipSlot)
            local currentID = currentLink and tonumber(currentLink:match("item:(%d+):"))

            if currentID ~= originalItemID then
                for bag = 0, 4 do
                    for slot = 1, C.GetContainerNumSlots(bag) do
                        local link = C.GetContainerItemLink(bag, slot)
                        if link then
                            local foundID = tonumber(link:match("item:(%d+):"))
                            if foundID == originalItemID then
                                C.PickupContainerItem(bag, slot)
                                EquipCursorItem(equipSlot)
                                print("Re-equipped original item.")
                                return
                            end
                        end
                    end
                end
                print("Original item not found in bags.")
            else
                print("Original item already equipped.")
            end
        end)
    end
end

EHM.MODULES.EquipItemsByItemID = EquipItemsByItemID
EHM.MODULES.EquipItemsByItemID_SeparateCall = EquipItemsByItemID_SeparateCall