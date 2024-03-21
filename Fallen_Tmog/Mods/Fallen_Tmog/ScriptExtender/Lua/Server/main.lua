
---Get Visibility status for each slot and update relevent loca entries
local function updatePotionsDescription()
    local modVars = GetModVariables()
    if modVars.Fallen_TmogInfos_Invisibles then
        local result = {}
        local descriptionSlots = { "Breast", "Gloves", "Boots", "Cloak" }
        local descriptionContent = {}
        GetSquadies()

        --Get visibility information
        for _, member in pairs(SQUADIES) do
            local invisTmogInfos = modVars.Fallen_TmogInfos_Invisibles[member]
            if invisTmogInfos then
                for slot, visibility in pairs(invisTmogInfos) do
                    result[member] = result[member] or {}
                    result[member][slot] = visibility
                end
            end
        end

        -- Translated strings for visibility
        local visibleText = GetTranslatedString(Handles["Visible"]) or "Visible"
        local invisibleText = GetTranslatedString(Handles["Invisible"]) or "Invisible"

        local greenHex = "#00FF00"  -- Green
        local orangeHex = "#FFA500" -- Orange

        -- Generate description content for each description slot
        for _, slot in pairs(descriptionSlots) do
            local slotDescriptionHandle = SlotToDescriptionHandle[slot]
            descriptionContent[slot] = ""
            for _, member in pairs(SQUADIES) do
                local visibility = result[member] and result[member][slot]
                local translatedVisibility = visibility and ColorTranslatedString(invisibleText, orangeHex) or
                    ColorTranslatedString(visibleText, greenHex)
                descriptionContent[slot] = descriptionContent[slot] ..
                    GetTranslatedName(member) .. " : " .. translatedVisibility .. "\n"
            end
            UpdateTranslatedString(Handles[slotDescriptionHandle], descriptionContent[slot])
        end

        if modVars.Fallen_TmogInfos then
            local WeaponResults = {}
            local WeaponDescriptionSlots = { "MeleeMainHand", "MeleeOffHand" }
            local WeaponDescriptionContent = {}
            GetSquadies()

            --Get visibility information
            for _, member in pairs(SQUADIES) do
                local invisWeaponTmogInfos = modVars.Fallen_TmogInfos[member]
                if invisWeaponTmogInfos then
                    for slot, skin in pairs(invisWeaponTmogInfos) do
                        if WeaponSlots[slot] then
                            WeaponResults[member] = WeaponResults[member] or {}
                            WeaponResults[member][slot] = skin == InvisibleShit
                            if WeaponResults[member][slot] == true then
                                BasicDebug(slot.." Shit do be invisible")
                                BasicDebug(WeaponResults)
                            else
                                BasicDebug(slot.." Shit do not be invisible")
                            end
                        end
                    end
                end
            end

            -- Translated strings for visibility
            local visibleText = GetTranslatedString(Handles["Visible"]) or "Visible"
            local invisibleText = GetTranslatedString(Handles["Invisible"]) or "Invisible"

            local greenHex = "#00FF00"  -- Green
            local orangeHex = "#FFA500" -- Orange

            -- Generate description content for each description slot
            for _, slot in pairs(WeaponDescriptionSlots) do
                local slotDescriptionHandle = Handles[SlotToDescriptionHandle[slot]]
                WeaponDescriptionContent[slot] = ""
                for _, member in pairs(SQUADIES) do
                    local visibility = WeaponResults[member] and WeaponResults[member][slot]
                    local translatedVisibility = visibility and ColorTranslatedString(invisibleText, orangeHex) or
                        ColorTranslatedString(visibleText, greenHex)
                    WeaponDescriptionContent[slot] = WeaponDescriptionContent[slot] ..
                        GetTranslatedName(member) .. " : " .. translatedVisibility .. "\n"
                end
                UpdateTranslatedString(slotDescriptionHandle, WeaponDescriptionContent[slot])
            end
        end
    end
end



Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(root, item, inventoryHolder, addType)
    if ModItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "armorBag" then
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
                        if correspondingEquipment and not IsArmorSlotInvisible(ArmorSlots[equipmentSlot], bagOwnerUUID) then
                            BasicDebug(string.format("Applying the skin of : %s on item : %s", GetTranslatedName(item),
                                GetTranslatedName(correspondingEquipment)))
                            TransmogArmor(GUID(item), GUID(correspondingEquipment), bagOwnerUUID)
                        end
                        SaveArmorInfosToModVars(GUID(item), bagOwnerUUID, equipmentSlot)
                    end
                end
            end
        end
    elseif ModItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "campBag" then
            Osi.ApplyStatus(item, FALLEN_BOOSTS[1], -1, 100, "") --Weightless item
            local bagEntity = _GE(inventoryHolder)
            if bagEntity then
                local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
                local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
                local itemEntity = _GE(item)
                if itemEntity and itemEntity.Equipable then
                    local equipmentSlot = itemEntity.Equipable.Slot
                    if bagOwnerUUID then
                        if CampSlots[equipmentSlot] then
                            equipmentSlot = CampSlots[equipmentSlot] --Convert real slot into camp slot
                            BasicDebug("Armor Tmog for Slot : " .. tostring(equipmentSlot))
                            local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
                            if correspondingEquipment then
                                BasicDebug(string.format("Applying the skin of : %s on item : %s", GetTranslatedName(item),
                                    GetTranslatedName(correspondingEquipment)))
                                TransmogArmor(GUID(item), GUID(correspondingEquipment), bagOwnerUUID)
                            end
                            SaveArmorInfosToModVars(GUID(item), bagOwnerUUID, equipmentSlot)
                        end
                    end
                end
            end
    elseif ModItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "weaponBag" then
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
    if ModItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "armorBag" then
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
                    local tmogInfos = modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[bagOwnerUUID]
                    if (tmogInfos and tmogInfos[equipmentSlot] and GUID(item) == tmogInfos[equipmentSlot]) then
                        if correspondingEquipment and not IsArmorSlotInvisible(equipmentSlot, bagOwnerUUID) then
                            RestoreOriginalArmorVisuals(_GE(correspondingEquipment))
                            RefreshCharacterArmorVisuals(_GE(bagOwnerUUID))
                        end
                        modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot] = nil
                        SyncModVariables()
                    end
                end
            end
        end
    elseif ModItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "campBag" then
            Osi.RemoveStatus(item, FALLEN_BOOSTS[1]) --Restore weight
            local bagEntity = _GE(inventoryHolder)
            if bagEntity then
                local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
                local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
                local itemEntity = _GE(item)
                if itemEntity and itemEntity.Equipable then
                    local equipmentSlot = itemEntity.Equipable.Slot
                    equipmentSlot = CampSlots[equipmentSlot] --Convert real slot into corrresponding vanity
                    if bagOwnerUUID and CampSlots[equipmentSlot] then
                        local modVars = GetModVariables()
                        local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID,
                            tostring(equipmentSlot))
                        BasicDebug(string.format("Removed Armor : %s from bag for Slot : %s", GetTranslatedName(item),
                            tostring(equipmentSlot)))
                        local tmogInfos = modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[bagOwnerUUID]
                        if (tmogInfos and tmogInfos[equipmentSlot] and GUID(item) == tmogInfos[equipmentSlot]) then
                            if correspondingEquipment and not IsArmorSlotInvisible(equipmentSlot, bagOwnerUUID) then
                                RestoreOriginalArmorVisuals(_GE(correspondingEquipment))
                                RefreshCharacterArmorVisuals(_GE(bagOwnerUUID))
                            end
                            modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot] = nil
                            SyncModVariables()
                        end
                    end
                end
            end
    elseif ModItemRoots[GUID(Osi.GetTemplate(inventoryHolder))] == "weaponBag" then
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
                --Check if should be invisibled
                if IsArmorSlotInvisible(ArmorSlots[equipmentSlot], character) then
                    HideArmorPiece(GUID(item), character)
                else
                    TransmogArmor(skinToApply, GUID(item), character)
                end
            else
                TransmogWeapon(item, skinToApply, character, true)
            end
        end
    elseif IsArmorSlotInvisible(ArmorSlots[equipmentSlot], character) then
        HideArmorPiece(GUID(item), character)
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



Ext.Osiris.RegisterListener("Combined", 7, "after", function(item1, item2, item3, item4, item5, character, newItem)
    local modVars = GetModVariables()
    if modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[GUID(character)] then
        local skinEntity = _GE(newItem)
        local equipmentSlot = skinEntity.Equipable.Slot
        equipmentSlot = ArmorSlots[equipmentSlot]
        local itemInfo = modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot]
        if itemInfo == GUID(newItem) then
            local correspondingEquipment = Osi.GetEquippedItem(character,
                tostring(equipmentSlot))
            if correspondingEquipment then
                DelayedCall(333, function()
                    HandleDyesForArmor(skinEntity, _GE(correspondingEquipment))
                end)
            end
        end
    end
end)


--Hide appearance potions
Ext.Osiris.RegisterListener("TemplateUseStarted", 3, "after", function(character, itemTemplate, item)
    if Osi.IsPartyMember(character, 1) == 1 then
        character = GUID(character)
        local slotToHide = HideSlots[GUID(itemTemplate)]
        if slotToHide then
            if ArmorSlots[slotToHide] then
                --It's an armor
                local correspondingEquipment = Osi.GetEquippedItem(character,
                    tostring(slotToHide))
                if correspondingEquipment then
                    if Osi.HasActiveStatus(correspondingEquipment, FALLEN_BOOSTS[2]) == 0 and not IsArmorSlotInvisible(slotToHide, character) then
                        Osi.ApplyStatus(correspondingEquipment, FALLEN_BOOSTS[2], -1, 100, "") --Invisible Items
                        BasicDebug("Invisibled the thing!")
                        SaveArmorInfosToModVars(NULLUUID, character, slotToHide)
                        HideArmorPiece(correspondingEquipment, character)
                    else
                        RestoreArmorVisibility(correspondingEquipment, slotToHide, character)
                    end
                    updatePotionsDescription()
                end
            else
                --It's a weapon
                local correspondingEquipment = Osi.GetEquippedItem(character,
                    tostring(WeaponSlots[slotToHide]))
                if correspondingEquipment then
                    if not IsWeaponInvisible(slotToHide, character) then
                        --Osi.ApplyStatus(correspondingEquipment, FALLEN_BOOSTS[2], -1, 100, "") --Invisible Items
                        BasicDebug("Invisibled the Weapon!")
                        SaveWeaponInfosToModVars(InvisibleShit, character, slotToHide)
                        TransmogWeapon(correspondingEquipment, InvisibleShit, character, true)
                    else
                        Osi.RemoveStatus(correspondingEquipment, FALLEN_BOOSTS[2])
                        RestoreOriginalWeaponVisuals(_GE(correspondingEquipment))
                        local modVars = GetModVariables()
                        modVars.Fallen_TmogInfos[character][slotToHide] = nil
                        RefreshCharacterArmorVisuals(_GE(character))
                    end
                    updatePotionsDescription()
                end
            end
        end
    end
end)

local function start()
    if not CONFIG then CONFIG = InitConfig() end
    RestoreMoggedWeapons()
    RestoreMoggedArmors()
    for item, name in pairs(ModItemRoots) do
        GiveItemToEachPartyMember(item,true,"Fallen_TmogInfos_GivenItems")
    end
    updatePotionsDescription()
end


Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", start)

Ext.Events.ResetCompleted:Subscribe(start)


