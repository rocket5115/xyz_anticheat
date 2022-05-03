AC3 = '<xyz_anticheat<'
AC2 = 20

Events = {}

function RegisterServerEvent(name, cb)
    Events[name] = true
    if GetResourceState(string.gsub(AC3, '<', '')) == 'started' and tonumber(AC2) == 20 then
        RegisterNetEvent(name, cb)
        TriggerEvent('Core:RegisterSafeServerEvent', name, cb)
    else
        RegisterNetEvent(name, cb)
    end
end

AddEventHandler('Core:GetRegisteredEvents', function(cb)
    local c = {}
    for k,v in pairs(Events) do
        c[#c+1] = k
    end
    cb(c)
end)