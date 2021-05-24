// # GUI::Label
// A simple Label that draws a colored or white box with or without a texture.

namespace GUI { // open GUI namespace

shared class Label : GUI { // open GUI::Label class
	// # Constructor
	Label(GUI@&in par, string&in vcls="GUI::Label") { super(@par,vcls); @text=@GUI::String(); alignText=GUI::Align::CENTER; @textFrame=@GUI::Square(); }

	// # Basic background/draw Label.
	GUI::String@ text;
	GUI::Font@ font { get { return @text.font; } set { @text.font=@value; } }
	Color color { get const { return text.color; } set { text.color=value; } }
	float scale { get { return text.scale; } set { text.scale=value; } }
	float fontScale { get { return text.scale; } set { text.scale=value; } } // alias

	// # Layout
	GUI::Square@ textFrame;
	GUI::Align alignText;


	void postLayout() { layoutPhrase(); }
	void layoutPhrase() {
		textFrame.position=frame.position;
		textFrame.size=Vector2f(text.width, text.height);
		switch(alignText) {
			case GUI::Align::CENTER:
				textFrame.position+=frame.size/2-textFrame.size/2;
				break;
			case GUI::Align::LEFT:
				textFrame.y+=frame.size.y/2-textFrame.size.y/2;
				break;
			case GUI::Align::TOP:
				textFrame.x+=frame.size.x/2-textFrame.size.x/2;
				break;
			case GUI::Align::RIGHT:
				textFrame.position+=Vector2f(frame.size.x-textFrame.size.x,frame.size.y/2-textFrame.size.y/2);
				break;
			case GUI::Align::BOTTOM:
				textFrame.position+=Vector2f(frame.size.x/2-textFrame.size.x/2,frame.size.y-textFrame.size.y);
				break;
			case GUI::Align::TOP_LEFT:
				// do nothing
				break;
			case GUI::Align::TOP_RIGHT:
				textFrame.x+=frame.size.x-textFrame.size.x;
				break;
			case GUI::Align::BOTTOM_LEFT:
				textFrame.y+=frame.size.y-textFrame.size.y;
				break;
			case GUI::Align::BOTTOM_RIGHT:
				textFrame.position+=frame.size-textFrame.size;
				break;
			default:
				Debug::error("Invalid text alignment on a GUI Label");
				break;
		}
	}

	// # render function
	void render(float&in interp) {
		text.render(textFrame.position,opacity);
	}
} // close GUI::Label class
} // close GUI namespace
