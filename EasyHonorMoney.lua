-- Auto mode (Buy,Equip,Sell Items)
local function RunAutoBuyEquipSell()
    EHM.MODULES.AutoBuyEquipSellItems(EHM_DB.USED_ITEM.index)
end

-- Buy Items
local function RunEHMBuy(itemId)
    local freeBagSlots = EHM.GetFreeBagSlots()
    EHM.MODULES.BuyItemsIfEnoughHonor(EHM_DB.USED_ITEM.index, freeBagSlots)
end

-- Equip Items
local function RunEHMEquip()
    EHM.MODULES.EquipItemsByItemID_SeparateCall(EHM_DB.USED_ITEM.index)
end

-- Sell Items
local function RunEHMSell()
    EHM.MODULES.SellItemsByItemID_SeparateCall(EHM_DB.USED_ITEM.index)
end

-- PVP
local function ViewVendorHonorStatistic()
    EHM.MODULES.VendorGoldStatistic(EHM.HONOR_INDEX)
end

local function ViewVendorConquestStatistic()
    EHM.MODULES.VendorGoldStatistic(EHM.CONQUEST_INDEX)
end

-- PVE
local function ViewVendorJusticeStatistic()
    EHM.MODULES.VendorGoldStatistic(EHM.JUSTICE_INDEX)
end

local function ViewVendorValorStatistic()
    EHM.MODULES.VendorGoldStatistic(EHM.VALOR_INDEX)
end

-- Main Menu
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

---PVP---
-- Honor Merchants Statistic
EHM.RegisterSlashCommand(
    EHM.COMMANDS.HONOR_STATISTIC.key .. "1",
    EHM.COMMANDS.HONOR_STATISTIC.register
)
SlashCmdList[EHM.COMMANDS.HONOR_STATISTIC.key] = ViewVendorHonorStatistic

-- Conquest
EHM.RegisterSlashCommand(
    EHM.COMMANDS.CONQUEST_STATISTIC.key .. "1",
    EHM.COMMANDS.CONQUEST_STATISTIC.register
)
SlashCmdList[EHM.COMMANDS.CONQUEST_STATISTIC.key] = ViewVendorConquestStatistic

---PVE---
-- Justice
EHM.RegisterSlashCommand(
    EHM.COMMANDS.JUSTICE_STATISTIC.key .. "1",
    EHM.COMMANDS.JUSTICE_STATISTIC.register
)
SlashCmdList[EHM.COMMANDS.JUSTICE_STATISTIC.key] = ViewVendorJusticeStatistic

-- Valor
EHM.RegisterSlashCommand(
    EHM.COMMANDS.VALOR_STATISTIC.key .. "1",
    EHM.COMMANDS.VALOR_STATISTIC.register
)
SlashCmdList[EHM.COMMANDS.VALOR_STATISTIC.key] = ViewVendorValorStatistic

-- All together
EHM.RegisterSlashCommand(
    EHM.COMMANDS.AUTO.key .. "1",
    EHM.COMMANDS.AUTO.A1.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.AUTO.key .. "2",
    EHM.COMMANDS.AUTO.A2.register
)
EHM.RegisterSlashCommand(
    EHM.COMMANDS.AUTO.key .. "3",
    EHM.COMMANDS.AUTO.A3.register
)
SlashCmdList[EHM.COMMANDS.AUTO.key] = RunAutoBuyEquipSell

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