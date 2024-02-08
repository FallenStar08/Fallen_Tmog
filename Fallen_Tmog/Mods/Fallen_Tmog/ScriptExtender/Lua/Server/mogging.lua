RegisterUserVariable("Fallen_TmogArmorOriginalVisuals")
RegisterUserVariable("Fallen_OriginalWeaponInfos")
RegisterModVariable("Fallen_TmogInfos")

-- -------------------------------------------------------------------------- --
--                                 WEAPON TMOG                                --
-- -------------------------------------------------------------------------- --
---Stuff to replicate on weapons
---@param itemEntity ItemEntity
local function replicateWeaponComponents(itemEntity)
    itemEntity:Replicate("GameObjectVisual")
end

---Todo migrate to modvars
---@param itemSkin ItemEntity
---@param character GUIDSTRING
---@param equipmentSlot EQUIPMENTSLOT
function SaveWeaponInfosToPvars(itemSkin, character, equipmentSlot)
    if not PersistentVars.Tmoggeds then PersistentVars.Tmoggeds = {} end
    if not PersistentVars.Tmoggeds[character] then PersistentVars.Tmoggeds[character] = {} end
    PersistentVars.Tmoggeds[GUID(character)][tostring(equipmentSlot)] = {
        new_appearance = itemSkin.GameObjectVisual.RootTemplateId
    }
end

---Save original weapon info for restoring inside the weapon entity
---@param itemEntity ItemEntity
local function saveOriginalWeaponInfos(itemEntity)
    if itemEntity.Vars.Fallen_OriginalWeaponInfos then
        BasicDebug("Already saved Original w infos")
        return
    end
    local dataToSave = { ["OriginalVisualId"] = itemEntity.GameObjectVisual.RootTemplateId }
    itemEntity.Vars.Fallen_OriginalWeaponInfos = dataToSave
    SyncUserVariables()
    BasicDebug("Saved state for weapon " .. EntityToUuid(itemEntity))
    BasicDebug(dataToSave)
end


---Apply stats to a given itemEntity based on what is in this slot in Pvars
---@param itemEntity ItemEntity the item entity, it's not a table but I can't be fucked
---@param character string character uuid
---@param slot EQUIPMENTSLOT the slot to apply the mogging to
function ApplyMoggedToItemFromPvar(itemEntity, character, slot)
    if WeaponSlots[slot] then
        saveOriginalWeaponInfos(itemEntity)
        local data = PersistentVars.Tmoggeds[GUID(character)][slot]
        if not data then return end
        itemEntity.GameObjectVisual.RootTemplateId = data.new_appearance
        replicateWeaponComponents(itemEntity)
    end
end

-- -------------------------------------------------------------------------- --
--                                 ARMOR TMOG                                 --
-- -------------------------------------------------------------------------- --


---Save original armor visuals inside the armor using info from a table
---@param armorEntity ItemEntity
---@param infoTable table
function SaveOriginalArmorInfos(armorEntity, infoTable)
    if armorEntity then
        if armorEntity.Vars.Fallen_TmogArmorOriginalVisuals then
            BasicPrint(string.format("Armor visual infos already saved for %s!",GetTranslatedName(EntityToUuid(armorEntity) or "")))
            return
        end
        BasicPrint(string.format("Saved new original armor visual infos for armor %s!",GetTranslatedName(EntityToUuid(armorEntity) or "")))
        armorEntity.Vars.Fallen_TmogArmorOriginalVisuals = Ext.Types.Serialize(infoTable)
        SyncUserVariables()
    end
end

---Delete mogged item, bring back real equipment piece and Equip it
---@param armorEntity ItemEntity
function RestoreOriginalArmorVisuals(armorEntity)
    ApplyVisualsFromTable(armorEntity, armorEntity.Vars.Fallen_TmogArmorOriginalVisuals)
end

---Create a new armor using skin from skin and data from equippedPiece on char
---@param skin GUIDSTRING
---@param equippedPiece GUIDSTRING
---@param character GUIDSTRING
function TransmogArmorUltimateVersion(skin, equippedPiece, character)
    local skinEntity = _GE(skin)
    local equippedPieceEntity = _GE(equippedPiece)
    local originalInfos = Table.DeepCopy(equippedPieceEntity.ServerItem.Template.Equipment.Visuals)
    SaveOriginalArmorInfos(equippedPieceEntity,originalInfos)
    CopyVisuals(equippedPieceEntity, skinEntity)
end

---Restores item to its original state using store info in sessionModifiedItems
---@param itemEntity ItemEntity
function RestoreOriginalStateForItem(itemEntity)
    if itemEntity.Vars.Fallen_OriginalArmorInfos then
        --dostuff
    elseif itemEntity.Vars.Fallen_OriginalWeaponInfos then
        local uuid = EntityToUuid(itemEntity)
        BasicDebug("Restoring item state for weapon : " .. uuid)
        itemEntity.GameObjectVisual.RootTemplateId = itemEntity.Vars.Fallen_OriginalWeaponInfos.OriginalVisualId
        replicateWeaponComponents(itemEntity)
    end
end

---Restore mogged appearance after loading a save
function RestoreMoggedWeapons()
    if not PersistentVars.Tmoggeds then return end
    for characterUUID, characterEquipments in pairs(PersistentVars.Tmoggeds) do
        for slot, data in pairs(characterEquipments) do
            if WeaponSlots[slot] then
                --BasicDebug(type(slot))
                local correspondingEquipment = Osi.GetEquippedItem(characterUUID, WeaponSlots[slot])
                ApplyMoggedToItemFromPvar(_GE(correspondingEquipment), characterUUID, slot)
            end
        end
    end
end

---Restore mogged appearance after loading a save
function RestoreMoggedArmors()
    local modVars=GetModVariables()
    if modVars.Fallen_TmogInfos then
        local data = modVars.Fallen_TmogInfos
        for character,characterData in pairs(data) do
            for slot,skin in pairs(characterData) do
                local correspondingEquipment = Osi.GetEquippedItem(character, tostring(slot))
                if correspondingEquipment then
                    TransmogArmorUltimateVersion(skin, correspondingEquipment, character)
                    RefreshCharacterArmorVisuals(_GE(character))
                end
            end
        end
    end
end

---Transmog a weapon using a given skin (another item)
---@param itemInUse GUIDSTRING
---@param skin GUIDSTRING
---@param character GUIDSTRING
function TransmogWeapon(itemInUse, skin, character)
    local itemToReskin = _GE(itemInUse)
    local itemSkin = _GE(skin)
    if itemToReskin and itemSkin then
        local equipmentSlot = itemToReskin.Equipable.Slot
        saveOriginalWeaponInfos(itemToReskin)
        SaveWeaponInfosToPvars(itemSkin, character, equipmentSlot)
        itemToReskin.GameObjectVisual.RootTemplateId = itemSkin.GameObjectVisual.RootTemplateId
        replicateWeaponComponents(itemToReskin)
    end
end

---Replicate ArmorSetsState to trigger a refresh of the armor visuals
---@param entity CharacterEntity
function RefreshCharacterArmorVisuals(entity)
    entity:Replicate("ArmorSetState")
end

---Clear existing armor visuals to prepare for copy
---@param entity ItemEntity
function ClearVisuals(entity)
    for index, visuals in pairs(entity.ServerItem.Template.Equipment.Visuals) do
        entity.ServerItem.Template.Equipment.Visuals[index] = {}
        entity.ServerItem.Template.Equipment.Visuals[index] = nil
    end
end

---Apply visuals from table
---@param entity ItemEntity
---@param table table
function ApplyVisualsFromTable(entity, table)
    for index, subtable in pairs(table) do
        entity.ServerItem.Template.Equipment.Visuals[index] = Table.DeepCopy(subtable)
    end
end

---Copy visuals from armor source to target
---@param target GUIDSTRING|ItemEntity
---@param source GUIDSTRING|ItemEntity
function CopyVisuals(target, source)
    if type(target) == "string" then
        ---@cast target string
        ---@cast source string
        local targetEntity = _GE(target)
        local sourceEntity = _GE(source)
        local sourceVisuals = sourceEntity.ServerItem.Template.Equipment.Visuals
        local sourceVisualsCopy = Table.DeepCopy(sourceVisuals)
        ClearVisuals(targetEntity)
        ApplyVisualsFromTable(targetEntity, sourceVisualsCopy)
    else
        local sourceVisuals = source.ServerItem.Template.Equipment.Visuals
        local sourceVisualsCopy = Table.DeepCopy(sourceVisuals)
        ClearVisuals(target)
        ApplyVisualsFromTable(target, sourceVisualsCopy)
    end
end
