AC.ClientConfig = {}

AC.ClientConfig.Enable = true -- Enables Client-Side Anti-cheat, without this, you would had empty Citizen.CreateThread

AC.ClientConfig.AntiResourceStop = true -- Anti Resource Stop

AC.ClientConfig.BasicWeaponsDetection = true -- Enables everything up to BasicPlayerDetection

AC.ClientConfig.AntiBlacklistedWeapons = true -- Anti Blacklisted Weapons
AC.ClientConfig.BlacklistedWeapons = { -- GetHashKey for optimization, client will still do the work if hash or pure name will be presented
    GetHashKey("WEAPON_SAWNOFFSHOTGUN"),-- Allowed are, GetHashKey(name) - preferred, 'name', hash
	GetHashKey("WEAPON_BULLPUPSHOTGUN"),
	GetHashKey("WEAPON_GRENADELAUNCHER"),
	GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE"),
	GetHashKey("WEAPON_RPG"),
	GetHashKey("WEAPON_STINGER"),
	GetHashKey("WEAPON_MINIGUN"),
	GetHashKey("WEAPON_GRENADE"),
	GetHashKey("WEAPON_FIREWORK"),
	GetHashKey("WEAPON_BALL"),
	GetHashKey("WEAPON_BOTTLE"),
	GetHashKey("WEAPON_HEAVYSHOTGUN"),
	GetHashKey("WEAPON_GARBAGEBAG"),
	GetHashKey("WEAPON_RAILGUN"),
	GetHashKey("WEAPON_RAILPISTOL"),
	GetHashKey("WEAPON_RAYPISTOL"),
	GetHashKey("WEAPON_RAYCARBINE"),
	GetHashKey("WEAPON_RAYMINIGUN"),
	GetHashKey("WEAPON_DIGISCANNER"),
	GetHashKey("weapon_specialcarbine"),
	GetHashKey("WEAPON_SPECIALCARBINE_MK2"),
	GetHashKey("weapon_bullpuprifle"),
	GetHashKey("WEAPON_BULLPUPRIFLE_MK2"),
	GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),
	GetHashKey("weapon_marksmanrifle"),
	GetHashKey("WEAPON_MARKSMANRIFLE_MK2"),
	GetHashKey("weapon_compactrifle"),
	GetHashKey("WEAPON_COMPACTLAUNCHER"),
	GetHashKey("WEAPON_REVOLVER_MK2"),
	GetHashKey("WEAPON_HOMINGLAUNCHER"),
	GetHashKey("WEAPON_SNOWBALL"),
	GetHashKey("WEAPON_SMG_MK2"),
	GetHashKey("weapon_molotov"),
	GetHashKey("weapon_militaryrifle"),
	GetHashKey("weapon_stickybomb"),
	GetHashKey("weapon_proxmine"),
	GetHashKey("WEAPON_AUTOSHOTGUN"),
	GetHashKey("WEAPON_DBSHOTGUN"),	
	GetHashKey("WEAPON_SMG"),
	GetHashKey("weapon_gusenberg"),
	GetHashKey("weapon_combatmg"),
	GetHashKey("weapon_mg"),
	GetHashKey("weapon_combatmg_mk2"),
	GetHashKey("weapon_sniperrifle"),
	GetHashKey("weapon_heavysniper"),
	GetHashKey("weapon_heavysniper_mk2"),
	GetHashKey("weapon_bzgas"),
	GetHashKey("weapon_assaultrifle"),
	GetHashKey("weapon_assaultrifle_mk2"),
	GetHashKey("weapon_carbinerifle"),
	GetHashKey("weapon_carbinerifle_mk2"),
	GetHashKey("weapon_advancedrifle")
}
AC.ClientConfig.BlacklistedWeaponsBanAmount = 3 -- How many blacklisted weapons you need to get banned

AC.ClientConfig.AntiAimbot = true -- Anti Aimbot
AC.ClientConfig.AntiTriggerBot = true -- Anti TriggerBot, will be reworked in maybe next update
AC.ClientConfig.AntiInfiniteAmmo = true -- Anti infinite ammo

AC.ClientConfig.BasicPlayerDetection = true -- Enables almost everything below

AC.ClientConfig.AntiInvincible = true
AC.ClientConfig.AntiInvisible = true
--AC.ClientConfig.AntiNoclip = true -- Unused by anticheat, found problems that need to be fixed
AC.ClientConfig.AntiSpectator = true
AC.ClientConfig.AntiThermalVision = true
AC.ClientConfig.AntiNightVision = true
AC.ClientConfig.AntiRagdoll = true -- Unused by anticheat, found problems that need to be fixed
AC.ClientConfig.AntiArmour = true
AC.ClientConfig.MaxArmour = 70 -- between 0 and 100
AC.ClientConfig.AntiMaxHealth = true

AC.ClientConfig.ProtectPlayer = true -- Protect Player from damage types
AC.ClientConfig.ProtectionTypes = {
	false, -- bullets
	true, -- fire
	true, -- explosions
	false, -- collisions
	false, -- melee
	true, -- steam
	false -- drown
}

AC.ClientConfig.AntiNUIDevtools = true

AC.ClientConfig.AntiBlacklistedCommands = true -- blacklisted commands
AC.ClientConfig.BlacklistedCommands = { -- list of em'
    'eulen',
    "serverlag",
	"cageall",
	"swastika",
}

AC.ClientConfig.AntiBlacklistedWords = true -- Anti blacklisted words on screen, you need screenshot-basic
AC.ClientConfig.BlacklistedWords = { -- you know what it is
    "rapidfire", "fuck server", "freecam", "execute", "superjump", "noclip", "spawn object", "close menu", "lynx", "absolute", "ckgangisontop", "lumia1", "ISMMENU", "HydroMenu", "rootMenu", "WaveCheat", 
    "Lynx8", "LynxEvo", "Maestro", "Brutan", "HamHaxia", "Dopamine", "Dopameme", "Malicious", "Draw pressed", "lumia", "Randomize Outfit", "Give Health", "Object Option", "misc option",
    "explode", "Anticheat", "Tapatio", "Particle", "Malossi", "RedStonia", "Chocohax", "Inyection", "Inyected", "Dumper", "LUA Executor", "Executor", "Reaper", "Event Blocker", "Cheats", "Cheat", "Destroyer", 
    "Spectate", "Wallhack", "Exploit", "triggers", "crosshair", "Explosive", "Hacking System", "Online Players", "Panic Button", "Destroy Menu", "Self Menu", "Server IP", "Teleport To", "mod menu",
    "Single Weapon", "Airstrike Player", "Taze Player", "Magneto", "fallout", "godmode", "god mode", "modmenu", "esx money", "give armor", "aimbot", "trigger", "troll option", "Super Powers", "Vehicle Option",
    "triggerbot", "rage bot", "ragebot", "Visual Options", "NukeWorld Options", "Semi-Godmode", "No Ragdoll", "Invisible", "Crash Player", "crash", "maxout", "Clone Outfit", "Clone Ped", "Weapon option",
    "Kill menu", "all weapons", "Get All", "Weapon list", "bullet Options", "Infinite Ammo", "No Reload", "Trigger Bot", "MAGIC CARPET", "Fix Vehicle", "Spawn Vehicle", "Vehicle God"
}

AC.ClientConfig.BlacklistedKeysPhoto = { -- key pressed, screenshot
    121, -- INSERT
}
