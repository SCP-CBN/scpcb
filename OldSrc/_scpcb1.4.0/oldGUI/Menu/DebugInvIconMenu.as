namespace DebugInvIconMenu {
    shared DebugInvIconMenu@ instance = DebugInvIconMenu();
}

shared class DebugInvIconMenu : Menu {
    private GUIImageView@ img;
    private GUITextInput@ name;
    private GUITextInput@ x;
    private GUITextInput@ y;
    private GUITextInput@ pitch;
    private GUITextInput@ yaw;
    private GUITextInput@ roll;
    private GUITextInput@ scale;

    private string cachedName;
    private float cachedX;
    private float cachedY;
    private float cachedPitch;
    private float cachedYaw;
    private float cachedRoll;
    private float cachedScale;

    DebugInvIconMenu() {
        super("invicons");
        @img = GUIImageView(this, -10, -20, 20, 20);

        @name = GUITextInput(this, -30, 5, 60, 5, true);
        name.txt = "SCPCB/GFX/Items/Firstaid/firstaid.fbx";

        @x = GUITextInput(this, -30, 15, 25, 5, true);
        x.txt = "0.0";
        @y = GUITextInput(this, 5, 15, 25, 5, true);
        y.txt = "0.0";

        @pitch = GUITextInput(this, -30, 25, 13.333, 5, true);
        pitch.txt = "0.0";
        @yaw = GUITextInput(this, -6.666, 25, 13.333, 5, true);
        yaw.txt = "0.0";
        @roll = GUITextInput(this, 16.666, 25, 13.333, 5, true);
        roll.txt = "0.0";

        @scale = GUITextInput(this, -30, 35, 60, 5, true);
        scale.txt = "0.1";
    }

    private bool updateText(GUITextInput@ input, float&inout cached) {
        bool succ;
        float new;
        new = input.txt.toFloat(succ);
        if (succ && new != cached) {
            cached = new;
            return true;
        }
        return false;
    }

    bool update() override {
        bool textUpdate = false;
        if (name.txt != cachedName) {
            cachedName = name.txt;
            textUpdate = true;
        }

        if (updateText(x, cachedX) || updateText(y, cachedY) ||
        updateText(pitch, cachedPitch) || updateText(yaw, cachedYaw) || updateText(roll, cachedRoll) ||
        updateText(scale, cachedScale) || textUpdate) {
            Texture::drop(img.tex);
            ModelImageGenerator::initialize(256);
            @img.tex = ModelImageGenerator::generate(cachedName, cachedScale, Vector3f(cachedPitch, cachedYaw, cachedRoll), Vector2f(cachedX, cachedY));
            ModelImageGenerator::deinitialize();
        }

        return false;
    }
}
