AC.ServerConfig = {}

AC.ServerConfig.BypassType = 'global' -- global, in future there will be more types. Add Ace
AC.ServerConfig.BypassRanks = {'acadmin'}

AC.ServerConfig.EnableWebhook = true
AC.ServerConfig.Webhook = "" -- webhook

AC.ServerConfig.AntiClearPedTasks = true -- Don't allow kicking out of cars
AC.ServerConfig.AntiClearPedTasksBan = true -- Ban for previous
AC.ServerConfig.AntiRemoveWeapons = true -- Don't allow removing other player's weapons
AC.ServerConfig.AntiRemoveWeaponsBan = true -- Ban for previous
AC.ServerConfig.AntiGiveWeapons = true -- Don't allow to give weapons to other players
AC.ServerConfig.AntiGiveWeaponsBan = true -- Ban for previous

AC.ServerConfig.StopUnathorizedResources = true -- some script called nn? Ban!
AC.ServerConfig.AntiResourceStop = true -- NEW Version! You can actually restart your resources without worrying about false-positives!

AC.ServerConfig.AntiBlacklistedNames = true
AC.ServerConfig.BlacklistedNames = {
    "administrator", "admin", "adm1n", "adm!n", "admln", "moderator", "owner", "nigger", "n1gger", "<script"
}

AC.ServerConfig.AntiBlacklistMessages = true -- Don't allow blacklisted messages
AC.ServerConfig.BlacklistMessagesEvents = { -- List of events that can transmit messages
    'chatMessage',
    '_chat:messageEntered'
}
AC.ServerConfig.BlacklistMessages = { -- Blacklisted Words
    "Mod Menu",
    "You got fucked",
    "You just got fucked",
    "ATG",
    "anticheat",
    "cheat",
    "Fuck This",
    "discord.gg",
    "Lynx",
    "Huge",
    "Brutan",
    "lynxmenu",
    "API-AC",
    "https://",
    "http://",
    "EULEN",
    "hammafia",
    "onion",
    "executor",
    "desudo",
    "unex",
    "DROP TABLE",
    "UPDATE users",
    "TRUNCATE TABLE",
    "unknowncheats",
    "absolute",
    "Hydro"
}

AC.ServerConfig.AntiEntitySpawning = true -- Could reduce server performance slightly, not much since its pretty optimized
AC.ServerConfig.AntiMassPedSpawn = true -- Checks if 6 or more peds of the same model have been spawned in a span of 10 seconds, if yes, ban
AC.ServerConfig.WhitelistPedModels = {
    '',
}

AC.ServerConfig.BlacklistPedModels = { -- Same checks are made on client, but no need to add it to client config
    'a_f_m_beach_01',
}

AC.ServerConfig.SafeEvents = true

AC.ServerConfig.AntiExplosions = true -- Enables Anti-Explosions
AC.ServerConfig.ExplosionsTypes = { -- Explosion Types, names for better readability
    [0] = { name = "Grenade", ban = true },
    [1] = { name = "GrenadeLauncher", ban = true },
    [2] = { name = "Molotov", ban = true },
    [3] = { name = "Rocket", ban = false },
    [4] = { name = "TankShell", ban = false},
    [5] = { name = "Hi_Octane", ban = false },
    [6] = { name = "Car", ban = false },
    [7] = { name = "Plance", ban = false },
    [8] = { name = "PetrolPump", ban = false },
    [9] = { name = "Bike", ban = false },
    [10] = { name = "Dir_Steam", ban = false },
    [11] = { name = "Dir_Flame", ban = false },
    [12] = { name = "Dir_Water_Hydrant", ban = false },
    [13] = { name = "Dir_Gas_Canister", ban = false },
    [14] = { name = "Boat", ban = false },
    [15] = { name = "Ship_Destroy", ban = false },
    [16] = { name = "Truck", ban = false },
    [17] = { name = "Bullet", ban = false },
    [18] = { name = "SmokeGrenadeLauncher", ban = true },
    [19] = { name = "SmokeGrenade", ban = false },
    [20] = { name = "BZGAS", ban = false },
    [21] = { name = "Flare", ban = false },
    [22] = { name = "Gas_Canister", ban = false },
    [23] = { name = "Extinguisher", ban = false },
    [24] = { name = "Programmablear", ban = false },
    [25] = { name = "Train", ban = false },
    [26] = { name = "Barrel", ban = false },
    [27] = { name = "PROPANE", ban = false },
    [28] = { name = "Blimp", ban = false },
    [29] = { name = "Dir_Flame_Explode", ban = false },
    [30] = { name = "Tanker", ban = false },
    [31] = { name = "PlaneRocket", ban = false },
    [32] = { name = "VehicleBullet", ban = false },
    [33] = { name = "Gas_Tank", ban = false },
    [34] = { name = "FireWork", ban = false },
    [35] = { name = "SnowBall", ban = false },
    [36] = { name = "ProxMine", ban = true },
    [37] = { name = "Valkyrie_Cannon", ban = true }
}
