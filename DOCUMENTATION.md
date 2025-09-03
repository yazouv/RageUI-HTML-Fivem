# RageUI Menu System - Ressource FiveM

Un système de menu HTML/JavaScript inspiré de RageUI, 100% contrôlable au clavier, positionné en haut à gauche et entièrement modulaire.

## 📋 Fonctionnalités

- ✅ **100% Clavier** : Navigation complète au clavier (flèches, Entrée, Échap)
- ✅ **Position fixe** : Menu positionné en haut à gauche
- ✅ **Authentique RageUI** : Style visuel identique à RageUI
- ✅ **Modulaire** : Système facile pour créer des menus dynamiques
- ✅ **Types d'éléments** : Boutons, listes, checkboxes, séparateurs
- ✅ **Sous-menus** : Navigation entre plusieurs menus
- ✅ **Intégration FiveM** : NUI avec callbacks Lua
- ✅ **Exemples inclus** : Menus pour inventaire, véhicules, police, etc.

## 🎮 Contrôles

| Touche   | Action                     |
| -------- | -------------------------- |
| `↑`      | Élément précédent          |
| `↓`      | Élément suivant            |
| `←`      | Valeur précédente (listes) |
| `→`      | Valeur suivante (listes)   |
| `Entrée` | Sélectionner/Activer       |
| `Échap`  | Fermer le menu             |

## 📁 Structure du projet

```
Menus/
├── fxmanifest.lua          # Manifest FiveM
├── html/
│   ├── index.html          # Interface NUI
│   ├── style.css          # Styles RageUI
│   ├── script.js          # Système de menu JavaScript
│   └── examples.js        # Exemples de menus (optionnel)
├── client/
│   ├── main.lua           # Script client principal
│   └── examples.lua       # Exemples d'utilisation
└── server/
    └── main.lua           # Script serveur (optionnel)
```

## 🚀 Installation

1. Placez le dossier `Menus` dans votre dossier `resources`
2. Ajoutez `start Menus` à votre `server.cfg`
3. Redémarrez votre serveur

## 💻 Utilisation de base

### Créer un menu simple

```lua
-- Définir les éléments du menu
local items = {
    {
        type = 'button',
        label = '🎯 Action 1',
        description = 'Description de l\'action 1'
    },
    {
        type = 'list',
        label = '📊 Options',
        description = 'Choisissez une option',
        values = {'Option A', 'Option B', 'Option C'},
        index = 0
    },
    {
        type = 'checkbox',
        label = '✅ Activé',
        description = 'Cochez pour activer',
        checked = false
    }
}

-- Créer le menu
exports['rageui_menu']:CreateMenu('mon_menu', 'Mon Titre', '~b~Mon sous-titre', items)

-- Ouvrir le menu
exports['rageui_menu']:OpenMenu('mon_menu')
```

### Gérer les callbacks

```lua
exports['rageui_menu']:RegisterMenuCallback('mon_menu', function(data)
    if data.item then
        print("Action:", data.item.label)
        print("Type:", data.item.type)

        if data.item.type == 'checkbox' then
            print("Coché:", data.item.checked)
        elseif data.item.type == 'list' then
            print("Valeur:", data.item.value)
        end
    end
end)
```

## 🔧 API Complète

### Exports disponibles

#### `CreateMenu(id, title, subtitle, items)`

Crée un nouveau menu

**Paramètres:**

- `id` (string) : Identifiant unique du menu
- `title` (string) : Titre principal
- `subtitle` (string) : Sous-titre (supporte les codes couleur GTA)
- `items` (table) : Liste des éléments du menu

#### `OpenMenu(id)`

Ouvre un menu existant

#### `CloseMenu()`

Ferme le menu actuel

#### `RegisterMenuCallback(id, callback)`

Enregistre une fonction de callback pour un menu

### Types d'éléments

#### Bouton

```lua
{
    type = 'button',
    label = 'Texte du bouton',
    description = 'Description optionnelle',
    submenu = 'id_autre_menu' -- Optionnel : ouvre un autre menu
}
```

#### Liste

```lua
{
    type = 'list',
    label = 'Titre de la liste',
    description = 'Description',
    values = {'Valeur 1', 'Valeur 2', 'Valeur 3'},
    index = 0 -- Index par défaut
}
```

#### Checkbox

```lua
{
    type = 'checkbox',
    label = 'Texte de la checkbox',
    description = 'Description',
    checked = false -- État par défaut
}
```

#### Séparateur

```lua
{
    type = 'separator',
    label = 'Titre de section'
}
```

## 📚 Exemples inclus

La ressource inclut plusieurs exemples prêts à utiliser :

### Commandes disponibles

- `/menu` ou `F1` - Menu principal
- `/inv` - Menu inventaire
- `/garage` - Menu véhicules
- `/police` - Menu police

### Menus d'exemple

1. **Menu Principal** : Navigation générale avec sous-menus
2. **Inventaire** : Liste des objets du joueur
3. **Garage** : Gestion des véhicules
4. **Informations** : Stats du joueur avec actions
5. **Police** : Outils pour les forces de l'ordre

## 🎨 Personnalisation

### Modifier les couleurs

Éditez `html/style.css` pour changer l'apparence :

```css
/* Couleur principale */
.menu-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* Couleur de sélection */
.menu-item.selected {
  background: rgba(255, 255, 255, 0.1);
}
```

### Modifier la position

Dans `html/style.css` :

```css
.menu-container {
  position: fixed;
  top: 50px; /* Ajustez la position verticale */
  left: 50px; /* Ajustez la position horizontale */
}
```

## 🔌 Intégration avec d'autres ressources

### Ouvrir un menu depuis une autre ressource

```lua
-- Depuis n'importe quelle ressource
exports['rageui_menu']:OpenMenu('inventory')
```

### Créer des menus dynamiques

```lua
-- Menu généré dynamiquement
local function CreateJobMenu(jobName, jobGrade)
    local items = {
        {
            type = 'button',
            label = '👔 Job: ' .. jobName,
            description = 'Grade: ' .. jobGrade
        }
    }

    exports['rageui_menu']:CreateMenu('job_menu', 'Menu Emploi', '~g~' .. jobName, items)
end
```

## 🐛 Dépannage

### Le menu ne s'ouvre pas

- Vérifiez que la ressource est démarrée
- Contrôlez les logs de la console F8
- Assurez-vous que l'ID du menu existe

### Navigation ne fonctionne pas

- Vérifiez que les contrôles ne sont pas utilisés par une autre ressource
- Testez avec les touches par défaut

### Erreurs JavaScript

- Ouvrez la console du navigateur (F12 → Console)
- Vérifiez la syntaxe des éléments du menu

## 📖 Changelog

### v1.0.0

- ✅ Système de menu complet
- ✅ Navigation clavier
- ✅ Interface RageUI authentique
- ✅ API modulaire
- ✅ Exemples inclus
- ✅ Documentation complète

## 🤝 Support

Pour obtenir de l'aide ou signaler des bugs :

1. Vérifiez d'abord cette documentation
2. Consultez les exemples fournis
3. Testez avec les menus d'exemple inclus

## 📄 Licence

Cette ressource est open source et libre d'utilisation pour tout serveur FiveM.

---

**Développé avec ❤️ pour la communauté FiveM**
