--[[
    RageUI Menu System - Client Principal
    Système de menus modulaire pour FiveM
]]

local RageUIMenu = {}
local isMenuOpen = false
local currentMenu = nil
local menuCallbacks = {}

-- Variable pour désactiver les contrôles pendant l'ouverture du menu
local disableControls = false

--[[
    Initialisation du système
]]
Citizen.CreateThread(function()
    SetNuiFocus(false, false)
end)

--[[
    Ouvre un menu
    @param menuId string - ID unique du menu
    @param data table - Données optionnelles à passer au menu
]]
function RageUIMenu.Open(menuId, data)
    if not menuId then
        print("^1[RageUI] Erreur: menuId requis pour ouvrir un menu^0")
        return
    end

    isMenuOpen = true
    currentMenu = menuId
    disableControls = true

    -- Activer le focus NUI
    SetNuiFocus(true, false)

    -- Envoyer les données au NUI
    SendNUIMessage({
        action = 'openMenu',
        menuId = menuId,
        data = data or {}
    })

    print("^2[RageUI] Menu ouvert: " .. menuId .. "^0")
end

--[[
    Ferme le menu actuel
]]
function RageUIMenu.Close()
    if not isMenuOpen then
        return
    end

    isMenuOpen = false
    currentMenu = nil
    disableControls = false

    -- Désactiver le focus NUI
    SetNuiFocus(false, false)

    -- Envoyer au NUI
    SendNUIMessage({
        action = 'closeMenu'
    })

    print("^2[RageUI] Menu fermé^0")
end

--[[
    Crée un menu avec des items
    @param menuId string - ID unique du menu
    @param title string - Titre du menu
    @param subtitle string - Sous-titre (optionnel)
    @param items table - Liste des items du menu
]]
function RageUIMenu.CreateMenu(menuId, title, subtitle, items)
    if not menuId or not title then
        print("^1[RageUI] Erreur: menuId et title requis^0")
        return
    end

    SendNUIMessage({
        action = 'createMenu',
        menuId = menuId,
        title = title,
        subtitle = subtitle or '',
        items = items or {}
    })

    print("^2[RageUI] Menu créé: " .. menuId .. "^0")
end

--[[
    Met à jour un menu existant
    @param menuId string - ID du menu à mettre à jour
    @param items table - Nouveaux items
]]
function RageUIMenu.UpdateMenu(menuId, items)
    if not menuId then
        print("^1[RageUI] Erreur: menuId requis^0")
        return
    end

    SendNUIMessage({
        action = 'updateMenu',
        menuId = menuId,
        items = items or {}
    })
end

--[[
    Enregistre un callback pour un menu
    @param menuId string - ID du menu
    @param callback function - Fonction de callback
]]
function RageUIMenu.RegisterCallback(menuId, callback)
    if not menuId or type(callback) ~= 'function' then
        print("^1[RageUI] Erreur: menuId et callback valide requis^0")
        return
    end

    menuCallbacks[menuId] = callback
    print("^2[RageUI] Callback enregistré pour: " .. menuId .. "^0")
end

--[[
    Gestion des messages NUI
]]
RegisterNUICallback('menuClosed', function(data, cb)
    RageUIMenu.Close()
    cb('ok')
end)

RegisterNUICallback('itemSelected', function(data, cb)
    if currentMenu and menuCallbacks[currentMenu] then
        menuCallbacks[currentMenu](data)
    end

    -- Trigger un événement pour les autres ressources
    TriggerEvent('rageui:itemSelected', currentMenu, data)

    cb('ok')
end)

RegisterNUICallback('menuAction', function(data, cb)
    -- Gestion des actions spécifiques
    if data.action == 'close' then
        RageUIMenu.Close()
    elseif data.action == 'notification' then
        -- Afficher une notification FiveM
        SetNotificationTextEntry("STRING")
        AddTextComponentString(data.message or "Action effectuée")
        DrawNotification(false, false)
    end

    cb('ok')
end)

--[[
    Désactivation des contrôles pendant l'ouverture du menu
]]
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if disableControls and isMenuOpen then
            -- Désactiver tous les contrôles de mouvement
            DisableAllControlActions(0)

            -- Réactiver les contrôles nécessaires pour le menu
            EnableControlAction(0, 1, true)   -- Souris X
            EnableControlAction(0, 2, true)   -- Souris Y
            EnableControlAction(0, 172, true) -- Flèche haut
            EnableControlAction(0, 173, true) -- Flèche bas
            EnableControlAction(0, 174, true) -- Flèche gauche
            EnableControlAction(0, 175, true) -- Flèche droite
            EnableControlAction(0, 176, true) -- Entrée
            EnableControlAction(0, 177, true) -- Échap/Retour
            EnableControlAction(0, 200, true) -- Échap (menu pause)
        else
            Citizen.Wait(500)
        end
    end
end)

--[[
    Commandes de test (à supprimer en production)
]]
RegisterCommand('testmenu', function(source, args)
    local menuId = args[1] or 'main'
    RageUIMenu.Open(menuId)
end, false)

RegisterCommand('closemenu', function()
    RageUIMenu.Close()
end, false)

--[[
    Exports pour autres ressources
]]
exports('OpenMenu', RageUIMenu.Open)
exports('CloseMenu', RageUIMenu.Close)
exports('CreateMenu', RageUIMenu.CreateMenu)
exports('UpdateMenu', RageUIMenu.UpdateMenu)
exports('RegisterMenuCallback', RageUIMenu.RegisterCallback)

--[[
    Events pour la compatibilité
]]
RegisterNetEvent('rageui:openMenu')
AddEventHandler('rageui:openMenu', function(menuId, data)
    RageUIMenu.Open(menuId, data)
end)

RegisterNetEvent('rageui:closeMenu')
AddEventHandler('rageui:closeMenu', function()
    RageUIMenu.Close()
end)

RegisterNetEvent('rageui:createMenu')
AddEventHandler('rageui:createMenu', function(menuId, title, subtitle, items)
    RageUIMenu.CreateMenu(menuId, title, subtitle, items)
end)

RegisterNetEvent('rageui:updateMenu')
AddEventHandler('rageui:updateMenu', function(menuId, items)
    RageUIMenu.UpdateMenu(menuId, items)
end)

print("^2[RageUI] Client chargé avec succès^0")
