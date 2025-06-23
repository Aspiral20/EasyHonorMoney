local honorIconPath = "Interface\\PVPFrame\\PVP-Currency-Honor"

local function GetCustomItemInfo(itemID)
    local name, link, rarity, level, minLevel, type, subType,
          stackCount, equipLoc, icon, vendorPrice = GetItemInfo(itemID)

    if not name then
        C_Item.RequestLoadItemDataByID(itemID)
        return nil -- Wait for data to load
    end

    return {
        name = name,
        link = link,
        texture = icon,
        price = vendorPrice,
        quantity = stackCount,
        isUsable = IsUsableSpell(name), -- Approximation
        isPurchasable = true, -- Assume true unless you're checking specific logic
        sellPrice = vendorPrice,
        itemID = itemID,
    }
end



function EHM.ItemButtonFactory(itemID, itemData, parentFrame, onClick)
    if not itemID or not itemData then return end

    local playerHonor = EHM.GetPlayerHonor()
    local btnSize = 44
    local canAfford = playerHonor >= itemData.price

    local btn = CreateFrame("Button", "EHM_HonorItemBtn"..itemID, parentFrame, "SecureActionButtonTemplate")
    btn:SetSize(btnSize, btnSize)
    btn:SetNormalTexture(GetItemIcon(itemID))
    btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    btn:GetNormalTexture():SetDesaturated(not canAfford)

    -- Border
    if not btn.border then
        btn.border = CreateFrame("Frame", nil, btn, BackdropTemplateMixin and "BackdropTemplate" or nil)
        btn.border:SetPoint("TOPLEFT", btn, "TOPLEFT", -2, 2)
        btn.border:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 2, -2)
        btn.border:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 2 })
        btn.border:SetBackdropColor(0, 0, 0, 0)
    end

    if EHM_DB and EHM_DB.USED_ITEM and EHM_DB.USED_ITEM.index == itemID then
        btn.border:SetBackdropBorderColor(0, 1, 0, 1) -- Green
    else
        btn.border:SetBackdropBorderColor(0, 0, 0, 0) -- Transparent
    end
    btn.border:Show()

    -- Click handler
    btn:SetScript("OnClick", function()
        if not canAfford or EHM.Utils.IsItemAdded(itemID) then return end
        EHM_DB.USED_ITEM = itemData
        if onClick then onClick(btn) end
    end)

    -- Price Text
    if not btn.priceText then
        btn.priceText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btn.priceText:SetPoint("TOP", btn, "BOTTOM", -8, -8)
    end
    btn.priceText:SetText(itemData.price)
    btn.priceText:SetTextColor(canAfford and 1 or 0, canAfford and 1 or 0, canAfford and 1 or 0)

    -- Honor Icon
    if not btn.honorIcon then
        btn.honorIcon = btn:CreateTexture(nil, "OVERLAY")
        btn.honorIcon:SetSize(14, 14)
        btn.honorIcon:SetPoint("LEFT", btn.priceText, "RIGHT", 2, 0)
        btn.honorIcon:SetTexture(honorIconPath)
    end
    btn.honorIcon:SetShown(true)

    -- Info Icon
    if not btn.infoIcon then
        btn.infoIcon = btn:CreateTexture(nil, "OVERLAY")
        btn.infoIcon:SetSize(14, 14)
        btn.infoIcon:SetPoint("RIGHT", btn, "RIGHT", 6, -6)
        btn.infoIcon:SetTexture("Interface\\COMMON\\help-i")
    end
    btn.infoIcon:SetShown(true)

    -- Tooltip
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:ClearLines()
        if itemData.money and itemData.price > 0 then
            local count = math.floor(playerHonor / itemData.price)
            local totalCopper = count * (
                (itemData.money.gold or 0) * 10000 +
                (itemData.money.silver or 0) * 100 +
                (itemData.money.copper or 0)
            )
            local g = math.floor(totalCopper / 10000)
            local s = math.floor((totalCopper % 10000) / 100)
            local c = totalCopper % 100
            local honorIcon = "|T" .. honorIconPath .. ":14:14:0:0|t"
            GameTooltip:AddLine(itemData.name, 1, 1, 1)
            GameTooltip:AddLine(string.format("x%d = %s / 4k%s", count, EHM.FormatGoldWithIcons(g, s, c), honorIcon), 1, 0.82, 0)
        else
            GameTooltip:AddLine("No sell value info available", 1, 0, 0)
        end
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    return btn
end

EHM.GetCustomItemInfo = GetCustomItemInfo