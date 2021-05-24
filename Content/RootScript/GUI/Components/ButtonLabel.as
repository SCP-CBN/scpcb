// # GUI::ButtonLabel
// A humble button with a label on it.

namespace GUI { // open GUI namespace
shared class ButtonLabel : Button { // open GUI::ButtonLabel class
	// # Constructor
	ButtonLabel(GUI@&in par, string vcls="GUI::ButtonLabel") { super(@par,vcls);
		@label=GUI::Label(@foreground);
		label.align=GUI::Align::FILL;
	}

	// # Basics
	GUI::Label@ label;
	string text { get { return label.text.text; } set { label.text.text=value; } }
	::Font@ font { get { return @label.font.font; } set { @label.font.font=@value; } }

	// # Skin
	void internalStartClick(Vector2f&in mpos) { skin(); label.textFrame.position+=Vector2f(2,2); }
	void internalStopClick() { skin(); label.textFrame.position-=Vector2f(2,2); }

} // close GUI::Button class
} // close GUI namespace
