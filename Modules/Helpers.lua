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