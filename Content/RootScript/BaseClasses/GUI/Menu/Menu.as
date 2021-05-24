shared abstract class Menu {
    private string _type;
    string type {
        get { return _type; }
    }

    array<GUIComponent@> components;

    Menu(const string&in type) {
        _type = type;
    }

    void onActivate() {}
    void onDeactivate() {}

    // Returns whether this menu should detach.
    bool onEscapeHit() { return true; }

    // Returns whether this menu should detach.
    bool update() { return false; }

    void render() final {
        for (int i = 0; i < components.length(); i++) {
            if (components[i].active) {
                components[i].render();
            }
        }
    }
}

shared class MenuManager {
    Menu@ currMenu;

    void deactivateMenu(Menu@ mu) {
        if (@currMenu == @mu) {
            @currMenu = null;
            mu.onDeactivate();
            for (int i = 0; i < mu.components.length(); i++) {
                mu.components[i].onClose();
            }
        } else {
            Debug::error("Attempted to deactivate a menu that wasn't active.");
        }
        World::paused = false;
    }

    void activateMenu(Menu@ mu) {
        if (currMenu == null) {
            @currMenu = mu;
            mu.onActivate();
            for (int i = 0; i < mu.components.length(); i++) {
                mu.components[i].onOpen();
            }
        } else {
            Debug::error("Attempted to activate a menu while another was active.");
        }
        World::paused = true;
    }

    void update() {
        if (Input::Escape::isHit()) {
            if (GUITextInput::subscriber != null && currMenu != null && currMenu.type != "console") {
                GUITextInput::subscriber.deselect();
            } else if (currMenu == null) {
                //activateMenu(PauseMenu::instance);
		Menu::pause();
            } else if (currMenu.onEscapeHit()) {
                deactivateMenu(currMenu);
            }
        }
        if (currMenu == null) {
            if (Input::getHit() & Input::Inventory != 0) {
                activateMenu(InventoryMenu::instance);
            } else if (Input::getHit() & Input::ToggleConsole != 0) {
                activateMenu(ConsoleMenu::instance);
            } else if (Input::getHit() & Input::Crouch != 0) {
                activateMenu(DebugInvIconMenu::instance);
            }
        } else {
            if (currMenu.update()) {
                deactivateMenu(currMenu);
            } else {
                for (int i = 0; i < currMenu.components.length(); i++) {
                    if (currMenu.components[i].active) {
                        currMenu.components[i].update();
                    }
                }
            }
        }
    }

    void render() {
        if (currMenu != null) {
            currMenu.render();
        }
    }
}
