// # GUI::Font ----
// A Font helper object

namespace GUI { // GUI namespace
shared class Font { // GUI::Font class
	::Font@ font;
	Color color;
	float scale;
	float rotation;
	Font(::Font@ f=Font::large, Color col=Color::White, float&in sz=0.1f) { @font=@f; color=col; scale=sz; rotation=0.f; }
	Font(::Font@ f, float&in sz, Color col=Color::White) { @font=@f; color=col; scale=sz; rotation=0.f; }

	void opAssign(::Font@&in f) { @font=@f; } // so you can do obj.font=Font::large to set the fontface.

	float width(string&in msg) { return font.stringWidth(msg,scale); }
	float height() { return font.getHeight(scale); }

	void draw(string&in msg, Vector2f&in pos, float&in opacity) {
		color.alpha=opacity;
		UI::setColor(color); // A clipping bug happens if this isn't done
		font.draw(msg, pos, scale, rotation, color);
	}
} // close GUI::Font class
} // close GUI namespace