ClientGlobals = ClientGlobals or {}

local IMGUI_WINDOW = Ext.IMGUI.NewWindow("Fallen's TMOGGER")
IMGUI_WINDOW.Closeable = true
IMGUI_WINDOW.Visible = true

local TAB_BAR = IMGUI_WINDOW:AddTabBar("general")
local TMOG_TAB = TAB_BAR:AddTabItem("Tmog")
local DYE_TAB = TAB_BAR:AddTabItem("Dyes")
local Hide_TAB = TAB_BAR:AddTabItem("Hide")

function getAllRTsInfos()
    local RTs = Ext.Template.GetAllRootTemplates()

    for _, RT in pairs(RTs) do
        local type = RT.TemplateType
        if not type == "item" then return end
        local templateID = RT.Id
        local visuals = SafeGetField(RT, "Equipment.Visuals")
        local slots = SafeGetField(RT, "Equipment.Slot")
        local name = Ext.Loca.GetTranslatedString(SafeGetField(RT, "DisplayName.Handle.Handle") or "")
        if visuals then
            ClientGlobals["Armors"] = ClientGlobals["Armors"] or {}
            ClientGlobals["Armors"][templateID] = { ["visuals"] = visuals, ["slots"] = slots, ["name"] = name }
        end
    end

    table.sort(ClientGlobals["Armors"], function(a, b) return a.name < b.name end)

    for k, v in pairs(ClientGlobals["Armors"]) do
        ClientGlobals["ArmorNames"] = ClientGlobals["ArmorNames"] or {}
        table.insert(ClientGlobals["ArmorNames"], v.name)
    end
end

function FindRTbyName(rtName)
    for id, entry in pairs(ClientGlobals["Armors"]) do
        if entry.name == rtName then
            return id
        end
    end
end

-- Slots = {}
-- for _, entry in pairs(ClientGlobals["Armors"]) do
--     for _, slot in pairs(entry.slots) do
--         Slots[slot] = true
--     end
-- end

-- _D(Slots)



-- _D(RTVisuals)
TMOG_TAB.OnActivate = function()
    Ext.Net.PostMessageToServer(CHANNELS["party"], "")
end

Ext.RegisterNetListener(CHANNELS["show"], function()
    IMGUI_WINDOW.Visible = true
end)

Ext.RegisterNetListener(CHANNELS["party"], function(_, payload)
    ClientGlobals["PARTY"] = JSON.Parse(payload)
    PARTY_TAB_BAR = CreatePartyTabGroup(TMOG_TAB)
end)
