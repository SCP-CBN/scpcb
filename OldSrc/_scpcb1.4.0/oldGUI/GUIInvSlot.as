namespace GUIInvSlot {
    const float screenSize = 7.5;
}

shared class GUIInvSlot : GUIComponent {
    private Rectanglef background;
    private Rectanglef top;
    private Rectanglef bottom;
    private Rectanglef left;
    private Rectanglef right;

    private GUIText@ text;

    private Item@ _item = null;

    Item@ item {
        get {
            return _item;
        }
        set {
            @_item = value;
            text.text = value.name;
        }
    }

    private bool hovered = false;
    private bool equipped = false;

    GUIInvSlot(Menu@ menu, float x, float y) {
        super(menu, x, y, GUIInvSlot::screenSize, GUIInvSlot::screenSize);
        @text = GUIText(menu, x + GUIInvSlot::screenSize / 2, y2 + GUIInvSlot::screenSize / 4, true, true, false);
        background = Rectanglef(x + GUIComponent::borderThickness, y + GUIComponent::borderThickness, x2 - GUIComponent::borderThickness, y2 - GUIComponent::borderThickness);
        updateRectangles(false);
    }

    private void updateRectangles(bool doubled) {
        float thickness = GUIComponent::borderThickness * (doubled ? 2 : 1);
        top = Rectanglef(x, y, x2, y + thickness);
        bottom = Rectanglef(x, y2, x2, y2 - thickness);
        right = Rectanglef(x, y + thickness, x + thickness, y2 - thickness);
        left = Rectanglef(x2 - thickness, y, x2, y2);
    }

    void onClose() override {
        text.active = false;
        hovered = false;
    }

    void update() override {
        Vector2f mousePos = Input::getMousePosition();

        if (mousePos.x >= x && mousePos.y >= y && mousePos.x <= x2 && mousePos.y <= y2) {
            hovered = true;
            
            if (item != null && Input::Mouse1::getClickCount() == 2) {
                if (item.onUse() != equipped) {
                    equipped = !equipped;
                    updateRectangles(equipped);
                }
            }
        } else {
            hovered = false;
        }
    }

    void render() override {
        text.active = false;
        if (item != null) {
            UI::setTextured(item.icon, false);
            UI::addRect(background);
        } else {
            UI::setTextured(GUIFrame::menublack, true);
            UI::addRect(background);
        }
        if (hovered) {
            UI::setTextureless();
            UI::setColor(Color(0.5f, 0.5f, 0.5f, 0.5f));
            UI::addRect(background);
            UI::setColor(Color::White);
            if (item != null) {
                text.active = true;
            }
        }
        UI::setTextured(GUIFrame::menuwhite, true);
        UI::addRect(top);
        UI::addRect(bottom);
        UI::addRect(right);
        UI::addRect(left);
    }
}
