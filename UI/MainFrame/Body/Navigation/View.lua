EHM.SidebarNavigation = {
    items = {
        key = "items",
        label = "Items",
        order = 1,
        title = "Available Items",
    },
    merchants = {
        key = "merchants",
        label = "Merchants",
        order = 2,
        title = "Available Merchants",
    },
    item_check = {
        key = "item_check",
        label = "Check Item",
        order = 3,
        title = "Check Item",
    },
}

local function ShowView(viewName)
    for name, frame in pairs(EHM.EHM_SideBarViews) do
        frame:SetShown(name == viewName)

        if name == viewName then
            if viewName == EHM.SidebarNavigation.items.key and frame.ShowItems then
                frame:ShowItems()
            elseif viewName == EHM.SidebarNavigation.merchants.key and frame.ShowMerchants then
                frame:ShowMerchants()
            end
        end
    end
end

-- ShowView(EHM.SidebarNavigation.items.key)

EHM.ShowView = ShowView