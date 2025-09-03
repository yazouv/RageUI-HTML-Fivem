--[[
    RageUI Menu System - Exemples Client
    Exemples d'utilisation pour différents types de menus
]]

--[[
    ========================================
    EXEMPLE 1: MENU PRINCIPAL
    ========================================
]]
local function CreateMainMenu()
    local items = {
        {
            type = 'button',
            label = '📦 Inventaire',
            description = 'Accédez à votre inventaire personnel',
            submenu = 'inventory'
        },
        {
            type = 'button',
            label = '🚗 Véhicules',
            description = 'Gérez votre garage personnel',
            submenu = 'vehicles'
        },
        {
            type = 'button',
            label = '👤 Informations',
            description = 'Vos informations personnelles',
            submenu = 'playerinfo'
        },
        {
            type = 'separator',
            label = 'Actions Rapides'
        },
        {
            type = 'checkbox',
            label = '🔊 Sons activés',
            description = 'Active/Désactive les effets sonores',
            checked = true
        },
        {
            type = 'list',
            label = '🎵 Volume général',
            description = 'Réglez le volume du jeu',
            values = { 'Silencieux', 'Faible', 'Normal', 'Fort', 'Maximum' },
            index = 2
        },
        {
            type = 'button',
            label = '🚪 Fermer',
            description = 'Fermer ce menu'
        }
    }

    exports['rageui_menu']:CreateMenu('main', 'Menu Principal', '~b~Bienvenue sur le serveur', items)
end

--[[
    ========================================
    EXEMPLE 2: MENU INVENTAIRE
    ========================================
]]
local function CreateInventoryMenu()
    -- Simulation d'un inventaire (normalement récupéré du serveur)
    local playerItems = {
        { name = 'Pomme', count = 5, icon = '🍎', description = 'Restaure 20 HP' },
        { name = 'Eau', count = 3, icon = '💧', description = 'Restaure la soif' },
        { name = 'Pistolet', count = 1, icon = '🔫', description = 'Arme de défense' },
        { name = 'Téléphone', count = 1, icon = '📱', description = 'Smartphone personnel' },
        { name = 'Clés de voiture', count = 2, icon = '🔑', description = 'Clés de vos véhicules' }
    }

    local items = {}

    -- Créer les items du menu à partir de l'inventaire
    for i, item in ipairs(playerItems) do
        table.insert(items, {
            type = 'button',
            label = item.icon .. ' ' .. item.name .. ' (x' .. item.count .. ')',
            description = item.description
        })
    end

    -- Ajouter le bouton retour
    table.insert(items, {
        type = 'button',
        label = '🔙 Retour',
        description = 'Retourner au menu principal'
    })

    exports['rageui_menu']:CreateMenu('inventory', 'Inventaire', '~g~Vos objets personnels', items)
end

--[[
    ========================================
    EXEMPLE 3: MENU VÉHICULES
    ========================================
]]
local function CreateVehiclesMenu()
    -- Simulation d'un garage (normalement récupéré du serveur)
    local playerVehicles = {
        { model = 'adder', name = 'Adder', icon = '🏎️', stored = true },
        { model = 'kuruma', name = 'Kuruma', icon = '🚙', stored = true },
        { model = 'faggio2', name = 'Faggio Sport', icon = '🛵', stored = false },
        { model = 'bmx', name = 'BMX', icon = '🚲', stored = true }
    }

    local items = {}

    for i, vehicle in ipairs(playerVehicles) do
        local status = vehicle.stored and "Disponible" or "Sorti"
        local statusIcon = vehicle.stored and "🟢" or "🔴"

        table.insert(items, {
            type = 'button',
            label = vehicle.icon .. ' ' .. vehicle.name,
            description = statusIcon .. ' ' .. status .. ' - Cliquez pour sortir'
        })
    end

    table.insert(items, {
        type = 'separator',
        label = 'Actions'
    })

    table.insert(items, {
        type = 'button',
        label = '🔧 Réparer tous les véhicules',
        description = 'Répare tous vos véhicules (500$)'
    })

    table.insert(items, {
        type = 'button',
        label = '🔙 Retour',
        description = 'Retourner au menu principal'
    })

    exports['rageui_menu']:CreateMenu('vehicles', 'Garage Personnel', '~y~Vos véhicules', items)
end

--[[
    ========================================
    EXEMPLE 4: MENU INFORMATIONS JOUEUR
    ========================================
]]
local function CreatePlayerInfoMenu()
    -- Récupérer les infos du joueur
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHealth = GetEntityHealth(playerPed)
    local playerArmour = GetPedArmour(playerPed)

    local items = {
        {
            type = 'button',
            label = '📍 Position: ' .. math.floor(playerCoords.x) .. ', ' .. math.floor(playerCoords.y),
            description = 'Votre position actuelle dans le monde'
        },
        {
            type = 'button',
            label = '❤️ Santé: ' .. (playerHealth - 100) .. '/100',
            description = 'Votre niveau de santé actuel'
        },
        {
            type = 'button',
            label = '🛡️ Armure: ' .. playerArmour .. '/100',
            description = 'Votre niveau d\'armure actuel'
        },
        {
            type = 'separator',
            label = 'Actions de Santé'
        },
        {
            type = 'button',
            label = '💊 Se soigner (100$)',
            description = 'Restaure votre santé au maximum'
        },
        {
            type = 'button',
            label = '🛡️ Acheter armure (200$)',
            description = 'Achète une armure complète'
        },
        {
            type = 'button',
            label = '🔙 Retour',
            description = 'Retourner au menu principal'
        }
    }

    exports['rageui_menu']:CreateMenu('playerinfo', 'Informations', '~w~Votre personnage', items)
end

--[[
    ========================================
    EXEMPLE 5: MENU JOB POLICE
    ========================================
]]
local function CreatePoliceMenu()
    local items = {
        {
            type = 'button',
            label = '🚔 Prendre service',
            description = 'Commencer votre service de police'
        },
        {
            type = 'button',
            label = '👮 Contrôle d\'identité',
            description = 'Contrôler l\'identité du joueur le plus proche'
        },
        {
            type = 'button',
            label = '🚓 Demander renfort',
            description = 'Envoyer une demande de renfort'
        },
        {
            type = 'separator',
            label = 'Équipement'
        },
        {
            type = 'list',
            label = '🔫 Arme de service',
            description = 'Choisissez votre arme',
            values = { 'Pistolet', 'Taser', 'Matraque' },
            index = 0
        },
        {
            type = 'checkbox',
            label = '🚨 Sirènes activées',
            description = 'Active/désactive les sirènes automatiquement',
            checked = false
        },
        {
            type = 'button',
            label = '🔙 Fermer',
            description = 'Fermer le menu police'
        }
    }

    exports['rageui_menu']:CreateMenu('police', 'Menu Police', '~r~Forces de l\'ordre', items)
end

--[[
    ========================================
    CALLBACKS DES MENUS
    ========================================
]]

-- Callback du menu principal
exports['rageui_menu']:RegisterMenuCallback('main', function(data)
    print("Action sur menu principal:", json.encode(data))

    if data.item and data.item.label then
        if string.find(data.item.label, "Fermer") then
            exports['rageui_menu']:CloseMenu()
        elseif string.find(data.item.label, "Sons activés") then
            print("Sons " .. (data.item.checked and "activés" or "désactivés"))
        elseif string.find(data.item.label, "Volume") then
            print("Volume changé:", data.item.value)
        end
    end
end)

-- Callback du menu inventaire
exports['rageui_menu']:RegisterMenuCallback('inventory', function(data)
    if data.item and data.item.label then
        if string.find(data.item.label, "Retour") then
            exports['rageui_menu']:OpenMenu('main')
        else
            -- Simulation d'utilisation d'objet
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Objet utilisé: " .. data.item.label)
            DrawNotification(false, false)
        end
    end
end)

-- Callback du menu véhicules
exports['rageui_menu']:RegisterMenuCallback('vehicles', function(data)
    if data.item and data.item.label then
        if string.find(data.item.label, "Retour") then
            exports['rageui_menu']:OpenMenu('main')
        elseif string.find(data.item.label, "Réparer") then
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Tous vos véhicules ont été réparés !")
            DrawNotification(false, false)
        else
            -- Simulation de sortie de véhicule
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Véhicule sorti du garage !")
            DrawNotification(false, false)
        end
    end
end)

-- Callback du menu informations
exports['rageui_menu']:RegisterMenuCallback('playerinfo', function(data)
    if data.item and data.item.label then
        if string.find(data.item.label, "Retour") then
            exports['rageui_menu']:OpenMenu('main')
        elseif string.find(data.item.label, "Se soigner") then
            SetEntityHealth(PlayerPedId(), 200)
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Vous avez été soigné !")
            DrawNotification(false, false)
        elseif string.find(data.item.label, "Acheter armure") then
            SetPedArmour(PlayerPedId(), 100)
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Armure équipée !")
            DrawNotification(false, false)
        end
    end
end)

-- Callback du menu police
exports['rageui_menu']:RegisterMenuCallback('police', function(data)
    if data.item and data.item.label then
        if string.find(data.item.label, "Fermer") then
            exports['rageui_menu']:CloseMenu()
        elseif string.find(data.item.label, "Prendre service") then
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Service de police commencé !")
            DrawNotification(false, false)
        end
    end
end)

--[[
    ========================================
    INITIALISATION ET COMMANDES
    ========================================
]]

-- Initialiser tous les menus au démarrage
Citizen.CreateThread(function()
    Wait(1000) -- Attendre que la ressource soit complètement chargée

    CreateMainMenu()
    CreateInventoryMenu()
    CreateVehiclesMenu()
    CreatePlayerInfoMenu()
    CreatePoliceMenu()

    print("^2[RageUI Examples] Tous les menus d'exemple ont été créés^0")
end)

-- Commandes pour tester les menus
RegisterCommand('menu', function()
    exports['rageui_menu']:OpenMenu('main')
end, false)

RegisterCommand('police', function()
    exports['rageui_menu']:OpenMenu('police')
end, false)

RegisterCommand('inv', function()
    exports['rageui_menu']:OpenMenu('inventory')
end, false)

RegisterCommand('garage', function()
    exports['rageui_menu']:OpenMenu('vehicles')
end, false)

-- Keybind pour ouvrir le menu principal (F1)
RegisterKeyMapping('menu', 'Ouvrir le menu principal', 'keyboard', 'F1')

print("^2[RageUI Examples] Exemples chargés - Utilisez /menu, /police, /inv, /garage ou F1^0")
