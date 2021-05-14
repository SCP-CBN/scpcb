// # GUIClickable --------
// Generic clickable gui element.

shared class GUIClickable : GUI {

	// # Constructor
	GUIClickable(GUI@&in parent,string vcls="GUI::Clickable") { super(@parent,vcls); }

	// # Click manager
	// .pressed=true for as long as the mouse button is held down.
	bool pressed;

	void internalClick(Vector2f mpos) { if(!pressed) { internalStartClick(mpos); pressed=true; } }
	void internalUpdate() {
		if(pressed && !Input::Mouse1::isDown() ) { pressed=false; internalStopClick(); }
		internalUpdateClickable();
		updateClickable();
	}
	void internalUpdateClickable() {}
	void updateClickable() {} // Override

	void internalStopClick() { stopClick(); }
	void stopClick() {} // Override

	void internalStartClick(Vector2f mpos) { startClick(mpos); }
	void startClick(Vector2f mpos) { startClick(); } // Override (with args)
	void startClick() {} // Override (no args)

}


// # GUIButton --------
// A clickable button with a foreground/background texture with a .locked feature.

shared class GUIButton : GUIClickable {

	// # Constructor
	GUIButton(GUI@&in parent,string vcls="GUI::Button") { super(@parent,vcls);
		@background=GUIPanel(@this);
		background.align=Alignment::Fill;
		@background.texture=@GUI::Skin::Button::bgtexture;

		@foreground=GUIPanel(@this);
		foreground.align=Alignment::Fill;
		foreground.margin=GUI::Skin::Button::fgMargin;
		@foreground.texture=@GUI::Skin::Button::fgtexture;
	}

	// # Skin
	GUIPanel@ background;
	GUIPanel@ foreground;
	bool locked;

	void updateClickable() {
		if(locked) {
			background.color=GUI::Skin::Button::lockedColor;
			foreground.color=GUI::Skin::Button::lockedColor;
		} else if(pressed) {
			background.color=GUI::Skin::Button::hoverColor;
			foreground.color=GUI::Skin::Button::downColor;
		} else if(isHovered()) {
			background.color=GUI::Skin::Button::hoverColor;
			foreground.color=GUI::Skin::Button::whiteColor;
		} else {
			background.color=GUI::Skin::Button::whiteColor;
			foreground.color=GUI::Skin::Button::whiteColor;
		}
	}
}


// # GUIButtonLabel --------
// A standard button but it has a label built into it.

shared class GUIButtonLabel : GUIButton {

	// # Constructor
	GUIButtonLabel(GUI@&in parent,string vcls="GUI::ButtonLabel") { super(@parent,vcls);
		@label=GUILabel(@this);
		label.align=Alignment::Fill;
		label.margin=GUI::Skin::Button::labelMargin;
		@label.font=@GUI::Skin::Button::font;
		label.fontScale=GUI::Skin::Button::fontScale;
		label.fontColor=GUI::Skin::Button::fontColor;
		label.text="Button";
	}

	// # Button Text
	GUILabel@ label;
	string text { get { return label.text; } set { label.text=value; label.invalidateLayout(); } }
}