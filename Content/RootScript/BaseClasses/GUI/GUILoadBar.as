namespace GUILoadBar {
    shared Texture@ whiteBar = Texture("SCPCB/GFX/HUD/BlinkMeter");
}

const float BORDER = 1.f;
const float BORDER_LEEWAY = 0.3f;

const float BAR_WIDTH = 2.f;
const float BAR_HEIGHT = 3.5f;
const float BAR_LEEWAY = 1.f;

shared class GUILoadBar : GUIComponent {
    private BorderHelper@ bh;
    private array<Rectanglef> bars;

    private int _maxValue;
    int maxValue {
        get {
            return _maxValue;
        }
    }

    private int _value;
    int value {
        set {
            _value = value;
        }
    }

    GUILoadBar(Menu@ menu, float x, float y, int max, Alignment alignment = Alignment::CenterXY) {
        super(menu, x, y, width, height, alignment);
        _maxValue = max;
        bars = array<Rectanglef>(max);
        for (int i = 0; i < max; i++) {
            bars[i] = Rectanglef(x + BORDER + BORDER_LEEWAY + i * (BAR_WIDTH + BAR_LEEWAY),
                    y + BORDER + BORDER_LEEWAY,
                    x + BORDER + BORDER_LEEWAY + i * (BAR_WIDTH + BAR_LEEWAY) + BAR_WIDTH,
                    y + BAR_HEIGHT + BORDER + BORDER_LEEWAY);
        }
        @bh = BorderHelper(x, y, max * (BAR_WIDTH + BAR_LEEWAY) + 2 * (BORDER + BORDER_LEEWAY) - BAR_LEEWAY, BAR_HEIGHT + 2 * (BORDER + BORDER_LEEWAY), BORDER);
    }

    void render() override {
        UI::setColor(Color::White);
        UI::setTextured(GUILoadBar::whiteBar, false);
        for (int i = 0; i < _value; i++) {
            UI::addRect(bars[i]);
        }
        UI::setTextureless();
        bh.addToUI();
    }
}
