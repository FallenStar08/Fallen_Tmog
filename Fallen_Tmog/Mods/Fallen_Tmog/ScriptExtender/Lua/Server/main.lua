local modItemRoots = {
    ["ee9d149e-4558-4583-86f2-bd3dc01a034a"] = "armorBag",
    ["7c515100-55f6-4dde-b46a-78099db32ace"] = "weaponBag"
}



ArmorSlots = {
    ["Breast"] = true,
    ["Boots"] = true,
    ["Cloak"] = true,
    ["Gloves"] = true,
    ["Helmet"] = true,
    ["Underwear"] = true,
    ["VanityBody"] = true,
    ["VanityBoots"] = true,
    ["Shield"] = true,
}



WeaponSlots = {
    ["MeleeMainHand"] = "Melee Main Weapon",
    ["MeleeOffHand"] = "Melee Offhand Weapon",
    ["RangedMainHand"] = "Ranged Main Weapon",
    ["RangedOffHand"] = "Ranged Offhand Weapon",
}



Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(root, item, inventoryHolder, addType)
    if modItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "armorBag" then
        local bagEntity = _GE(inventoryHolder)
        if bagEntity then
            local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
            local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
            local itemEntity = _GE(item)
            if itemEntity and itemEntity.Equipable then
                local equipmentSlot = itemEntity.Equipable.Slot
                if bagOwnerUUID then
                    if ArmorSlots[equipmentSlot] then
                        BasicPrint("Armor Tmog for Slot : " .. tostring(equipmentSlot))
                        local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
                        if correspondingEquipment then
                            BasicPrint(string.format("Applying the skin of : %s on item : %s", GetTranslatedName(item),
                                GetTranslatedName(correspondingEquipment)))
                            TransmogArmorUltimateVersion(GUID(item), (GUID(correspondingEquipment)), bagOwnerUUID)
                        end
                        SaveArmorInfosToModVars(GUID(item), bagOwnerUUID, equipmentSlot)
                    end
                end
            end
        end
    elseif modItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "weaponBag" then
        local bagEntity = _GE(inventoryHolder)
        if bagEntity then
            local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
            local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
            local itemEntity = _GE(item)
            if itemEntity and itemEntity.Equipable then
                local equipmentSlot = itemEntity.Equipable.Slot
                if bagOwnerUUID then
                    if WeaponSlots[equipmentSlot] then
                        BasicPrint("Weapon Tmog for Slot : " .. tostring(equipmentSlot))
                        local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID,
                            tostring(WeaponSlots[equipmentSlot]))
                        if correspondingEquipment then
                            BasicPrint(string.format("Applying the skin of : %s on item : %s", GetTranslatedName(item),
                                GetTranslatedName(correspondingEquipment)))
                            TransmogWeapon(correspondingEquipment, item, bagOwnerUUID)
                        end
                        SaveWeaponInfosToModVars(itemEntity, GUID(bagOwnerUUID), equipmentSlot)
                    end
                end
            end
        end
    end
end)

Ext.Osiris.RegisterListener("RemovedFrom", 2, "after", function(item, inventoryHolder)
    inventoryHolder = GUID(inventoryHolder)
    if modItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "armorBag" then
        local bagEntity = _GE(inventoryHolder)
        if bagEntity then
            local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
            local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
            local itemEntity = _GE(item)
            if itemEntity and itemEntity.Equipable then
                local modVars = GetModVariables()
                local equipmentSlot = itemEntity.Equipable.Slot
                if bagOwnerUUID and ArmorSlots[equipmentSlot] and (modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[bagOwnerUUID] and modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot] and GUID(item) == modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot]) then
                    BasicPrint(string.format("Removed Armor : %s from bag for Slot : %s", GetTranslatedName(item),
                        tostring(equipmentSlot)))
                    modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot] = nil
                    SyncModVariables()
                end
            end
        end
    elseif modItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "weaponBag" then
        local bagEntity = _GE(inventoryHolder)
        if bagEntity then
            local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
            local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
            local itemEntity = _GE(item)
            if itemEntity and itemEntity.Equipable then
                local equipmentSlot = itemEntity.Equipable.Slot
                if bagOwnerUUID and WeaponSlots[equipmentSlot] then
                    local modVars = GetModVariables()
                    BasicPrint("Removed Weapon from bag for Slot : " .. tostring(equipmentSlot))
                    local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID,
                        tostring(WeaponSlots[equipmentSlot]))
                    if correspondingEquipment then
                        BasicPrint("Restoring Equipped Piece's visuals")
                        --TransmogArmor(GUID(item), GUID(correspondingEquipment), bagOwnerUUID)
                        RestoreOriginalWeaponVisuals(_GE(correspondingEquipment))
                        RefreshCharacterArmorVisuals(bagOwnerEntity)
                    end
                    modVars.Fallen_TmogInfos[GUID(bagOwnerUUID)][equipmentSlot] = nil
                    SyncModVariables()
                end
            end
        end
    end
end)

--TODO USE TEMPLATES INSTEAD!!!!
Ext.Osiris.RegisterListener("Equipped", 2, "before", function(item, character)
    local itemEntity = _GE(item)
    if itemEntity then
        local modVars = GetModVariables()
        local equipmentSlot = tostring(itemEntity.Equipable.Slot)
        if ArmorSlots[equipmentSlot] then
            if modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[GUID(character)] and modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot] then
                --BasicPrint(itemEntity.Vars.Fallen_TmogArmorInfos)
                local skinToApply = modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot]
                BasicPrint(string.format("Equipped() Applying the skin of : %s on item : %s from modVars!",
                    GetTranslatedName(skinToApply), GetTranslatedName(item)))
                TransmogArmorUltimateVersion(skinToApply, GUID(item), character)
            end
        elseif WeaponSlots[equipmentSlot] then
            if modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[GUID(character)] and modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot] then
                local skinToApply = modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot]
                BasicPrint(string.format("Equipped() Applying the skin of : %s on item : %s from modVars!",
                    GetTranslatedName(skinToApply), GetTranslatedName(item)))
                TransmogWeapon(item, skinToApply, character)
            end
        end
    end
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "before", function(item, character)
    local itemEntity = _GE(item)
    if itemEntity.Vars.Fallen_OriginalWeaponInfos then
        BasicPrint("Unequip restoring original weapon visuals")
        RestoreOriginalWeaponVisuals(itemEntity)
        RefreshCharacterArmorVisuals(_GE(character))
    elseif itemEntity.Vars.Fallen_TmogArmorOriginalVisuals then
        BasicPrint("Unequip restoring original armor visuals")
        RestoreOriginalArmorVisuals(itemEntity)
        RefreshCharacterArmorVisuals(_GE(character))
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, iseditor)
    RestoreMoggedWeapons()
    RestoreMoggedArmors()
    for _, player in pairs(GetSquadies()) do
        for item, name in pairs(modItemRoots) do
            if not HasItemTemplate(player, item) then
                Osi.TemplateAddTo(item, player, 1, 1)
            end
        end
    end
end)

Ext.Events.ResetCompleted:Subscribe(function()
end)
