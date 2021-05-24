namespace GUIText {
    shared const float defaultScale = 100.f / UI::getScreenHeight();
}

shared class GUIText : GUIComponent {
    private bool centerX;
    private bool centerY;
    private bool localized;

    private Vector2f pos;

    private Font@ font;
    private string _text = "";

    string text { // TODO: Rename to txt.
        get {
            return _text;
        }
        set {
            if (localized) {
                _text = Local::getTxt(value);
            } else {
                _text = value;
            }
            updatePosition();
        }
    }

    Color color = Color::White;
    float rotation = 0.f;
    float scale = GUIText::defaultScale;

    void set_x(float value) property override {
        GUIComponent::set_x(value);
        updatePosition();
    }

    void set_y(float value) property override {
        GUIComponent::set_y(value);
        updatePosition();
    }

    GUIText(Menu@ menu, float x, float y, bool centerX, bool centerY, bool localized, Alignment alignment = Alignment::CenterXY, Font@ font = Font::large) {
        super(menu, x, y, 0.f, 0.f, alignment);
        this.centerX = centerX;
        this.centerY = centerY;
        this.localized = localized;

        @this.font = font;
        
        updatePosition();
    }

    float getWidth() const {
        return font.stringWidth(_text, scale);
    }

    float getWidth(const string&in text) const {
        return font.stringWidth(text, scale);
    }

    float getHeight() const {
        return font.getHeight(scale);
    }

    private void updatePosition() {
        pos = Vector2f(x, y);
        if (centerX) {
            pos.x -= font.stringWidth(_text, scale) / 2.f;
        }
        if (centerY) {
            pos.y -= font.getHeight(scale) / 2.f;
        }
    }

    const Vector2f& getTextPos() {
        return pos;
    }

    void render() override {
        UI::setTextureless();
        font.draw(_text, pos, scale, rotation, color);
    }
}