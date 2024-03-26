-- -------------------------------------------------------------------------- --
--                                 WEAPON TMOG                                --
-- -------------------------------------------------------------------------- --
---Stuff to replicate on weapons
---@param itemEntity ItemEntity
local function replicateWeaponComponents(itemEntity)
    itemEntity:Replicate("GameObjectVisual")
end

---@param itemSkin ItemEntity|GUIDSTRING
---@param character GUIDSTRING
---@param equipmentSlot EQUIPMENTSLOT
function SaveWeaponInfosToModVars(itemSkin, character, equipmentSlot)
    local modVars = GetModVariables()
    local skinId = type(itemSkin) == "string" and itemSkin or itemSkin.GameObjectVisual.RootTemplateId
    if not modVars.Fallen_TmogInfos then modVars.Fallen_TmogInfos = {} end
    if not modVars.Fallen_TmogInfos[character] then modVars.Fallen_TmogInfos[character] = {} end
    modVars.Fallen_TmogInfos[GUID(character)][tostring(equipmentSlot)] = skinId
    SyncModVariables()
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
---Restores weapon item to its original state using stored infos
---@param itemEntity ItemEntity
function RestoreOriginalWeaponVisuals(itemEntity, cleanVars)
    if itemEntity.Vars.Fallen_OriginalWeaponInfos then
        local uuid = EntityToUuid(itemEntity)
        BasicDebug("Restoring item state for weapon : " .. uuid)
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
                    BasicDebug(string.format("Restoring appearance for weapon : %s for slot : %s Osislot : %s",
                        correspondingEquipment or "", slot, WeaponSlots[slot]))
                    TransmogWeapon(correspondingEquipment, skin, characterUUID, true)
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
    local itemToReskin = _GE(itemInUse)
    if not itemToReskin then return end

    if not fromVars then
        local itemSkin = _GE(skin)
        if not itemSkin then return end

        saveOriginalWeaponInfos(itemToReskin)
        itemToReskin.GameObjectVisual.RootTemplateId = itemSkin.GameObjectVisual.RootTemplateId
    else
        saveOriginalWeaponInfos(itemToReskin)
        itemToReskin.GameObjectVisual.RootTemplateId = skin
    end

    replicateWeaponComponents(itemToReskin)
    RefreshCharacterArmorVisuals(_GE(character))
end

---Return true if appearance is the invisible shit
---@param slot EQUIPMENTSLOT
---@param character GUIDSTRING
---@return boolean
function IsWeaponInvisible(slot, character)
    local modVars = GetModVariables()
    local weaponMogging = modVars.Fallen_TmogInfos and modVars.Fallen_TmogInfos[character]
    if weaponMogging and weaponMogging[slot] == InvisibleShit then
        return true
    else
        return false
    end
end
