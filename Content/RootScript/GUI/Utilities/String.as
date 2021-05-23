// # GUI::String ----
// A string, but with GUI functions

namespace GUI { // GUI namespace
shared class String { // GUI::String class
	String(string&in msg="") { text=msg; @font=@GUI::Font(@GUI::Skin::Label::font,GUI::Skin::Label::fontColor,GUI::Skin::Label::fontScale); }
	string text;

	GUI::Font@ font;
	Color color { get const { return font.color; } set { font.color=value; } }
	float scale { get const { return font.scale; } set { font.scale=value; } }

	const float width { get const { return font.width(text); } }
	const float height { get const { return font.height(); } }

	void opAssign(string&in msg) { text=msg; } // so you can do obj.text="".
	void opAddAssign(string&in msg) { text+=msg; } // so you can do obj.text+="".
	string opAdd(string&in msg) { return text+msg; } // so you can do ""+obj.text+"".
	string opAdd_r(string&in msg) { return msg+text; } // so you can do ""+obj.text+"".

	void render(Vector2f&in pos, float&in opacity=1.f) { font.draw(text, pos-GUI::center, opacity); }
} // close GUI::String class
} // close GUI namespace