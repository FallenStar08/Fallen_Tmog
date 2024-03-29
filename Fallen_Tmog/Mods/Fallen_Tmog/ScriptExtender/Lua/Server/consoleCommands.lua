local function uninstall()
    BasicPrint("uninstall() - Deleting all mod items for the mod 'cosmetic slots'")
    local itemsToDelete = {}
    for item, _ in pairs(ModItemRoots) do
        itemsToDelete[#itemsToDelete + 1] = item
    end
    for _, member in pairs(GetEveryoneThatIsRelevant()) do
        local result = DeepIterateInventory(_GE(member), { FilterByTemplate(itemsToDelete) })
        for uuid, item in pairs(result) do
            if Osi.IsContainer(uuid) == 1 then
                BasicPrint("uninstall() - This is a container OwO we need to get stuff out of it just in case OwO")
                local thingsToGetOut = DeepIterateInventory(_GE(uuid))
                for thinguuid, _ in pairs(thingsToGetOut) do
                    Osi.TeleportTo(thinguuid, member)
                end
                DelayedCall(200, function() Osi.RequestDelete(uuid) end)
            else
                Osi.RequestDelete(uuid)
            end
        end
    end
    BasicPrint("uninstall() - Done OwO")
end

local function nukeAllVars()
    BasicPrint("nukeAllVars() - Nuking all the damn vars the mod 'cosmetic slots'")
    local modVars = GetModVariables()
    for var, data in pairs(modVars) do
        BasicPrint(var)
        modVars[var] = nil
    end
    SyncModVariables()

    local allEntities = Ext.Entity.GetAllEntitiesWithComponent("ServerItem")
    for _, entity in pairs(allEntities) do
        if entity.Vars then
            for _, varName in pairs(UserVars) do
                entity.Vars[varName] = nil
            end
            SyncUserVariables()
        end
    end
    BasicPrint("nukeAllVars() - Done OwO")
end

local function giveModItems()
    BasicPrint("giveModItems() - Giving mod items for the mod 'cosmetic slots' to the selected character")
    for key, item in pairs(ModItemRoots) do
        Osi.TemplateAddTo(key, Osi.GetHostCharacter(), 1)
    end
    BasicPrint("giveModItems() - Done OwO")
end

Ext.RegisterConsoleCommand("fallen_uninstall_cslot", uninstall)
Ext.RegisterConsoleCommand("fallen_give_cslot_items", giveModItems)
Ext.RegisterConsoleCommand("fallen_nuke_cslot_vars", nukeAllVars)
