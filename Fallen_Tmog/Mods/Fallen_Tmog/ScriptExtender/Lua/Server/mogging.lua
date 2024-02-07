RegisterUserVariable("Fallen_TmogArmorInfos")
RegisterUserVariable("Fallen_OriginalWeaponInfos")
RegisterModVariable("Fallen_TmogInfos")

TransmogCopyList = {
    "AttributeFlags",
    "Armor",
    "CanBeDisarmed",
    "CombatParticipant",
    "Data",
    "DisplayName",
    "Equipable",
    "ItemBoosts",
    "GameplayLight",
    "ObjectSize",
    "PassiveContainer",
    "StatusImmunities",
    "Tag",
    "TurnBased",
    "Use",
    "Value",
    "Weapon",
    "DisplayName",
    "Proficiency",
    "ProficiencyGroup"
}
-- -------------------------------------------------------------------------- --
--                                 WEAPON TMOG                                --
-- -------------------------------------------------------------------------- --
---comment
---@param itemEntity ItemEntity
local function replicateWeaponComponents(itemEntity)
    itemEntity:Replicate("GameObjectVisual")
end

---comment
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

---comment
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
---comment
---@param character GUIDSTRING
---@param armor GUIDSTRING
---@param equipmentSlot EQUIPMENTSLOT
function SaveArmorSkinInfoOnCharacter(character, armor, equipmentSlot)
    local modVars = GetModVariables()
    local data = {
        [GUID(character)] = {
            [equipmentSlot] = {

            }
        }
    }
    if not modVars.Fallen_TmogInfos then modVars.Fallen_TmogInfos = data end
    modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot] = { ["skin"] = GUID(armor) }
    BasicDebug(modVars.Fallen_TmogInfos)
    SyncModVariables()
end

function RemoveArmorSkinInfoOnCharacter(character, armor, equipmentSlot)
    local modVars = GetModVariables()
    if modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[GUID(character)] and modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot] and modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot].skin then
        modVars.Fallen_TmogInfos[GUID(character)][equipmentSlot] = nil
        SyncModVariables()
    end
end

---Delete mogged item, bring back real equipment piece and Equip it
---@param equippedItem GUIDSTRING
---@param skin GUIDSTRING
---@param bagOwnerUUID GUIDSTRING
---@param fromSkinRemoval boolean
function RestoreOldArmor(equippedItem, skin, bagOwnerUUID, fromSkinRemoval)
    local skinEntity = _GE(skin)
    local equippedEntity = _GE(equippedItem)
    if fromSkinRemoval then
        if equippedEntity and equippedEntity.Vars.Fallen_TmogArmorInfos.parentItem and equippedEntity.Vars.Fallen_TmogArmorInfos.skinItem then
            local parentItem = equippedEntity.Vars.Fallen_TmogArmorInfos.parentItem
            Osi.ToInventory(parentItem, bagOwnerUUID)
            equippedEntity.Vars.Fallen_TmogArmorInfos.parentItem = nil
            equippedEntity.Vars.Fallen_TmogArmorInfos.skinItem = nil
            equippedEntity.Vars.Fallen_TmogArmorInfos = nil
        end
    else
        if equippedEntity and equippedEntity.Vars.Fallen_TmogArmorInfos.parentItem and equippedEntity.Vars.Fallen_TmogArmorInfos.skinItem then
            local parentItem = equippedEntity.Vars.Fallen_TmogArmorInfos.parentItem
            Osi.RequestDelete(skinEntity.Vars.Fallen_TmogArmorInfos.moggingItem)
            Osi.ToInventory(parentItem, bagOwnerUUID)
            equippedEntity.Vars.Fallen_TmogArmorInfos.parentItem = nil
            equippedEntity.Vars.Fallen_TmogArmorInfos.skinItem = nil
            equippedEntity.Vars.Fallen_TmogArmorInfos = nil
        end
    end
    SyncUserVariables()
end

---Create a new armor using skin from skin and data from equippedPiece on char
---@param skin GUIDSTRING
---@param equippedPiece GUIDSTRING
---@param character GUIDSTRING
function TransmogArmorUltimateVersion(skin, equippedPiece, character)
    local skinEntity = _GE(skin)
    local equippedPieceEntity = _GE(equippedPiece)
    if skinEntity and equippedPieceEntity then
        local createdMogging = Osi.CreateAtObject(Osi.GetTemplate(tostring(EntityToUuid(skinEntity))), character, 0, 1,
            "", 0)
        local moggingEntity = _GE(createdMogging)
        if moggingEntity then
            DelayedCall(333, function()
                CopyEntityData(moggingEntity, equippedPieceEntity, TransmogCopyList)
                CopyStatuses(moggingEntity, equippedPieceEntity, 200)
                BasicDebug("Tmog, Created mog uuid : " .. createdMogging)
                Osi.Equip(character, createdMogging, 1, 0, 0)
                moggingEntity.Vars.Fallen_TmogArmorInfos = {
                    ["parentItem"] = GUID(equippedPiece),
                    ["skinItem"] = GUID(
                        skin)
                }
                skinEntity.Vars.Fallen_TmogArmorInfos = { ["moggingItem"] = GUID(createdMogging) }
                SyncUserVariables()
            end)
            DelayedCall(200, function() Osi.ToInventory(equippedPiece, NAKED_DUMMY_2) end)
        end
    end
end

---Restores item to its original state using store info in sessionModifiedItems
---@param itemEntity ItemEntity
function RestoreOriginalStateForItem(itemEntity)
    if itemEntity.Vars.Fallen_OriginalArmorInfos then
        local uuid = EntityToUuid(itemEntity)
        BasicDebug("Restoring item state for armor : " .. uuid)
        local data = itemEntity.Vars.Fallen_OriginalArmorInfos
        BasicDebug("Using the following data : " .. JSON.Stringify(data))
        if not data then return end
        itemEntity.Use.Boosts = {}
        itemEntity.Data.StatsId = data.StatsId
        itemEntity.ServerItem.Stats = data.StatsId
        itemEntity.ProficiencyGroup.field_0 = data.ProficiencyGroup.field_0
        for armorparam, value in pairs(itemEntity.Armor) do
            itemEntity.Armor[armorparam] = data.Armor[armorparam]
        end
        if data.Boosts ~= {} then
            for i, v in ipairs(data.Boosts) do
                for k, boostparam in pairs(v) do
                    if not itemEntity.Use.Boosts[i] then
                        itemEntity.Use.Boosts[i] = { ["Boost"] = "", ["Params"] = "", ["Params2"] = "" }
                    end
                    for paramName, value in pairs(boostparam) do
                        itemEntity.Use.Boosts[i][paramName] = value
                    end
                end
            end
        end
        --replicateArmorComponents(itemEntity)
    elseif itemEntity.Vars.Fallen_OriginalWeaponInfos then
        local uuid = EntityToUuid(itemEntity)
        BasicDebug("Restoring item state for weapon : " .. uuid)
        itemEntity.GameObjectVisual.RootTemplateId = itemEntity.Vars.Fallen_OriginalWeaponInfos.OriginalVisualId
        replicateWeaponComponents(itemEntity)
    end
end

function RestoreMoggedItems()
    if not PersistentVars.Tmoggeds then return end
    for characterUUID, characterEquipments in pairs(PersistentVars.Tmoggeds) do
        for slot, data in pairs(characterEquipments) do
            if ArmorSlots[slot] then
                --BasicDebug(type(slot))
                local correspondingEquipment = Osi.GetEquippedItem(characterUUID, slot)
                ApplyMoggedToItemFromPvar(_GE(correspondingEquipment), characterUUID, slot)
            elseif WeaponSlots[slot] then
                --BasicDebug(type(slot))
                local correspondingEquipment = Osi.GetEquippedItem(characterUUID, WeaponSlots[slot])
                ApplyMoggedToItemFromPvar(_GE(correspondingEquipment), characterUUID, slot)
            end
        end
    end
end

---comment
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
