function EHM.AddonButton(parent, text, width, height, onClickFunc)
    local borderIns = 1
    -- Base colors
    local borderColor   = {0.1, 0.1, 0.1, 1}
    local normalColor   = {0, 0, 0, EHM.BTN_BACKGROUND_OPACITY}
    local hoverColor    = {0.3, 0.3, 0.3, 0.7}
    local pressedColor  = {0.2, 0.2, 0.2, 0.7}

    local textColor = {1, 0.82, 0}
    local disabledTextColor = {0.6, 0.5, 0}

    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width or 80, height or 24)

    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    btn.text:SetPoint("CENTER", btn, "CENTER")
    btn.text:SetText(text or "Button")
    btn.text:SetTextColor(unpack(textColor))

    -- Background color (optional)
    btn:SetBackdrop({
        -- bgFile = EHM.BACKGROUND_POPUP,
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        insets = { left = borderIns, right = borderIns, top = borderIns, bottom = borderIns }
    })

    btn:SetBackdropColor(unpack(normalColor))
    btn:SetBackdropBorderColor(unpack(borderColor)) -- Subtle border

    btn.isPressed = false

    -- Mouse enter = highlight
    btn:SetScript("OnEnter", function(self)
        if self.isPressed then
            self:SetBackdropColor(unpack(pressedColor))
        else
            self:SetBackdropColor(unpack(hoverColor))
        end
    end)

    -- Mouse leave = reset (but also cancel "pressed" if holding mouse)
    btn:SetScript("OnLeave", function(self)
        if not self.isPressed then
            self:SetBackdropColor(unpack(normalColor))
        end
        -- else: don't change the color, keep it pressed
    end)

    -- Mouse down = pressed effect
    btn:SetScript("OnMouseDown", function(self)
        self.isPressed = true
        self:SetBackdropColor(unpack(pressedColor))
    end)

    -- Mouse up = return to hover if mouse is still over, or normal
    btn:SetScript("OnMouseUp", function(self)
        self.isPressed = false
        if self:IsMouseOver() then
            self:SetBackdropColor(unpack(hoverColor))
        else
            self:SetBackdropColor(unpack(normalColor))
        end
    end)

    -- Click handler
    if onClickFunc then
        btn:SetScript("OnClick", onClickFunc)
    end

    function btn:SetDisabled(disabled)
        if disabled then
            self:Disable()
            self.text:SetTextColor(unpack(disabledTextColor))
            self:SetBackdropColor(0.2, 0.2, 0.2, 0.3)
            self:SetScript("OnEnter", nil)
            self:SetScript("OnLeave", nil)
            self:SetScript("OnMouseDown", nil)
            self:SetScript("OnMouseUp", nil)
        else
            self:Enable()
            self.text:SetTextColor(unpack(textColor))
            self:SetBackdropColor(unpack(normalColor))
            -- Re-apply scripts
            self:SetScript("OnEnter", function(self)
                if self.isPressed then
                    self:SetBackdropColor(unpack(pressedColor))
                else
                    self:SetBackdropColor(unpack(hoverColor))
                end
            end)
            self:SetScript("OnLeave", function(self)
                if not self.isPressed then
                    self:SetBackdropColor(unpack(normalColor))
                end
            end)
            self:SetScript("OnMouseDown", function(self)
                self.isPressed = true
                self:SetBackdropColor(unpack(pressedColor))
            end)
            self:SetScript("OnMouseUp", function(self)
                self.isPressed = false
                if self:IsMouseOver() then
                    self:SetBackdropColor(unpack(hoverColor))
                else
                    self:SetBackdropColor(unpack(normalColor))
                end
            end)
        end
    end

    return btn
end
