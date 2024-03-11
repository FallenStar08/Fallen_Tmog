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
---@param armorEntity ItemEntity
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
---@param armorEntity ItemEntity
function RestoreOriginalArmorVisuals(armorEntity)
    restoreOriginalDyesForArmor(armorEntity)
    ApplyVisualsFromTable(armorEntity, armorEntity.Vars.Fallen_TmogArmorOriginalVisuals,armorEntity.Vars.Fallen_TmogArmorOriginalSlots)
end

---Handle the dyes stuff.
---@param skinEntity ItemEntity
---@param equippedPieceEntity ItemEntity
function HandleDyesForArmor(skinEntity, equippedPieceEntity)
    if equippedPieceEntity.ItemDye then
        local equippedPieceDye = equippedPieceEntity.ItemDye.Color
        --Save original dye
        equippedPieceEntity.Vars.Fallen_TmogArmorOriginalDye = equippedPieceDye
    else
        equippedPieceEntity:CreateComponent("ItemDye")
    end
    if skinEntity.ItemDye then
        local skinDye = skinEntity.ItemDye.Color
        equippedPieceEntity.ItemDye.Color = skinDye
        equippedPieceEntity:Replicate("ItemDye")
    end
    SyncUserVariables()
end

---Do the tmogging of the armor
---@param skin GUIDSTRING
---@param equippedPiece GUIDSTRING
---@param character GUIDSTRING
function TransmogArmorUltimateVersion(skin, equippedPiece, character)
    local skinEntity = _GE(skin)
    local equippedPieceEntity = _GE(equippedPiece)
    local originalInfos = Ext.Types.Serialize(equippedPieceEntity.ServerItem.Template.Equipment.Visuals)
    local originalSlotInfos = Ext.Types.Serialize(equippedPieceEntity.ServerItem.Template.Equipment.Slot)
    HandleDyesForArmor(skinEntity, equippedPieceEntity)
    SaveOriginalArmorInfos(equippedPieceEntity, originalInfos, originalSlotInfos)
    CopyVisuals(equippedPieceEntity, skinEntity)
    RefreshCharacterArmorVisuals(_GE(character))
end

function HideArmorPiece(equippedPiece, character)
    local equippedPieceEntity = _GE(equippedPiece)
    if equippedPieceEntity then
        local success, originalInfos = pcall(function() return Ext.Types.Serialize(equippedPieceEntity.ServerItem.Template
            .Equipment.Visuals) end)

        if success then
            SaveOriginalArmorInfos(equippedPieceEntity, originalInfos, Ext.Types.Serialize(equippedPieceEntity.ServerItem.Template
            .Equipment.Slot))
            ClearVisuals(equippedPieceEntity)
            RefreshCharacterArmorVisuals(_GE(character))
        else
            -- An error occurred, handle it appropriately
            BasicDebug("Equipment is either already invisible (tmog ring) or bad, probably bad")
        end
    end
end

function RestoreArmorVisibility(equippedPiece,slot,character)
    local modVars=GetModVariables()
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
                TransmogArmorUltimateVersion(data[character][slot], correspondingEquipment, character)
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
                local invisible=IsArmorSlotInvisible(slot, characterUUID)
                BasicDebug(string.format("armor piece : %s is %s",
                correspondingEquipment or "", invisible))
                if correspondingEquipment and not invisible then
                    BasicDebug(string.format("Restoring appearance for armor piece : %s for slot : %s",
                        correspondingEquipment or "", slot))
                    TransmogArmorUltimateVersion(skin, correspondingEquipment, characterUUID)
                    RefreshCharacterArmorVisuals(_GE(characterUUID))
                elseif correspondingEquipment then
                    BasicDebug(string.format("Hiding appearance for armor piece : %s for slot : %s",
                    correspondingEquipment or "", slot))
                    HideArmorPiece(correspondingEquipment, characterUUID)
                    RefreshCharacterArmorVisuals(_GE(characterUUID))
                end
            end
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
                    RefreshCharacterArmorVisuals(_GE(characterUUID))
                end
            end
        end
    end
end

---Replicate ArmorSetsState to trigger a refresh of the armor visuals
---@param entity CharacterEntity
function RefreshCharacterArmorVisuals(entity)
    if not entity.ArmorSetState then
        entity:CreateComponent("ArmorSetState")
    end
    entity:Replicate("ArmorSetState")
end

---Clear existing armor visuals to prepare for copy
---@param entity ItemEntity
function ClearVisuals(entity)
    entity.ServerItem.Template.Equipment.Visuals={}
    entity.ServerItem.Template.Equipment.Slot={}
    -- for index, visuals in pairs(entity.ServerItem.Template.Equipment.Visuals) do
    --     entity.ServerItem.Template.Equipment.Visuals[index] = nil
    -- end
end

---Apply visuals from table
---@param entity ItemEntity
---@param table table
---@param slots table
function ApplyVisualsFromTable(entity, table, slots)
    if table and entity then
        for index, subtable in pairs(table) do
            entity.ServerItem.Template.Equipment.Visuals[index] = Table.DeepCopy(subtable)
        end
    end
    if slots and entity then
        for index, slot in pairs(slots) do
            entity.ServerItem.Template.Equipment.Slot[index] = slot
        end
    end
end

---Return true if slot is supposed to be invisible
---@param slot EQUIPMENTSLOT
---@param character GUIDSTRING
---@return boolean
function IsArmorSlotInvisible(slot,character)
    local modVars = GetModVariables()
    local invisTmogInfos = modVars.Fallen_TmogInfos_Invisibles and modVars.Fallen_TmogInfos_Invisibles[GUID(character)]
    if invisTmogInfos and invisTmogInfos[ArmorSlots[slot]] then
        return true
    end
    return false
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
        local sourceSlots = sourceEntity.ServerItem.Template.Equipment.Slot
        local serializedSourceVisualsCopy = Ext.Types.Serialize(sourceVisuals)
        local serializedSourceSlotsCopy = Ext.Types.Serialize(sourceSlots)
        BasicDebug("serializedSourceVisualsCopy : ")
        BasicDebug(serializedSourceVisualsCopy)
        ClearVisuals(targetEntity)
        --Ext.Types.Unserialize(targetEntity.ServerItem.Template.Equipment.Visuals,serializedSourceVisualsCopy)
        ApplyVisualsFromTable(targetEntity, serializedSourceVisualsCopy, serializedSourceSlotsCopy)
    else
        local sourceSlots = source.ServerItem.Template.Equipment.Slot
        local serializedSourceSlotsCopy = Ext.Types.Serialize(sourceSlots)
        local sourceVisuals = source.ServerItem.Template.Equipment.Visuals
        local serializedSourceVisualsCopy = Ext.Types.Serialize(sourceVisuals)
        BasicDebug("serializedSourceVisualsCopy : ")
        BasicDebug(serializedSourceVisualsCopy)
        ClearVisuals(target)
        --Ext.Types.Unserialize(target.ServerItem.Template.Equipment.Visuals,serializedSourceVisualsCopy)
        ApplyVisualsFromTable(target, serializedSourceVisualsCopy,serializedSourceSlotsCopy)
    end
end
