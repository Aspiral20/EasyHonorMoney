-- Run this script to see in game currencies:
-- /run for i=1,GetCurrencyListSize() do local name, _, _, _, _, _, _, _, id = GetCurrencyListInfo(i) if id then print(id, name) end end

-- PVP Currencies
EHM.HONOR_INDEX    = 1901  -- Honor Points
EHM.CONQUEST_INDEX = 390   -- Conquest Points

-- PVE Currencies
EHM.JUSTICE_INDEX  = 395   -- Justice Points
EHM.VALOR_INDEX    = 697   -- Valor Points

-- Mop specific currencies
EHM.TIMELESS_COIN_INDEX = 777  -- Timeless Coin (used on Timeless Isle)
EHM.MOGU_RUNE_INDEX     = 752  -- Mogu Rune of Fate (used for bonus rolls)
EHM.ELDER_CHARM_INDEX   = 697  -- Elder Charm of Good Fortune (note: same ID as valor early MoP, Blizzard reused IDs)
EHM.LESSER_CHARM_INDEX  = 738  -- Lesser Charm of Good Fortune (used to buy bonus roll tokens)
