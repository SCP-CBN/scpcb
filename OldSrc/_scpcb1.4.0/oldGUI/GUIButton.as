namespace GUIButton {
    shared const Color downColor = Color(100, 100, 175, 225);
}

shared class GUIButton : GUIComponent {
    private GUIFrame@ frame;
    private GUIText@ text;

    private bool hit = false;
    private bool down = false;
    private bool hasBeenDown = false;

    private bool _locked = false;
    bool locked {
        set {
            _locked = value;
            if (value) {
                hit = false;
                down = false;
                frame.hovered = false;
            }
        }
    }

    void set_active(bool value) property override {
        GUIComponent::set_active(value);
        frame.active = value;
        text.active = value;
    }

    GUIButton(Menu@ menu, float x, float y, float width, float height, const string&in txt, Alignment alignment = Alignment::CenterXY, Font@ font = Font::large) {
        super(menu, x, y, width, height, alignment);
        @frame = GUIFrame(menu, x, y, width, height, alignment);
        @text = GUIText(menu, x + width / 2, y + height / 2, true, true, true, alignment, font);
        text.text = txt;
    }

    bool getHit() {
        return hit;
    }

    bool getDown() {
        return down;
    }

    void update() override {
        hit = false;

        if (_locked) { return; }

        Vector2f mousePos = Input::getMousePosition();

        if (mousePos.x >= x && mousePos.y >= y && mousePos.x <= x2 && mousePos.y <= y2) {
            frame.hovered = true;

            if (Input::Mouse1::isHit() || hasBeenDown) {
                down = true;
                hasBeenDown = true;
            } else if (!Input::Mouse1::isDown() && down) {
                hit = true;
                down = false;
            }
        } else {
            frame.hovered = false;
            down = false;
        }

        if (hasBeenDown && !Input::Mouse1::isDown()) {
            hasBeenDown = false; // TODO: Move?
        }
    }

    void render() override {
        if (down) {
            frame.color = GUIButton::downColor;
            text.x = x + width / 2 + 0.2f * UI::getAspectRatio();
            text.y = y + height / 2 + 0.2f;
        } else {
            frame.color = GUIFrame::hoverColor;
            text.x = x + width / 2;
            text.y = y + height / 2;
        }
    }
}
