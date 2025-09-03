--[[
    RageUI Menu System - Serveur
    Gestion côté serveur pour les actions de menu
]]

--[[
    ========================================
    ÉVÉNEMENTS SERVEUR
    ========================================
]]

-- Événement pour sauvegarder les préférences du joueur
RegisterNetEvent('rageui_menu:savePreferences')
AddEventHandler('rageui_menu:savePreferences', function(preferences)
    local source = source
    -- Ici vous pouvez sauvegarder en base de données
    print(("Préférences sauvegardées pour le joueur %s: %s"):format(source, json.encode(preferences)))
end)

-- Événement pour récupérer l'inventaire du joueur
RegisterNetEvent('rageui_menu:getInventory')
AddEventHandler('rageui_menu:getInventory', function()
    local source = source

    -- Simulation d'inventaire (remplacer par votre système)
    local inventory = {
        { name = 'Pomme',           count = 5, weight = 0.5 },
        { name = 'Eau',             count = 3, weight = 1.0 },
        { name = 'Pistolet',        count = 1, weight = 2.0 },
        { name = 'Téléphone',       count = 1, weight = 0.3 },
        { name = 'Clés de voiture', count = 2, weight = 0.1 }
    }

    TriggerClientEvent('rageui_menu:receiveInventory', source, inventory)
end)

-- Événement pour utiliser un objet
RegisterNetEvent('rageui_menu:useItem')
AddEventHandler('rageui_menu:useItem', function(itemName, amount)
    local source = source
    print(("Joueur %s utilise %dx %s"):format(source, amount or 1, itemName))

    -- Ici vous pouvez implémenter la logique d'utilisation d'objet
    -- Par exemple: retirer de l'inventaire, appliquer des effets, etc.

    TriggerClientEvent('rageui_menu:itemUsed', source, itemName, true)
end)

-- Événement pour sortir un véhicule
RegisterNetEvent('rageui_menu:spawnVehicle')
AddEventHandler('rageui_menu:spawnVehicle', function(vehicleModel)
    local source = source
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)

    print(("Joueur %s demande le véhicule: %s"):format(source, vehicleModel))

    -- Vérifier si le joueur possède ce véhicule (remplacer par votre logique)
    local hasVehicle = true -- Simulation

    if hasVehicle then
        -- Informer le client qu'il peut faire apparaître le véhicule
        TriggerClientEvent('rageui_menu:vehicleAuthorized', source, vehicleModel, coords)
    else
        TriggerClientEvent('rageui_menu:showNotification', source, "Vous ne possédez pas ce véhicule !")
    end
end)

-- Événement pour les achats (soins, armure, etc.)
RegisterNetEvent('rageui_menu:purchase')
AddEventHandler('rageui_menu:purchase', function(itemType, cost)
    local source = source

    -- Vérifier l'argent du joueur (remplacer par votre système économique)
    local playerMoney = 1000 -- Simulation

    if playerMoney >= cost then
        -- Déduire l'argent et autoriser l'achat
        print(("Joueur %s achète %s pour %s$"):format(source, itemType, cost))
        TriggerClientEvent('rageui_menu:purchaseAuthorized', source, itemType)
    else
        TriggerClientEvent('rageui_menu:showNotification', source, "Vous n'avez pas assez d'argent !")
    end
end)

-- Événement pour les actions police
RegisterNetEvent('rageui_menu:policeAction')
AddEventHandler('rageui_menu:policeAction', function(action, targetId)
    local source = source

    -- Vérifier si le joueur est policier (remplacer par votre système de job)
    local isPolice = true -- Simulation

    if not isPolice then
        TriggerClientEvent('rageui_menu:showNotification', source, "Vous n'êtes pas policier !")
        return
    end

    if action == 'backup' then
        -- Envoyer une demande de renfort à tous les policiers
        print(("Demande de renfort de la part du joueur %s"):format(source))
        -- TriggerClientEvent('rageui_menu:backupRequested', -1, source)
    elseif action == 'identity' and targetId then
        -- Contrôle d'identité
        print(("Contrôle d'identité: Joueur %s contrôle joueur %s"):format(source, targetId))
        TriggerClientEvent('rageui_menu:showIdentity', source, targetId)
    elseif action == 'onduty' then
        -- Prendre service
        print(("Joueur %s prend son service de police"):format(source))
        TriggerClientEvent('rageui_menu:policeOnDuty', source)
    end
end)

--[[
    ========================================
    FONCTIONS UTILITAIRES
    ========================================
]]

-- Fonction pour récupérer les informations d'un joueur
function GetPlayerInfo(playerId)
    local playerPed = GetPlayerPed(playerId)
    local coords = GetEntityCoords(playerPed)

    return {
        id = playerId,
        name = GetPlayerName(playerId),
        coords = { x = coords.x, y = coords.y, z = coords.z },
        health = GetEntityHealth(playerPed),
        armor = GetPedArmour(playerPed)
    }
end

-- Fonction pour obtenir le joueur le plus proche
function GetClosestPlayer(playerId, maxDistance)
    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer = nil
    local closestDistance = maxDistance or 5.0

    for _, targetId in ipairs(GetPlayers()) do
        if tonumber(targetId) ~= playerId then
            local targetPed = GetPlayerPed(targetId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)

            if distance < closestDistance then
                closestPlayer = tonumber(targetId)
                closestDistance = distance
            end
        end
    end

    return closestPlayer
end

--[[
    ========================================
    COMMANDES SERVEUR
    ========================================
]]

-- Commande pour obtenir le joueur le plus proche (pour la police)
RegisterCommand('closest', function(source, args, rawCommand)
    if source == 0 then return end -- Éviter l'exécution depuis la console

    local closestPlayer = GetClosestPlayer(source, 10.0)
    if closestPlayer then
        local info = GetPlayerInfo(closestPlayer)
        TriggerClientEvent('rageui_menu:showNotification', source,
            ("Joueur le plus proche: %s (ID: %s)"):format(info.name, info.id))
    else
        TriggerClientEvent('rageui_menu:showNotification', source, "Aucun joueur à proximité")
    end
end, false)

--[[
    ========================================
    ÉVÉNEMENTS DE DÉCONNEXION
    ========================================
]]

-- Nettoyer les données quand un joueur se déconnecte
AddEventHandler('playerDropped', function(reason)
    local source = source
    print(("Joueur %s déconnecté: %s"):format(source, reason))
    -- Nettoyer les données du joueur si nécessaire
end)

--[[
    ========================================
    INITIALISATION
    ========================================
]]

Citizen.CreateThread(function()
    print("^2[RageUI Menu Server] Serveur initialisé^0")

    -- Ici vous pouvez initialiser votre base de données
    -- ou d'autres systèmes nécessaires
end)

--[[
    ========================================
    EXPORTS SERVEUR
    ========================================
]]

-- Export pour que d'autres ressources puissent interagir
exports('GetPlayerInventory', function(playerId)
    -- Retourner l'inventaire du joueur depuis la base de données
    return {
        { name = 'Pomme', count = 5 },
        { name = 'Eau',   count = 3 }
    }
end)

exports('GetPlayerVehicles', function(playerId)
    -- Retourner les véhicules du joueur depuis la base de données
    return {
        { model = 'adder',  plate = 'ABC123' },
        { model = 'kuruma', plate = 'DEF456' }
    }
end)

exports('IsPlayerPolice', function(playerId)
    -- Vérifier si le joueur est policier
    return true -- Simulation
end)

print("^2[RageUI Menu Server] Exports disponibles: GetPlayerInventory, GetPlayerVehicles, IsPlayerPolice^0")
