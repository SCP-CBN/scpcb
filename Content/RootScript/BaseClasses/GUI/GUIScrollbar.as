shared class GUIScrollbar : GUIComponent {
    private float _sourceTotalSize;
    private float _sourceDisplayedSize;
    private float _position;

    float sourceTotalSize {
        set {
            if (value != _sourceTotalSize) {
                _sourceTotalSize = value;
                updateRectangles();
            }
        }
    }

    float sourceDisplayedSize {
        set {
            if (value != _sourceDisplayedSize) {
                _sourceDisplayedSize = value;
                updateRectangles();
            }
        }
    }

    float position {
        set {
            if (value != _position) {
                float percentage = _sourceDisplayedSize / Math::max(_sourceDisplayedSize, _sourceTotalSize);
                _position = Math::min(value, _sourceDisplayedSize / percentage - _sourceDisplayedSize);
                updateRectangles();
            }
        }
        get { return _position; }
    }

    private Rectanglef scrollbar;
    private Rectanglef thumb;

    GUIScrollbar(Menu@ menu, float x, float y, float width, float height, Alignment alignment = Alignment::CenterXY) {
        super(menu, x, y, width, height, alignment);
    }

    private void updateRectangles() {
        scrollbar = Rectanglef(x, y, x + width, y + height);
        float percentage = _sourceDisplayedSize / Math::max(_sourceDisplayedSize, _sourceTotalSize);
        float screenY = y + height - _position * percentage;
        thumb = Rectanglef(x + 1.f, screenY - height * percentage, x + width - 1.f, screenY);
    }

    void render() override {
        UI::setTextureless();
        UI::setColor(Color::Blue);
        UI::addRect(scrollbar);
        UI::setColor(Color::Green);
        UI::addRect(thumb);
        UI::setColor(Color::White);
    }
}
