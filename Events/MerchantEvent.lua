-- Frame to listen for merchant close
local MerchantEventFrame = CreateFrame("Frame")
MerchantEventFrame:RegisterEvent("MERCHANT_CLOSED")
-- MerchantEventFrame:SetScript("OnEvent", function(self, event)
--     if event == "MERCHANT_CLOSED" then
--         isCancelled = true
--     end
-- end)

EHM.MerchantEventFrame = MerchantEventFrame