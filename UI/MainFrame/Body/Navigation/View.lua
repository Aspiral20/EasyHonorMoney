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
    end
end
ShowView(EHM.SidebarNavigation.items.key)

EHM.ShowView = ShowView