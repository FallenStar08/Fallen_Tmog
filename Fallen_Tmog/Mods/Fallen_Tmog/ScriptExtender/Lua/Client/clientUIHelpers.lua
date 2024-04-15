--Slot conversion for vanity
ArmorSlots = {
    ["Breast"] = "Breast",
    ["Boots"] = "Boots",
    ["Cloak"] = "Cloak",
    ["Gloves"] = "Gloves",
    ["Helmet"] = "Helmet",
    ["Underwear"] = "Underwear",
    ["VanityBody"] = "Breast",
    ["VanityBoots"] = "Boots",
}

--Slot conversion for camp bag
CampSlots = {
    ["VanityBody"] = "VanityBody",
    ["VanityBoots"] = "VanityBoots",
    ["Breast"] = "VanityBody",
    ["Boots"] = "VanityBoots"
}

function GetAllRTsInfos()
    local RTs = Ext.Template.GetAllRootTemplates()

    for _, RT in pairs(RTs) do
        local type = RT.TemplateType
        local templateID = RT.Id
        local visuals = SafeGetField(RT, "Equipment.Visuals")
        local slots = SafeGetField(RT, "Equipment.Slot")
        local name = Ext.Loca.GetTranslatedString(SafeGetField(RT, "DisplayName.Handle.Handle") or "")
        if visuals and slots and next(Ext.Types.Serialize(slots)) and type == "item" and not StringEmpty(name) then
            ClientGlobals["Armors"] = ClientGlobals["Armors"] or {}
            ClientGlobals["Armors"][templateID] = { ["visuals"] = visuals, ["slots"] = slots, ["name"] = name }
        end
    end



    for k, v in pairs(ClientGlobals["Armors"]) do
        ClientGlobals["ArmorNames"] = ClientGlobals["ArmorNames"] or {}
        table.insert(ClientGlobals["ArmorNames"], v.name)
    end

    table.sort(ClientGlobals["ArmorNames"], function(a, b) return a < b end)
end

function FindRTbyName(rtName)
    for id, entry in pairs(ClientGlobals["Armors"]) do
        if entry.name == rtName then
            return id, entry.slot
        end
    end
end

function CreateTmogMenu(tab)
    TMOG_MENU_GROUP = tab:AddGroup("TMOG_MENU_GROUP")
    GetAllRTsInfos()

    local charSelection = tab:AddCombo("charSelection")
    local charOptions = {}
    for memberUUID, memberName in pairs(ClientGlobals["PARTY"]) do
        table.insert(charOptions, memberName)
    end

    charSelection.Options = charOptions
    -- ------------------------------- SLOT SELECT ------------------------------ --
    local slotSelection = tab:AddCombo("slotSelection")
    local slotOptions = {}
    for k, v in pairs(ArmorSlots) do
        table.insert(slotOptions, k)
    end
    slotSelection.Options = slotOptions
    -- ------------------------------ CLEAR BUTTON ------------------------------ --
    local clearButton = tab:AddButton("clearSlot")
    clearButton.SameLine = true

    -- ------------------------------- SKIN SELECT ------------------------------ --
    local skinSelection = tab:AddCombo("skinSelection")
    skinSelection.Options = ClientGlobals["ArmorNames"]

    -- ------------------------------ APPLY BUTTON ------------------------------ --
    local applyButton = tab:AddButton("applySkin")
    applyButton.SameLine = true
    applyButton.OnClick = function()
        local skinIndex = skinSelection.SelectedIndex + 1
        local id, slot = FindRTbyName(skinSelection.Options[skinIndex])
        _D(slot)
        local slotIndex = slotSelection.SelectedIndex + 1
        SendTmogRequest(id, slotSelection.Options[slotIndex], ClientGlobals["SelectedCharacter"])
    end
end
