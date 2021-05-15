namespace GUIComponent {
    shared const float SCALE_MAGNITUDE = 50.0;
    shared float borderThickness = 0.5;
}

shared enum Alignment {
    CenterXY = 0x0,
    Left = 0x1,
    Right = 0x2,
    Top = 0x4,
    Bottom = 0x8
}

shared abstract class GUIComponent {
    private float trueX;
    private float trueY;

    float x {
        get { return trueX; }
        set {
            trueX = value;
            if ((alignment & Alignment::Left) != Alignment::CenterXY) {
                trueX -= GUIComponent::SCALE_MAGNITUDE * UI::getAspectRatio();
            }

            if ((alignment & Alignment::Right) != Alignment::CenterXY) {
                trueX += GUIComponent::SCALE_MAGNITUDE * UI::getAspectRatio();
            }
        }
    }

    float y {
        get { return trueY; }
        set {
            trueY = value;
            if ((alignment & Alignment::Left) != Alignment::CenterXY) {
                trueY -= GUIComponent::SCALE_MAGNITUDE * UI::getAspectRatio();
            }

            if ((alignment & Alignment::Right) != Alignment::CenterXY) {
                trueY += GUIComponent::SCALE_MAGNITUDE * UI::getAspectRatio();
            }
        }
    }

    float x2 {
        get { return trueX + width; }
    }

    float y2 {
        get { return trueY + height; }
    }

    private float _width;
    protected float width {
        get { return _width; }
    }
    private float _height;
    protected float height {
        get { return _height; }
    }

    Alignment alignment;

    private bool _active = true;
    bool active {
        get { return _active; }
        set { _active = value; }
    }

    GUIComponent(Menu@ menu, float x, float y, float width, float height, Alignment alignment = Alignment::CenterXY) {
        // If menu == null we are being managed by our parent component.
        if (menu != null) {
            menu.components.insertLast(this);
        }

        _width = width;
        _height = height;

        this.alignment = alignment;

        this.x = x;
        this.y = y;
    }

    void onClose() {}
    void onOpen() {}

    void update() {}
    void render() {}
}
