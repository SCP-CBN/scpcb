
// # GUITextEntry --------
// Text Input beast.
// One line only.
// Text boxes maybe another day, game doesn't need it.

shared Font@ tempFont=Font::large;

shared class GUICharacter : GUIClickable {
	// A single character.
	// Yes, I know.
	// But it works with little to no effort.
	// Hard to argue with results.

	Color fontColor=Color::White;
	Color fontColorSelected=Color::Green;

	bool textSelected;
	string text { get { return label.text; } set { label.text=value; } }
	GUILabel@ label;
	GUICharacter(GUI@&in parent, string vcls="GUICharacter") { super(@parent,vcls);
		align=Alignment::Left;
		width=4;

		@label=GUILabel(@this);
		label.align=Alignment::Fill;
		label.alignVertical = Alignment::Center;
		label.margin={0.1,0.1,0.1,0.1};
		label.text="B";
		label.fontScale=2;
		@label.font=@tempFont;
	}

	void stopClick() {
		GUITextEntry@ par=parentTextEntry();
		par.stopCharClick(@this);
	}
	void startClick(Vector2f mpos) {
		GUITextEntry@ par=parentTextEntry();
		par.startCharClick(@this);
	}

	void updateClickable() {

	}

	void paint() {
		if(textSelected) {
			label.fontColor=fontColorSelected;
		} else {
			label.fontColor=fontColor;
		}
	}

	GUITextEntry@ parentTextEntry() { return cast<GUITextEntry@>(_parent); }
}

shared class GUITextEntry : GUIClickable {

	// Apple only
	// Basically shift+arrow key after a drag or multi-click on macOS has different behavior than on Windows.
	// On macOS after a select drag or multi-click select the first shift+arrow combo you hit determines which side of the selection you're manipulating.
	// So this boolean determines when exactly to trigger that behavior because other types of highlighting/text-modifying don't do that.
	bool appleSelectionInsanityMode = false;

	Vector2f mselectStart;
	int charLimit = 2147483647; // Memento thing.
	array<string> prevStrings;
	array<GUICharacter@> selected;
	int Carrot=-1;

	GUI::TextEnteredFunc@ inputFunc;

	string text { get { return getText(); } set { setText(value); } }
	void setText(string txt) { while(_children.length()>0) { _children.removeLast(); } Carrot=-1; keyboardDoTextInput(txt); }
	string getText() { return fetchText(); }

	Color _fontColor=Color::White;
	Color fontColor { get { return _fontColor; } set { setFontColor(value); } }
	void setFontColor(Color&in col) { _fontColor=col; for(int i=0; i<_children.length(); i++) { cast<GUICharacter@>(_children[i]).fontColor=col; } }


	GUITextEntry(string vcls="GUITextEntry") { super(vcls); Carrot=-1; }
	GUITextEntry(GUI@&in parent, string vcls="GUITextEntry") { super(@parent,vcls);
		appleSelectionInsanityMode = (World::Platform::active == World::Platform::Apple);
	}
	~GUITextEntry() {
	}

	string fetchSelectedText() { string chr=""; for(int i=0; i<_children.length(); i++) {
		if(cast<GUICharacter@>(_children[i]).textSelected) { chr=chr+cast<GUICharacter@>(_children[i]).text; } } return chr;
	}
	string fetchText() { string chr=""; for(int i=0; i<_children.length(); i++) { chr=chr+cast<GUICharacter@>(_children[i]).text; } return chr; }

	void paint() {
		if(@GUI::textEntryFocus==@this) {
			Vector2f carrotPos;
			if(Carrot>=0) {
				GUICharacter@ child = cast<GUICharacter@>(_children[Carrot]);
				if(@child!=null) { carrotPos=child.label.paintPos+Vector2f(child.label.textSize.x-1,0)-GUI::center; }
			} else {
				carrotPos=paintPos-GUI::center;
			}
			UI::setTextureless();
			UI::setColor(Color::White);
			tempFont.draw("|", carrotPos, 0.3f, 0.f, Color::White);
		}
	}

	void selectCharacters() {
		if(_children.length()<=0) { return; }
		Vector2f mpos=GUI::mouse();
		if(mselectStart.distance(mpos)<1) { return; }

		selected={};
		float selMin=Math::minFloat(mselectStart.x,mpos.x);
		float selMax=Math::maxFloat(mselectStart.x,mpos.x);

		for(int i=0; i<_children.length(); i++) {
			GUICharacter@ child = cast<GUICharacter@>(_children[i]);
			Vector2f cpos = child.paintPos+(child.paintSize/2);
			if(cpos.x>=selMin&&cpos.x<=selMax) {
				selected.insertLast(@child);
				child.textSelected=true;
				Carrot=i;
			} else { child.textSelected=false; }
		}
	}
	void doClick() { GUI::startTextEntering(@this); }
	void stopCharClick(GUICharacter@&in child) { selectCharacters(); }
	void startCharClick(GUICharacter@&in child) { selected={}; if(_children.length()==0) { return; } mselectStart=child.paintPos+(child.paintSize/2); Carrot=findChild(@child); }

	void addChild(GUI@&in child) { hasChild=true; Carrot++; _children.insertAt(Carrot,@child); onChildAdded(@child); invalidateLayout(); }
	void removeChild(GUI@&in x) { Debug::error("Warning: TextEntry tried to remove child with GUI element"); }
	void removeChild() {
		if(Carrot<0 || _children.length()==0) { return; }
		GUI@ child=@_children[Carrot];
		_children.removeAt(Carrot); Carrot--;
		hasChild=(_children.length()>0); invalidateLayout(); onChildRemoved(@child);
	}
	bool shiftDown() { return Input::anyShiftDown(); }
	bool shortcutDown() { return Input::anyShortcutDown(); }
	void deleteSelected() { for(int i=_children.length()-1; i>-1; i--) { if(cast<GUICharacter@>(_children[i]).textSelected) { Carrot=i; removeChild(); } } selected={}; }
	void deselectAll() { for(int i=0; i<_children.length(); i++) { cast<GUICharacter@>(_children[i]).textSelected=false; } }
	void selectRight() { for(int i=Carrot; i<_children.length(); i++) { cast<GUICharacter@>(_children[i]).textSelected=true; } }
	void selectLeft() { for(int i=Carrot; i>-1; i--) { cast<GUICharacter@>(_children[i]).textSelected=true; } }
	void keyboardDoArrow(bool right) {
		if (Input::anyShiftDown()) {
			if(right) { selectRight(); } else { selectLeft(); }
		} else if (Input::anyShortcutDown()) {
			if(right) { Carrot=_children.length()-1; } else { Carrot=-1; }
		}

	}
	void keyboardDoDelete(bool del) { if(selected.length()>0) { deleteSelected(); } else if(!del) { removeChild(); } }
	void keyboardDoSelectAll() { Carrot=_children.length()-1; for(int i=0; i<_children.length(); i++) { cast<GUICharacter@>(_children[i]).textSelected=true; } }
	void keyboardDoCopy(bool cut) { if(selected.length()>0) { Input::setClipboardText(fetchSelectedText()); } }
	void keyboardDoPaste() { string chr=Input::getClipboardText(); if(chr!="") { keyboardDoTextInput(chr); } }

	void keyboardDoUndo() {} // Maybe another time.
	void keyboardDoRedo() {} // Maybe another time.

	void keyboardEscape() {
		GUI::stopTextEntering();
	}
	void keyboardDoMouse1(int clicks) {
		Vector2f mpos=GUI::mouse();
		if(!GUI::pointInSquare(mpos,paintPos,paintSize)) { keyboardEscape(); return; }
	}
	void keyboardDoMouse2(int clicks) {
		Vector2f mpos=GUI::mouse();
		if(!GUI::pointInSquare(mpos,paintPos,paintSize)) { keyboardEscape(); return; }
	}
	void keyboardDoTextInput(string append) {
		keyboardDoDelete(true);
		for(int i=0; i<append.length(); i++) {
			GUICharacter@ char=GUICharacter(@this);
			char.align=Alignment::Left;
			char.text=append[i];
			char.fontColor=_fontColor;
		}
	}
	void keyboardDoEnter() { if(@inputFunc!=null) { inputFunc(text); } text=""; }

	void updateTextEntering() {
		if(Input::Escape::isHit()) { keyboardEscape(); return; }
		if(pressed) { selectCharacters(); return; }
		string append=Input::getTextInput();
		if(append!="") { keyboardDoTextInput(append); }

		if(Input::selectAllIsHit()) { keyboardDoSelectAll(); }
		else if(Input::LeftArrow::isHit() || Input::RightArrow::isHit()) { keyboardDoArrow(Input::RightArrow::isHit()); }
		else if(Input::Backspace::isHit() || Input::Delete::isHit()) { keyboardDoDelete(Input::Delete::isHit()); }
		else if(Input::copyIsHit() || Input::cutIsHit()) { keyboardDoCopy(Input::cutIsHit()); }
		else if(Input::pasteIsHit()) { keyboardDoPaste(); }
		else if(Input::undoIsHit()) { keyboardDoUndo(); }
		else if(Input::redoIsHit()) { keyboardDoRedo(); }
		else if(Input::Mouse1::isHit()) { keyboardDoMouse1(Input::Mouse1::getClickCount()); }
		//else if(Input::Mouse2::isHit()) { keyboardDoMouse2(); } //Input::Mouse2::getClickCount()
		else if(Input::Enter::isHit()) { keyboardDoEnter(); }
	}

}