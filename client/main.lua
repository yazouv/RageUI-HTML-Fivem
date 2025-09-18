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
    SendNUIMessage({
        action = 'hideAll'
    })
    Wait(1000)
end)

--[[
    Ouvre un menu
    @param menuId string - ID unique du menu
    @param data table - Données optionnelles à passer au menu
]]
function RageUIMenu.Open(menuId, data)
    if not menuId then
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
        return
    end

    SendNUIMessage({
        action = 'createMenu',
        menuId = menuId,
        title = title,
        subtitle = subtitle or '',
        items = items or {}
    })
end

--[[
    Crée un sous-menu relié à un menu parent
    @param menuId string - ID unique du sous-menu
    @param parentMenuId string - ID du menu parent
    @param title string - Titre du sous-menu
    @param subtitle string - Sous-titre (optionnel)
    @param items table - Liste des items du sous-menu
]]
function RageUIMenu.CreateSubMenu(menuId, parentMenuId, title, subtitle, items)
    if not menuId or not parentMenuId or not title then
        return
    end

    SendNUIMessage({
        action = 'createSubMenu',
        menuId = menuId,
        parentMenuId = parentMenuId,
        title = title,
        subtitle = subtitle or '',
        items = items or {}
    })
end

--[[
    Ouvre un sous-menu spécifique
    @param menuId string - ID du sous-menu à ouvrir
]]
function RageUIMenu.OpenSubMenu(menuId)
    if not menuId then
        return
    end

    SendNUIMessage({
        action = 'openSubMenu',
        menuId = menuId
    })
end

--[[
    Met à jour un menu existant
    @param menuId string - ID du menu à mettre à jour
    @param items table - Nouveaux items
]]
function RageUIMenu.UpdateMenu(menuId, items)
    if not menuId then
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
    print("Registering callback for menu:", menuId)
    menuCallbacks[menuId] = callback
end

--[[
    Supprime un callback pour un menu
    @param menuId string - ID du menu
]]
function RageUIMenu.UnregisterCallback(menuId)
    print("Unregistering callback for menu:", menuId)
    menuCallbacks[menuId] = nil
end

--[[
    Gestion des messages NUI
]]

exports('GetCurrentMenu', function()
    return currentMenu
end)

exports('IsMenuOpen', function()
    return currentMenu ~= nil
end)

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

RegisterNUICallback('listChanged', function(data, cb)
    -- Trigger un événement pour les autres ressources
    TriggerEvent('rageui:listChanged', data.menuId, data.itemId, data.newIndex, data.newValue)
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
    Exports pour autres ressources
]]
exports('OpenMenu', RageUIMenu.Open)
exports('CloseMenu', RageUIMenu.Close)
exports('CreateMenu', RageUIMenu.CreateMenu)
exports('CreateSubMenu', RageUIMenu.CreateSubMenu)
exports('OpenSubMenu', RageUIMenu.OpenSubMenu)
exports('UpdateMenu', RageUIMenu.UpdateMenu)
exports('RegisterMenuCallback', RageUIMenu.RegisterCallback)
exports('UnregisterMenuCallback', RageUIMenu.UnregisterCallback)
