local function CreateActionButtons(frame, actionBtns, x, y, spacing, callback)
    if not frame.content then
        frame.content = CreateFrame("Frame", nil, frame)
        frame.content:SetAllPoints()
    else
        frame.content:Show()
    end

    if not frame.actionButtons then
        frame.actionButtons = {}

        local actionButtons = actionBtns or {
            { name = "Equip", command = function() SlashCmdList[EHM.COMMANDS.EQUIP.key]("") end },
            { name = "Sell",  command = function() SlashCmdList[EHM.COMMANDS.SELL.key]("") end },
        }

        local startX = x or 15
        local startY = y or -39
        local spacingBetween = spacing or 75

        -- Create buttons once
        for i, data in ipairs(actionButtons) do
            local btn = EHM.AddonButton(frame.content, data.name, 65, 24, data.command)
            btn:SetPoint("TOPLEFT", frame.content, "TOPLEFT", startX + (i - 1) * spacingBetween, startY)
            frame.actionButtons[#frame.actionButtons + 1] = btn
        end
        
        if callback and type(callback) == "function" then
            callback(frame, frame.actionButtons)
        end
    end
end

EHM.CreateActionButtons = CreateActionButtons