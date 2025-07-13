-- Frame to listen for merchant close
local MerchantEventFrame = CreateFrame("Frame")
MerchantEventFrame:RegisterEvent("MERCHANT_CLOSED")
EHM.MerchantEventFrame = MerchantEventFrame
EHM.MerchantEventFrame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_CLOSED" then
        EHM.IsClosedMerchant = true
        EHM.LOADERS.buy = false
        EHM.LOADERS.equip = false
        EHM.LOADERS.sell = false
        EHM.LOADERS.autoBSE = false
    end
end)