local function sendPartyInfo()
    local partyStuff = {}
    for _, member in pairs(GetSquadies()) do
        partyStuff[member] = Ext.Loca.GetTranslatedString(Osi.GetDisplayName(member))
    end
    Fprint("Sending party info to channel %s", CHANNELS["party"])
    local payload = JSON.Stringify(partyStuff)
    Ext.Net.BroadcastMessage(CHANNELS["party"], payload)
end


local function sendInitialInfos()
    sendPartyInfo()
end

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", sendInitialInfos)
Ext.Events.ResetCompleted:Subscribe(sendInitialInfos)

Ext.RegisterNetListener(CHANNELS["party"], function()
    --BasicPrint("Answering party info request from client")
    sendPartyInfo()
end)

Ext.RegisterNetListener(CHANNELS["tmog"], function(_, payload)
    payload = JSON.Parse(payload)
    local skinRT = payload.Id
    local host = Osi.GetHostCharacter()
    local equippedItem = Osi.GetEquippedItem(host, ArmorSlots[payload.Slot])
    local equippedItemRT = GUID(Osi.GetTemplate(equippedItem))
    if equippedItemRT then
        TransmogArmorNetwork(skinRT, equippedItemRT)
    end
end)
