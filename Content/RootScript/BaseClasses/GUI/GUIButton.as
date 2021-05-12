
// GUIButton --------
// A stylish clickable label with a background/foreground.

shared class GUIClickable : GUI {
	bool pressed;

	GUIClickable(GUI@&in parent,string vcls="button") { super(@parent,vcls); }

	void skinColors() {};

	void internalUpdate() {
		if(pressed && !Input::Mouse1::isDown() ) { pressed=false; stopClick(); }
		skinColors();
	}

	void stopClick() {}
	void startClick(Vector2f mpos) {startClick();}
	void startClick() {}

	void internalClick(Vector2f mpos) {
		if(!pressed) { startClick(mpos); pressed=true; }
	}
}
shared class GUIButton : GUIClickable {
	GUIPanel@ background;
	GUIPanel@ foreground;
	bool locked;

	GUIButton(GUI@&in parent,string vcls="button") { super(@parent,vcls);
		@background=GUIPanel(@this);
		background.align=Alignment::Fill;
		background.visible=true;
		@background.texture=@GUI::Skin::Button::bgtexture;

		@foreground=GUIPanel(@this);
		foreground.align=Alignment::Fill;
		foreground.visible=true;
		foreground._margin=GUI::Skin::Button::fgMargin;
		@foreground.texture=@GUI::Skin::Button::fgtexture;

	}

	void skinColors() {
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

shared class GUIButtonLabel : GUIButton {
	GUILabel@ label;

	GUIButtonLabel(GUI@&in parent,string vcls="button_label") { super(@parent,vcls);
		@label=GUILabel(@this);
		label.align=Alignment::Fill;
		label._margin=GUI::Skin::Button::labelMargin;
		label.text="Button";
	}
	string text { get { return label.text; } set { label.text=value; } }

}