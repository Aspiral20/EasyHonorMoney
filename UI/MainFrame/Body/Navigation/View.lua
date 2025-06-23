EHM.SidebarNavigation = {
    items = {
        key = "items",
        label = "Items",
        order = 1,
        title = "Available Items",
    },
    merchants = {
        key = "merchants",
        label = "Vendors",
        order = 2,
        title = "Available Vendors",
    },
}

local function ShowView(viewName)
    for name, frame in pairs(EHM.EHM_SideBarViews) do
        frame:SetShown(name == viewName)

        print(name, frame)

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