local RegisteredSafeEvents = {}

AddEventHandler('Core:RegisterSafeServerEvent', function(name)
    if not RegisteredSafeEvents[name] then
        RegisteredSafeEvents[name] = true
    end
end)

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then
        Citizen.Wait(100)
        TriggerEvent('Core:GetRegisteredEvents', function(events)
            for i=1, #events, 1 do
                RegisteredSafeEvents[events[i]] = true
            end
        end)
    end
end)

local serverScripts = {
    ['sessionmanager-rdr3'] = {},
    ['sessionmanager'] = {},
    ['runcode'] = {},
    ['rconlog'] = {},
    ['hardcap'] = {},
    ['baseevents'] = {},
    ['webpack'] = {},
    ['yarn'] = {},
    ['mapmanager'] = {},
    ['playernames'] = {},
    [GetCurrentResourceName()] = {}
}

Npassed = nil

Citizen.CreateThread(function()
    local pol = LoadResourceFile(GetCurrentResourceName(), 'server_safety/values.lua')
    if pol then
        local c = false
        if string.find(pol, 'AC2 = 10') then c = true else c = false end
        if (not c) == AC.ServerConfig.SafeEvents then
        else
            local p = 10
            local p2 = 20
            if c == true then
                pol = string.gsub(pol, 'AC2 = 10', 'AC2 = 20')
                SaveResourceFile(GetCurrentResourceName(), 'server_safety/values.lua', pol, -1)
            else
                pol = string.gsub(pol, 'AC2 = 20', 'AC2 = 10')
                SaveResourceFile(GetCurrentResourceName(), 'server_safety/values.lua', pol, -1)
            end
        end
        local c = false
        local c2 = 0
        for i=1, string.len(pol), 1 do
            local sub = string.sub(pol, i, i)
            if sub == '<' and c == true then
                pol = string.gsub(pol, string.sub(pol,c2+1, i-1), GetCurrentResourceName())
                SaveResourceFile(GetCurrentResourceName(), 'server_safety/values.lua', pol, -1)
            elseif sub == '<' and not c then
                c = true
                c2 = i
            end
        end
    end
    local res = LoadResourceFile('xyz_emergency', 'fxmanifest.lua')
    if not res then
        Npassed = true
    else
        Npassed = false
        print('^2Resource xyz_emergency is online!^7')
    end
    Citizen.Wait(100)
    if Npassed then
        print('^1You do not have resource xyz_emergency created! Please create this directory or You won\'t be able to use safe server events!^7')
        return        
    end
    Citizen.Wait(1000)
    for k,v in pairs(blacklistedEvents) do
        if not RegisteredSafeEvents[k] and not Events[k] then
            RegisterNetEvent(k, function()
                local event = k
                if not RegisteredSafeEvents[k] and not Events[k] then
                    AC:BanPlayer(source, 'Injection Detected: Blacklisted Event Triggered! ' .. event)
                end
            end)
        end
    end
end)

AddEventHandler('Core:IsRegisteredAllowed', function(cb)
    while Npassed == nil do
        Citizen.Wait(10)
    end
    cb(Npassed)
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    if AC.ServerConfig.SafeEvents then
        if Npassed then
            print('^1You do not have resource xyz_emergency created! Please create this directory or You won\'t be able to use safe server events!^7')
            return        
        end
        local resName = GetCurrentResourceName()
        for i=0, GetNumResources()-1 do
            if not serverScripts[GetResourceByFindIndex(i)] then
                local path = GetResourcePath(GetResourceByFindIndex(i))
                if string.len(path) > 4 then
                    local p1 = LoadResourceFile(GetResourceByFindIndex(i), 'fxmanifest.lua')
                    local p2 = LoadResourceFile(GetResourceByFindIndex(i), '__resource.lua')
                    local resource = p1 or p2
                    local c1
                    if p1 then
                        c1 = 'fxmanifest.lua'
                    else
                        c1 = '__resource.lua'
                    end

                    if resource:find('server_script') and ((not resource:find("'@" .. resName .. "/server_safety/values.lua'") and (not resource:find("'@xyz_anticheat/server_safety/values.lua'")))) then
                        resource = 'server_script ' .. "'@" .. resName .. "/server_safety/values.lua'\n" .. resource
                        SaveResourceFile(GetResourceByFindIndex(i), c1, resource, -1)
                        print('Added server_safety to ' .. GetResourceByFindIndex(i) .. '!')
                    end
                end
            end
        end
    else
        local resName = GetCurrentResourceName()
        for i=0, GetNumResources()-1 do
            if not serverScripts[GetResourceByFindIndex(i)] then
                local path = GetResourcePath(GetResourceByFindIndex(i))
                if string.len(path) > 4 then
                    local p1 = LoadResourceFile(GetResourceByFindIndex(i), 'fxmanifest.lua')
                    local p2 = LoadResourceFile(GetResourceByFindIndex(i), '__resource.lua')
                    local resource = p1 or p2
                    local c1
                    if p1 then
                        c1 = 'fxmanifest.lua'
                    else
                        c1 = '__resource.lua'
                    end
                    if resource:find('server_script') and ((resource:find("'@" .. resName .. "/server_safety/values.lua'") or (resource:find("'@xyz_anticheat/server_safety/values.lua'")))) then
                        resource = string.gsub(resource, "server_script '@" .. resName .. "/server_safety/values.lua'\n", '')
                        resource = string.gsub(resource, "server_script '@xyz_anticheat/server_safety/values.lua'\n", '')
                        SaveResourceFile(GetResourceByFindIndex(i), c1, resource, -1)
                        print('Deleted server_safety from ' .. GetResourceByFindIndex(i) .. '!')
                    end
                end
            end
        end
    end
end)
