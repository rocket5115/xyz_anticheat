XYZ = nil

TriggerEvent('XYZSource:getSharedObject', function(obj) XYZ = obj end)

local BypassType = AC.ServerConfig.BypassType
local BypassRanks = AC.ServerConfig.BypassRanks

local SecureCallbackCleared = false

local CallbacksCalled = {} 

RegisterServerEvent('xyz_anticheat:getVariables', function(token)
    local _source = source

    while not Core.ModulesLoaded or not SecureCallbackCleared or AC.ClientConfig == nil do
        Citizen.Wait(10)
    end

    if token ~= '$H.D<S' then
        AC:BanPlayer(_source, 'Injection Detected: Internal Secured Event Triggered!')
    end

    if CallbacksCalled[_source] then
        AC:BanPlayer(_source, 'Injection Detected: Internal Secured Event Triggered!')
    else
        if not AC.ClientConfig.AntiEntitySpawning then
            AC.ClientConfig.AntiEntitySpawning = AC.ServerConfig.AntiEntitySpawning
        end
        if not AC.ClientConfig.BlacklistPedModels then
            AC.ClientConfig.BlacklistPedModels = AC.ServerConfig.BlacklistPedModels
        end
        if not AC.ClientConfig.WhitelistPedModels then
            AC.ClientConfig.WhitelistPedModels = AC.ServerConfig.WhitelistPedModels
        end
        if BypassType == 'global' then
            local c = false
            for i=1, #BypassRanks, 1 do
                if IsPlayerAceAllowed(_source, BypassRanks[i]) then
                    c = true
                end
            end
            TriggerClientEvent('xyz_anticheat:variablesRespond', _source, AC.ClientConfig, c, Core.SecurityTokens)
        else
            TriggerClientEvent('xyz_anticheat:variablesRespond', _source, AC.ClientConfig, false, Core.SecurityTokens)
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CallbacksCalled = {}
        SecureCallbackCleared = true
    end
end)

AddEventHandler("clearPedTasksEvent", function(sender, data)
    if AC.ServerConfig.AntiClearPedTasks then
        if AC.ServerConfig.AntiClearPedTasksBan then
            AC:BanPlayer(sender, 'Injection Detected: ClearPedTasksImmediately!')
        end 
        CancelEvent()
    end 
end)

AddEventHandler('removeWeaponEvent', function(sender, data)
    if AC.ServerConfig.AntiRemoveWeapons then 
        if AC.ServerConfig.AntiRemoveWeaponsBan then
            AC:BanPlayer(sender, 'Injection Detected: RemovePlayerWeapon!')
        end
        CancelEvent()
    end 
end)

AddEventHandler('giveWeaponEvent', function(sender, data)
    if AC.ServerConfig.AntiGiveWeapons then 
        if AC.ServerConfig.AntiGiveWeaponsBan then
            AC:BanPlayer(sender, 'Injection Detected: GiveWeaponToPed!')
        end
        CancelEvent()
    end 
end)

function GetEntityOwner(entity)
    if (not DoesEntityExist(entity)) then 
        return nil 
    end
    local owner = NetworkGetEntityOwner(entity)
    if (GetEntityPopulationType(entity) ~= 7) then return nil end
    return owner
end

function IsLegal(entity) 
    local model = GetEntityModel(entity)
    if (model ~= nil) then
        if (GetEntityType(entity) == 1 and GetEntityPopulationType(entity) == 7) then 
            local WhitelistPedModels = AC.ServerConfig.WhitelistPedModels
            local isWhitelisted = false;
            for i = 1, #WhitelistPedModels do 
                if GetHashKey(WhitelistPedModels[i]) == model then 
                    isWhitelisted = true;
                end 
            end 
            if not isWhitelisted then 
				return false;
            else
                return false;
            end 
        end
        for i=1, #AC.ServerConfig.BlacklistPedModels do 
            local hashkey = tonumber(AC.ServerConfig.BlacklistPedModels[i]) ~= nil and tonumber(AC.ServerConfig.BlacklistPedModels[i]) or GetHashKey(AC.ServerConfig.BlacklistPedModels[i]) 
            if (hashkey == model) then
                if (GetEntityPopulationType(entity) ~= 7) then
                    return AC.ServerConfig.BlacklistPedModels[i];
                else
                    return false 
                end
            end
        end
    end
    return false
end

local models = {}
local cachedModels = {}

AddEventHandler('entityCreating', function(model)
    if AC.ServerConfig.AntiMassPedSpawn then
        local model = GetEntityModel(entity)
        if model then
            local owner = GetEntityOwner(entity)
            if models[model] and owner ~= nil and owner > 0 then
                if #models[model] >= 6 then
                    AC:BanPlayer(owner, 'Injection Detected: Mass Ped Spawn! ' .. model .. ' ' .. #models[model])
                    CancelEvent()
                else
                    models[model][#models[model]+1] = {
                        owner = owner,
                        entity = GetHashKey(model)
                    }
                end
            elseif not models[model] and owner ~= nil and owner > 0 then
                models[model] = {}
                models[model][#models[model]+1] = {
                    owner = owner,
                    entity = GetHashKey(model)
                }
            end
        end
    end
end)

local Explosions = {}

AddEventHandler('explosionEvent', function(sender, data)
    if AC.ServerConfig.AntiExplosions then
        if tonumber(sender) then
            if Explosions[tonumber(sender)] and Explosions[tonumber(sender)] >= 3 then
                AC:BanPlayer(tonumber(sender), 'Injection Detected: Blacklisted explosion detected!')
            elseif not Explosions[tonumber(sender)] then
                Explosions[tonumber(sender)] = 1
            else
                Explosions[tonumber(sender)] = Explosions[tonumber(sender)] + 1
            end
            if AC.ServerConfig.ExplosionsTypes[data.explosionType].ban or (data.isInvisible or data.damageScale > 1.0 or not data.isAudible) then
                AC:BanPlayer(tonumber(sender), 'Injection Detected: Blacklisted explosion detected!')
            end
        end
        CancelEvent()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15000)

        Explosions = {}
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        for k,v in pairs(models) do
            cachedModels[#cachedModels+1] = v
        end
        models = {}
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        cachedModels = {}
    end
end)

local validResources

local function ValidResources()
    validResources = {}
    for i=0, GetNumResources()-1 do
        validResources[GetResourceByFindIndex(i)] = true
    end
end
ValidResources()

if AC.ServerConfig.StopUnathorizedResources then
    AddEventHandler("onResourceListRefresh", collectValidResourceList)
    RegisterServerEvent('xyz_anticheat:resourceList', function(token, resources)
        local _source = source

        if token and token == Core.SecurityTokens['xyz_anticheat:resourceList'] then
            for _,name in ipairs(resources) do
                if not validResources[name] then
                    AC:BanPlayer(_source, 'Injection Detected: Strange Resource Found Or Player stopped it! ' .. name)
                end
            end
        else
            AC:BanPlayer(_source, 'Injection Detected: Internal Secured Event Triggered!')
        end
    end)
end

if AC.ServerConfig.AntiResourceStop then
    local function CheckResource(source, resourceName)
        local _source = source
        if GetResourceState(resourceName) ~= 'stopped' and GetResourceState(resourceName) ~= 'started' then
            AC:BanPlayer(_source, 'Injection Detected: Tried to stop resource! ' .. resourceName)
        end
    end

    RegisterServerEvent('OnClientResourceStop', function(resourceName, token)
        if token and token == Core.SecurityTokens['OnClientResourceStop'] then
            CheckResource(source, resourceName)
        else
            AC:BanPlayer(source, 'Injection Detected: Internal Secured Event Triggered!')
        end
    end)
end

if AC.ServerConfig.AntiBlacklistedEvents then
    for i=1, #AC.ServerConfig.BlacklistedEvents, 1 do
        RegisterServerEvent(AC.ServerConfig.BlacklistedEvents[i], function()
            local event = AC.ServerConfig.BlacklistedEvents[i]
            AC:BanPlayer(source, 'Injection Detected: Blacklisted Event Triggered! ' .. event)
        end)
    end
end

RegisterCommand('clearvehicles', function(source, args)
    local _source = source
    local c = false
    for i=1, #BypassRanks, 1 do
        if IsPlayerAceAllowed(_source, BypassRanks[i]) then
            c = true
        end
    end
    if c then
        TriggerClientEvent('AC:clearvehicles', -1)
    end
end)

RegisterCommand('clearobjects', function(source, args)
    local _source = source
    local c = false
    for i=1, #BypassRanks, 1 do
        if IsPlayerAceAllowed(_source, BypassRanks[i]) then
            c = true
        end
    end
    if c then
        TriggerClientEvent('AC:clearprops', -1)
    end
end)

RegisterCommand('clearpeds', function(source, args)
    local _source = source
    local c = false
    for i=1, #BypassRanks, 1 do
        if IsPlayerAceAllowed(_source, BypassRanks[i]) then
            c = true
        end
    end
    if c then
        TriggerClientEvent('AC:clearpeds', -1)
    end
end)

RegisterServerEvent('AC:HasFoundViolation', function(token, reason, target)
    local _source = source
    if token and token == Core.SecurityTokens['AC:HasFoundViolation'] then
        AC:BanPlayer(target or _source, 'Injection Detected: ' .. reason)
    else
        AC:BanPlayer(_source, 'Injection Detected: Internal Secured Event Triggered!')
    end
end)

if AC.ServerConfig.AntiBlacklistMessages then
    for i=1, #AC.ServerConfig.BlacklistMessagesEvents, 1 do
        RegisterServerEvent(AC.ServerConfig.BlacklistMessagesEvents[i], function(source, name, message)
            local _source = source
            for i=1, #AC.ServerConfig.BlacklistMessages do
                if type(message) == "string" then
                    if string.find(string.lower(message), string.lower(AC.ServerConfig.BlacklistMessages[i])) then
                        AC:BanPlayer(_source, 'Injection Detected: Blacklist Message! ' .. AC.ServerConfig.BlacklistMessages[i])
                        CancelEvent()
                    end
                end
                if type(name) == "string" then
                    if string.find(string.lower(name), string.lower(AC.ServerConfig.BlacklistMessages[i])) then
                        AC:BanPlayer(_source, 'Injection Detected: Blacklist Message! ' .. AC.ServerConfig.BlacklistMessages[i])
                        CancelEvent()
                    end
                end
            end
        end)
    end
end

local identifiersFormat = "**Name:** %s\n**ServerID:** %s\n**Reason:** %s\n **BanID:** %s\n**Steam:** %s\n**Discord:** %s\n**License:** %s\n**License2:** %s\n**XBL:** %s\n**Live:** %s\n**IP:** ||%s||\n"

function AC:BanPlayer(source, reason)
    local _source = source
    local identifiers = Core:RetrieveIdentifiers(_source)

    while not Core.ModulesLoaded do
        Citizen.Wait(10)
    end

    if reason then
        DropPlayer(_source, 'You have been banned from the server by Anticheat System!')
        local iden = identifiersFormat:format(
            identifiers['name'] or 'NOT FOUND',
            _source,
            reason or 'UNDEFINED',
            'X#ASFS',
            identifiers['steam:'] or 'NOT FOUND',
            '<@' .. string.gsub(identifiers['discord:'], 'discord:', '') .. '>' or 'NOT FOUND',
            identifiers['license:'] or 'NOT FOUND',
            identifiers['license2:'] or 'NOT FOUND',
            identifiers['xbl:'] or 'NOT FOUND',
            identifiers['live:'] or 'NOT FOUND',
            identifiers['ip:'] or 'NOT FOUND'
        )

        local BannableIdentifiers = {}

        table.insert(BannableIdentifiers, identifiers['name'])

        for k,v in pairs(identifiers) do
            if v ~= 'NOT FOUND' and type(v) == 'string' then
                if k ~= 'name' then
                    table.insert(BannableIdentifiers, v)
                end
            end
        end
        for i=1, #identifiers['tokens_'] do
            table.insert(BannableIdentifiers, identifiers['tokens_'][i])
        end
        Core:SendWebhook(iden, reason)
        Core:BanInternal(BannableIdentifiers, reason)
    end
end