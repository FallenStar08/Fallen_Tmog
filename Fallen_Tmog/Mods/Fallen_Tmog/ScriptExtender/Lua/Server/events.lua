EVENTS={
	["Activated"] = {
		"object",
	},
	["ActorSpeakerIndexChanged"] = {
		"instanceID",
		"player",
		"oldIndex",
		"newIndex",
	},
	["AddedTo"] = {
		"object",
		"inventoryHolder",
		"addType",
	},
	["AllLoadedFlagsInPresetReceivedEvent"] = {
		"",
	},
	["AnimationEvent"] = {
		"object",
		"eventName",
		"wasFromLoad",
	},
	["AppearTeleportFailed"] = {
		"character",
		"appearEvent",
	},
	["ApprovalRatingChangeAttempt"] = {
		"ratingOwner",
		"ratedEntity",
		"attemptedApprovalChange",
		"clampedApprovalChange",
		"newApproval",
	},
	["ApprovalRatingChanged"] = {
		"ratingOwner",
		"ratedEntity",
		"newApproval",
	},
	["ArmedTrapUsed"] = {
		"character",
		"item",
	},
	["ArmorSetChanged"] = {
		"character",
		"eArmorSet",
	},
	["AttachedToPartyGroup"] = {
		"character",
	},
	["AttackedBy"] = {
		"defender",
		"attackerOwner",
		"attacker2",
		"damageType",
		"damageAmount",
		"damageCause",
		"storyActionID",
	},
	["AttemptedDisarm"] = {
		"disarmableItem",
		"character",
		"itemUsedToDisarm",
		"bool",
	},
	["AutomatedDialogEnded"] = {
		"dialog",
		"instanceID",
	},
	["AutomatedDialogForceStopping"] = {
		"dialog",
		"instanceID",
	},
	["AutomatedDialogRequestFailed"] = {
		"dialog",
		"instanceID",
	},
	["AutomatedDialogStarted"] = {
		"dialog",
		"instanceID",
	},
	["BackgroundGoalFailed"] = {
		"character",
		"goal",
	},
	["BackgroundGoalRewarded"] = {
		"character",
		"goal",
	},
	["BaseFactionChanged"] = {
		"target",
		"oldFaction",
		"newFaction",
	},
	["CameraReachedNode"] = {
		"spline",
		"character",
		"event",
		"index",
		"last",
	},
	["CanBeLootedCapabilityChanged"] = {
		"lootingTarget",
		"canBeLooted",
	},
	["CastSpell"] = {
		"caster",
		"spell",
		"spellType",
		"spellElement",
		"storyActionID",
	},
	["CastSpellFailed"] = {
		"caster",
		"spell",
		"spellType",
		"spellElement",
		"storyActionID",
	},
	["CastedSpell"] = {
		"caster",
		"spell",
		"spellType",
		"spellElement",
		"storyActionID",
	},
	["ChangeAppearanceCancelled"] = {
		"character",
	},
	["ChangeAppearanceCompleted"] = {
		"character",
	},
	["CharacterCreationFinished"] = {
		"",
	},
	["CharacterCreationStarted"] = {
		"",
	},
	["CharacterDisarmed"] = {
		"character",
		"item",
		"slotName",
	},
	["CharacterJoinedParty"] = {
		"character",
	},
	["CharacterLeftParty"] = {
		"character",
	},
	["CharacterLoadedInPreset"] = {
		"character",
	},
	["CharacterLootedCharacter"] = {
		"player",
		"lootedCharacter",
	},
	["CharacterMadePlayer"] = {
		"character",
	},
	["CharacterMoveFailedUseJump"] = {
		"character",
	},
	["CharacterMoveToAndTalkFailed"] = {
		"character",
		"target",
		"moveID",
		"failureReason",
	},
	["CharacterMoveToAndTalkRequestDialog"] = {
		"character",
		"target",
		"dialog",
		"moveID",
	},
	["CharacterMoveToCancelled"] = {
		"character",
		"moveID",
	},
	["CharacterOnCrimeSensibleActionNotification"] = {
		"character",
		"crimeRegion",
		"crimeID",
		"priortiyName",
		"primaryDialog",
		"criminal1",
		"criminal2",
		"criminal3",
		"criminal4",
		"isPrimary",
	},
	["CharacterPickpocketFailed"] = {
		"player",
		"npc",
	},
	["CharacterPickpocketSuccess"] = {
		"player",
		"npc",
		"item",
		"itemTemplate",
		"amount",
		"goldValue",
	},
	["CharacterReservedUserIDChanged"] = {
		"character",
		"oldUserID",
		"newUserID",
	},
	["CharacterSelectedAsBestUnavailableFallbackLead"] = {
		"character",
		"crimeRegion",
		"unavailableForCrimeID",
		"busyCrimeID",
	},
	["CharacterSelectedClimbOn"] = {
		"character",
	},
	["CharacterSelectedForUser"] = {
		"character",
		"userID",
	},
	["CharacterStoleItem"] = {
		"character",
		"item",
		"itemRootTemplate",
		"x",
		"y",
		"z",
		"oldOwner",
		"srcContainer",
		"amount",
		"goldValue",
	},
	["CharacterTagEvent"] = {
		"character",
		"tag",
		"event",
	},
	["Closed"] = {
		"item",
	},
	["CombatEnded"] = {
		"combatGuid",
	},
	["CombatPaused"] = {
		"combatGuid",
	},
	["CombatResumed"] = {
		"combatGuid",
	},
	["CombatRoundStarted"] = {
		"combatGuid",
		"round",
	},
	["CombatStarted"] = {
		"combatGuid",
	},
	["Combined"] = {
		"item1",
		"item2",
		"item3",
		"item4",
		"item5",
		"character",
		"newItem",
	},
	["CompanionSelectedForUser"] = {
		"character",
		"userID",
	},
	["CreditsEnded"] = {
		"",
	},
	["CrimeDisabled"] = {
		"character",
		"crime",
	},
	["CrimeEnabled"] = {
		"character",
		"crime",
	},
	["CrimeIsRegistered"] = {
		"victim",
		"crimeType",
		"crimeID",
		"evidence",
		"criminal1",
		"criminal2",
		"criminal3",
		"criminal4",
	},
	["CrimeProcessingStarted"] = {
		"crimeID",
		"actedOnImmediately",
	},
	["CriticalHitBy"] = {
		"defender",
		"attackOwner",
		"attacker",
		"storyActionID",
	},
	["CustomBookUIClosed"] = {
		"character",
		"bookName",
	},
	["DLCUpdated"] = {
		"dlc",
		"userID",
		"installed",
	},
	["Deactivated"] = {
		"object",
	},
	["DeathSaveStable"] = {
		"character",
	},
	["DestroyedBy"] = {
		"item",
		"destroyer",
		"destroyerOwner",
		"storyActionID",
	},
	["DestroyingBy"] = {
		"item",
		"destroyer",
		"destroyerOwner",
		"storyActionID",
	},
	["DetachedFromPartyGroup"] = {
		"character",
	},
	["DialogActorJoinFailed"] = {
		"dialog",
		"instanceID",
		"actor",
	},
	["DialogActorJoined"] = {
		"dialog",
		"instanceID",
		"actor",
		"speakerIndex",
	},
	["DialogActorLeft"] = {
		"dialog",
		"instanceID",
		"actor",
		"instanceEnded",
	},
	["DialogAttackRequested"] = {
		"target",
		"player",
	},
	["DialogEnded"] = {
		"dialog",
		"instanceID",
	},
	["DialogForceStopping"] = {
		"dialog",
		"instanceID",
	},
	["DialogRequestFailed"] = {
		"dialog",
		"instanceID",
	},
	["DialogRollResult"] = {
		"character",
		"success",
		"dialog",
		"isDetectThoughts",
		"criticality",
	},
	["DialogStartRequested"] = {
		"target",
		"player",
	},
	["DialogStarted"] = {
		"dialog",
		"instanceID",
	},
	["DialogueCapabilityChanged"] = {
		"character",
		"isEnabled",
	},
	["Died"] = {
		"character",
	},
	["DifficultyChanged"] = {
		"difficultyLevel",
	},
	["DisappearOutOfSightToCancelled"] = {
		"character",
		"moveID",
	},
	["DoorTemplateClosing"] = {
		"itemTemplate",
		"item2",
		"character",
	},
	["DownedChanged"] = {
		"character",
		"isDowned",
	},
	["DroppedBy"] = {
		"object",
		"mover",
	},
	["DualEntityEvent"] = {
		"object1",
		"object2",
		"event",
	},
	["Dying"] = {
		"character",
	},
	["EndTheDayRequested"] = {
		"character",
	},
	["EnterCombatFailed"] = {
		"opponentLeft",
		"opponentRight",
	},
	["EnteredChasm"] = {
		"object",
		"cause",
		"chasm",
		"fallbackPosX",
		"fallbackPosY",
		"fallbackPosZ",
	},
	["EnteredCombat"] = {
		"object",
		"combatGuid",
	},
	["EnteredForceTurnBased"] = {
		"object",
	},
	["EnteredLevel"] = {
		"object",
		"objectRootTemplate",
		"level",
	},
	["EnteredSharedForceTurnBased"] = {
		"object",
		"zoneId",
	},
	["EnteredTrigger"] = {
		"character",
		"trigger",
	},
	["EntityEvent"] = {
		"object",
		"event",
	},
	["EquipFailed"] = {
		"item",
		"character",
	},
	["Equipped"] = {
		"item",
		"character",
	},
	["EscortGroupLeaderChanged"] = {
		"oldLeader",
		"newLeader",
		"group",
	},
	["FailedToLoadItemInPreset"] = {
		"character",
		"originalItem",
		"level",
		"newItem",
	},
	["Falling"] = {
		"entity",
		"cause",
	},
	["Fell"] = {
		"entity",
		"cause",
	},
	["FlagCleared"] = {
		"flag",
		"speaker",
		"dialogInstance",
	},
	["FlagLoadedInPresetEvent"] = {
		"object",
		"flag",
	},
	["FlagSet"] = {
		"flag",
		"speaker",
		"dialogInstance",
	},
	["FleeFromCombat"] = {
		"participant",
		"combatGuid",
	},
	["FollowerCantUseItem"] = {
		"character",
	},
	["ForceDismissCompanion"] = {
		"companion",
	},
	["ForceMoveEnded"] = {
		"source",
		"target",
		"storyActionID",
	},
	["ForceMoveStarted"] = {
		"source",
		"target",
		"storyActionID",
	},
	["GainedControl"] = {
		"target",
	},
	["GameBookInterfaceClosed"] = {
		"item",
		"character",
	},
	["GameModeStarted"] = {
		"gameMode",
		"isEditorMode",
		"isStoryReload",
	},
	["GameOption"] = {
		"key",
		"value",
	},
	["GoldChanged"] = {
		"inventoryHolder",
		"changeAmount",
	},
	["GotUp"] = {
		"target",
	},
	["HappyWithDeal"] = {
		"character",
		"trader",
		"characterValue",
		"traderValue",
	},
	["HenchmanAborted"] = {
		"player",
	},
	["HenchmanSelected"] = {
		"player",
		"hireling",
	},
	["HitProxy"] = {
		"proxy",
		"target",
		"attackerOwner",
		"attacker2",
		"storyActionID",
	},
	["HitpointsChanged"] = {
		"entity",
		"percentage",
	},
	["InstanceDialogChanged"] = {
		"instanceID",
		"oldDialog",
		"newDialog",
		"oldDialogStopping",
	},
	["InteractionCapabilityChanged"] = {
		"character",
		"isEnabled",
	},
	["InteractionFallback"] = {
		"character",
		"item",
	},
	["InventoryBoundChanged"] = {
		"item",
		"isBoundToInventory",
	},
	["InventorySharingChanged"] = {
		"character",
		"sharingEnabled",
	},
	["ItemEnteredTrigger"] = {
		"item",
		"trigger",
		"mover",
	},
	["ItemLeftTrigger"] = {
		"item",
		"trigger",
		"mover",
	},
	["ItemTeleported"] = {
		"target",
		"oldX",
		"oldY",
		"oldZ",
		"newX",
		"newY",
		"newZ",
	},
	["KilledBy"] = {
		"defender",
		"attackOwner",
		"attacker",
		"storyActionID",
	},
	["LearnedSpell"] = {
		"character",
		"spell",
	},
	["LeftCombat"] = {
		"object",
		"combatGuid",
	},
	["LeftForceTurnBased"] = {
		"object",
	},
	["LeftLevel"] = {
		"object",
		"level",
	},
	["LeftTrigger"] = {
		"character",
		"trigger",
	},
	["LevelGameplayStarted"] = {
		"levelName",
		"isEditorMode",
	},
	["LevelLoaded"] = {
		"newLevel",
	},
	["LevelTemplateLoaded"] = {
		"levelTemplate",
	},
	["LevelUnloading"] = {
		"level",
	},
	["LeveledUp"] = {
		"character",
	},
	["LongRestCancelled"] = {
		"",
	},
	["LongRestFinished"] = {
		"",
	},
	["LongRestStartFailed"] = {
		"",
	},
	["LongRestStarted"] = {
		"",
	},
	["LostSightOf"] = {
		"character",
		"targetCharacter",
	},
	["MainPerformerStarted"] = {
		"character",
		"event",
	},
	["MessageBoxChoiceClosed"] = {
		"character",
		"message",
		"resultChoice",
	},
	["MessageBoxClosed"] = {
		"character",
		"message",
	},
	["MessageBoxYesNoClosed"] = {
		"character",
		"message",
		"result",
	},
	["MissedBy"] = {
		"defender",
		"attackOwner",
		"attacker",
		"storyActionID",
	},
	["ModuleLoadedinSavegame"] = {
		"name",
		"major",
		"minor",
		"revision",
		"build",
	},
	["MoveCapabilityChanged"] = {
		"character",
		"isEnabled",
	},
	["Moved"] = {
		"item",
	},
	["MovedBy"] = {
		"movedEntity",
		"character",
	},
	["MovedFromTo"] = {
		"movedObject",
		"fromObject",
		"toObject",
		"isTrade",
	},
	["MovieFinished"] = {
		"movieName",
	},
	["MoviePlaylistFinished"] = {
		"movieName",
	},
	["NestedDialogPlayed"] = {
		"dialog",
		"instanceID",
	},
	["ObjectAvailableLevelChanged"] = {
		"character",
		"oldLevel",
		"newLevel",
	},
	["ObjectTimerFinished"] = {
		"object",
		"timer",
	},
	["ObjectTransformed"] = {
		"object",
		"toTemplate",
	},
	["ObscuredStateChanged"] = {
		"object",
		"obscuredState",
	},
	["OnCrimeConfrontationDone"] = {
		"crimeID",
		"investigator",
		"wasLead",
		"criminal1",
		"criminal2",
		"criminal3",
		"criminal4",
	},
	["OnCrimeInvestigatorSwitchedState"] = {
		"crimeID",
		"investigator",
		"fromState",
		"toState",
	},
	["OnCrimeMergedWith"] = {
		"oldCrimeID",
		"newCrimeID",
	},
	["OnCrimeRemoved"] = {
		"crimeID",
		"victim",
		"criminal1",
		"criminal2",
		"criminal3",
		"criminal4",
	},
	["OnCrimeResetInterrogationForCriminal"] = {
		"crimeID",
		"criminal",
	},
	["OnCrimeResolved"] = {
		"crimeID",
		"victim",
		"criminal1",
		"criminal2",
		"criminal3",
		"criminal4",
	},
	["OnCriminalMergedWithCrime"] = {
		"crimeID",
		"criminal",
	},
	["OnShutdown"] = {
		"isEditorMode",
	},
	["OnStartCarrying"] = {
		"carriedObject",
		"carriedObjectTemplate",
		"carrier",
		"storyActionID",
		"pickupPosX",
		"pickupPosY",
		"pickupPosZ",
	},
	["OnStoryOverride"] = {
		"target",
	},
	["OnThrown"] = {
		"thrownObject",
		"thrownObjectTemplate",
		"thrower",
		"storyActionID",
		"throwPosX",
		"throwPosY",
		"throwPosZ",
	},
	["Opened"] = {
		"item",
	},
	["PartyPresetLoaded"] = {
		"partyPreset",
		"levelName",
	},
	["PickupFailed"] = {
		"character",
		"item",
	},
	["PingRequested"] = {
		"character",
	},
	["PlatformDestroyed"] = {
		"object",
	},
	["PlatformMovementCanceled"] = {
		"object",
		"eventId",
	},
	["PlatformMovementFinished"] = {
		"object",
		"eventId",
	},
	["PreMovedBy"] = {
		"item",
		"character",
	},
	["PuzzleUIClosed"] = {
		"character",
		"uIInstance",
		"type",
	},
	["PuzzleUIUsed"] = {
		"character",
		"uIInstance",
		"type",
		"command",
		"elementId",
	},
	["QuestAccepted"] = {
		"character",
		"questID",
	},
	["QuestClosed"] = {
		"questID",
	},
	["QuestUpdateUnlocked"] = {
		"character",
		"topLevelQuestID",
		"stateID",
	},
	["QueuePurged"] = {
		"object",
	},
	["RandomCastProcessed"] = {
		"caster",
		"storyActionID",
		"spellID",
		"rollResult",
		"randomCastDC",
	},
	["ReactionInterruptActionNeeded"] = {
		"object",
	},
	["ReactionInterruptAdded"] = {
		"character",
		"reactionInterruptName",
	},
	["ReactionInterruptUsed"] = {
		"object",
		"reactionInterruptPrototypeId",
		"isAutoTriggered",
	},
	["ReadyCheckFailed"] = {
		"id",
	},
	["ReadyCheckPassed"] = {
		"id",
	},
	["RelationChanged"] = {
		"sourceFaction",
		"targetFaction",
		"newRelation",
		"permanent",
	},
	["RemovedFrom"] = {
		"object",
		"inventoryHolder",
	},
	["ReposeAdded"] = {
		"entity",
		"onEntity",
	},
	["ReposeRemoved"] = {
		"entity",
		"onEntity",
	},
	["RequestCanCombine"] = {
		"character",
		"item1",
		"item2",
		"item3",
		"item4",
		"item5",
		"requestID",
	},
	["RequestCanDisarmTrap"] = {
		"character",
		"item",
		"requestID",
	},
	["RequestCanLockpick"] = {
		"character",
		"item",
		"requestID",
	},
	["RequestCanLoot"] = {
		"looter",
		"target",
	},
	["RequestCanMove"] = {
		"character",
		"item",
		"requestID",
	},
	["RequestCanPickup"] = {
		"character",
		"object",
		"requestID",
	},
	["RequestCanUse"] = {
		"character",
		"item",
		"requestID",
	},
	["RequestEndTheDayFail"] = {
		"",
	},
	["RequestEndTheDaySuccess"] = {
		"",
	},
	["RequestGatherAtCampFail"] = {
		"character",
	},
	["RequestGatherAtCampSuccess"] = {
		"character",
	},
	["RequestPickpocket"] = {
		"player",
		"npc",
	},
	["RequestTrade"] = {
		"character",
		"trader",
		"tradeMode",
		"itemsTagFilter",
	},
	["RespecCancelled"] = {
		"character",
	},
	["RespecCompleted"] = {
		"character",
	},
	["Resurrected"] = {
		"character",
	},
	["RollResult"] = {
		"eventName",
		"roller",
		"rollSubject",
		"resultType",
		"isActiveRoll",
		"criticality",
	},
	["RulesetModifierChangedBool"] = {
		"modifier",
		"old",
		"new",
	},
	["RulesetModifierChangedFloat"] = {
		"modifier",
		"old",
		"new",
	},
	["RulesetModifierChangedInt"] = {
		"modifier",
		"old",
		"new",
	},
	["RulesetModifierChangedString"] = {
		"modifier",
		"old",
		"new",
	},
	["SafeRomanceOptionChanged"] = {
		"userID",
		"state",
	},
	["SavegameLoadStarted"] = {
		"",
	},
	["SavegameLoaded"] = {
		"",
	},
	["Saw"] = {
		"character",
		"targetCharacter",
		"targetWasSneaking",
	},
	["ScatteredAt"] = {
		"item",
		"x",
		"y",
		"z",
	},
	["ScreenFadeCleared"] = {
		"userID",
		"fadeID",
	},
	["ScreenFadeDone"] = {
		"userID",
		"fadeID",
	},
	["ShapeshiftChanged"] = {
		"character",
		"race",
		"gender",
		"shapeshiftStatus",
	},
	["ShapeshiftedHitpointsChanged"] = {
		"entity",
		"percentage",
	},
	["ShareInitiative"] = {
		"object",
	},
	["ShortRestCapable"] = {
		"character",
		"capable",
	},
	["ShortRestProcessing"] = {
		"character",
	},
	["ShortRested"] = {
		"character",
	},
	["StackedWith"] = {
		"item",
		"stackedWithItem",
	},
	["StartAttack"] = {
		"defender",
		"attackOwner",
		"attacker",
		"storyActionID",
	},
	["StartAttackPosition"] = {
		"x",
		"y",
		"z",
		"attackOwner",
		"attacker",
		"storyActionID",
	},
	["StartedDisarmingTrap"] = {
		"character",
		"item",
	},
	["StartedFleeing"] = {
		"character",
	},
	["StartedLockpicking"] = {
		"character",
		"item",
	},
	["StartedPreviewingSpell"] = {
		"caster",
		"spell",
		"isMostPowerful",
		"hasMultipleLevels",
	},
	["StatusApplied"] = {
		"object",
		"status",
		"causee",
		"storyActionID",
	},
	["StatusAttempt"] = {
		"object",
		"status",
		"causee",
		"storyActionID",
	},
	["StatusAttemptFailed"] = {
		"object",
		"status",
		"causee",
		"storyActionID",
	},
	["StatusRemoved"] = {
		"object",
		"status",
		"causee",
		"applyStoryActionID",
	},
	["StatusTagCleared"] = {
		"target",
		"tag",
		"sourceOwner",
		"source2",
		"storyActionID",
	},
	["StatusTagSet"] = {
		"target",
		"tag",
		"sourceOwner",
		"source2",
		"storyActionID",
	},
	["StoppedCombining"] = {
		"character",
		"item1",
		"item2",
		"item3",
		"item4",
		"item5",
	},
	["StoppedDisarmingTrap"] = {
		"character",
		"item",
	},
	["StoppedLockpicking"] = {
		"character",
		"item",
	},
	["StoppedSneaking"] = {
		"character",
	},
	["SubQuestUpdateUnlocked"] = {
		"character",
		"subQuestID",
		"stateID",
	},
	["SupplyTemplateSpent"] = {
		"templateId",
		"amount",
	},
	["SwarmAIGroupJoined"] = {
		"object",
		"group",
	},
	["SwarmAIGroupLeft"] = {
		"object",
		"group",
	},
	["SwitchedCombat"] = {
		"object",
		"oldCombatGuid",
		"newCombatGuid",
	},
	["TadpolePowerAssigned"] = {
		"character",
		"power",
	},
	["TagCleared"] = {
		"target",
		"tag",
	},
	["TagEvent"] = {
		"tag",
		"event",
	},
	["TagSet"] = {
		"target",
		"tag",
	},
	["TeleportToFleeWaypoint"] = {
		"character",
		"trigger",
	},
	["TeleportToFromCamp"] = {
		"character",
	},
	["TeleportToWaypoint"] = {
		"character",
		"trigger",
	},
	["Teleported"] = {
		"target",
		"cause",
		"oldX",
		"oldY",
		"oldZ",
		"newX",
		"newY",
		"newZ",
		"spell",
	},
	["TeleportedFromCamp"] = {
		"character",
	},
	["TeleportedToCamp"] = {
		"character",
	},
	["TemplateAddedTo"] = {
		"objectTemplate",
		"object2",
		"inventoryHolder",
		"addType",
	},
	["TemplateDestroyedBy"] = {
		"itemTemplate",
		"item2",
		"destroyer",
		"destroyerOwner",
		"storyActionID",
	},
	["TemplateEnteredTrigger"] = {
		"itemTemplate",
		"item2",
		"trigger",
		"owner",
		"mover",
	},
	["TemplateEquipped"] = {
		"itemTemplate",
		"character",
	},
	["TemplateKilledBy"] = {
		"characterTemplate",
		"defender",
		"attackOwner",
		"attacker",
		"storyActionID",
	},
	["TemplateLeftTrigger"] = {
		"itemTemplate",
		"item2",
		"trigger",
		"owner",
		"mover",
	},
	["TemplateOpening"] = {
		"itemTemplate",
		"item2",
		"character",
	},
	["TemplateRemovedFrom"] = {
		"objectTemplate",
		"object2",
		"inventoryHolder",
	},
	["TemplateUnequipped"] = {
		"itemTemplate",
		"character",
	},
	["TemplateUseFinished"] = {
		"character",
		"itemTemplate",
		"item2",
		"sucess",
	},
	["TemplateUseStarted"] = {
		"character",
		"itemTemplate",
		"item2",
	},
	["TemplatesCombined"] = {
		"template1",
		"template2",
		"template3",
		"template4",
		"template5",
		"character",
		"newItem",
	},
	["TemporaryHostileRelationRemoved"] = {
		"enemy",
		"sourceFaction",
		"targetFaction",
	},
	["TemporaryHostileRelationRequestHandled"] = {
		"character1",
		"character2",
		"success",
	},
	["TextEvent"] = {
		"event",
	},
	["TimelineScreenFadeStarted"] = {
		"userID",
		"dialogInstanceId",
		"dialog2",
	},
	["TimerFinished"] = {
		"timer",
	},
	["TradeEnds"] = {
		"character",
		"trader",
	},
	["TradeGenerationEnded"] = {
		"trader",
	},
	["TradeGenerationStarted"] = {
		"trader",
	},
	["TurnEnded"] = {
		"object",
	},
	["TurnStarted"] = {
		"object",
	},
	["TutorialBoxClosed"] = {
		"character",
		"message",
	},
	["TutorialClosed"] = {
		"userId",
		"entryId",
	},
	["TutorialEvent"] = {
		"entity",
		"event",
	},
	["UnequipFailed"] = {
		"item",
		"character",
	},
	["Unequipped"] = {
		"item",
		"character",
	},
	["Unlocked"] = {
		"item",
		"character",
		"key",
	},
	["UnlockedRecipe"] = {
		"character",
		"recipe",
	},
	["UseFinished"] = {
		"character",
		"item",
		"sucess",
	},
	["UseStarted"] = {
		"character",
		"item",
	},
	["UserAvatarCreated"] = {
		"userID",
		"avatar",
		"daisy",
	},
	["UserCampChestChanged"] = {
		"userID",
		"chest",
	},
	["UserCharacterLongRested"] = {
		"character",
		"isFullRest",
	},
	["UserConnected"] = {
		"userID",
		"userName",
		"userProfileID",
	},
	["UserDisconnected"] = {
		"userID",
		"userName",
		"userProfileID",
	},
	["UserEvent"] = {
		"userID",
		"userEvent",
	},
	["UserMakeWar"] = {
		"sourceUserID",
		"targetUserID",
		"war",
	},
	["UsingSpell"] = {
		"caster",
		"spell",
		"spellType",
		"spellElement",
		"storyActionID",
	},
	["UsingSpellAtPosition"] = {
		"caster",
		"x",
		"y",
		"z",
		"spell",
		"spellType",
		"spellElement",
		"storyActionID",
	},
	["UsingSpellInTrigger"] = {
		"caster",
		"spell",
		"spellType",
		"spellElement",
		"trigger",
		"storyActionID",
	},
	["UsingSpellOnTarget"] = {
		"caster",
		"target",
		"spell",
		"spellType",
		"spellElement",
		"storyActionID",
	},
	["UsingSpellOnZoneWithTarget"] = {
		"caster",
		"target",
		"spell",
		"spellType",
		"spellElement",
		"storyActionID",
	},
	["VoiceBarkEnded"] = {
		"bark",
		"instanceID",
	},
	["VoiceBarkFailed"] = {
		"bark",
	},
	["VoiceBarkStarted"] = {
		"bark",
		"instanceID",
	},
	["WentOnStage"] = {
		"object",
		"isOnStageNow",
	},
}

return EVENTS