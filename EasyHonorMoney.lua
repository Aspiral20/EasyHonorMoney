
-- 🧪 Additional Suggestions:
-- Make sure the vendor window remains open during the process.
-- You can test selling with /run UseContainerItem(bag, slot) to see it work live.
-- You could also log how many were sold or track honor gained per loop if needed.

local currentItem = EHM.Items[18441]

local function GetFreeBagSlots()
    local free = 0
    for bag = 0, 4 do
        local freeSlots = C_Container.GetContainerNumFreeSlots(bag)
        if freeSlots then
            free = free + freeSlots
        end
    end
    return free
end

local function RunEHMLoop()
    local honor = GetCurrencyInfo(EHM.HONOR_INDEX).quantity
    local freeBagSlots = GetFreeBagSlots()
    local itemID = currentItem.index
    local itemName, _, _, _, _, _, _, _, equipSlotName, _, vendorPrice = GetItemInfo(currentItem.index)

    local function continueLoop()
        EHM.MODULES.EquipItemsByItemID(itemID, equipSlotName, function(success)
            if success then
                EHM.MODULES.SellItemsByItemID(itemID, {itemName = itemName or "Item", vendorPrice = vendorPrice or 0}, function(success)
                    if success then
                        -- print("Looping again...")
                        -- C_Timer.After(1, RunEHMLoop)
                    else
                        print("Sell step failed")
                    end
                end)
            else
                print("Equip step failed")
            end
        end)
    end

    if honor < EHM.CURRENT_MINIMAL_CURRENCY then
        local hasItemInBag = false
            
        for bag = 0, 4 do
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                local link = C_Container.GetContainerItemLink(bag, slot)
                if link then
                    local foundID = tonumber(link:match("item:(%d+):"))
                    if foundID == itemID then
                        hasItemInBag = true
                        break
                    end
                end
            end
            if hasItemInBag then break end
        end

        if not hasItemInBag then
            print("Stopping: Not enough honor and no items left in bag.")
            return
        else
            print("Honor too low, but still items in bag → processing them...")
            continueLoop()
            return
        end
    end

    EHM.MODULES.BuyItemsIfEnoughHonor(itemID, freeBagSlots, function(success)
        if success then
            continueLoop()
        else
            print("Buying failed.")
        end
    end)
    
    -- EHM.MODULES.BuyItemsIfEnoughHonor(currentItem.index, freeBagSlots)
    -- EHM.MODULES.EquipItemsByItemID(currentItem.index, equipSlotName)

    -- EHM.MODULES.BuyItemsIfEnoughHonor(currentItem.index, freeBagSlots, function(success)
    --     if success then
    --         print("All items bought!")
    --         C_Timer.After(4, function()
    --             EHM.MODULES.EquipItemsByItemID(currentItem.index, equipSlotName)
    --             C_Timer.After(6, function()
    --                 EHM.MODULES.SellItemsByItemID(currentItem.index, {itemName = itemName, vendorPrice = vendorPrice})
    --             end)
    --         end)
    --     else
    --         print("Buying failed")
    --     end
    -- end)

    -- C_Timer.After(2, function()
        -- EHM.MODULES.EquipItemsByItemID(currentItem.index, equipSlotName)

        -- C_Timer.After(4, function()
            -- EHM.MODULES.SellItemsByItemID(currentItem.index, {itemName = itemName, vendorPrice = vendorPrice})

            -- C_Timer.After(1, RunEHM)
        -- end)

    -- end)
    -- print("EHM Stats:")
    -- print("Honor:", honor)
    -- print("Free slots:", freeBagSlots)
end

local function RunEHMBuy()
    local freeBagSlots = GetFreeBagSlots()
    EHM.MODULES.BuyItemsIfEnoughHonor(currentItem.index, freeBagSlots)
end

local function RunEHMEquip()
    EHM.MODULES.EquipItemsByItemID_SeparateCall(currentItem.index)
end

local function RunEHMSell()
    EHM.MODULES.SellItemsByItemID_SeparateCall(currentItem.index)
end

-- All together (slower)
SLASH_EHM1 = EHM.COMMANDS.MAIN.M1
SLASH_EHM2 = EHM.COMMANDS.MAIN.M2
SLASH_EHM3 = EHM.COMMANDS.MAIN.M3
SlashCmdList.EHM = RunEHMLoop

-- Only Buy
SLASH_EHM_B1 = EHM.COMMANDS.BUY.B1
SLASH_EHM_B2 = EHM.COMMANDS.BUY.B2
SLASH_EHM_B3 = EHM.COMMANDS.BUY.B3
SlashCmdList.EHM_B = RunEHMBuy

-- Only Equip
SLASH_EHM_E1 = EHM.COMMANDS.EQUIP.E1
SLASH_EHM_E2 = EHM.COMMANDS.EQUIP.E2
SLASH_EHM_E3 = EHM.COMMANDS.EQUIP.E3
SlashCmdList.EHM_E = RunEHMEquip

-- Only Sell
SLASH_EHM_S1 = EHM.COMMANDS.SELL.S1
SLASH_EHM_S2 = EHM.COMMANDS.SELL.S2
SLASH_EHM_S3 = EHM.COMMANDS.SELL.S3
SlashCmdList.EHM_S = RunEHMSell