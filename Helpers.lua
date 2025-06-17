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
            print("Action already in progress...")
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

EHM.DUMP = DumpTable
EHM.CreateLoadingFunction = CreateLoadingFunction
EHM.GetProgressBar = GetProgressBar
EHM.FormatGoldString = FormatGoldString