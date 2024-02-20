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
function SaveOriginalArmorInfos(armorEntity, infoTable)
    if armorEntity then
        if armorEntity.Vars.Fallen_TmogArmorOriginalVisuals then
            BasicDebug(string.format("Armor visual infos already saved for %s!",
                GetTranslatedName(EntityToUuid(armorEntity) or "")))
            return
        end
        BasicDebug(string.format("Saved new original armor visual infos for armor %s!",
            GetTranslatedName(EntityToUuid(armorEntity) or "")))
        armorEntity.Vars.Fallen_TmogArmorOriginalVisuals = Ext.Types.Serialize(infoTable)
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
    ApplyVisualsFromTable(armorEntity, armorEntity.Vars.Fallen_TmogArmorOriginalVisuals)
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
    local originalInfos = Table.DeepCopy(equippedPieceEntity.ServerItem.Template.Equipment.Visuals)
    HandleDyesForArmor(skinEntity, equippedPieceEntity)
    SaveOriginalArmorInfos(equippedPieceEntity, originalInfos)
    CopyVisuals(equippedPieceEntity, skinEntity)
    RefreshCharacterArmorVisuals(_GE(character))
end

function HideArmorPiece(equippedPiece, character)
    local equippedPieceEntity = _GE(equippedPiece)
    if equippedPieceEntity then
        local success, originalInfos = pcall(function() return Table.DeepCopy(equippedPieceEntity.ServerItem.Template
            .Equipment.Visuals) end)

        if success then
            SaveOriginalArmorInfos(equippedPieceEntity, originalInfos)
            ClearVisuals(equippedPieceEntity)
            RefreshCharacterArmorVisuals(_GE(character))
        else
            -- An error occurred, handle it appropriately
            BasicDebug("Equipment is either already invisible (tmog ring) or bad, probably bad")
        end
        --local originalInfos = Table.DeepCopy(equippedPieceEntity.ServerItem.Template.Equipment.Visuals)
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
    for index, visuals in pairs(entity.ServerItem.Template.Equipment.Visuals) do
        entity.ServerItem.Template.Equipment.Visuals[index] = {}
    end
end

---Apply visuals from table
---@param entity ItemEntity
---@param table table
function ApplyVisualsFromTable(entity, table)
    if table and entity then
        for index, subtable in pairs(table) do
            entity.ServerItem.Template.Equipment.Visuals[index] = Table.DeepCopy(subtable)
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
