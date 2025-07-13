-- Logic
function debugPrint(...)
    if not EHM.DEBUG_MODE then return end
    local msg = "|cff999999[EHM DEBUG]|r " .. string.format(...)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

EHM.debugPrint = debugPrint

function switchDebugPrint(msg)
    EHM.DEBUG_MODE = not EHM.DEBUG_MODE
    local status = EHM.DEBUG_MODE and "enabled" or "disabled"
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[EHM]|r Debug mode " .. status)
end

-- Command
EHM.RegisterSlashCommand(
    EHM.COMMANDS.DEBUG.key .. "1",
    EHM.COMMANDS.DEBUG.register
)
SlashCmdList[EHM.COMMANDS.DEBUG.key] = switchDebugPrint