ClientGlobals = ClientGlobals or {}
ClientGlobals["FLAGS"] = ClientGlobals["FLAGS"] or {}
ClientGlobals["FLAGS"]["PartyInitDone"] = false
IMGUI_WINDOW = Ext.IMGUI.NewWindow("Fallen's TMOGGER")
IMGUI_WINDOW.Closeable = true
IMGUI_WINDOW.Visible = true

TAB_BAR = IMGUI_WINDOW:AddTabBar("general")
TMOG_TAB = TAB_BAR:AddTabItem("Tmog")
DYE_TAB = TAB_BAR:AddTabItem("Dyes")
HIDE_TAB = TAB_BAR:AddTabItem("Hide")



TMOG_TAB.OnActivate = function()
    Ext.Net.PostMessageToServer(CHANNELS["party"], "")
end
