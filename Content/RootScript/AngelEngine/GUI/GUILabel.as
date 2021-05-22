// # GUILabel --------
// Draws some text

shared class GUILabel : GUI {

	// # Constructor
	GUILabel(GUI@&in parent, string vcls="GUILabel") { super(@parent,vcls); }

	// # Skin
	Font@ font=GUI::Skin::Label::font;
	Color fontColor=GUI::Skin::Label::fontColor;
	float fontScale=GUI::Skin::Label::fontScale;
	Texture@ fontTexture;
	bool fontTiledTexture;

	// # Text GUI::Align
	GUI::Align alignHorizontal=GUI::Align::Center;
	GUI::Align alignVertical=GUI::Align::Center;

	// # Phrase manager
	// Localization should happen in the local-script, not in the label element. Call: Local::getTxt(value)
	string text;
	String::Glitch@ glitch=String::Glitch();

	Vector2f textPos;
	Vector2f textSize;
	float textRotation=0.f; // # Rotation will not be done unless there's a reason it is needed.

	// # Layout
	void internalDoLayout() {
		textPos=paintPos;
		textSize=Vector2f(font.stringWidth(text,fontScale), font.getHeight(fontScale) );
		layoutPhrase();
		textPos-=GUI::center;
	}

	void layoutPhrase() {
		switch(alignVertical) {
			case GUI::Align::Manual:
				textPos.y += pos.y;
				break;
			case GUI::Align::Center:
				textPos.y += (paintSize.y/2)-(textSize.y/2);
				break;
			case GUI::Align::Top:
				// do nothing.
				break;
			case GUI::Align::Bottom:
				textPos.y += paintSize.y-textSize.y;
				break;
		}
		switch(alignHorizontal) {
			case GUI::Align::Manual:
				textPos.x += pos.x;
				break;
			case GUI::Align::Center:
				textPos.x += (paintSize.x/2)-(textSize.x/2);
				break;
			case GUI::Align::Left:
				// Do nothing
				break;
			case GUI::Align::Right:
				textPos.x += paintSize.x-textSize.x;
				break;
		}
	}

	// # Draw()
	void paint() {
		UI::setTextureless(); //if(@fontTexture==null) { UI::setTextureless(); } else { UI::setTextured(@fontTexture,fontTiledTexture); }
		UI::setColor(fontColor);
		font.draw(text, textPos, fontScale, textRotation, fontColor);
	}

	bool glitched;
	void update() {
		//if(text!="") { if(!glitched) { glitched=true; glitch.start(text); } }
		//if(glitched) { glitch.update(text); internalDoLayout(); }
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
	float fontScale=GUI::Skin::Label::fontScale;

	// # Text GUI::Align
	GUI::Align alignHorizontal=GUI::Align::Center; // GUI::Align of the textbox within the parent labelbox
	GUI::Align alignVertical=GUI::Align::Center; // GUI::Align of the textbox within the parent labelbox

	// # Phrase manager
	string _text;
	string text { get { return _text; } set { _text=value; } }

	// # Pre Layout
	void layoutParent(GUI@&in parent) {
		makePhrases(@parent);
	}
	void addPhrase(string phrase, float fontHeight) {
		GUILabel @child=GUILabel(@this);
		child.align=GUI::Align::Top;
		child.alignVertical=GUI::Align::Top;
		child.alignHorizontal=alignHorizontal;
		child.height=fontHeight;
		child.width=paintSize.x;
		@child.font=@font;
		child.fontScale=fontScale;
		child.fontColor=fontColor;
		child.text=phrase;
		child.margin={0,0.1,0,0.1};
	}
	void makePhrases(GUI@&in parent) {
		removeChildren();

		array<string> words=String::explode(_text," ");
		float fontSize=fontScale;
		float fontHeight=font.getHeight(fontSize);
		string phrase="";

		while(words.length()>0) {
			for(int i=0; i<words.length(); i++) {
				if(phrase!="") { phrase += " "; }
				if(words[i] != "\n") { phrase+=words[i]; }
				if((i==words.length()-1) || words[i]=="\n" || font.stringWidth((phrase+" "+words[i]),fontSize) > paintSize.x ) {
					addPhrase(phrase,fontHeight);
					for(int u=0; u<=i; u++) { words.removeAt(0); }
					phrase = "";
					break;
				}
			}
		}
		float newSize=fontHeight*_children.length();
		if(size.y!=newSize) { size.y=newSize; parent.invalidateLayout(); }
	}

	// # Mid Layout
	void internalDoLayout() {
		layoutPhrases();
	}
	void layoutPhrases() {
		float textHeight=layout[1];
		float textHeightOffset=0.f;

		switch(alignVertical) {
			case GUI::Align::Manual:
				textHeightOffset = pos.y;
				break;
			case GUI::Align::Center:
				textHeightOffset = (paintSize.y/2)-(textHeight/2);
				break;
			case GUI::Align::Top:
				// do nothing.
				break;
			case GUI::Align::Bottom:
				textHeightOffset = paintSize.y-textHeight;
				break;
		}
		for(int i=0; i<_children.length(); i++) { _children[i].paintPos.y += textHeightOffset; }
	}

}


