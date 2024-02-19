local modItemRoots = {
    ["ee9d149e-4558-4583-86f2-bd3dc01a034a"] = "armorBag",
    ["7c515100-55f6-4dde-b46a-78099db32ace"] = "weaponBag"
}



ArmorSlots = {
    ["Breast"] = "Breast",
    ["Boots"] = "Boots",
    ["Cloak"] = "Cloak",
    ["Gloves"] = "Gloves",
    ["Helmet"] = "Helmet",
    ["Underwear"] = "Underwear",
    ["VanityBody"] = "Breast",
    ["VanityBoots"] = "Boots",
    ["Shield"] = "Shield", --For some reason?
}



WeaponSlots = {
    ["MeleeMainHand"] = "Melee Main Weapon",
    ["MeleeOffHand"] = "Melee Offhand Weapon",
    ["RangedMainHand"] = "Ranged Main Weapon",
    ["RangedOffHand"] = "Ranged Offhand Weapon",
}



Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(root, item, inventoryHolder, addType)
    if modItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "armorBag" then
        Osi.ApplyStatus(item, FALLEN_BOOSTS[1], -1, 100, "") --Weightless item
        local bagEntity = _GE(inventoryHolder)
        if bagEntity then
            local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
            local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
            local itemEntity = _GE(item)
            if itemEntity and itemEntity.Equipable then
                local equipmentSlot = itemEntity.Equipable.Slot
                if bagOwnerUUID then
                    if ArmorSlots[equipmentSlot] then
                        equipmentSlot = ArmorSlots[equipmentSlot] --Convert Vanities into their corresponding real slots
                        BasicDebug("Armor Tmog for Slot : " .. tostring(equipmentSlot))
                        local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
                        if correspondingEquipment then
                            BasicDebug(string.format("Applying the skin of : %s on item : %s", GetTranslatedName(item),
                                GetTranslatedName(correspondingEquipment)))
                            TransmogArmorUltimateVersion(GUID(item), (GUID(correspondingEquipment)), bagOwnerUUID)
                        end
                        SaveArmorInfosToModVars(GUID(item), bagOwnerUUID, equipmentSlot)
                    end
                end
            end
        end
    elseif modItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "weaponBag" then
        Osi.ApplyStatus(item, FALLEN_BOOSTS[1], -1, 100, "") --Weightless item
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
                            BasicDebug(string.format("Applying the skin of : %s on item : %s", GetTranslatedName(item),
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
        Osi.RemoveStatus(item, FALLEN_BOOSTS[1]) --Restore weight
        local bagEntity = _GE(inventoryHolder)
        if bagEntity then
            local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
            local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
            local itemEntity = _GE(item)
            if itemEntity and itemEntity.Equipable then
                local equipmentSlot = itemEntity.Equipable.Slot
                equipmentSlot = ArmorSlots[equipmentSlot] --Convert Vanities into their corresponding real slots
                if bagOwnerUUID and ArmorSlots[equipmentSlot] then
                    local modVars = GetModVariables()
                    local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID,
                        tostring(equipmentSlot))
                    BasicDebug(string.format("Removed Armor : %s from bag for Slot : %s", GetTranslatedName(item),
                        tostring(equipmentSlot)))
                    if (modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[bagOwnerUUID] and modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot] and GUID(item) == modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot]) then
                        if correspondingEquipment then
                            RestoreOriginalArmorVisuals(_GE(correspondingEquipment))
                            RefreshCharacterArmorVisuals(_GE(bagOwnerUUID))
                        end
                        modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot] = nil
                        SyncModVariables()
                    end
                end
            end
        end
    elseif modItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "weaponBag" then
        Osi.RemoveStatus(item, FALLEN_BOOSTS[1]) --Restore weight
        local bagEntity = _GE(inventoryHolder)
        if bagEntity then
            local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
            local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
            local itemEntity = _GE(item)
            if itemEntity and itemEntity.Equipable then
                local equipmentSlot = itemEntity.Equipable.Slot
                if bagOwnerUUID and WeaponSlots[equipmentSlot] then
                    local modVars = GetModVariables()
                    BasicDebug("Removed Weapon from bag for Slot : " .. tostring(equipmentSlot))
                    local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID,
                        tostring(WeaponSlots[equipmentSlot]))
                    if correspondingEquipment then
                        BasicDebug("Restoring Equipped Piece's visuals")
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

Ext.Osiris.RegisterListener("Equipped", 2, "before", function(item, character)
    local itemEntity = _GE(item)
    if not itemEntity then return end

    local modVars = GetModVariables()
    local equipmentSlot = tostring(itemEntity.Equipable.Slot)
    local tmogInfos = modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[GUID(character)]

    if tmogInfos and tmogInfos[equipmentSlot] then
        local skinToApply = tmogInfos[equipmentSlot]
        local slotType = ArmorSlots[equipmentSlot] and "Armor" or (WeaponSlots[equipmentSlot] and "Weapon")
        if slotType then
            BasicDebug(string.format("Equipped() Applying the skin of : %s on item : %s from modVars!",
                GetTranslatedName(skinToApply), GetTranslatedName(item)))
            if slotType == "Armor" then
                TransmogArmorUltimateVersion(skinToApply, GUID(item), character)
            else
                TransmogWeapon(item, skinToApply, character, true)
            end
        end
    end
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "before", function(item, character)
    local itemEntity = _GE(item)
    if itemEntity.Vars.Fallen_OriginalWeaponInfos then
        BasicDebug("Unequip restoring original weapon visuals")
        RestoreOriginalWeaponVisuals(itemEntity)
        RefreshCharacterArmorVisuals(_GE(character))
    elseif itemEntity.Vars.Fallen_TmogArmorOriginalVisuals then
        BasicDebug("Unequip restoring original armor visuals")
        RestoreOriginalArmorVisuals(itemEntity)
        RefreshCharacterArmorVisuals(_GE(character))
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, iseditor)
    if not CONFIG then CONFIG = InitConfig() end
    RestoreMoggedWeapons()
    RestoreMoggedArmors()
    for item, name in pairs(modItemRoots) do
        GiveItemToEachPartyMember(item)
    end
end)
