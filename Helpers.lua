local function DumpTable(t, indent)
    indent = indent or ""
    for k, v in pairs(t) do
        local keyStr = tostring(k)
        if type(v) == "table" then
            print(indent .. keyStr .. " = {")
            DumpTable(v, indent .. "  ")
            print(indent .. "}")
        else
            print(indent .. keyStr .. " = " .. tostring(v))
        end
    end
end

-- Example:
-- local function LongAction()
--     print("Starting long action...")
--     C_Timer.After(2, function()
--         print("Finished!")
--     end)
-- end

-- local safeLongAction = CreateLoadingFunction(LongAction)

-- -- Safe usage:
-- safeLongAction() -- Will run
-- safeLongAction() -- Will ignore if already running
local function CreateLoadingFunction(func)
    local isLoading = false

    return function(...)
        if isLoading then
            EHM.Notifications("Action already in progress...")
            return
        end

        isLoading = true
        local result = {pcall(func, ...)}
        isLoading = false

        return unpack(result)
    end
end

local function GetProgressBar(current, total, length)
    length = length or 20
    local lightGreen = EHM.CHAR_COLORS.lightGreen
    local lightBlue = EHM.CHAR_COLORS.lightBlue
    local white = EHM.CHAR_COLORS.white
    local reset = EHM.CHAR_COLORS.reset
    local filled = math.floor((current / total) * length)
    local bar = ""

    for i = 1, length do
        if i <= filled then
            bar = bar .. lightGreen .. "█" .. reset  -- Light green filled square
        else
            bar = bar .. white .. "░" .. reset  -- Light green empty square
        end
    end

    -- return "Progress: " .. lightBlue .. "[" .. reset .. bar .. lightBlue .. "]" .. reset
    return "Progress: " .. bar
end

local function FormatGoldString(g, s, c)
    return string.format("|cffffd700%dg|r |cffc7c7cf%ds|r |cffeda55f%dc|r", g, s, c)
end

local function FormatGoldWithIcons(g, s, c)
    local out = ""
    if g > 0 then out = out .. g .. EHM.MONEY_ICONS.gold end
    if s > 0 or (g > 0 and c > 0) then out = out .. s .. EHM.MONEY_ICONS.silver end
    if c > 0 or (g == 0 and s == 0) then out = out .. c .. EHM.MONEY_ICONS.copper end
    return out
end

local function GetHonorIcon()
    local faction = UnitFactionGroup("player")
    local honorIconPath = "Interface\\ICONS\\pvpcurrency-honor-" .. string.lower(faction or EHM.FACTION.Alliance)
    return { honorIcon = "|T" .. honorIconPath .. ":14:14:0:0|t", honorIconPath = honorIconPath}
end

local function CreateHonorIcon(frame, width, height)
    local honorIconPath = GetHonorIcon().honorIconPath
    local honorIconFrame = frame:CreateTexture(nil, "OVERLAY")
    honorIconFrame:SetSize(width or 14, height or 14)
    honorIconFrame:SetTexture(honorIconPath)
    return honorIconFrame
end

-- Faction Logic
local function GetFactionIcon(outsideFaction)
    local playerFaction = UnitFactionGroup("player") or EHM.FACTION.Alliance
    local faction = outsideFaction or playerFaction
    local factionIconPath = "Interface\\GroupFrame\\UI-Group-PVP-" .. string.upper(faction)
    return { factionIcon = "|T" .. factionIconPath .. ":14:14:0:0|t", factionIconPath = factionIconPath}
end

function EHM.CountItemsByFaction(outsideFaction)
    local playerFaction = UnitFactionGroup("player") or EHM.FACTION.Alliance
    local faction = outsideFaction or playerFaction
    local count = 0
    for _, item in pairs(EHM.Items) do
        if item.merchant.faction and item.merchant.faction == faction then
            count = count + 1
        end
    end
    return count
end

function EHM.CountAllItems()
    local count = 0
    for _, item in pairs(EHM.Items) do
        count = count + 1
    end
    return count
end

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

function EHM.Notifications(...)
    local args = { ... }
    local firstArg = args[1]

    local prefixColor = EHM.CHAR_COLORS.green
    local startIndex = 1

    -- If first arg is a known color code, use it
    for _, color in pairs(EHM.CHAR_COLORS) do
        if firstArg == color then
            prefixColor = firstArg
            startIndex = 2
            break
        end
    end

    local message = ""
    for i = startIndex, #args do
        message = message .. tostring(args[i])
        if i < #args then
            message = message .. " "
        end
    end

    print(prefixColor .. "[EHM]" .. EHM.CHAR_COLORS.reset .. " " .. message)
end

function EHM.NotificationsWarning(...)
    EHM.Notifications(EHM.CHAR_COLORS.yellow, ...)
end

function EHM.NotificationsError(...)
    EHM.Notifications(EHM.CHAR_COLORS.red, ...)
end

local function IsItemAdded(itemID)
    if not EHM_DB or not EHM_DB.USED_ITEM then return false end
    for _, id in ipairs(EHM_DB.USED_ITEM) do
        if id == itemID then return true end
    end
    return false
end

local function GetPlayerHonor()
    local honorPoints = 0
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(EHM.HONOR_INDEX)
    if currencyInfo then honorPoints = currencyInfo.quantity or 0 end
    return honorPoints
end

local function GetMerchantItemID(merchantIndex)
    local link = GetMerchantItemLink(merchantIndex)
    if not link then return nil end
    local itemID = tonumber(link:match("item:(%d+):"))
    return itemID
end

local function GetAllMapIds()
    for _, continent in ipairs(C_Map.GetMapChildrenInfo(946, 2)) do
        print(continent.name, continent.mapID)
    end
end
-- Ex:
-- local sortedItems = GetItemsSortedByPrice(EHM.Items, false) -- false = ascending
-- or
-- local sortedItemsDesc = GetItemsSortedByPrice(EHM.Items, true) -- true = descending

local function GetItemsSortedByPrice(itemsTable, field, descending)
    local sortDirection = descending or false
    local field = field or "price"

    -- Step 1: Copy items into a new list
    local sortedList = {}
    for _, item in pairs(itemsTable) do
        table.insert(sortedList, item)
    end

    -- Step 2: Sort the copied list
    table.sort(sortedList, function(a, b)
        if sortDirection then
            return a[field] > b[field]
        else
            return a[field] < b[field]
        end
    end)

    return sortedList
end

local function SetUsedItem(itemID)
    EHM_DB.USED_ITEM = EHM.Items[itemID]
    
    -- Update all views that depend on USED_ITEM
    if EHM.EHM_SideBarViews and EHM.EHM_SideBarViews[EHM.SidebarNavigation.items.key] then
        EHM.EHM_SideBarViews[EHM.SidebarNavigation.items.key]:ShowItems()
    end
    if EHM_HonorVendor and EHM_HonorVendor:IsShown() then
        EHM_HonorVendor:BuildPopup()
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

-- Run scripts after addon is loaded to avoid leak of memory
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "EasyHonorMoneyDev" then  -- use your actual AddOn name here
        if EHM.EHM_SideBarViews and EHM.EHM_SideBarViews[EHM.SidebarNavigation.items.key] then
            EHM.EHM_SideBarViews[EHM.SidebarNavigation.items.key]:ShowItems()
        end
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

function EHM.HasItemInBags(itemID)
    for bag = 0, NUM_BAG_SLOTS do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local item = C_Container.GetContainerItemLink(bag, slot)
            if item and item:find("item:" .. itemID) then
                return true
            end
        end
    end
    return false
end
function EHM.GetRealTimePriceItem(itemID)
    local itemName, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(itemID)
    if vendorPrice then
        return vendorPrice -- in copper (1g = 10000)
    else
        print("Item not cached:", itemID)
        return 0
    end
end

function EHM.GetRealTimeHonorCostForItem(itemID)
    for i = 1, GetMerchantNumItems() do
        local link = GetMerchantItemLink(i)
        if link then
            local id = tonumber(link:match("item:(%d+):"))
            if id == itemID then
                local costInfoCount = GetMerchantItemCostInfo(i)
                for j = 1, costInfoCount do
                    local texture, amount, currencyLink, quality = GetMerchantItemCostItem(i, j)

                    local currencyID = tonumber(currencyLink and currencyLink:match("currency:(%d+)"))
                    if currencyID == EHM.HONOR_INDEX then
                        return amount
                    end
                end
            end
        end
    end
    return nil
end

function EHM.SplitMoney(copper)
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copperOnly = copper % 100
    return gold, silver, copperOnly
end


EHM.DUMP = DumpTable
EHM.CreateLoadingFunction = CreateLoadingFunction
EHM.GetProgressBar = GetProgressBar
EHM.FormatGoldString = FormatGoldString
EHM.FormatGoldWithIcons = FormatGoldWithIcons
EHM.GetHonorIcon = GetHonorIcon
EHM.CreateHonorIcon = CreateHonorIcon
EHM.GetFactionIcon = GetFactionIcon
EHM.GetFreeBagSlots = GetFreeBagSlots
EHM.IsItemAdded = IsItemAdded
EHM.GetPlayerHonor = GetPlayerHonor
EHM.GetMerchantItemID = GetMerchantItemID
EHM.GetItemsSortedByPrice = GetItemsSortedByPrice
EHM.SetUsedItem = SetUsedItem

EHM.RegisterSlashCommand(
    EHM.COMMANDS.LIST.key .. "1",
    EHM.COMMANDS.LIST.register
)
SlashCmdList[EHM.COMMANDS.LIST.key] = function()
    if not EHM_DB or not EHM_DB.USED_ITEM then
        EHM.Notifications(EHM.CHAR_COLORS.lightBlue, "No items in DB.")
        return
    end

    EHM.Notifications(EHM.CHAR_COLORS.lightBlue, "EHM_DB Items:")
    for i, id in ipairs(EHM_DB.USED_ITEM) do
        local name = GetItemInfo(id) or "Unknown"
        print(i .. ". " .. name .. " (ID: " .. id .. ")")
    end
end