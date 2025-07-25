EHM.MERCHANT_GENDER = {
    male = "male",
    female = "female"
}
EHM.RACE_ICONS = {
    ["Human"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Human_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Human_Female",
        },
        name = "Human",
    },
    ["Dwarf"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Dwarf_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Dwarf_Female",
        },
        name = "Dwarf",
    },
    ["NightElf"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Nightelf_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Nightelf_Female",
        },
        name = "NightElf",
    },
    ["Gnome"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Gnome_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Gnome_Female",
        },
        name = "Gnome",
    },
    ["Draenei"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Draenei_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Draenei_Female",
        },
        name = "Draenei",
    },
    ["Orc"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Orc_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Orc_Female",
        },
        name = "Orc",
    },
    ["Troll"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Troll_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Troll_Female",
        },
        name = "Troll",
    },
    ["Undead"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Undead_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Undead_Female",
        },
        name = "Undead",
    },
    ["Tauren"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Tauren_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Tauren_Female",
        },
        name = "Tauren",
    },
    ["BloodElf"] = {
        iconPath = {
            [EHM.MERCHANT_GENDER.male] = "Interface\\Icons\\Achievement_Character_Bloodelf_Male",
            [EHM.MERCHANT_GENDER.female] = "Interface\\Icons\\Achievement_Character_Bloodelf_Female",
        },
        name = "BloodElf",
    },
}

EHM.MAP_ICONS = {
    [84]  = { id = 84,  name = "Stormwind City",    zone = "Elwynn Forest",     path = "Interface\\Icons\\Achievement_Zone_Elwynnforest" },
    [85]  = { id = 85,  name = "Orgrimmar",         zone = "Durotar",           path = "Interface\\Icons\\Achievement_Zone_Durotar" },
    [87]  = { id = 87,  name = "Ironforge",         zone = "Dun Morogh",        path = "Interface\\Icons\\Achievement_Zone_DunMorogh" },
    [89]  = { id = 89,  name = "Darnassus",         zone = "Teldrassil",        path = "Interface\\Icons\\Achievement_Zone_Teldrassil" },
    [90]  = { id = 90,  name = "Undercity",         zone = "Tirisfal Glades",   path = "Interface\\Icons\\Achievement_Zone_Tirisfal" },
    [88]  = { id = 88,  name = "Thunder Bluff",     zone = "Mulgore",           path = "Interface\\Icons\\Achievement_Zone_Mulgore" },
    [103] = { id = 103, name = "The Exodar",        zone = "Azuremyst Isle",    path = "Interface\\Icons\\Achievement_Zone_AzuremystIsle" },
    [110] = { id = 110, name = "Silvermoon City",   zone = "Eversong Woods",    path = "Interface\\Icons\\Achievement_Zone_EversongWoods" },
    [111] = { id = 111, name = "Shattrath City",    zone = "Terokkar Forest",   path = "Interface\\Icons\\Achievement_Zone_TerokkarForest" },
    [125] = { id = 125, name = "Dalaran",           zone = "Crystalsong Forest",path = "Interface\\Icons\\Achievement_Zone_CrystalsongForest" },

    -- Cataclysm zones remain unchanged (unless they were remapped in MoP, which is rare):
    [640] = { id = 640, name = "Deepholm",          zone = "Deepholm",          path = "Interface\\Icons\\Achievement_Zone_Deepholm" },
    [605] = { id = 605, name = "Kezan",             zone = "Kezan",             path = "Interface\\Icons\\Achievement_Zone_Kezan" },
    [544] = { id = 544, name = "Gilneas",           zone = "Gilneas",           path = "Interface\\Icons\\Achievement_Zone_Gilneas" },
    [737] = { id = 737, name = "The Lost Isles",    zone = "The Lost Isles",    path = "Interface\\Icons\\Achievement_Zone_LostIsles" },
    [709] = { id = 709, name = "Tol Barad",         zone = "Tol Barad",         path = "Interface\\Icons\\Achievement_Zone_TolBarad" },
}

-- Add for horde (mapId = 85 - Ogrimar)
-- Viev uoir current mapId, use in chat:
-- /dump C_Map.GetBestMapForUnit("player")
EHM.Merchants = {
    -- Horde
    [12795] = {
        index = 12795,
        name = "First Sergeant Hola'mahi",
        title = "<Legacy Armor Quartermaster>",
        mapID = EHM.MAP_ICONS[85].id,
        x = 38.36,
        y = 73.08,
        race = EHM.RACE_ICONS["Troll"],
        faction = EHM.FACTION.Horde,
        gender = EHM.MERCHANT_GENDER.female,
    },
    [12794] = {
        index = 12794,
        name = "Stone Guard Zarg",
        title = "<Legacy Weapon Quartermaster>",
        mapID = EHM.MAP_ICONS[85].id,
        x = 38.52,
        y = 73.09,
        race = EHM.RACE_ICONS["Orc"],
        faction = EHM.FACTION.Horde,
        gender = EHM.MERCHANT_GENDER.male,
    },
    -- Alliance
    [12785] = {
        index = 12785,
        name = "Sergeant Major Clate",
        title = "<Legacy Armor Quartermaster>",
        mapID = EHM.MAP_ICONS[84].id,
        x = 75.62,
        y = 67.18,
        race = EHM.RACE_ICONS["Dwarf"],
        faction = EHM.FACTION.Alliance,
        gender = EHM.MERCHANT_GENDER.male,
    },
    [12784] = {
        index = 12784,
        name = "Lieutenant Jackspring",
        title = "<Legacy Weapon Quartermaster>",
        mapID = EHM.MAP_ICONS[84].id,
        x = 75.49,
        y = 67.30,
        race = EHM.RACE_ICONS["Gnome"],
        faction = EHM.FACTION.Alliance,
        gender = EHM.MERCHANT_GENDER.male,
    },
    [12778] = {
        index = 12778,
        name = "Lieutenant Rachel Vaccar",
        title = "<Outland Armor Quartermaster>",
        mapID = EHM.MAP_ICONS[84].id,
        x = 75.32,
        y = 67.45,
        race = EHM.RACE_ICONS["Human"],
        faction = EHM.FACTION.Alliance,
        gender = EHM.MERCHANT_GENDER.female,
    },
}
