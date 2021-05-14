// # GUILabel --------
// Draws some text

shared class GUILabel : GUI {

	// # Constructor
	GUILabel(GUI@&in parent, string vcls="GUILabel") { super(@parent,vcls); }

	// # Skin
	Font@ font=GUI::Skin::Label::font;
	Color fontColor=GUI::Skin::Label::fontColor;
	float fontScale=GUI::Skin::Label::fontScale*GUI::aspectScale;
	Texture@ fontTexture;
	bool fontTiledTexture;

	// # Text Alignment
	Alignment alignHorizontal=Alignment::Center;
	Alignment alignVertical=Alignment::Center;

	// # Phrase manager
	// Localization should happen in the local-script, not in the label element. Call: Local::getTxt(value)
	string text;

	Vector2f textPos;
	Vector2f textSize;
	float textRotation=0.f; // # Rotation will not be done unless there's a reason it is needed.

	// # Layout
	void internalPreLayout() {
		textPos=paintPos;
		textSize=Vector2f(font.stringWidth(text,fontScale*GUI::aspectScale), font.getHeight(fontScale*GUI::aspectScale) );
		layoutPhrase();
		textPos-=GUI::center;
	}

	void layoutPhrase() {
		switch(alignVertical) {
			case Alignment::Manual:
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
			case Alignment::Manual:
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

	// # Draw()
	void paint() {
		if(@fontTexture==null) { UI::setTextureless(); } else { UI::setTextured(@fontTexture,fontTiledTexture); }
		UI::setColor(fontColor);
		font.draw(text, textPos, fontScale*GUI::aspectScale, textRotation, fontColor);
	}
}


// # GUILabelBox --------
// Draws some text with word wrapping. Must be calculated on layout, so cheaper to use it only when its needed.

shared class GUILabelBox : GUI {

	// # Constructor
	GUILabelBox(GUI@&in parent, string vcls="GUILabelBox") { super(@parent,vcls); }

	// # Skin
	Font@ font=GUI::Skin::Label::font;
	Color fontColor=GUI::Skin::Label::fontColor;
	float fontScale=GUI::Skin::Label::fontScale*GUI::aspectScale;

	// # Text Alignment
	Alignment alignHorizontal=Alignment::Center; // Alignment of the textbox within the parent labelbox
	Alignment alignVertical=Alignment::Center; // Alignment of the textbox within the parent labelbox

	// # Phrase manager
	string _text;
	string text { get { return _text; } set { _text=value; } }

	// # Pre Layout
	void internalPreLayout() {
		makePhrases();
	}
	void addPhrase(string phrase, float fontHeight) {
		GUILabel @child=GUILabel(@this);
		child.align=Alignment::Top;
		child.alignVertical=Alignment::Top;
		child.alignHorizontal=alignHorizontal;
		child.height=fontHeight;
		child.width=paintSize.x;
		@child.font=@font;
		child.fontScale=fontScale;
		child.fontColor=fontColor;
		child.text=phrase;
		child.margin={0,0.1,0,0.1};
	}
	void makePhrases() {
		removeChildren();

		array<string> words=String::explode(_text," ");
		float fontSize=fontScale*GUI::aspectScale;
		float fontHeight=font.getHeight(fontSize);
		string phrase="";

		while(words.length()>0) {
			for(int i=0; i<words.length(); i++) {
				if(i>0) { phrase += " "; }
				phrase+=words[i];
				if((i==words.length()-1) || font.stringWidth((phrase+" "+words[i]),fontSize) > paintSize.x ) {
					addPhrase(phrase,fontHeight);
					Debug::log("Added Phrase: " + phrase);
					for(int u=0; u<=i; u++) { words.removeAt(0); }
					phrase = "";
					break;
				}
			}
		}
	}

	// # Mid Layout
	void internalDoLayout() {
		layoutPhrases();
	}
	void layoutPhrases() {
		float textHeight=layout[1];
		float textHeightOffset=0.f;

		switch(alignVertical) {
			case Alignment::Manual:
				textHeightOffset = pos.y;
				break;
			case Alignment::Center:
				textHeightOffset = (paintSize.y/2)-(textHeight/2);
				break;
			case Alignment::Top:
				// do nothing.
				break;
			case Alignment::Bottom:
				textHeightOffset = paintSize.y-textHeight;
				break;
		}
		for(int i=0; i<_children.length(); i++) { _children[i].paintPos.y += textHeightOffset; }
	}

}


