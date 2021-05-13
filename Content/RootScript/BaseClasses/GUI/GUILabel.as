
// GUILabel --------
// Draws some text

shared class GUILabel : GUI {
	GUILabel() { super("label"); }
	GUILabel(GUI@&in parent, string vclass="label") { super(@parent,vclass); }
	bool localized;
	Vector2f textPos;
	Vector2f textSize;
	float textRotation=0.f;
	Alignment alignHorizontal=Alignment::Center;
	Alignment alignVertical=Alignment::Center;
	void setTextAlignment(Alignment horizontal, Alignment vertical) { alignHorizontal=horizontal; alignVertical=vertical; }

	Font@ font=GUI::Skin::Label::font;
	Color fontColor=GUI::Skin::Label::fontColor;
	float fontScale=GUI::Skin::Label::fontScale;

	string _text="Label";
	string text { get { return _text; }
		set { value=(localized ? Local::getTxt(value) : value); if(_text!=value) { invalidateLayout(); } _text=value; wrapStrings(); }
	}
	array<string> strings;
	void wrapStrings() {}

	void internalDoneLayout() {
		Vector2f textSize=Vector2f(font.stringWidth(_text,fontScale*GUI::aspectScale),font.getHeight(fontScale*GUI::aspectScale));
		textPos=paintPos;

		switch(alignVertical) {
			case Alignment::None:
				textPos.y += pos.y;
				break;
			case Alignment::Center:
				textPos.y += (paintSize.y/2)-(textSize.y/2);
				break;
			case Alignment::Top:
				// do nothing.
				break;
			case Alignment::Bottom:
				textPos.y += paintSize.y-textSize.y;
				break;
		}
		switch(alignHorizontal) {
			case Alignment::None:
				textPos.x += pos.x;
				break;
			case Alignment::Center:
				textPos.x += (paintSize.x/2)-(textSize.x/2);
				break;
			case Alignment::Left:
				// Do nothing
				break;
			case Alignment::Right:
				textPos.x += paintSize.x-textSize.x;
				break;
		}
	}

	void Paint() {
		UI::setTextureless();
		UI::setColor(fontColor);
		font.draw(_text, textPos-GUI::Center, fontScale*GUI::aspectScale, textRotation, fontColor);
	}
}

