---Get Visibility status for each slot and update relevent loca entries
---Needs a fucking rewritelocal function updatePotionsDescription()
local function updatePotionsDescription()
    local modVars = GetModVariables()
    if not modVars.Fallen_TmogInfos_Invisibles then return end

    local descriptionSlots = { "Breast", "Gloves", "Boots", "Cloak" }
    local visibleText = GetTranslatedString(Handles["Visible"]) or "Visible"
    local invisibleText = GetTranslatedString(Handles["Invisible"]) or "Invisible"
    local greenHex = "#00FF00"  -- Green
    local orangeHex = "#FFA500" -- Orange

    for _, slot in pairs(descriptionSlots) do
        local slotDescriptionHandle = SlotToDescriptionHandle[slot]
        local descriptionContent = ""
        for _, member in pairs(SQUADIES) do
            local invisTmogInfos = modVars.Fallen_TmogInfos_Invisibles[member]
            local visibility = invisTmogInfos and invisTmogInfos[slot] or false
            local translatedVisibility = visibility and ColorTranslatedString(invisibleText, orangeHex) or
                ColorTranslatedString(visibleText, greenHex)
            descriptionContent = descriptionContent ..
                GetTranslatedName(member) .. " : " .. translatedVisibility .. "\n"
        end
        UpdateTranslatedString(Handles[slotDescriptionHandle], descriptionContent)
    end

    if modVars.Fallen_TmogInfos then
        local WeaponDescriptionSlots = { "MeleeMainHand", "MeleeOffHand" }

        for _, slot in pairs(WeaponDescriptionSlots) do
            local slotDescriptionHandle = Handles[SlotToDescriptionHandle[slot]]
            local WeaponDescriptionContent = ""
            for _, member in pairs(SQUADIES) do
                local invisWeaponTmogInfos = modVars.Fallen_TmogInfos[member]
                local visibility = invisWeaponTmogInfos and invisWeaponTmogInfos[slot] == InvisibleShit or false
                local translatedVisibility = visibility and ColorTranslatedString(invisibleText, orangeHex) or
                    ColorTranslatedString(visibleText, greenHex)
                WeaponDescriptionContent = WeaponDescriptionContent ..
                    GetTranslatedName(member) .. " : " .. translatedVisibility .. "\n"
            end
            UpdateTranslatedString(slotDescriptionHandle, WeaponDescriptionContent)
        end
    end
end




---Manage tmog logic for skin added to bag
---@param item GUIDSTRING
---@param inventoryHolder GUIDSTRING
---@param bagType bagtype
---@param slotMappings table one of the slot mapping table
local function ApplyTransmog(item, inventoryHolder, bagType, slotMappings)
    Osi.ApplyStatus(item, FALLEN_BOOSTS[1], -1, 100, "") -- Weightless item
    local bagEntity = _GE(inventoryHolder)
    if bagEntity then
        local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
        local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
        local itemEntity = _GE(item)
        if itemEntity and itemEntity.Equipable then
            local equipmentSlot = itemEntity.Equipable.Slot
            if bagOwnerUUID and slotMappings[equipmentSlot] then
                equipmentSlot = slotMappings[equipmentSlot]
                if bagType == "weaponBag" then
                    BasicDebug("Weapon Tmog for Slot : " .. tostring(equipmentSlot))
                    local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
                    if correspondingEquipment then
                        BasicDebug(string.format("Applying the skin of : %s on item : %s", GetTranslatedName(item),
                            GetTranslatedName(correspondingEquipment)))
                        TransmogWeapon(correspondingEquipment, item, bagOwnerUUID)
                    end
                    SaveWeaponInfosToModVars(itemEntity, GUID(bagOwnerUUID), equipmentSlot)
                else
                    BasicDebug("Armor Tmog for Slot : " .. tostring(equipmentSlot))
                    local correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
                    if correspondingEquipment and not IsArmorSlotInvisible(slotMappings[equipmentSlot], bagOwnerUUID) then
                        BasicDebug(string.format("Applying the skin of : %s on item : %s", GetTranslatedName(item),
                            GetTranslatedName(correspondingEquipment)))
                        TransmogArmorUltimateVersion(GUID(item), GUID(correspondingEquipment), bagOwnerUUID)
                    end
                    SaveArmorInfosToModVars(GUID(item), bagOwnerUUID, equipmentSlot)
                end
            end
        end
    end
end

Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(root, item, inventoryHolder, addType)
    local bagType = ModItemRoots[GUID(Osi.GetTemplate(inventoryHolder))]
    if bagType == "armorBag" then
        ApplyTransmog(item, inventoryHolder, bagType, ArmorSlots)
    elseif bagType == "campBag" then
        ApplyTransmog(item, inventoryHolder, bagType, CampSlots)
    elseif bagType == "weaponBag" then
        ApplyTransmog(item, inventoryHolder, bagType, WeaponSlots)
    end
end)

---Manage tmog logic for skin remove from bag
---@param item GUIDSTRING
---@param inventoryHolder GUIDSTRING
---@param bagType bagtype
---@param slotMappings table one of the slot mapping table
local function ApplyTransmogRemoval(item, inventoryHolder, bagType, slotMappings)
    Osi.RemoveStatus(item, FALLEN_BOOSTS[1]) -- Restore weight
    local bagEntity = _GE(inventoryHolder)
    if not bagEntity then return end

    local bagOwnerEntity = bagEntity.OwneeCurrent.Ownee
    local bagOwnerUUID = EntityToUuid(bagOwnerEntity)
    if not bagOwnerUUID then return end

    local itemEntity = _GE(item)
    if not (itemEntity and itemEntity.Equipable) then return end

    local equipmentSlot = itemEntity.Equipable.Slot
    local modVars = GetModVariables()
    local correspondingEquipment

    if bagType == "weaponBag" then
        Osi.RemoveStatus(item, FALLEN_BOOSTS[1])
        equipmentSlot = slotMappings[equipmentSlot]
        correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
        if correspondingEquipment then
            BasicDebug("Removed Weapon from bag for Slot : " .. tostring(equipmentSlot))
            BasicDebug("Restoring Equipped Piece's visuals")
            RestoreOriginalWeaponVisuals(_GE(correspondingEquipment))
            RefreshCharacterArmorVisuals(bagOwnerEntity)
            modVars.Fallen_TmogInfos[GUID(bagOwnerUUID)][equipmentSlot] = nil
        end
    elseif slotMappings[equipmentSlot] then
        Osi.RemoveStatus(item, FALLEN_BOOSTS[1])
        equipmentSlot = slotMappings[equipmentSlot]
        correspondingEquipment = Osi.GetEquippedItem(bagOwnerUUID, tostring(equipmentSlot))
        if correspondingEquipment then
            BasicDebug(string.format("Removed Armor : %s from bag for Slot : %s", GetTranslatedName(item),
                tostring(equipmentSlot)))
            local tmogInfos = modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[bagOwnerUUID]
            if tmogInfos and tmogInfos[equipmentSlot] and GUID(item) == tmogInfos[equipmentSlot] then
                if not IsArmorSlotInvisible(equipmentSlot, bagOwnerUUID) then
                    RestoreOriginalArmorVisuals(_GE(correspondingEquipment))
                    RefreshCharacterArmorVisuals(_GE(bagOwnerUUID))
                end
                modVars.Fallen_TmogInfos[bagOwnerUUID][equipmentSlot] = nil
            end
        end
    end
end

Ext.Osiris.RegisterListener("RemovedFrom", 2, "after", function(item, inventoryHolder)
    inventoryHolder = GUID(inventoryHolder)
    local bagType = ModItemRoots[GUID(Osi.GetTemplate(inventoryHolder))]
    if bagType == "weaponBag" then
        ApplyTransmogRemoval(item, inventoryHolder, bagType, WeaponSlots)
    elseif bagType == "armorBag" then
        ApplyTransmogRemoval(item, inventoryHolder, bagType, ArmorSlots)
    elseif bagType == "campBag" then
        ApplyTransmogRemoval(item, inventoryHolder, bagType, CampSlots)
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
                    TransmogArmorUltimateVersion(skinToApply, GUID(item), character)
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
        GiveItemToEachPartyMember(item, true, "Fallen_TmogInfos_GivenItems")
    end
    updatePotionsDescription()
end


Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", start)

Ext.Events.ResetCompleted:Subscribe(start)

---Should've done this from the start
Ext.Events.GameStateChanged:Subscribe(function(e)
    if e.FromState == "Running" and e.ToState == "Save" then
        SyncModVariables()
        SyncUserVariables()
    end
end)
