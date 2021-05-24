// # GUI::Button
// A simple Button that draws a colored or white box with or without a texture.

namespace GUI { // open GUI namespace
shared class Button : Clickable { // open GUI::Button class
	// # Constructor
	Button(GUI@&in par, string&in vcls="GUI::Button") { super(@par,vcls);
		@background=@GUI::Panel(@this);
		background.align=GUI::Align::FILL;
		@background.texture=@GUI::Skin::Button::bgTexture;

		@foreground=@GUI::Panel(@background);
		foreground.align=GUI::Align::FILL;
		foreground.margin=GUI::Skin::Button::fgMargin;
		@foreground.texture=@GUI::Skin::Button::fgTexture;

		skin();
	}

	// # Basics
	GUI::Panel@ background;
	GUI::Panel@ foreground;

	// #.locked
	// makes the button greyed out and unclickable.
	protected bool _locked;
	bool locked { get { return _locked; } set { if(value!=_locked) { updateLocked(value); } _locked=value; skin(); } }

	void updateLocked(bool&in state) {} // override

	void skin() {
		if(locked) {
			background.color=GUI::Skin::Button::lockedColor;
			foreground.color=GUI::Skin::Button::lockedColor;
		} else if(pressed) {
			background.color=GUI::Skin::Button::hoverColor;
			foreground.color=GUI::Skin::Button::downColor;
		} else if(hovered) {
			background.color=GUI::Skin::Button::hoverColor;
			foreground.color=GUI::Skin::Button::whiteColor;
		} else {
			background.color=GUI::Skin::Button::whiteColor;
			foreground.color=GUI::Skin::Button::whiteColor;
		}
	}
	void internalStartHovering() { skin(); Clickable::internalStartHovering(); }
	void internalStopHovering() { skin(); Clickable::internalStopHovering(); }
	void internalStartClick(Vector2f&in mpos) { Clickable::internalStartClick(mpos); skin(); }
	void internalStopClick() { Clickable::internalStopClick(); skin(); }
	void internalPostLayout() { skin(); }

	void tickInternal(int&in tick) { testHovered(); Clickable::tickInternal(tick); }

} // close GUI::Button class
} // close GUI namespace
