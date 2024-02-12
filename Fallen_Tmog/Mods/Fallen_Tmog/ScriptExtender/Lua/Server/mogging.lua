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

---@param itemSkin ItemEntity
---@param character GUIDSTRING
---@param equipmentSlot EQUIPMENTSLOT
function SaveWeaponInfosToModVars(itemSkin, character, equipmentSlot)
    local modVars = GetModVariables()
    if not modVars.Fallen_TmogInfos then modVars.Fallen_TmogInfos = {} end
    if not modVars.Fallen_TmogInfos[character] then modVars.Fallen_TmogInfos[character] = {} end
    modVars.Fallen_TmogInfos[GUID(character)][tostring(equipmentSlot)] = itemSkin.GameObjectVisual.RootTemplateId
    SyncModVariables()
end

---Save original weapon info for restoring inside the weapon entity
---@param itemEntity ItemEntity
local function saveOriginalWeaponInfos(itemEntity)
    if itemEntity.Vars.Fallen_OriginalWeaponInfos then
        BasicPrint("Already saved Original w infos")
        return
    end
    local dataToSave = { ["OriginalVisualId"] = itemEntity.GameObjectVisual.RootTemplateId }
    itemEntity.Vars.Fallen_OriginalWeaponInfos = dataToSave
    SyncUserVariables()
    BasicPrint("Saved state for weapon " .. EntityToUuid(itemEntity))
    BasicPrint(dataToSave)
end

-- -------------------------------------------------------------------------- --
--                                 ARMOR TMOG                                 --
-- -------------------------------------------------------------------------- --

---comment
---@param armor GUIDSTRING
---@param character GUIDSTRING
---@param equipmentSlot EQUIPMENTSLOTNAME|string
function SaveArmorInfosToModVars(armor, character, equipmentSlot)
    local modVars = GetModVariables()
    if not modVars.Fallen_TmogInfos then modVars.Fallen_TmogInfos = {} end
    if not modVars.Fallen_TmogInfos[character] then modVars.Fallen_TmogInfos[character] = {} end
    modVars.Fallen_TmogInfos[character][equipmentSlot] = GUID(armor)
    SyncModVariables()
end

---Save original armor visuals inside the armor using info from a table
---@param armorEntity ItemEntity
---@param infoTable table
function SaveOriginalArmorInfos(armorEntity, infoTable)
    if armorEntity then
        if armorEntity.Vars.Fallen_TmogArmorOriginalVisuals then
            BasicPrint(string.format("Armor visual infos already saved for %s!",
                GetTranslatedName(EntityToUuid(armorEntity) or "")))
            return
        end
        BasicPrint(string.format("Saved new original armor visual infos for armor %s!",
            GetTranslatedName(EntityToUuid(armorEntity) or "")))
        armorEntity.Vars.Fallen_TmogArmorOriginalVisuals = Ext.Types.Serialize(infoTable)
        SyncUserVariables()
    end
end

---Basically do a tmog with the original infos
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
    SaveOriginalArmorInfos(equippedPieceEntity, originalInfos)
    CopyVisuals(equippedPieceEntity, skinEntity)
    RefreshCharacterArmorVisuals(_GE(character))
end

---Restores weapon item to its original state using store info
---@param itemEntity ItemEntity
function RestoreOriginalWeaponVisuals(itemEntity)
    if itemEntity.Vars.Fallen_OriginalWeaponInfos then
        local uuid = EntityToUuid(itemEntity)
        BasicPrint("Restoring item state for weapon : " .. uuid)
        itemEntity.GameObjectVisual.RootTemplateId = itemEntity.Vars.Fallen_OriginalWeaponInfos.OriginalVisualId
        replicateWeaponComponents(itemEntity)
    end
end

---Restore mogged appearance after loading a save
function RestoreMoggedWeapons()
    local modVars = GetModVariables()
    if not modVars.Fallen_TmogInfos then return end
    for characterUUID, characterEquipments in pairs(modVars.Fallen_TmogInfos) do
        for slot, skin in pairs(characterEquipments) do
            if WeaponSlots[slot] then
                local correspondingEquipment = Osi.GetEquippedItem(characterUUID, WeaponSlots[slot])
                if correspondingEquipment then
                    BasicPrint(string.format("Restoring appearance for weapon : %s for slot : %s Osislot : %s",
                    correspondingEquipment or "", slot, WeaponSlots[slot]))
                    TransmogWeapon(correspondingEquipment, skin, characterUUID,true)
                end
            end
        end
    end
end

---Restore mogged appearance after loading a save
function RestoreMoggedArmors()
    local modVars = GetModVariables()
    if modVars.Fallen_TmogInfos then
        local data = modVars.Fallen_TmogInfos
        for characterUUID, characterEquipments in pairs(data) do
            for slot, skin in pairs(characterEquipments) do
                local correspondingEquipment = Osi.GetEquippedItem(characterUUID, tostring(slot))
                if correspondingEquipment then
                    BasicPrint(string.format("Restoring appearance for armor piece : %s for slot : %s",
                    correspondingEquipment or "", slot))
                    TransmogArmorUltimateVersion(skin, correspondingEquipment, characterUUID)
                    RefreshCharacterArmorVisuals(_GE(characterUUID))
                end
            end
        end
    end
end

---Transmog a weapon using a given skin (another item)
---@param itemInUse GUIDSTRING
---@param skin GUIDSTRING
---@param character GUIDSTRING
---@param fromVars? boolean
function TransmogWeapon(itemInUse, skin, character, fromVars)
    if not fromVars then
        local itemToReskin = _GE(itemInUse)
        local itemSkin = _GE(skin)
        if itemToReskin and itemSkin then
            saveOriginalWeaponInfos(itemToReskin)
            itemToReskin.GameObjectVisual.RootTemplateId = itemSkin.GameObjectVisual.RootTemplateId
            replicateWeaponComponents(itemToReskin)
            RefreshCharacterArmorVisuals(_GE(character))
        end
    else
        local itemToReskin = _GE(itemInUse)
        saveOriginalWeaponInfos(itemToReskin)
        itemToReskin.GameObjectVisual.RootTemplateId = skin
        replicateWeaponComponents(itemToReskin)
        RefreshCharacterArmorVisuals(_GE(character))
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
