-- button:SetBackdrop({
--   bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
--   edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
--   tile = true, tileSize = 16, edgeSize = 16,
--   insets = { left = 4, right = 4, top = 4, bottom = 4 }
-- })
-- button:SetBackdropColor(0, 0.5, 0.5, 0.8)

function EHM:CreateButton(name, parent, width, height, text, onClick, opts)
    local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    button:SetSize(width or 120, height or 30)
    button:SetText(text or "Click")

    if onClick then
        button:SetScript("OnClick", onClick)
    end

    button.isLoading = false

    button:SetScript("OnClick", function(self)
        if self.isLoading then return end
        self.isLoading = true

        local success, err = pcall(onClick, self)

        if not success then
            print("Error:", err)
        end

        self.isLoading = false
    end)



    -- Optional: tooltip
    button.tooltip = opts and opts.tooltip or ""
    button:SetScript("OnEnter", function(self)
        if self.tooltip ~= "" then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(self.tooltip, 1, 1, 1)
            GameTooltip:Show()
        end
    end)
    button:SetScript("OnLeave", GameTooltip_Hide)

    -- Optional: font color
    if opts and opts.textColor then
        local r, g, b = unpack(opts.textColor)
        button:GetFontString():SetTextColor(r, g, b)
    end

    -- Optional: background color
    if opts and opts.bgColor then
        local r, g, b = unpack(opts.bgColor)
        button:SetNormalTexture(nil) -- remove default texture
        local tex = button:CreateTexture(nil, "BACKGROUND")
        tex:SetAllPoints()
        tex:SetColorTexture(r, g, b, 1)
        button.tex = tex
    end

    return button
end
