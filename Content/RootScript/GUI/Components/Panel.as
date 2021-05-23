// # GUI::Panel
// A simple panel that draws a colored or white box with or without a texture.

namespace GUI { // open GUI namespace

shared class Panel : GUI { // open GUI::Panel class
	// # Constructor
	Panel(string vcls="GUI::Panel") { super(vcls); @coltex=GUI::ColTex(); }
	Panel(GUI@&in par, string vcls="GUI::Panel") { super(@par,vcls); @coltex=@GUI::ColTex(); }

	// # Basic background/draw panel.
	GUI::ColTex@ coltex;
	Color color { get const { return coltex.color; } set { coltex.color=value; } }
	Texture@ texture { get const { return @coltex.texture; } set { @coltex.texture=@value; } }
	bool tiledTexture { get const { return coltex.tiled; } set { coltex.tiled=value; } }

	// # render function
	void doRender(float&in interp) {
		coltex.paint(opacity);
		UI::addRect(frame());
	}
} // close GUI::Panel class
} // close GUI namespace
