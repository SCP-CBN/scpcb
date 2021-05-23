// # GUI::ColTex ----
// A Color/Texture helper object

namespace GUI { // open GUI namespace
shared class ColTex { // open GUI::ColTex class
	Color color;
	Texture@ texture;
	bool tiled;

	ColTex(Color col=Color::White) { color=col; }
	ColTex(Color col, Texture@ tex, bool tile=false) { color=col; @texture=@tex; tiled=tile; }
	ColTex(Texture@ tex, bool tile=false) { color=Color::White; @texture=@tex; tiled=tile; }

	void paintTexture() { if(@texture==null) { UI::setTextureless(); } else { UI::setTextured(texture, tiled); } }
	void paint() { paintTexture(); UI::setColor(color); }
	void paint(const float&in opacity) { paintTexture(); color.alpha=opacity; UI::setColor(color); }

} // close GUI::ColTex class
} // close GUI namespace