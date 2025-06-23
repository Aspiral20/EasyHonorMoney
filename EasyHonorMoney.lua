
-- 🧪 Additional Suggestions:
-- Make sure the vendor window remains open during the process.
-- You can test selling with /run UseContainerItem(bag, slot) to see it work live.
-- You could also log how many were sold or track honor gained per loop if needed.

local function RunEHMLoop()
    local honor = GetCurrencyInfo(EHM.HONOR_INDEX).quantity
    local freeBagSlots = EHM.GetFreeBagSlots()
    local itemID = EHM_DB.USED_ITEM.index
    local itemName, _, _, _, _, _, _, _, equipSlotName, _, vendorPrice = GetItemInfo(itemID)

    local function continueLoop()
        EHM.MODULES.EquipItemsByItemID(itemID, equipSlotName, function(success)
            if success then
                EHM.MODULES.SellItemsByItemID(itemID, {itemName = itemName or "Item", vendorPrice = vendorPrice or 0}, function(success)
                    if success then
                        -- print("Looping again...")
                        -- C_Timer.After(1, RunEHMLoop)
                    else
                        EHM.Notifications(EHM.CHAR_COLORS.red, "Sell step failed")
                    end
                end)
            else
                EHM.Notifications(EHM.CHAR_COLORS.red, "Equip step failed")
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
            EHM.Notifications(EHM.CHAR_COLORS.red, "Stopping: Not enough honor and no items left in bag.")
            return
        else
            EHM.Notifications(EHM.CHAR_COLORS.red, "Honor too low, but still items in bag → processing them...")
            continueLoop()
            return
        end
    end

    EHM.MODULES.BuyItemsIfEnoughHonor(itemID, freeBagSlots, function(success)
        if success then
            continueLoop()
        else
            EHM.Notifications(EHM.CHAR_COLORS.red, "Buying failed.")
        end
    end)
end

local function RunEHMBuy(itemId)
    local freeBagSlots = EHM.GetFreeBagSlots()
    EHM.MODULES.BuyItemsIfEnoughHonor(EHM_DB.USED_ITEM.index, freeBagSlots)
end

local function RunEHMEquip()
    EHM.MODULES.EquipItemsByItemID_SeparateCall(EHM_DB.USED_ITEM.index)
end

local function RunEHMSell()
    EHM.MODULES.SellItemsByItemID_SeparateCall(EHM_DB.USED_ITEM.index)
end

local function OpenUI() 
    EHM_MainFrame:Show()
end

-- Open UI
EHM.RegisterSlashCommand(
    EHM.COMMANDS.UI.key .. "1",
    EHM.COMMANDS.UI.UI1.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.UI.key .. "2",
    EHM.COMMANDS.UI.UI2.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.UI.key .. "3",
    EHM.COMMANDS.UI.UI3.register
)
SlashCmdList[EHM.COMMANDS.UI.key] = OpenUI

-- All together (slower)
-- EHM.RegisterSlashCommand(
--     EHM.COMMANDS.ALL.key .. "1",
--     EHM.COMMANDS.ALL.M1.register
-- )
-- EHM.RegisterSlashCommand(
--     EHM.COMMANDS.ALL.key .. "2",
--     EHM.COMMANDS.ALL.M2.register
-- )
-- EHM.RegisterSlashCommand(
--     EHM.COMMANDS.ALL.key .. "3",
--     EHM.COMMANDS.ALL.M3.register
-- )
-- SlashCmdList[EHM.COMMANDS.ALL.key] = RunEHMLoop
-- Only Buy
EHM.RegisterSlashCommand(
    EHM.COMMANDS.BUY.key .. "1",
    EHM.COMMANDS.BUY.B1.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.BUY.key .. "2",
    EHM.COMMANDS.BUY.B2.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.BUY.key .. "3",
    EHM.COMMANDS.BUY.B3.register
)
SlashCmdList[EHM.COMMANDS.BUY.key] = RunEHMBuy
-- Only Equip
EHM.RegisterSlashCommand(
    EHM.COMMANDS.EQUIP.key .. "1",
    EHM.COMMANDS.EQUIP.E1.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.EQUIP.key .. "2",
    EHM.COMMANDS.EQUIP.E2.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.EQUIP.key .. "3",
    EHM.COMMANDS.EQUIP.E3.register
)
SlashCmdList[EHM.COMMANDS.EQUIP.key] = RunEHMEquip
-- Only Sell
EHM.RegisterSlashCommand(
    EHM.COMMANDS.SELL.key .. "1",
    EHM.COMMANDS.SELL.S1.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.SELL.key .. "2",
    EHM.COMMANDS.SELL.S2.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.SELL.key .. "3",
    EHM.COMMANDS.SELL.S3.register
)
SlashCmdList[EHM.COMMANDS.SELL.key] = RunEHMSell