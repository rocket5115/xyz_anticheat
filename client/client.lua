local ACConfig = {}
local ACTokens = {}

local Bypass

Citizen.CreateThread(function()
    TriggerServerEvent('xyz_anticheat:getVariables', '$H.D<S')
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    TriggerServerEvent('OnClientResourceStop', resourceName, ACTokens['OnClientResourceStop'])
end)

RegisterNetEvent('xyz_anticheat:variablesRespond', function(cfg, bp, tokens)
    ACConfig = cfg
    Bypass = bp
    ACTokens = tokens
end)

local playerSpawned = false
local playerId = PlayerId()
local currentWeapon = 0
local unarmedHash = GetHashKey('WEAPON_UNARMED')
local playerPed = PlayerPedId()
local strike = 0
local strikes2 = 0
local vehicle = 0
local playerPedSaved = 0
local coords = vector3(0.0, 0.0, 0.0)
local weaponsFound = 0
local timeOut = false

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

local function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

Citizen.CreateThread(function()
    while ACConfig.Enable == nil or Bypass == nil do
        Citizen.Wait(100)
    end

    if not Bypass then
        if ACConfig.Enable then
            local _evhandler = AddEventHandler

            Citizen.CreateThread(function()
                Citizen.Wait(15000)
                timeOut = true
            end)

            Citizen.CreateThread(function()
                while true do
                    Citizen.Wait(2000)
                    playerPed = playerPed
                    if playerPedSaved == 3 then
                        break
                    else
                        playerPedSaved = playerPedSaved + 1
                    end
                end
            end)

            Citizen.CreateThread(function()
                while true do
                    Citizen.Wait(500)
                    vehicle = GetVehiclePedIsIn(playerPed, false)
                    coords = GetEntityCoords(playerPed)
                end
            end)
            if ACConfig.BasicPlayerDetection then
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(1000)
                        if ACConfig.AntiSpectator then
                            if NetworkIsInSpectatorMode() then
                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Is In spectator mode!')
                            end
                        end
                        if ACConfig.AntiThermalVision then
                            if GetUsingseethrough() then
                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Has Thermal Vision!')
                            end
                        end
                        if ACConfig.AntiNightVision then
                            if GetUsingnightvision() then
                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Has Night Vision!')
                            end
                        end
                        if ACConfig.AntiArmour then
                            if (ACConfig.MaxArmour == 0 and GetPedArmour(playerPed) > 0) then
                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player has Armour! ' .. GetPedArmour(playerPed) .. ' Max ' .. ACConfig.MaxArmour)
                            elseif (GetPedArmour(playerPed) > ACConfig.MaxArmour) then
                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player has Armour! ' .. GetPedArmour(playerPed) .. ' Max ' .. ACConfig.MaxArmour)
                            end
                        end
                        if ACConfig.AntiMaxHealth then
                            if GetEntityHealth(playerPed) > 200 or GetEntityMaxHealth(playerPed) > 200 then
                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player has more health than 200! ' .. GetEntityHealth(playerPed) .. '/' .. GetEntityMaxHealth(playerPed))
                            end
                        end
                        if ACConfig.AntiInvisible and timeOut and playerSpawned then
                            if IsPedWalking(playerPed) and not IsPedStill(playerPed) then
                                SetEntityVisible(playerPed, true)
                                if not IsEntityVisible(playerPed) then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Is Invisible!')
                                end
                            elseif IsPedRunning(playerPed) and not IsPedStill(playerPed) then
                                SetEntityVisible(playerPed, true)
                                if not IsEntityVisible(playerPed) then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Is Invisible!')
                                end
                            elseif GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_niko_01') then
                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Is Invisible!')
                            end
                        end
                        if ACConfig.AntiRagdoll and timeOut and not IsPedInAnyVehicle(playerPed, true) and playerSpawned then
                            if IsPedWalking(playerPed) and not IsPedStill(playerPed) then
                                SetPedCanRagdoll(playerPed, true)
                                if CanPedRagdoll(playerPed) ~= false then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Has no Ragdoll!')
                                end
                            elseif IsPedRunning(playerPed) and not IsPedStill(playerPed) then
                                SetPedCanRagdoll(playerPed, true)
                                if CanPedRagdoll(playerPed) ~= false then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Is Invisible!')
                                end
                            end
                        end
                        if ACConfig.AntiInvincible and timeOut and playerSpawned then
                            if IsPedWalking(playerPed) and not IsPedStill(playerPed) then
                                SetPlayerInvincible(PlayerId(), true)
                                if GetPlayerInvincible(PlayerId()) ~= false then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Is Invicible!')
                                end
                            elseif IsPedRunning(playerPed) and not IsPedStill(playerPed) then
                                SetPlayerInvincible(PlayerId(), true)
                                if GetPlayerInvincible(PlayerId()) ~= false then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Is Invicible!')
                                end
                            end
                        end
                    end
                end)
            end

            local WeaponsWait = 10

            if ACConfig.BasicWeaponsDetection then
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(500)
                        local retval, weapon = GetCurrentPedWeapon(playerPed, true)
                        currentWeapon = weapon
                    end
                end)
                if ACConfig.AntiBlacklistedWeapons then
                    if #ACConfig.BlacklistedWeapons ~= 0 then
                        for i=1, #ACConfig.BlacklistedWeapons, 1 do
                            local weapon = ACConfig.BlacklistedWeapons[i]
                            if type(weapon) == 'string' then
                                ACConfig.BlacklistedWeapons[i] = GetHashKey(weapon)
                            elseif type(weapon) == 'number' then
                                local retval, ammoType = GetPedAmmoTypeFromWeapon(playerPed, weapon)
                                if ammoType ~= 0 then
                                    ACConfig.BlacklistedWeapons[i] = weapon      
                                end
                            end
                        end
                        Citizen.CreateThread(function()
                            while true do
                                Citizen.Wait(5000)
                                for _, weapon in ipairs(ACConfig.BlacklistedWeapons) do
                                    if HasPedGotWeapon(playerPed, weapon) then    
                                        weaponsFound = weaponsFound + 1
                                    end
                                end
                                if weaponsFound >= ACConfig.BlacklistedWeaponsBanAmount then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Has Blacklisted Weapons! ' .. weaponsFound)
                                    weaponsFound = 0
                                else
                                    weaponsFound = 0
                                end
                            end
                        end)      
                    end       
                end
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(WeaponsWait)
                        if currentWeapon ~= unarmedHash then
                            WeaponsWait = 10
                            if ACConfig.AntiAimbot then
                                if GetScriptTaskStatus(playerPed, 0xD90EF188) == 1 or GetScriptTaskStatus(playerPed, 0x0A01F8B8) == 1 then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Has Aimbot!')
                                end
                            end
                            if ACConfig.AntiTriggerBot then
                                if IsPedShooting(playerPed) then
                                    if GetTimeSinceLastInput(106) > 100 then
                                        TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Has TriggerBot!')
                                    end
                                end
                            end
                            if ACConfig.AntiInfiniteAmmo then
                                if GetAmmoInPedWeapon(playerPed, currentWeapon) == -1 then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Has Infinite Ammo!')
                                end
                            end
                        else
                            WeaponsWait = 200
                        end
                    end
                end)
            end
            local function collectAndSendResourceList()
                local resourceList = {}
                for i=0,GetNumResources()-1 do
                    resourceList[i+1] = GetResourceByFindIndex(i)
                    Wait(500)
                end
                Wait(5000)
                TriggerServerEvent('xyz_anticheat:resourceList', ACTokens['xyz_anticheat:resourceList'] resourceList)
            end
    
            if ACConfig.AntiResourceStop then
                local _onclresstop = 'onResourceStop'
                _evhandler(_onclresstop, function(res)
                    if res == GetCurrentResourceName() then
                        CancelEvent()
                    else
                        collectAndSendResourceList()
                    end
                end)
            end

            if ACConfig.AntiNUIDevtools then
                RegisterNUICallback(GetCurrentResourceName(), function()
                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Tried to use NUI Devtools!')
                end)
            end
    
            if ACConfig.AntiBlacklistedWords and #ACConfig.BlacklistedKeysPhoto ~= 0 then
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(2000)
                        for i=1, #ACConfig.BlacklistedKeysPhoto, 1 do
                            if GetTimeSinceLastInput(ACConfig.BlacklistedKeysPhoto[i]) < 3000 then
                                if exports['screenshot-basic'] ~= nil then
                                    exports['screenshot-basic']:requestScreenshot(function(data)
                                        Citizen.Wait(1000)
                                        SendNUIMessage({
                                            type = "checkscreenshot",
                                            screenshoturl = data
                                        })
                                    end)
                                end
                            end
                        end
                    end
                end)
            end

            if ACConfig.AntiBlacklistedWords then
                RegisterNUICallback('menucheck', function(data)
                    if data.text ~= nil then     
                        for _, word in pairs(ACConfig.BlacklistedWords) do
                            if string.find(string.lower(data.text), string.lower(word)) then
                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Found Blacklisted Word! ' .. word)
                            end
                        end
                    end
                end)
            end

            if ACConfig.AntiBlacklistedCommands then
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(15000)
                        for _,cmd in ipairs(GetRegisteredCommands()) do
                            for i=1, #ACConfig.BlacklistedCommands, 1 do
                                if cmd.name == ACConfig.BlacklistedCommands[i] then
                                    TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Blacklisted Command Detected! ' .. cmd.name)
                                end
                            end
                        end
                    end
                end)
            end

            if ACConfig.ProtectPlayer then
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(10000)
                        SetEntityProofs(playerPed, ACConfig.ProtectionTypes[1], ACConfig.ProtectionTypes[2], ACConfig.ProtectionTypes[3], ACConfig.ProtectionTypes[4], ACConfig.ProtectionTypes[5], ACConfig.ProtectionTypes[6], 1, ACConfig.ProtectionTypes[7])
                    end
                end)
            end

            if ACConfig.AntiEntitySpawning then
                local blacklist = {}
                for i=1, #ACConfig.BlacklistPedModels do
                    blacklist[GetHashKey(ACConfig.BlacklistPedModels[i])] = true
                end

                Citizen.CreateThread(function()
                    local CR = {}
                    while true do
                        Citizen.Wait(4000)

                        local pedsFound = 0

                        for ped in EnumeratePeds() do
                            local pedModel = GetEntityModel(ped) or 'NotFound'
                            pedsFound = pedsFound + 1
                            if blacklist[pedModel] == true then
                                if not IsPedAPlayer(ped) then
                                    ClearPedTasksImmediately(ped)
                                    local owner = NetworkGetEntityOwner(ped)
                                    if owner ~= -1 then
                                        if not CR[GetPlayerServerId(owner)] then
                                            CR[GetPlayerServerId(owner)] = 1
                                        else
                                            if CR[GetPlayerServerId(owner)] >= 6 then
                                                TriggerServerEvent('AC:HasFoundViolation', ACTokens['AC:HasFoundViolation'], 'Player Spawned Blacklisted Ped! ' .. GetEntityModel(ped), GetPlayerServerId(owner))
                                            else
                                                CR[GetPlayerServerId(owner)] = CR[GetPlayerServerId(owner)] + 1
                                            end
                                        end
                                        while not NetworkHasControlOfEntity(ped) do
                                            NetworkRequestControlOfEntity(ped)
                                            Citizen.Wait(10)
                                        end
                                    end
                                    SetEntityAsMissionEntity(ped, true, true)
                                    DeleteEntity(ped)
                                end
                            end
                        end

                        if pedsFound > 80 then
                            for ped in EnumeratePeds() do
                                if not IsPedAPlayer(ped) then
                                    ClearPedTasksImmediately(ped)
                                    while not NetworkHasControlOfEntity(ped) do
                                        NetworkRequestControlOfEntity(ped)
                                        Citizen.Wait(10)
                                    end
                                    SetEntityAsMissionEntity(ped, true, true)
                                    DeleteEntity(ped)
                                end
                            end
                        end
                    end
                end)             
            end
        end
    end
end)

local function DeleteNetworkedEntity(entity)
    local attempt = 0
    while not NetworkHasControlOfEntity(entity) and attempt < 50 and DoesEntityExist(entity) do
        NetworkRequestControlOfEntity(entity)
        attempt = attempt + 1
    end
    if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
        SetEntityAsMissionEntity(entity, false, true)
        DeleteEntity(entity)
    end
end

RegisterNetEvent('AC:clearpeds', function()
    local _peds = GetGamePool('CPed')
    for _, ped in ipairs(_peds) do
        if not (IsPedAPlayer(ped)) then
            RemoveAllPedWeapons(ped, true)
            if NetworkGetEntityIsNetworked(ped) then
                DeleteNetworkedEntity(ped)
            else
                DeleteEntity(ped)
            end
        end
    end
end)

RegisterNetEvent('AC:clearprops', function()
    local objs = GetGamePool('CObject')
    for _, obj in ipairs(objs) do
        if NetworkGetEntityIsNetworked(obj) then
            DeleteNetworkedEntity(obj)
            DeleteEntity(obj)
        else
            DeleteEntity(obj)
        end
    end
    for object in EnumerateObjects() do
        SetEntityAsMissionEntity(object, false, false)
        DeleteObject(object)
        if (DoesEntityExist(object)) then 
            DeleteObject(object)
        end
    end
end)

RegisterNetEvent('AC:clearvehicles', function(vehicles)
    if vehicles == nil then
        local vehs = GetGamePool('CVehicle')
        for _, vehicle in ipairs(vehs) do
            if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
                if NetworkGetEntityIsNetworked(vehicle) then
                    DeleteNetworkedEntity(vehicle)
                else
                    SetVehicleHasBeenOwnedByPlayer(vehicle, false)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteEntity(vehicle)
                end
            end
        end
    end
end)

AddEventHandler('playerSpawned', function()
    if not playerSpawned then
        playerSpawned = true
    end
end)
