-- -------------------------------------------------------------------------- --
--                                 ARMOR TMOG                                 --
-- -------------------------------------------------------------------------- --

---comment
---@param armor GUIDSTRING
---@param character GUIDSTRING
---@param equipmentSlot EQUIPMENTSLOTNAME|string
function SaveArmorInfosToModVars(armor, character, equipmentSlot)
    local modVars = GetModVariables()
    if armor == NULLUUID then
        if not modVars.Fallen_TmogInfos_Invisibles then modVars.Fallen_TmogInfos_Invisibles = {} end
        if not modVars.Fallen_TmogInfos_Invisibles[character] then modVars.Fallen_TmogInfos_Invisibles[character] = {} end
        modVars.Fallen_TmogInfos_Invisibles[character][equipmentSlot] = true
    else
        if not modVars.Fallen_TmogInfos then modVars.Fallen_TmogInfos = {} end
        if not modVars.Fallen_TmogInfos[character] then modVars.Fallen_TmogInfos[character] = {} end
        modVars.Fallen_TmogInfos[character][equipmentSlot] = GUID(armor)
    end
    SyncModVariables()
end

---Save original armor visuals inside the armor using info from a table
---@param armorEntity ItemEntity?
---@param infoTable table
---@param originalSlotInfos table
function SaveOriginalArmorInfos(armorEntity, infoTable, originalSlotInfos)
    if armorEntity then
        if armorEntity.Vars.Fallen_TmogArmorOriginalVisuals and armorEntity.Vars.Fallen_TmogArmorOriginalSlots then
            BasicDebug(string.format("Armor visual infos already saved for %s!",
                GetTranslatedName(EntityToUuid(armorEntity) or "")))
            return
        end
        BasicDebug(string.format("Saved new original armor visual infos for armor %s!",
            GetTranslatedName(EntityToUuid(armorEntity) or "")))
        armorEntity.Vars.Fallen_TmogArmorOriginalVisuals = infoTable
        armorEntity.Vars.Fallen_TmogArmorOriginalSlots = originalSlotInfos
        SyncUserVariables()
    end
end

---Restore dyes
---@param armorEntity ItemEntity
local function restoreOriginalDyesForArmor(armorEntity)
    if armorEntity.Vars.Fallen_TmogArmorOriginalDye then
        armorEntity.ItemDye.Color = armorEntity.Vars.Fallen_TmogArmorOriginalDye
        armorEntity.Vars.Fallen_TmogArmorOriginalDye = nil
        armorEntity:Replicate("ItemDye")
    end
end

---Basically do a tmog with the original infos
---@param armorEntity ItemEntity?
function RestoreOriginalArmorVisuals(armorEntity)
    if armorEntity then
        local entityUUID = EntityToUuid(armorEntity)
        local armorRT = GetRootTemplateData(entityUUID)
        restoreOriginalDyesForArmor(armorEntity)
        if armorRT then
            ApplyVisualsFromTable(armorRT, armorEntity.Vars.Fallen_TmogArmorOriginalVisuals,
                armorEntity.Vars.Fallen_TmogArmorOriginalSlots)
        end
    end
end

---Handle the dyes stuff.
---@param skinEntity ItemEntity?
---@param equippedPieceEntity ItemEntity?
function HandleDyesForArmor(skinEntity, equippedPieceEntity)
    if equippedPieceEntity then
        if equippedPieceEntity.ItemDye then
            local equippedPieceDye = equippedPieceEntity.ItemDye.Color
            --Save original dye
            equippedPieceEntity.Vars.Fallen_TmogArmorOriginalDye = equippedPieceDye
        else
            equippedPieceEntity:CreateComponent("ItemDye")
        end
        if skinEntity and skinEntity.ItemDye then
            local skinDye = skinEntity.ItemDye.Color
            equippedPieceEntity.ItemDye.Color = skinDye
            equippedPieceEntity:Replicate("ItemDye")
        end
    end
    SyncUserVariables()
end

---Do the tmogging of the armor
---@param skin GUIDSTRING
---@param equippedPiece GUIDSTRING
---@param character GUIDSTRING
function TransmogArmor(skin, equippedPiece, character)
    local skinEntity = _GE(skin)
    local equippedPieceEntity = _GE(equippedPiece)
    local equippedPieceRT = GetRootTemplateData(equippedPiece)
    local equipmentVisuals = (equippedPieceRT and equippedPieceRT.Equipment) and equippedPieceRT.Equipment.Visuals
    local equipmentSlot = (equippedPieceRT and equippedPieceRT.Equipment) and equippedPieceRT.Equipment.Slot
    local originalInfos = equipmentVisuals and Ext.Types.Serialize(equipmentVisuals)
    local originalSlotInfos = equipmentSlot and Ext.Types.Serialize(equipmentSlot)
    if originalInfos and originalSlotInfos then
        HandleDyesForArmor(skinEntity, equippedPieceEntity)
        SaveOriginalArmorInfos(equippedPieceEntity, originalInfos, originalSlotInfos)
        CopyVisuals(equippedPieceEntity, skinEntity)
        RefreshCharacterArmorVisuals(_GE(character))
    end
end

function HideArmorPiece(equippedPiece, character)
    local equippedPieceEntity = _GE(equippedPiece)
    local equippedPieceRT = GetRootTemplateData(equippedPiece)
    if equippedPieceEntity and equippedPieceRT then
        local originalInfos = (equippedPieceRT and equippedPieceRT.Equipment) and
            Ext.Types.Serialize(equippedPieceRT.Equipment.Visuals)
        if originalInfos then
            SaveOriginalArmorInfos(equippedPieceEntity, originalInfos,
                Ext.Types.Serialize(equippedPieceRT.Equipment.Slot))
            BasicDebug("Clearing Visuals")
            ClearVisuals(equippedPieceRT)
            RefreshCharacterArmorVisuals(_GE(character))
        else
            -- An error occurred, handle it appropriately
            BasicDebug("Equipment is either already invisible (tmog ring) or bad, probably bad")
        end
    end
end

function RestoreArmorVisibility(equippedPiece, slot, character)
    local modVars = GetModVariables()
    Osi.RemoveStatus(equippedPiece, FALLEN_BOOSTS[2])
    if not modVars.Fallen_TmogInfos_Invisibles then modVars.Fallen_TmogInfos_Invisibles = {} end
    if not modVars.Fallen_TmogInfos_Invisibles[character] then modVars.Fallen_TmogInfos_Invisibles[character] = {} end
    modVars.Fallen_TmogInfos_Invisibles[character][slot] = nil
    local modVars = GetModVariables()
    if modVars.Fallen_TmogInfos then
        local data = modVars.Fallen_TmogInfos
        if data and data[character] and data[character][slot] then
            local correspondingEquipment = Osi.GetEquippedItem(character, tostring(slot))
            if correspondingEquipment then
                BasicDebug(string.format("Restoring appearance for armor piece : %s for slot : %s",
                    correspondingEquipment or "", slot))
                TransmogArmor(data[character][slot], correspondingEquipment, character)
                RefreshCharacterArmorVisuals(_GE(character))
                return
            end
        end
    end
    RestoreOriginalArmorVisuals(_GE(equippedPiece))
    RefreshCharacterArmorVisuals(_GE(character))
end

---Restore mogged appearance after loading a save
function RestoreMoggedArmors()
    local modVars = GetModVariables()
    if modVars.Fallen_TmogInfos then
        local data = modVars.Fallen_TmogInfos
        for characterUUID, characterEquipments in pairs(data) do
            for slot, skin in pairs(characterEquipments) do
                local correspondingEquipment = Osi.GetEquippedItem(characterUUID, tostring(slot))
                local invisible = IsArmorSlotInvisible(slot, characterUUID)
                BasicDebug(string.format("armor piece : %s is %s",
                    correspondingEquipment or "", invisible))
                if correspondingEquipment and not invisible then
                    BasicDebug(string.format("Restoring appearance for armor piece : %s for slot : %s",
                        correspondingEquipment or "", slot))
                    TransmogArmor(skin, correspondingEquipment, characterUUID)
                elseif correspondingEquipment then
                    BasicDebug(string.format("Hiding appearance for armor piece : %s for slot : %s",
                        correspondingEquipment or "", slot))
                    HideArmorPiece(correspondingEquipment, characterUUID)
                end
            end
            RefreshCharacterArmorVisuals(_GE(characterUUID))
        end
    end
    if modVars.Fallen_TmogInfos_Invisibles then
        local data = modVars.Fallen_TmogInfos_Invisibles
        for characterUUID, characterEquipments in pairs(data) do
            for slot, invisibility in pairs(characterEquipments) do
                if invisibility then
                    local correspondingEquipment = Osi.GetEquippedItem(characterUUID, tostring(slot))
                    BasicDebug(string.format("Hiding appearance for armor piece : %s for slot : %s",
                        correspondingEquipment or "", slot))
                    HideArmorPiece(correspondingEquipment, characterUUID)
                end
            end
            RefreshCharacterArmorVisuals(_GE(characterUUID))
        end
    end
end

---Replicate ArmorSetsState to trigger a refresh of the armor visuals
---@param entity CharacterEntity?
function RefreshCharacterArmorVisuals(entity)
    if entity then
        if not entity.ArmorSetState then
            entity:CreateComponent("ArmorSetState")
        end
        entity:Replicate("ArmorSetState")
    end
end

---Clear existing armor visuals to prepare for copy
---@param RT GameObjectTemplate
function ClearVisuals(RT)
    RT.Equipment.Visuals = {}
    RT.Equipment.Slot = {}
    -- entity.ServerItem.Template.Equipment.Visuals = {}
    -- entity.ServerItem.Template.Equipment.Slot = {}
    -- for index, visuals in pairs(entity.ServerItem.Template.Equipment.Visuals) do
    --     entity.ServerItem.Template.Equipment.Visuals[index] = nil
    -- end
end

---Apply visuals from table
---@param RT GameObjectTemplate
---@param table table
---@param slots table
function ApplyVisualsFromTable(RT, table, slots)
    if table and RT then
        for index, subtable in pairs(table) do
            --RT.Equipment.Visuals[index] = Table.DeepCopy(subtable)
            RT.Equipment.Visuals[index] = Table.DeepCopy(subtable)
        end
    end
    if slots and RT then
        for index, slot in pairs(slots) do
            RT.Equipment.Slot[index] = slot
        end
    end
end

---Return true if slot is supposed to be invisible
---@param slot EQUIPMENTSLOT
---@param character GUIDSTRING
---@return boolean
function IsArmorSlotInvisible(slot, character)
    local modVars = GetModVariables()
    local invisTmogInfos = modVars.Fallen_TmogInfos_Invisibles and modVars.Fallen_TmogInfos_Invisibles[GUID(character)]
    if invisTmogInfos and invisTmogInfos[ArmorSlots[slot]] then
        return true
    end
    return false
end

--- Copy visuals from armor source to target
---@param target GUIDSTRING|ItemEntity?
---@param source GUIDSTRING|ItemEntity?
function CopyVisuals(target, source)
    if not target and not source then return end
    local targetEntity = type(target) == "string" and _GE(target) or target
    local sourceEntity = type(source) == "string" and _GE(source) or source
    ---@cast targetEntity ItemEntity
    ---@cast sourceEntity ItemEntity

    if targetEntity and sourceEntity then
        -- local sourceVisuals = sourceEntity.ServerItem.Template.Equipment.Visuals
        -- local sourceSlots = sourceEntity.ServerItem.Template.Equipment.Slot
        local sourceUUID = EntityToUuid(sourceEntity)
        local sourceRT = GetRootTemplateData(sourceUUID)
        local targetUUID = EntityToUuid(targetEntity)
        local targetRT = GetRootTemplateData(targetUUID)
        local sourceVisuals = sourceRT and sourceRT.Equipment.Visuals
        local sourceSlots = sourceRT and sourceRT.Equipment.Slot

        if targetEntity.ServerItem and targetEntity.ServerItem.Template and sourceVisuals and sourceSlots and targetRT then
            local serializedSourceVisualsCopy = Ext.Types.Serialize(sourceVisuals)
            local serializedSourceSlotsCopy = Ext.Types.Serialize(sourceSlots)
            ClearVisuals(targetRT)
            ApplyVisualsFromTable(targetRT, serializedSourceVisualsCopy, serializedSourceSlotsCopy)
            BasicDebug("Serialized source visuals copy: ")
            BasicDebug(serializedSourceVisualsCopy)
        end
    end
end
