fx_version 'cerulean'

game 'gta5'

lua54 'yes'

server_scripts {
    'blacklistedEvents.lua',
    'server_safety/_GCore.lua',
    'server_safety/values.lua',
    'server/core.lua',
    'server/server_config.lua',
    'server/client_config.lua',
    'server/server.lua'
}

client_scripts {
    'client/*.lua'
}

ui_page "html/index.html"

files {
    'html/*.html',
    'html/js/*.js'
}
