

// GUIPanel --------
// A simple panel that draws a box.
//
// Use "GUI(@parent)" for a panel that doesn't draw anything.

shared class GUIPanel : GUI {
	GUIPanel() { super("panel"); }
	GUIPanel(GUI@&in parent) { super(@parent,"panel"); }

	Texture@ texture;
	bool tile;
	Color color=Color::White;

	Rectanglef square;
	void doneLayout() {
		square=Rectanglef((paintPos)-GUI::Center,(paintPos+paintSize)-GUI::Center);
	}

	void Paint() {
		if(@texture==null) { UI::setTextureless(); } else { UI::setTextured(texture, tile); }
		color.alpha=opacity;
		UI::setColor(color);
		UI::addRect(square);
	}
}
