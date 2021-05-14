namespace InventoryMenu {
    shared InventoryMenu@ instance = InventoryMenu(10);
}

shared class InventoryMenu : Menu {
    private array<GUIInvSlot@> slots;

    InventoryMenu(int size) {
        super("inventory");

        const int rows = Math::ceil(size / 6.0);
        if (size % rows != 0) {
            Debug::error("Invalid inventory size");
        }
        const int itemsPerRow = size / rows;

        slots = array<GUIInvSlot@>(size);

        float screenX; float screenY = -(rows * 2 - 1) * GUIInvSlot::screenSize / 2;
        for (int y = 0; y < rows; y++) {
            screenX = -(itemsPerRow * 2 - 1) * GUIInvSlot::screenSize / 2;
            for (int x = 0; x < itemsPerRow; x++) {
                @slots[x + y * itemsPerRow] = GUIInvSlot(this, screenX, screenY);
                screenX += GUIInvSlot::screenSize * 2;
            }
            screenY += GUIInvSlot::screenSize * 2;
        }
    }

    bool addItem(Item@ it) {
        for (int i = 0; i < slots.length(); i++) {
            if (slots[i].item == null) {
                @slots[i].item = it;
                return true;
            }
        }
        return false;
    }

    bool onEscapeHit() override {
        return true;
    }

    bool update() override {
        return Input::getHit() & Input::Inventory != 0;
    }
}
