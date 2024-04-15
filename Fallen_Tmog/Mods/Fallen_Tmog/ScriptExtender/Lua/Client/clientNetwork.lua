Ext.RegisterNetListener(CHANNELS["show"], function()
    IMGUI_WINDOW.Visible = true
end)

Ext.RegisterNetListener(CHANNELS["party"], function(_, payload)
    ClientGlobals["PARTY"] = JSON.Parse(payload)
    BasicPrint("Got Party info from server : ")
    BasicPrint(ClientGlobals["PARTY"])
    if not TMOG_MENU_GROUP then
        CreateTmogMenu(TMOG_TAB)
        ClientGlobals["FLAGS"]["PartyInitDone"] = true
    end
end)


---Send request to tmog item RT for Slot on character
---@param id GUIDSTRING
---@param slot string
---@param character GUIDSTRING
function SendTmogRequest(id, slot, character)
    Ext.Net.PostMessageToServer(CHANNELS["tmog"], JSON.Stringify({ Id = id, Slot = slot, Character = character }))
end
