namespace HUDMenu {
    shared HUDMenu@ instance = HUDMenu();
}

shared class HUDMenu : Menu {
    private GUILoadBar@ _blinkMeter;
    GUILoadBar@ blinkMeter {
        get {
            return _blinkMeter;
        }
    }

    HUDMenu() {
        super("hud");

        @_blinkMeter = GUILoadBar(this, 0, 0, 10);
    }
}
