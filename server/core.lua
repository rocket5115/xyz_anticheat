AC = {}
Core = {}

Core.ModulesLoaded = false
Core.SecurityTokens = {}

local NextBanId = 0

Citizen.CreateThread(function()
    local resource = GetCurrentResourceName()
    local versionFile = LoadResourceFile(resource, '/json/version.json')
    if versionFile then
        print('^2version.json File correctly initialized!^7') 
        PerformHttpRequest("https://raw.githubusercontent.com/rocket5115/xyz_anticheat/main/version.json?token=GHSAT0AAAAAABIK5BJ5HTLSZWEXXJNIMQ7OYTC7CAQ", function (errorCode, resultData, resultHeaders)
            if errorCode == 200 then
                versionFile = string.gsub(versionFile, ' ', '')
                resultData = string.gsub(resultData, ' ', '')
                if versionFile == resultData then
                    print('^2You have up to date version of xyz_anticheat!^7')
                else
                    print('^1You don\'t have the latest version of xyz_anticheat!^7')
                end
            else
                print('^1Version check failed!^7')
            end
        end)
    else
        print('^1version.json not Found! Created new File!^7')
        PerformHttpRequest("https://raw.githubusercontent.com/rocket5115/xyz_anticheat/main/version.json?token=GHSAT0AAAAAABIK5BJ5HTLSZWEXXJNIMQ7OYTC7CAQ", function (errorCode, resultData, resultHeaders)
            if errorCode == 200 then
                SaveResourceFile(resource, '/json/version.json', tostring(resultData), -1)
            else
                SaveResourceFile(resource, '/json/version.json', '"0.0-X"', -1)
            end
        end)
    end
    local bansFile = LoadResourceFile(resource, '/json/bans.json')
    if bansFile then
        print('^2bans.json File correctly initialized!^7')
    else
        print('^1bans.json not Found! Created new File!^7')
        SaveResourceFile(resource, '/json/bans.json', '', -1)
    end
    local IDBansFile = LoadResourceFile(resource, '/json/bans.id')
    if IDBansFile then
        NextBanId = tonumber(IDBansFile)
    end
    Citizen.Wait(100)
    Core:Initialize()
end)

IDS = {
    [1] = 'a',
    [2] = 'b',
    [3] = 'c',
    [4] = 'd',
    [5] = 'e',
    [6] = 'f',
    [7] = 'g',
    [8] = 'h',
    [9] = 'i',
    [10] = 'j',
    [11] = 'k',
    [12] = 'l',
    [13] = 'm',
    [14] = 'n',
    [15] = 'o',
    [16] = 'p',
    [17] = 'q',
    [18] = 'r',
    [19] = 's',
    [20] = 't',
    [21] = 'u',
    [22] = 'v',
    [23] = 'w',
    [24] = 'x',
    [25] = 'y',
    [26] = 'z'
}

SYM = {
    [1] = "!",
    [2] = "@",
    [3] = "#",
    [4] = "$",
    [5] = "%",
    [6] = "^",
    [7] = "&",
    [8] = "*",
    [9] = "(",
    [10] = ")",
    [11] = "-",
    [12] = "+",
    [13] = "~",
    [14] = "`",
    [15] = "[",
    [16] = "]",
    [17] = "|",
    [18] = ";",
    [19] = ":",
    [20] = "'",
    [21] = '"',
    [22] = ",",
    [23] = ".",
    [24] = "/",
    [25] = "?"
}

local function RandomizeID()
    local ret = ""
    for i=1, math.random(10, 15) do
        local c = math.random(1, 2)
        if c == 1 then
            ret = ret .. IDS[math.random(1, #IDS)]
        elseif c == 2 then
            ret = ret .. SYM[math.random(1, #SYM)]
        end
    end
    return ret
end

function Core:Initialize()
    local list = {
        'xyz_anticheat:resourceList',
        'OnClientResourceStop',
        'AC:HasFoundViolation'
    }

    for i=1, #list, 1 do
        Core.SecurityTokens[list[i]] = RandomizeID()
    end

    Core.ModulesLoaded = true
end

local bannedTable = {}
local BansToSave = {}

function Core:LoadBans()
    banned = LoadResourceFile(GetCurrentResourceName(), '/json/bans.json')
    banned = json.decode(banned)
    if banned then
        for k,v in pairs(banned) do
            bannedTable[k] = v
            BansToSave[k] = v
        end
    end
end

function Core:SendWebhook(identifiers, reason)
    while not Core.ModulesLoaded do
        Citizen.Wait(10)
    end
    if AC.ServerConfig.EnableWebhook and AC.ServerConfig.Webhook ~= "" then
        local embed = {
            {
                ["color"] = 16711680,
                ["title"] = "**".. " XYZ_AntiCheat " .."**",
                ["description"] = "**CHEATER BANNED**\n\n" .. string.gsub(identifiers, 'X#ASFS', NextBanId),
                ["footer"] = {
                    ["text"] = "RC-Logs 2020-2022",
                },
            }
        }
        PerformHttpRequest(AC.ServerConfig.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "RC-logs", embeds = embed}), { ['Content-Type'] = 'application/json'})
    end
end

function Core:BanInternal(data, reason)
    while not Core.ModulesLoaded do
        Citizen.Wait(10)
    end
    local length = #BansToSave + 1
    local length2 = #bannedTable + 1
    local top = {}
    for k,v in pairs(data) do
        table.insert(top, v)
    end
    if not BansToSave[length] then
        BansToSave[length] = {}
    end
    if not bannedTable[length2] then
        bannedTable[length2] = {}
    end
    for k,v in ipairs(top) do
        table.insert(BansToSave[length], v)
        table.insert(bannedTable[length2], v)
    end
    BansToSave[length]['ID'] = NextBanId
    bannedTable[length2]['ID'] = NextBanId

    NextBanId = NextBanId + 1
    
    local jo = json.encode(BansToSave)

    jo = string.gsub(jo, ',', ',\n')
    jo = string.gsub(jo, '{', '{\n')
    jo = string.gsub(jo, '}', '\n}')

    SaveResourceFile(GetCurrentResourceName(), 'json/bans.id', NextBanId, -1)
    SaveResourceFile(GetCurrentResourceName(), '/json/bans.json', jo, -1)
end

function Core:RetrieveIdentifiers(source)
    local _source = source
    local identifiers = {
        ['name'] = false,
        ['steam:'] = false,
        ['license:'] = false,
        ['license2:'] = false,
        ['discord:'] = false,
        ['ip:'] = false,
        ['live:'] = false,
        ['xbl:'] = false,
        ['tokens_'] = {}
    }

    identifiers['name'] = GetPlayerName(_source)
    for k,v in pairs(GetPlayerIdentifiers(_source)) do
        for name,_ in pairs(identifiers) do
            if type(name) ~= 'number' and v:find(name) then
                identifiers[name] = v
            end
        end
    end
    for k,v in pairs(GetPlayerTokens(_source)) do
        identifiers['tokens_'][k] = v
    end

    return identifiers
end

AddEventHandler('playerConnecting', function(name, err)
    local _source = source
    local identifiers = Core:RetrieveIdentifiers(_source)
    local tokens = identifiers['tokens_']
    local idnt = {}

    if AC.ServerConfig.AntiBlacklistedNames then
        for i=1, #AC.ServerConfig.BlacklistedNames, 1 do
            if string.find(name, AC.ServerConfig.BlacklistedNames[i]) then
                err('xyz_anticheat\nYou have blacklisted name!')
            end
        end
    end

    if not identifiers['steam:'] then
        err('xyz_anticheat\nTo join the server you need to have steam opened!')
        CancelEvent()
        return
    end

    for i=1, #bannedTable, 1 do
        for l,c in pairs(bannedTable[i]) do
            if l == 'ID' then
                idnt['ID'] = c
            else
                table.insert(idnt, c)
            end
        end
    end

    for i=1, #idnt, 1 do
        for _, idn in pairs(identifiers) do
            if idnt[i] == idn then
                err('xyz_anticheat\nYou have been banned from the server!\nBan ID:' .. idnt['ID'])
                CancelEvent()
                return
            end
        end
    end
    
    for i=1, #idnt, 1 do
        for j=1, #tokens, 1 do
            if idnt[i] == tokens[j] then
                err('xyz_anticheat\nYou have been banned from the server!\nBan ID:' .. idnt['ID'])
                CancelEvent()
                return
            end
        end
    end
end)

function Core:UnbanPlayer(id, source)
    local BypassType = AC.ServerConfig.BypassType
    local BypassRanks = AC.ServerConfig.BypassRanks

    local result = false
    local result2 = false

    local resultlen = 0
    local result2len = 0

    for i=1, #BansToSave, 1 do
        if BansToSave[i]['ID'] == id then
            result = true
            resultlen = i
        end
    end
    for i=1, #bannedTable, 1 do
        if bannedTable[i]['ID'] == id then
            result2 = true
            result2len = i
        end
    end
    if result and result2 then
        BansToSave[resultlen] = nil
        bannedTable[result2len] = nil

        local jo = json.encode(BansToSave)

        jo = string.gsub(jo, ',', ',\n')
        jo = string.gsub(jo, '{', '{\n')
        jo = string.gsub(jo, '}', '\n}')
    
        SaveResourceFile(GetCurrentResourceName(), '/json/bans.json', jo, -1)

        print('^7[^1xyz_anticheat^7] Player with ID ' .. id .. ' Has Been ^2Unbanned^7')
    end
end

RegisterCommand('xyzunban', function(source, args)
    local _source = source
    if (_source ~= nil and _source > 0) then
        if not tonumber(args[1]) then
            return
        end
        local c = false
        if BypassType == 'framework' then
            local XYZClient = XYZ.GetPlayerFromId(_source) 

            for i=1, #BypassRanks, 1 do
                if BypassRanks[i] == XYZClient.data.group then
                    c = true
                end
            end

            if c then
                Core:UnbanPlayer(tonumber(args[1]), _source)
            end
        elseif BypassType == 'global' then
            for i=1, #BypassRanks, 1 do
                if IsPlayerAceAllowed(_source, BypassRanks[i]) then
                    c = true
                end
            end

            if c then
                Core:UnbanPlayer(tonumber(args[1]), _source)
            end
        end
    else
        if tonumber(args[1]) then
            Core:UnbanPlayer(tonumber(args[1]))
        end
    end
end)
Core:LoadBans()
