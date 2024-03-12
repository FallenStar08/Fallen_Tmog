local tmogConfig = {
    MOD_ENABLED = 1,
    DEBUG_MESSAGES = 3,
}

MOD_INFO=ModInfo:new("Fall_Tmog","Fall_Tmog",true,tmogConfig)


--Todo register them from lists automatically from modinfo at some point (ok it doesnt work fuck that)
UserVars={
    "Fallen_TmogArmorOriginalVisuals","Fallen_TmogArmorOriginalDye","Fallen_OriginalWeaponInfos","Fallen_TmogArmorOriginalSlots"
}

ModVars={
    "Fallen_TmogInfos","Fallen_TmogInfos_GivenItems","Fallen_TmogInfos_Invisibles"
}

--This whole fucking mod needs to be rewritten holy fuck
RegisterUserVariable("Fallen_TmogArmorOriginalVisuals")
RegisterUserVariable("Fallen_TmogArmorOriginalSlots")
RegisterUserVariable("Fallen_TmogArmorOriginalDye")
RegisterUserVariable("Fallen_OriginalWeaponInfos")
RegisterModVariable("Fallen_TmogInfos")
RegisterModVariable("Fallen_TmogInfos_GivenItems")
RegisterModVariable("Fallen_TmogInfos_Invisibles")

ModItemRoots = {
    ["ee9d149e-4558-4583-86f2-bd3dc01a034a"] = "armorBag",
    ["7c515100-55f6-4dde-b46a-78099db32ace"] = "weaponBag",
    ["0f6e837f-203c-4d9c-90de-4cd7c63d7337"] = "PotionInvisBreast",
    ["549690dc-8fbd-43f2-87c2-673212535587"] = "potionInvisBoots",
    ["b35dc03b-2224-4943-b060-3759033c8c6e"] = "potionInvisCloak",
    ["4cea80d0-cda3-4eb8-b483-a70256877a19"] = "potionInvisGloves",
    ["45e3e30c-75e0-452e-980d-6581f002a5af"] = "potionInvisMainHand",
    ["d573df23-4156-415d-abfb-6a14ca9c9402"] = "potionInvisOffHand"
}


Handles = {
    ["Boots_Description"] = "h1dcc962ag45cag4e4eg8e65g2db6b14c7eb6",
    ["Gloves_Description"] = "h95a0daafg3e8bg4127ga3b7gf2550fb5b414",
    ["Chest_Description"] = "h9adbd35agc653g4d85gb96dg2494ca4731a7",
    ["Cloak_Description"] = "h1f82547egb314g490dg89ddgecfaa929f680",
    ["MeleeMainHand_Description"] ="h7b5dfe6fgad75g4a89g9020gecbebd3ffd1c",
    ["MeleeOffHand_Description"] ="ha3cbd677gc7aag4a26g8f8fgc649d495bc24",
    ["Visible"] = "hc0011734gbfa1g4276g9f50gdc2c02c56832",
    ["Invisible"] = "h97fc23c6gf453g4950gb4f0gc5d9e44249f0"
}

SlotToDescriptionHandle={
    ["Breast"] = "Chest_Description",
    ["Boots"] = "Boots_Description",
    ["Cloak"] = "Cloak_Description",
    ["Gloves"] = "Gloves_Description",
    ["MeleeMainHand"] ="MeleeMainHand_Description",
    ["MeleeOffHand"] ="MeleeOffHand_Description",
}

--Potion template to corresponding slot to hide
HideSlots = {
    ["0f6e837f-203c-4d9c-90de-4cd7c63d7337"] = "Breast",
    ["549690dc-8fbd-43f2-87c2-673212535587"] = "Boots",
    ["b35dc03b-2224-4943-b060-3759033c8c6e"] = "Cloak",
    ["4cea80d0-cda3-4eb8-b483-a70256877a19"] = "Gloves",
    ["45e3e30c-75e0-452e-980d-6581f002a5af"] = "MeleeMainHand",
    ["d573df23-4156-415d-abfb-6a14ca9c9402"] = "MeleeOffHand"
}

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

--Slot type conversion
WeaponSlots = {
    ["MeleeMainHand"] = "Melee Main Weapon",
    ["MeleeOffHand"] = "Melee Offhand Weapon",
    ["RangedMainHand"] = "Ranged Main Weapon",
    ["RangedOffHand"] = "Ranged Offhand Weapon",
}

InvisibleShit = "7c7890a2-a135-409e-a92a-69629288485d"