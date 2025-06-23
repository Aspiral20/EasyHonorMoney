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
    if g > 0 then out = out .. g .. "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t " end
    if s > 0 or (g > 0 and c > 0) then out = out .. s .. "|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t " end
    if c > 0 or (g == 0 and s == 0) then out = out .. c .. "|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t" end
    return out
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

local function IsItemAdded(itemID)
    if not EHM_DB or not EHM_DB.USED_ITEM then return false end
    for _, id in ipairs(EHM_DB.USED_ITEM) do
        if id == itemID then return true end
    end
    return false
end

local function GetPlayerHonor()
    local honorPoints = 0
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(390) -- Honor ID
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

local function GetItemsSortedByPrice(itemsTable, descending)
    local sortDirection = descending or false

    -- Step 1: Copy items into a new list
    local sortedList = {}
    for _, item in pairs(itemsTable) do
        table.insert(sortedList, item)
    end

    -- Step 2: Sort the copied list
    table.sort(sortedList, function(a, b)
        if sortDirection then
            return a.price > b.price
        else
            return a.price < b.price
        end
    end)

    return sortedList
end

function SetUsedItem(itemID)
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

EHM.DUMP = DumpTable
EHM.CreateLoadingFunction = CreateLoadingFunction
EHM.GetProgressBar = GetProgressBar
EHM.FormatGoldString = FormatGoldString
EHM.FormatGoldWithIcons = FormatGoldWithIcons
EHM.GetFreeBagSlots = GetFreeBagSlots
EHM.IsItemAdded = IsItemAdded
EHM.GetPlayerHonor = GetPlayerHonor
EHM.GetMerchantItemID = GetMerchantItemID
EHM.GetItemsSortedByPrice = GetItemsSortedByPrice
EHM.SetUsedItem = SetUsedItem

EHM.RegisterSlashCommand(
    EHM.COMMANDS.LIST.key,
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