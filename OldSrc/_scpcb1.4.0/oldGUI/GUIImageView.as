shared class GUIImageView : GUIComponent {
    Texture@ tex;
    private Rectanglef rec;

    // Doesn't support alignment atm, will we drop it?
    GUIImageView(Menu@ menu, float x, float y, float width, float height) {
        super(menu, x, y, width, height, Alignment::CenterXY);
        this.rec = Rectanglef(x, y, x + width, y + height);
    }

    void render() override {
        if (tex != null) {
            UI::setTextured(tex, false);
            UI::addRect(rec);
        }
    }
}
