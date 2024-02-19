local tmogConfig = {
    MOD_ENABLED = 1,
    DEBUG_MESSAGES = 3,
}

MOD_INFO=ModInfo:new("Fall_Tmog","Fall_Tmog",true,tmogConfig)

RegisterUserVariable("Fallen_TmogArmorOriginalVisuals")
RegisterUserVariable("Fallen_TmogArmorOriginalDye")
RegisterUserVariable("Fallen_OriginalWeaponInfos")
RegisterModVariable("Fallen_TmogInfos")
RegisterModVariable("Fallen_TmogInfos_Invisibles")