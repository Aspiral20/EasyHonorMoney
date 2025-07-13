local function RunAutoBuyEquipSell()
    EHM.MODULES.AutoBuyEquipSellItems(EHM_DB.USED_ITEM.index)
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

-- All together
EHM.RegisterSlashCommand(
    EHM.COMMANDS.ALL.key .. "1",
    EHM.COMMANDS.ALL.M1.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.ALL.key .. "2",
    EHM.COMMANDS.ALL.M2.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.ALL.key .. "3",
    EHM.COMMANDS.ALL.M3.register
)
SlashCmdList[EHM.COMMANDS.ALL.key] = RunAutoBuyEquipSell
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