namespace GUIFrame {
    shared Texture@ menuwhite = Texture("SCPCB/GFX/Menu/menuwhite");
    shared Texture@ menublack = Texture("SCPCB/GFX/Menu/menublack");
    shared const Color hoverColor = Color(70, 70, 150, 200);
}

shared class GUIFrame : GUIComponent {
    private Rectanglef foreground;
    private Rectanglef background;

    Color color = GUIFrame::hoverColor;

    bool hovered = false;

    void set_x(float value) property override {
        GUIComponent::set_x(value);
        updateRectangles();
    }

    void set_y(float value) property override {
        GUIComponent::set_y(value);
        updateRectangles();
    }

    GUIFrame(Menu@ menu, float x, float y, float width, float height, Alignment alignment = Alignment::CenterXY) {
        super(menu, x, y, width, height, alignment);
        updateRectangles();
    }

    private void updateRectangles() {
        foreground = Rectanglef(x + GUIComponent::borderThickness, y + GUIComponent::borderThickness, x2 - GUIComponent::borderThickness, y2 - GUIComponent::borderThickness);
        background = Rectanglef(x, y, x2, y2);
    }

    void onClose() override {
        hovered = false;
    }

    void render() override {
        UI::setTextured(GUIFrame::menuwhite, true);
        UI::addRect(background);
        UI::setTextured(GUIFrame::menublack, true);
        UI::addRect(foreground);

        if (hovered) {
            UI::setTextureless();
            UI::setColor(color);
            UI::addRect(foreground);
            UI::setColor(Color::White);
        }
    }
}
