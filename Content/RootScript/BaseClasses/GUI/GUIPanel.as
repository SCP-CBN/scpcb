// # GUIPanel --------
// A simple blank panel that draws a box with or without a texture.

shared class GUIPanel : GUI {

	// # Constructor
	GUIPanel(string vcls="GUIPanel") { super(vcls); }
	GUIPanel(GUI@&in parent, string vcls="GUIPanel") { super(@parent,vcls); }

	// # Basic background/draw panel.
	Color color=Color::White;
	Texture@ texture;
	bool tiledTexture;

	// # Layout
	Rectanglef paintSquare;
	void doLayout() {
		paintSquare=Rectanglef((paintPos)-GUI::center,(paintPos+paintSize)-GUI::center);
	}

	// # Draw()
	void paint() {
		if(@texture==null) { UI::setTextureless(); } else { UI::setTextured(texture, tiledTexture); }
		color.alpha=opacity;
		UI::setColor(color);
		UI::addRect(paintSquare);
	}
}
