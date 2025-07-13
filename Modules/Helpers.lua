function EHM.HM_GetEquipSlot(itemID)
    local CHAR_SLOT_INDEX = EHM.CHAR_SLOT_INDEX
    local itemEquipLoc = select(9, GetItemInfo(itemID)) -- e.g., "INVTYPE_CLOAK"
    return CHAR_SLOT_INDEX[itemEquipLoc], itemEquipLoc
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
    local delayEquip = 0.8 -- 0.1 for many items, 0.8 for few(1-5)
    local C = C_Container

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
                                return
                            end
                        end
                    end
                end
                EHM.NotificationsError("Original item not found in bags.")
            else
                EHM.NotificationsWarning("Original item already equipped.")
            end
        end)
    end
end