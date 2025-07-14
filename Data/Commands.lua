-- Output command Example: { registered = "/ehm-debug", key = "ehm-debug" }
local function ParseCommand(cmd)
    if type(cmd) ~= "string" then return nil end
    local key = cmd
    if cmd:sub(1,1) == "/" then
        key = cmd:sub(2)
    end
    return { register = cmd, key = key }
end

EHM.COMMANDS = {
    DEBUG = ParseCommand("/ehm-debug"),
    LIST = ParseCommand("/ehm-list"),
    UI = {
        key = "ehm",
        UI1 = ParseCommand("/easy-honor-money"),
        UI2 = ParseCommand("/EHM"),
        UI3 = ParseCommand("/ehm"),
    },
    BUY = {
        key = "ehm_b",
        B1 = ParseCommand("/easy-honor-money_buy"),
        B2 = ParseCommand("/EHM_B"),
        B3 = ParseCommand("/ehm_b"),
    },
    EQUIP = {
        key = "ehm_e",
        E1 = ParseCommand("/easy-honor-money_equip"),
        E2 = ParseCommand("/EHM_E"),
        E3 = ParseCommand("/ehm_e"),
    },
    SELL = {
        key = "ehm_s",
        S1 = ParseCommand("/easy-honor-money_sell"),
        S2 = ParseCommand("/EHM_S"),
        S3 = ParseCommand("/ehm_s"),
    },
    AUTO = {
        key = "ehm_auto",
        A1 = ParseCommand("/easy-honor-money_auto"),
        A2 = ParseCommand("/EHM_AUTO"),
        A3 = ParseCommand("/ehm_auto"),
    },
    VENDOR_STATISTIC = ParseCommand("/ehm_vstat_chat")
}

local function RegisterSlashCommand(key, register)
    local cmd = register
    if cmd and key then
        _G["SLASH_" .. key] = cmd
    end
end

EHM.RegisterSlashCommand = RegisterSlashCommand