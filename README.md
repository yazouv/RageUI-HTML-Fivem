# 🎮 RageUI Menu System - Modulaire pour FiveM

Un système de menus RageUI authentique, entièrement modulaire et facilement intégrable avec FiveM.

## ✨ Fonctionnalités

- ✅ **Design authentique RageUI** (style FiveM)
- ✅ **100% contrôlé au clavier** (pas de souris)
- ✅ **Position fixe** en haut à gauche
- ✅ **Système modulaire** pour créer facilement des menus
- ✅ **Types d'éléments** : boutons, checkboxes, listes, séparateurs
- ✅ **Navigation hiérarchique** avec sous-menus
- ✅ **Callbacks personnalisables** pour FiveM
- ✅ **Checkboxes améliorées** avec style RageUI authentique

## 🚀 Utilisation rapide

### 1. Créer un menu simple

```javascript
RageUI.createMenu('monMenu', 'Mon Titre', 'Mon sous-titre', [
    {
        type: 'button',
        label: '📦 Option 1',
        description: 'Description de l\'option',
        onclick: () => console.log('Option 1 cliquée')
    },
    {
        type: 'checkbox',
        label: '🔊 Option avec checkbox',
        checked: true,
        onchange: (checked) => console.log('Checkbox:', checked)
    },
    {
        type: 'list',
        label: '🎵 Liste de choix',
        values: ['Choix 1', 'Choix 2', 'Choix 3'],
        index: 0,
        onchange: (index, value) => console.log('Sélectionné:', value)
    }
]);

// Ouvrir le menu
RageUI.openMenu('monMenu');
```

### 2. Menu avec sous-menus

```javascript
// Menu principal
RageUI.createMenu('main', 'Menu Principal', '', [
    {
        type: 'button',
        label: '📦 Inventaire',
        submenu: 'inventory' // Ouvre automatiquement le menu 'inventory'
    }
]);

// Sous-menu inventaire
RageUI.createMenu('inventory', 'Inventaire', 'Vos objets', [
    {
        type: 'button',
        label: '🍎 Pomme',
        onclick: () => console.log('Pomme utilisée')
    },
    {
        type: 'button',
        label: '🔙 Retour',
        onclick: () => RageUI.goBack()
    }
]);
```

### 3. Pour les jobs FiveM

```javascript
// Menu job policier
RageUI.createMenu('police', 'Police', 'Actions policières', [
    {
        type: 'button',
        label: '🚔 Patrouille',
        onclick: () => {
            RageUI.closeMenu();
            // TriggerServerEvent('police:startPatrol');
        }
    },
    {
        type: 'list',
        label: '🚨 Code urgence',
        values: ['Code 1', 'Code 2', 'Code 3'],
        onchange: (index, value) => {
            // TriggerServerEvent('police:setCode', index);
        }
    }
]);
```

## 🎯 Types d'éléments disponibles

### Button (bouton)
```javascript
{
    type: 'button',
    label: '📦 Mon bouton',
    description: 'Description optionnelle',
    onclick: () => { /* action */ },
    submenu: 'autreMenu' // Optionnel: ouvre un sous-menu
}
```

### Checkbox
```javascript
{
    type: 'checkbox',
    label: '🔊 Mon checkbox',
    description: 'Active/désactive quelque chose',
    checked: true, // État initial
    onchange: (checked) => { /* action avec l'état */ }
}
```

### List (liste déroulante)
```javascript
{
    type: 'list',
    label: '🎵 Ma liste',
    description: 'Choisissez une option',
    values: ['Option 1', 'Option 2', 'Option 3'],
    index: 0, // Index initial
    onchange: (index, value) => { /* action */ }
}
```

### Separator (séparateur)
```javascript
{
    type: 'separator',
    label: 'Section Title'
}
```

## 🎮 Navigation

- **Flèches ↑/↓** : Naviguer dans le menu
- **Flèches ←/→** : Changer les valeurs des listes
- **Entrée** : Sélectionner un élément
- **Échap/Retour** : Retour au menu précédent

## 🔧 Intégration FiveM

### Côté Client Lua
```lua
-- Ouvrir un menu depuis Lua
SendNUIMessage({
    action = 'openMenu',
    menuId = 'police'
})

-- Fermer le menu
SendNUIMessage({action = 'closeMenu'})

-- Mettre à jour un menu dynamiquement
SendNUIMessage({
    action = 'updateMenu',
    menuId = 'inventory',
    items = {
        {type = 'button', label = '🍎 Pomme (x3)'},
        {type = 'button', label = '💧 Eau (x2)'}
    }
})
```

### Callbacks JavaScript
```javascript
// Configurer les callbacks pour FiveM
RageUI.setCallbacks({
    onMenuClosed: () => {
        // Informer FiveM que le menu est fermé
        fetch('https://myserver/menuClosed', {method: 'POST'});
    },
    
    onItemSelected: (menuId, itemIndex, item) => {
        // Envoyer les actions au serveur FiveM
        fetch(`https://myserver/itemSelected`, {
            method: 'POST',
            body: JSON.stringify({menuId, itemIndex, item})
        });
    }
});
```

## 📁 Structure des fichiers

```
Menus/
├── index.html      # Page principale (minimaliste)
├── style.css       # Styles RageUI authentiques
├── script.js       # Système de menu modulaire
├── examples.js     # Exemples d'utilisation
└── README.md       # Ce fichier
```

## 📱 Exemples prêts à l'emploi

Le fichier `examples.js` contient des exemples complets :
- Menu principal avec sous-menus
- Menu d'inventaire dynamique
- Menu de job (police)
- Popups de confirmation
- Communication avec FiveM

## 🚀 Démarrage rapide

1. Ouvrez `index.html` dans votre navigateur
2. Le menu de démo s'ouvre automatiquement
3. Consultez `examples.js` pour voir comment créer vos propres menus
4. Adaptez pour votre serveur FiveM !

---

**Parfait pour :** Jobs, inventaires, garages, shops, administration, popups de confirmation, etc.
