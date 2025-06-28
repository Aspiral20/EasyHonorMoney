EHM.RACE_ICONS = {
    ["Human"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Human_Male",
        name = "Human",
    },
    ["Dwarf"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Dwarf_Male",
        name = "Dwarf",
    },
    ["NightElf"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Nightelf_Male",
        name = "NightElf",
    },
    ["Gnome"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Gnome_Male",
        name = "Gnome",
    },
    ["Draenei"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Draenei_Male",
        name = "Draenei",
    },
    ["Orc"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Orc_Male",
        name = "Orc",
    },
    ["Troll"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Troll_Male",
        name = "Troll",
    },
    ["Undead"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Undead_Male",
        name = "Undead",
    },
    ["Tauren"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Tauren_Male",
        name = "Tauren",
    },
    ["BloodElf"] = {
        iconPath = "Interface\\Icons\\Achievement_Character_Bloodelf_Male",
        name = "BloodElf",
    },
}
-- Add for horde (mapId = 85 - Ogrimar)
-- Viev uoir current mapId, use in chat:
-- /dump C_Map.GetBestMapForUnit("player")
EHM.Merchants = {
    [12785] = {
        index = 12785,
        name = "Sergeant Major Clate",
        title = "<Legacy Armor Quartermaster>",
        mapID = 1453,
        x = 75.62,
        y = 67.18,
        race = EHM.RACE_ICONS["Dwarf"]
    },
    [12784] = {
        index = 12784,
        name = "Lieutenant Jackspring",
        title = "<Legacy Weapon Quartermaster>",
        mapID = 1453,
        x = 75.49,
        y = 67.30,
        race = EHM.RACE_ICONS["Gnome"]
    },
}

