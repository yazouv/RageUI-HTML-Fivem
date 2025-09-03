--[[
    Test rapide du système RageUI Menu
    Utilisez /test_menu pour ouvrir un menu de test
]]

RegisterCommand('test_menu', function()
    -- Créer un menu de test simple
    local items = {
        {
            type = 'button',
            label = '🎯 Test Button',
            description = 'Ceci est un bouton de test'
        },
        {
            type = 'list',
            label = '📋 Test List',
            description = 'Liste de test avec plusieurs options',
            values = { 'Option 1', 'Option 2', 'Option 3', 'Option 4' },
            index = 0
        },
        {
            type = 'checkbox',
            label = '✅ Test Checkbox',
            description = 'Checkbox de test',
            checked = false
        },
        {
            type = 'separator',
            label = 'Section de test'
        },
        {
            type = 'button',
            label = '❌ Fermer',
            description = 'Fermer ce menu de test'
        }
    }

    -- Créer et ouvrir le menu
    exports['rageui_menu']:CreateMenu('test', 'Menu de Test', '~y~Test du système', items)
    exports['rageui_menu']:OpenMenu('test')
end, false)

-- Callback pour le menu de test
exports['rageui_menu']:RegisterMenuCallback('test', function(data)
    if data.item then
        if string.find(data.item.label, "Fermer") then
            exports['rageui_menu']:CloseMenu()
        else
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Test: " .. data.item.label)
            DrawNotification(false, false)
        end
    end
end)

print("^2[RageUI Test] Tapez /test_menu pour tester le système^0")
