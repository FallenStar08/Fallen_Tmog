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
                    if (ArmorSlots[equipmentSlot]) then
                        BasicDebug("Armor Tmog for Slot : " .. tostring(equipmentSlot))
                        local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
                        if correspondingEquipment then
                            TransmogArmorUltimateVersion(GUID(item), (GUID(correspondingEquipment)), bagOwnerUUID)
                        end
                        SaveArmorSkinInfoOnCharacter(bagOwnerUUID, item, equipmentSlot)
                    end
                end
            end
        end
    elseif modItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "weaponBag" then
        BasicDebug("ENGAGING MOGGING OF WEAPON")
        local bagEntity = _GE(inventoryHolder)
        if bagEntity then
            local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
            local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
            local itemEntity = _GE(item)
            if itemEntity and itemEntity.Equipable then
                local equipmentSlot = itemEntity.Equipable.Slot
                if bagOwnerUUID then
                    if WeaponSlots[equipmentSlot] then
                        BasicDebug("Weapon Tmog for Slot : " .. tostring(equipmentSlot))
                        local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID,
                            tostring(WeaponSlots[equipmentSlot]))
                        if correspondingEquipment then
                            TransmogWeapon(correspondingEquipment, item, bagOwnerUUID)
                        else
                            SaveWeaponInfosToPvars(itemEntity, GUID(bagOwnerUUID), equipmentSlot)
                        end
                    end
                    return
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
                local modVars=GetModVariables()
                modVars=modVars.Fallen_TmogInfos
                local equipmentSlot = itemEntity.Equipable.Slot
                if bagOwnerUUID and ArmorSlots[equipmentSlot] and (modVars and modVars[bagOwnerUUID] and modVars[bagOwnerUUID][equipmentSlot] and GUID(item)==modVars[bagOwnerUUID][equipmentSlot].skin) then
                    BasicDebug("Removed Armor from bag for Slot : " .. tostring(equipmentSlot))
                    local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
                    if correspondingEquipment and _GE(correspondingEquipment).Vars.Fallen_TmogArmorInfos and _GE(correspondingEquipment).Vars.Fallen_TmogArmorInfos.parentItem then
                        BasicDebug("Restoring Equipped Piece's visuals")
                        RestoreOldArmor(correspondingEquipment, item, bagOwnerUUID, true)  --TransmogArmor(GUID(item), GUID(correspondingEquipment), bagOwnerUUID)
                    end
                    RemoveArmorSkinInfoOnCharacter(bagOwnerUUID, item, equipmentSlot)
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
                    BasicDebug("Removed Weapon from bag for Slot : " .. tostring(equipmentSlot))
                    local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID,
                        tostring(WeaponSlots[equipmentSlot]))
                    if correspondingEquipment then
                        BasicDebug("Restoring Equipped Piece's visuals")
                        --TransmogArmor(GUID(item), GUID(correspondingEquipment), bagOwnerUUID)
                        RestoreOriginalStateForItem(_GE(correspondingEquipment))
                    end
                    PersistentVars.Tmoggeds[GUID(bagOwnerUUID)][equipmentSlot] = nil
                end
            end
        end
    end
end)

--TODO FIX INFINITE EQUIP LOOP
Ext.Osiris.RegisterListener("Equipped", 2, "before", function(item, character)
    local itemEntity = _GE(item)
    if itemEntity then
        local equipmentSlot = tostring(itemEntity.Equipable.Slot)
        if ArmorSlots[equipmentSlot] then
            local modVars = GetModVariables()
            if modVars and modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[GUID(character)] and modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot] then
                BasicDebug(itemEntity.Vars.Fallen_TmogArmorInfos)
                if not itemEntity.Vars.Fallen_TmogArmorInfos then itemEntity.Vars.Fallen_TmogArmorInfos = {} end
                if not itemEntity.Vars.Fallen_TmogArmorInfos.parentItem then
                    local skinToApply = modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot].skin
                    BasicDebug("skinToApply : " .. skinToApply)
                    --local correspondingEquipment = Osi.GetEquippedItem(character, tostring(equipmentSlot))
                    TransmogArmorUltimateVersion(skinToApply, GUID(item), character)
                end
            end
            --Weapon shit
        elseif WeaponSlots[equipmentSlot] and PersistentVars.Tmoggeds and PersistentVars.Tmoggeds[GUID(character)] then
            if PersistentVars.Tmoggeds[GUID(character)][equipmentSlot] then
                BasicDebug("EQUIPPED ARMOR IN SLOT : " .. equipmentSlot)
                BasicDebug("Pvars for character & slot : ")
                BasicDebug(PersistentVars.Tmoggeds[GUID(character)][equipmentSlot])
                ApplyMoggedToItemFromPvar(itemEntity, GUID(character), equipmentSlot)
            end
        end
    end
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "before", function(item, character)
    local itemEntity = _GE(item)
    if itemEntity.Vars.Fallen_OriginalWeaponInfos then
        RestoreOriginalStateForItem(itemEntity)
    elseif itemEntity.Vars.Fallen_TmogArmorInfos and itemEntity.Vars.Fallen_TmogArmorInfos.parentItem then
        BasicDebug("Uniequip restoring old armor")
        RestoreOldArmor(item, itemEntity.Vars.Fallen_TmogArmorInfos.skinItem, character, false)
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, iseditor)
    RestoreMoggedItems()
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
