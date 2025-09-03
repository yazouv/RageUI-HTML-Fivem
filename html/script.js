/**
 * RageUI Menu System - Modulaire pour FiveM
 * Utilisation simple et flexible pour jobs, popups, etc.
 */

class RageUIMenuSystem {
    constructor() {
        this.menus = {};
        this.currentMenu = null;
        this.menuStack = [];
        this.callbacks = {};
        this.isOpen = false;

        this.init();
    }

    init() {
        this.setupEventListeners();
        this.createStyles();
    }

    setupEventListeners() {
        document.addEventListener('keydown', (e) => {
            if (this.isOpen) {
                this.handleKeyPress(e);
            }
        });
    }

    /**
     * Crée un nouveau menu
     * @param {string} id - ID unique du menu
     * @param {string} title - Titre du menu
     * @param {string} subtitle - Sous-titre (optionnel)
     * @param {Array} items - Items du menu
     */
    createMenu(id, title, subtitle = '', items = []) {
        const menu = {
            id: id,
            title: title,
            subtitle: subtitle,
            items: items,
            activeIndex: 0,
            element: null
        };

        this.menus[id] = menu;
        this.createMenuElement(menu);
        return menu;
    }

    createMenuElement(menu) {
        const menuElement = document.createElement('div');
        menuElement.className = 'rageui-menu';
        menuElement.id = menu.id;
        menuElement.style.display = 'none';

        menuElement.innerHTML = `
            <!-- Header -->
            <div class="menu-header">
                <div class="menu-title">${menu.title}</div>
            </div>
            
            <!-- Subtitle -->
            <div class="menu-subtitle">
                <span class="subtitle-text">${menu.subtitle}</span>
                <span class="page-counter">1 / ${menu.items.length}</span>
            </div>
            
            <!-- Menu Items -->
            <div class="menu-items"></div>
            
            <!-- Navigation -->
            <div class="menu-navigation">
                <div class="nav-arrows">▲▼</div>
            </div>
            
            <!-- Description -->
            <div class="menu-description">
                <div class="description-bar"></div>
                <div class="description-text">
                    Utilisez les flèches pour naviguer et Entrée pour sélectionner.
                </div>
            </div>
            
            <!-- Instructions -->
            <div class="menu-instructions">
                <div class="instruction-item">
                    <span class="key-icon">↑↓</span>
                    <span class="key-text">Naviguer</span>
                </div>
                <div class="instruction-item">
                    <span class="key-icon">↵</span>
                    <span class="key-text">Sélectionner</span>
                </div>
                <div class="instruction-item">
                    <span class="key-icon">⌫</span>
                    <span class="key-text">Retour</span>
                </div>
            </div>
        `;

        menu.element = menuElement;
        this.updateMenuItems(menu);

        // Chercher le container ou le créer
        let container = document.querySelector('.menu-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'menu-container';
            document.body.appendChild(container);
        }
        container.appendChild(menuElement);
    }

    updateMenuItems(menu) {
        const itemsContainer = menu.element.querySelector('.menu-items');
        itemsContainer.innerHTML = '';

        menu.items.forEach((item, index) => {
            const itemElement = this.createItemElement(item, index === menu.activeIndex);
            itemsContainer.appendChild(itemElement);
        });
    }

    createItemElement(item, isActive) {
        const itemElement = document.createElement('div');
        let className = 'menu-item';

        if (isActive) className += ' active';
        if (item.type === 'separator') className += ' separator';
        if (item.type === 'checkbox') className += ' checkbox';
        if (item.type === 'list') className += ' list';

        itemElement.className = className;

        switch (item.type) {
            case 'separator':
                itemElement.innerHTML = `<span class="separator-text">${item.label}</span>`;
                break;

            case 'checkbox':
                itemElement.dataset.checked = item.checked || false;
                itemElement.innerHTML = `
                    <span class="item-text">${item.label}</span>
                    <span class="checkbox-icon"></span>
                `;
                break;

            case 'list':
                const currentValue = item.values[item.index || 0];
                itemElement.dataset.listIndex = item.index || 0;
                itemElement.innerHTML = `
                    <span class="item-text">${item.label}</span>
                    <span class="list-control">‹ ${currentValue} ›</span>
                `;
                break;

            default: // button
                itemElement.innerHTML = `
                    <span class="item-text">${item.label}</span>
                    <span class="item-arrow">›</span>
                `;
                break;
        }

        return itemElement;
    }

    /**
     * Ouvre un menu
     * @param {string} menuId - ID du menu à ouvrir
     */
    openMenu(menuId) {
        if (!this.menus[menuId]) {
            console.error(`Menu ${menuId} n'existe pas`);
            return;
        }

        // Fermer le menu actuel s'il existe
        if (this.currentMenu) {
            this.menus[this.currentMenu].element.style.display = 'none';
            this.menuStack.push(this.currentMenu);
        }

        this.currentMenu = menuId;
        this.menus[menuId].element.style.display = 'block';
        this.menus[menuId].activeIndex = 0;
        this.updateMenuItems(this.menus[menuId]);
        this.updateDescription();
        this.isOpen = true;

        // Pour FiveM - Désactiver les contrôles du jeu
        if (typeof SetNuiFocus !== 'undefined') {
            SetNuiFocus(true, false);
        }
    }

    /**
     * Ferme le menu actuel
     */
    closeMenu() {
        if (this.currentMenu) {
            this.menus[this.currentMenu].element.style.display = 'none';
        }

        this.currentMenu = null;
        this.menuStack = [];
        this.isOpen = false;

        // Pour FiveM - Réactiver les contrôles du jeu
        if (typeof SetNuiFocus !== 'undefined') {
            SetNuiFocus(false, false);
        }

        // Callback pour FiveM
        if (this.callbacks.onMenuClosed) {
            this.callbacks.onMenuClosed();
        }
    }

    /**
     * Retourne au menu précédent
     */
    goBack() {
        if (this.menuStack.length > 0) {
            const previousMenu = this.menuStack.pop();
            this.menus[this.currentMenu].element.style.display = 'none';
            this.currentMenu = previousMenu;
            this.menus[previousMenu].element.style.display = 'block';
            this.updateDescription();
        } else {
            this.closeMenu();
        }
    }

    handleKeyPress(e) {
        if (!this.currentMenu) return;

        switch (e.key) {
            case 'ArrowUp':
                e.preventDefault();
                this.navigateUp();
                break;
            case 'ArrowDown':
                e.preventDefault();
                this.navigateDown();
                break;
            case 'Enter':
                e.preventDefault();
                this.selectCurrentItem();
                break;
            case 'Escape':
            case 'Backspace':
                e.preventDefault();
                this.goBack();
                break;
            case 'ArrowLeft':
                e.preventDefault();
                this.handleLeftArrow();
                break;
            case 'ArrowRight':
                e.preventDefault();
                this.handleRightArrow();
                break;
        }
    }

    navigateUp() {
        const menu = this.menus[this.currentMenu];
        let newIndex = menu.activeIndex - 1;

        // Skip separators
        while (newIndex >= 0 && menu.items[newIndex].type === 'separator') {
            newIndex--;
        }

        if (newIndex < 0) {
            // Go to last non-separator item
            newIndex = menu.items.length - 1;
            while (newIndex >= 0 && menu.items[newIndex].type === 'separator') {
                newIndex--;
            }
        }

        if (newIndex >= 0) {
            menu.activeIndex = newIndex;
            this.updateMenuItems(menu);
            this.updateDescription();
        }
    }

    navigateDown() {
        const menu = this.menus[this.currentMenu];
        let newIndex = menu.activeIndex + 1;

        // Skip separators
        while (newIndex < menu.items.length && menu.items[newIndex].type === 'separator') {
            newIndex++;
        }

        if (newIndex >= menu.items.length) {
            // Go to first non-separator item
            newIndex = 0;
            while (newIndex < menu.items.length && menu.items[newIndex].type === 'separator') {
                newIndex++;
            }
        }

        if (newIndex < menu.items.length) {
            menu.activeIndex = newIndex;
            this.updateMenuItems(menu);
            this.updateDescription();
        }
    }

    selectCurrentItem() {
        const menu = this.menus[this.currentMenu];
        const item = menu.items[menu.activeIndex];

        if (!item) return;

        // Animation de sélection
        const itemElement = menu.element.querySelectorAll('.menu-item')[menu.activeIndex];
        itemElement.classList.add('selecting');
        setTimeout(() => {
            itemElement.classList.remove('selecting');
        }, 300);

        switch (item.type) {
            case 'checkbox':
                item.checked = !item.checked;
                this.updateMenuItems(menu);
                if (item.onchange) {
                    item.onchange(item.checked);
                }
                break;

            case 'button':
                if (item.submenu) {
                    this.openMenu(item.submenu);
                } else if (item.onclick) {
                    item.onclick();
                }
                break;

            default:
                if (item.onclick) {
                    item.onclick();
                }
                break;
        }

        // Callback global pour FiveM
        if (this.callbacks.onItemSelected) {
            this.callbacks.onItemSelected(menu.id, menu.activeIndex, item);
        }
    }

    handleLeftArrow() {
        const menu = this.menus[this.currentMenu];
        const item = menu.items[menu.activeIndex];

        if (item && item.type === 'list') {
            let newIndex = (item.index || 0) - 1;
            if (newIndex < 0) newIndex = item.values.length - 1;

            item.index = newIndex;
            this.updateMenuItems(menu);

            if (item.onchange) {
                item.onchange(newIndex, item.values[newIndex]);
            }
        }
    }

    handleRightArrow() {
        const menu = this.menus[this.currentMenu];
        const item = menu.items[menu.activeIndex];

        if (item && item.type === 'list') {
            let newIndex = (item.index || 0) + 1;
            if (newIndex >= item.values.length) newIndex = 0;

            item.index = newIndex;
            this.updateMenuItems(menu);

            if (item.onchange) {
                item.onchange(newIndex, item.values[newIndex]);
            }
        }
    }

    updateDescription() {
        const menu = this.menus[this.currentMenu];
        const item = menu.items[menu.activeIndex];
        const descElement = menu.element.querySelector('.description-text');

        if (item && item.description) {
            descElement.textContent = item.description;
        } else {
            descElement.textContent = 'Utilisez les flèches pour naviguer et Entrée pour sélectionner.';
        }
    }

    /**
     * Met à jour un menu existant
     * @param {string} menuId - ID du menu
     * @param {Array} items - Nouveaux items
     */
    updateMenu(menuId, items) {
        if (this.menus[menuId]) {
            this.menus[menuId].items = items;
            this.menus[menuId].activeIndex = 0;
            this.updateMenuItems(this.menus[menuId]);
        }
    }

    /**
     * Définit les callbacks pour FiveM
     * @param {Object} callbacks 
     */
    setCallbacks(callbacks) {
        this.callbacks = callbacks;
    }

    createStyles() {
        // Styles déjà définis dans style.css
    }
}

// Instance globale pour faciliter l'utilisation
const RageUI = new RageUIMenuSystem();

// Pour FiveM - Écouter les messages NUI
if (typeof window !== 'undefined') {
    window.addEventListener('message', (event) => {
        const data = event.data;

        switch (data.action) {
            case 'openMenu':
                RageUI.openMenu(data.menuId);
                break;
            case 'closeMenu':
                RageUI.closeMenu();
                break;
            case 'updateMenu':
                RageUI.updateMenu(data.menuId, data.items);
                break;
        }
    });
}

// Add CSS animations for notifications
const style = document.createElement('style');
style.textContent = `
    @keyframes notificationSlide {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    @keyframes notificationSlideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }

    @keyframes menuSlideOut {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(-20px);
        }
    }
`;
document.head.appendChild(style);

// Initialize the menu when the page loads
document.addEventListener('DOMContentLoaded', () => {
    new RageUIMenu();
});

// Show instructions on load
window.addEventListener('load', () => {
    setTimeout(() => {
        const instructions = document.createElement('div');
        instructions.innerHTML = `
            <div style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); 
                        background: rgba(0,0,0,0.9); color: white; padding: 20px; border-radius: 10px;
                        border: 2px solid #3498db; text-align: center; z-index: 2000; max-width: 400px;">
                <h3 style="color: #3498db; margin-bottom: 15px;">🎮 RageUI Menu Demo</h3>
                <p style="margin-bottom: 10px;">Utilisez les <strong>flèches</strong> pour naviguer</p>
                <p style="margin-bottom: 10px;">Appuyez sur <strong>Entrée</strong> pour sélectionner</p>
                <p style="margin-bottom: 15px;">Utilisez <strong>Échap</strong> pour revenir en arrière</p>
                <button onclick="this.parentElement.remove()" 
                        style="background: #3498db; color: white; border: none; padding: 8px 16px; 
                               border-radius: 5px; cursor: pointer;">Compris!</button>
            </div>
        `;
        document.body.appendChild(instructions);
    }, 1000);
});
