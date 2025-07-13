local panel = CreateFrame("Frame", "EasyHonorMoneyOptionsPanel", UIParent)

panel.name = EHM.ADDON_NAME or "EasyHonorMoney"

-- Title
local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(panel.name)

-- Description
local desc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
desc:SetText("Click the button below to open the addon UI manually.")

-- Button
local openBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
openBtn:SetSize(180, 26)
openBtn:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -12)
openBtn:SetText("Open EasyHonorMoney")

openBtn:SetScript("OnClick", function()
    if EHM_MainFrame then
        if EHM_MainFrame:IsShown() then
            EHM_MainFrame:Hide()
        else
            EHM_MainFrame:Show()
        end
    else
        print("|cffff0000EasyHonorMoney UI not found!|r")
    end
end)

-- Register in Interface > AddOns
if SettingsPanel and SettingsPanel.AddCategory then
    SettingsPanel:AddCategory(panel)
elseif InterfaceOptionsFrameCategories then
    -- Legacy fallback for Classic/MoP
    panel.default = function() end -- Optional default handler
    panel.okay = function() end    -- Optional okay handler
    panel.cancel = function() end  -- Optional cancel handler
    table.insert(INTERFACEOPTIONS_ADDONCATEGORIES, panel)
end


