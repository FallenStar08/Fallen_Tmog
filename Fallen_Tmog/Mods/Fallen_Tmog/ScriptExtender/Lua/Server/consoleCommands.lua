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
                BasicDebug("uninstall() - This is a container OwO we need to get stuff out of it just in case OwO")
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
end

local function giveModItems()
    for key,item in pairs(ModItemRoots) do
        Osi.TemplateAddTo(item,Osi.GetHostCharacter(),1)
    end
end

Ext.RegisterConsoleCommand("fallen_uninstall_cslot", uninstall)
Ext.RegisterConsoleCommand("fallen_give_cslot_items", giveModItems)