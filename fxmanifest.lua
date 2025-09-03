fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'RageUI Menu System'
description 'Système de menus RageUI modulaire pour FiveM'
version '1.0.0'

-- Interface utilisateur
ui_page 'html/index.html'

-- Fichiers HTML/CSS/JS
files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/examples.js'
}

-- Scripts côté client
client_scripts {
    'client/main.lua',
    'client/examples.lua',
    'client/test.lua'
}

-- Scripts côté serveur (optionnel)
server_scripts {
    'server/main.lua'
}

-- Exports pour utilisation par d'autres ressources
exports {
    'OpenMenu',
    'CloseMenu',
    'CreateMenu',
    'UpdateMenu',
    'RegisterMenuCallback'
}

-- Exports côté serveur
server_exports {

}

-- Dépendances
dependencies {

}
