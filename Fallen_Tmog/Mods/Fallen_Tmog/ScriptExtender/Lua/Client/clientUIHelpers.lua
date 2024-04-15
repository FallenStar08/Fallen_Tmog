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

function CreatePartyTabGroup(windowOrTab)
    local PARTY_TAB_BAR = {}
    PARTY_TAB_BAR["TABS"] = PARTY_TAB_BAR["TABS"] or {}
    PARTY_TAB_BAR["TAB_BAR"] = windowOrTab:AddTabBar("party")
    local party = ClientGlobals["PARTY"] or {}
    for index, member in ipairs(party) do
        local tab = PARTY_TAB_BAR["TAB_BAR"]:AddTabItem(member)
        table.insert(PARTY_TAB_BAR["TABS"], tab)
        CreateTmogMenu(tab)
    end
    return PARTY_TAB_BAR
end

function SendTmogRequest(Id, Slot)
    Ext.Net.PostMessageToServer(CHANNELS["tmog"], JSON.Stringify({ Id = Id, Slot = Slot }))
end

function CreateTmogMenu(tab)
    local slotSelection = tab:AddCombo("slotSelection")
    local slotOptions = {}
    for _, v in pairs(ArmorSlots) do
        table.insert(slotOptions, v)
    end
    slotSelection.Options = slotOptions

    local clearButton = tab:AddButton("clearSlot")
    clearButton.SameLine = true
    --slotSelection:SetStyle("ItemSpacing", 10)
    local skinSelection = tab:AddCombo("skinSelection")
    getAllRTsInfos()
    skinSelection.Options = ClientGlobals["ArmorNames"]
    local applyButton = tab:AddButton("applySkin")
    applyButton.SameLine = true

    applyButton.OnClick = function()
        local skinIndex = skinSelection.SelectedIndex + 1
        _D(skinSelection.Options[skinIndex])
        local id = FindRTbyName(skinSelection.Options[skinIndex])
        local slotIndex = slotSelection.SelectedIndex + 1
        SendTmogRequest(id, slotSelection.Options[slotIndex])
    end
end
