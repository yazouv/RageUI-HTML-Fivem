/**
 * EXEMPLES D'UTILISATION - RageUI Menu System
 * Facilement intégrable avec FiveM
 */

// ========================================
// EXEMPLE 1: MENU PRINCIPAL SIMPLE
// ========================================
RageUI.createMenu('main', 'Menu Principal', 'Choisissez une option', [
    {
        type: 'button',
        label: '📦 Inventaire',
        description: 'Accédez à votre inventaire',
        submenu: 'inventory',
        onclick: () => console.log('Inventaire sélectionné')
    },
    {
        type: 'button',
        label: '🚗 Véhicules',
        description: 'Gérez vos véhicules',
        submenu: 'vehicles'
    },
    {
        type: 'separator',
        label: 'Options'
    },
    {
        type: 'checkbox',
        label: '🔊 Son activé',
        description: 'Active/Désactive les sons',
        checked: true,
        onchange: (checked) => {
            console.log('Son:', checked ? 'Activé' : 'Désactivé');
        }
    },
    {
        type: 'list',
        label: '🎵 Volume',
        description: 'Réglez le volume',
        values: ['Faible', 'Moyen', 'Élevé'],
        index: 1,
        onchange: (index, value) => {
            console.log('Volume changé:', value);
        }
    },
    {
        type: 'button',
        label: '🚪 Quitter',
        description: 'Fermer le menu',
        onclick: () => RageUI.closeMenu()
    }
]);

// ========================================
// EXEMPLE 2: MENU INVENTAIRE
// ========================================
RageUI.createMenu('inventory', 'Inventaire', 'Gérez vos objets', [
    {
        type: 'button',
        label: '🍎 Pomme (x5)',
        description: 'Restaure 20 HP',
        onclick: () => {
            console.log('Pomme utilisée');
            // Pour FiveM: fetch('https://myserver/useItem', {...})
        }
    },
    {
        type: 'button',
        label: '🔫 Pistolet',
        description: 'Arme de base',
        onclick: () => {
            console.log('Pistolet équipé');
        }
    },
    {
        type: 'button',
        label: '💊 Médicament',
        description: 'Soigne les blessures',
        onclick: () => {
            console.log('Médicament utilisé');
        }
    },
    {
        type: 'button',
        label: '🔙 Retour',
        description: 'Retour au menu principal',
        onclick: () => RageUI.goBack()
    }
]);

// ========================================
// EXEMPLE 3: MENU VÉHICULES
// ========================================
RageUI.createMenu('vehicles', 'Garage', 'Vos véhicules', [
    {
        type: 'button',
        label: '🏎️ Adder',
        description: 'Supercar de luxe',
        onclick: () => {
            console.log('Adder sorti du garage');
            // Pour FiveM: TriggerServerEvent('spawnVehicle', 'adder')
        }
    },
    {
        type: 'button',
        label: '🚙 Kuruma',
        description: 'Véhicule blindé',
        onclick: () => {
            console.log('Kuruma sorti du garage');
        }
    },
    {
        type: 'button',
        label: '🔙 Retour',
        onclick: () => RageUI.goBack()
    }
]);

// ========================================
// EXEMPLE 4: MENU POUR JOB (Ex: Policier)
// ========================================
RageUI.createMenu('police', 'Police', 'Actions policières', [
    {
        type: 'button',
        label: '🚔 Faire une patrouille',
        description: 'Commencer une mission de patrouille',
        onclick: () => {
            console.log('Patrouille démarrée');
            RageUI.closeMenu();
            // Pour FiveM: TriggerServerEvent('police:startPatrol')
        }
    },
    {
        type: 'button',
        label: '👮 Contrôle d\'identité',
        description: 'Contrôler l\'identité d\'un joueur',
        submenu: 'police_id'
    },
    {
        type: 'list',
        label: '🚨 Code d\'urgence',
        values: ['Code 1', 'Code 2', 'Code 3'],
        index: 0,
        onchange: (index, value) => {
            console.log('Code d\'urgence:', value);
        }
    }
]);

// ========================================
// EXEMPLE 5: POPUP DE CONFIRMATION
// ========================================
function showConfirmDialog(title, message, onConfirm, onCancel) {
    RageUI.createMenu('confirm', title, message, [
        {
            type: 'button',
            label: '✅ Confirmer',
            onclick: () => {
                RageUI.closeMenu();
                if (onConfirm) onConfirm();
            }
        },
        {
            type: 'button',
            label: '❌ Annuler',
            onclick: () => {
                RageUI.closeMenu();
                if (onCancel) onCancel();
            }
        }
    ]);

    RageUI.openMenu('confirm');
}

// ========================================
// CONFIGURATION POUR FIVEM
// ========================================

// Callbacks pour communiquer avec FiveM
RageUI.setCallbacks({
    onMenuClosed: () => {
        console.log('Menu fermé');
        // Pour FiveM: fetch('https://myserver/menuClosed', {method: 'POST'})
    },

    onItemSelected: (menuId, itemIndex, item) => {
        console.log('Item sélectionné:', menuId, itemIndex, item);
        // Pour FiveM: envoyer au serveur Lua
    }
});

// ========================================
// FONCTIONS UTILES POUR FIVEM
// ========================================

// Mettre à jour un menu dynamiquement (ex: inventaire qui change)
function updateInventory(items) {
    const menuItems = items.map(item => ({
        type: 'button',
        label: `${item.icon} ${item.name} (x${item.count})`,
        description: item.description,
        onclick: () => {
            console.log('Item utilisé:', item.name);
            // TriggerServerEvent('useItem', item.id)
        }
    }));

    // Ajouter le bouton retour
    menuItems.push({
        type: 'button',
        label: '🔙 Retour',
        onclick: () => RageUI.goBack()
    });

    RageUI.updateMenu('inventory', menuItems);
}

// Exemple d'utilisation avec des données dynamiques
const exampleInventoryData = [
    { id: 1, name: 'Pomme', count: 5, icon: '🍎', description: 'Restaure la santé' },
    { id: 2, name: 'Eau', count: 3, icon: '💧', description: 'Restaure la soif' },
    { id: 3, name: 'Clés de voiture', count: 1, icon: '🔑', description: 'Clés du véhicule' }
];

// ========================================
// DÉMARRAGE AUTOMATIQUE (pour le test)
// ========================================
document.addEventListener('DOMContentLoaded', () => {
    // Ouvrir automatiquement le menu principal pour la démo
    setTimeout(() => {
        RageUI.openMenu('main');
    }, 500);
});

// ========================================
// EXEMPLES DE COMMUNICATION FIVEM/NUI
// ========================================

/*
-- CÔTÉ LUA (FiveM Server/Client)

-- Ouvrir un menu depuis Lua
SendNUIMessage({
    action = 'openMenu',
    menuId = 'police'
})

-- Mettre à jour un menu depuis Lua
SendNUIMessage({
    action = 'updateMenu',
    menuId = 'inventory',
    items = {
        {type = 'button', label = '🍎 Pomme (x3)', onclick = 'useItem1'},
        {type = 'button', label = '💧 Eau (x2)', onclick = 'useItem2'}
    }
})

-- Fermer le menu depuis Lua
SendNUIMessage({action = 'closeMenu'})

*/
