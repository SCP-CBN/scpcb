
// # GUITextEntry --------
// Text Input beast.
// One line only.
// Text boxes maybe another day, game doesn't need it.

shared Font@ tempFont=Font::large;


shared class GUITextEntry : GUIClickable {

	GUILabel@ label;

	// Apple only
	// Basically shift+arrow key after a drag or multi-click on macOS has different behavior than on Windows.
	// On macOS after a select drag or multi-click select the first shift+arrow combo you hit determines which side of the selection you're manipulating.
	// So this boolean determines when exactly to trigger that behavior because other types of highlighting/text-modifying don't do that.
	private bool appleSelectionInsanityMode = false;

	// Memento manager
	// onSet() 
	// .push(0, text, false, true);
	// .push(0, newvalue, true, true);
	// 
	//
	private MementoManager@ mementoMgr;
	private int charLimit = 2147483647;
	private int mementoMaxSize = 1048576;

	// # Font
	Font@ font { get { return @label.font; } set { @label.font=@value; } }
	Color fontColor { get { return label.fontColor; } set { label.fontColor=value; } }
	float fontScale { get { return label.fontScale; } set { label.fontScale=value; } }

	// Default text
	bool clearOnClick;
	string _defaultText="Enter text...";
	string defaultText { get { return _defaultText; } set { _defaultText=value; clearOnClick=true; text=value; } }

	GUI::Align alignVertical { get { return label.alignVertical; } set { label.alignVertical=value; } }
	GUI::Align alignHorizontal { get { return label.alignHorizontal; } set { label.alignHorizontal=value; } }

	// # Constructor
	GUITextEntry(GUI@&in parent, string vcls="GUITextEntry") { super(@parent,vcls);
        	@mementoMgr = MementoManager::create(mementoMaxSize);
		clearOnClick=true;
		@label=GUILabel(@this);
		label.align=GUI::Align::Fill;
		alignVertical=GUI::Align::Center;
		alignHorizontal=GUI::Align::Left;
		@font=@GUI::Skin::TextEntry::font;
		fontScale=GUI::Skin::TextEntry::fontScale;
		text=defaultText;
		appleSelectionInsanityMode = (Environment::Platform::active == Environment::Platform::Apple);
	}
	~GUITextEntry() {
        	MementoManager::destroy(mementoMgr);
	}


	// # Text handling and selection
	GUI::TextEnteredFunc@ inputFunc;
	string text { get { return (clearOnClick ? ("") : label.text); } set {
		string newval=value;
		if(value.length()>=charLimit) { newval=String::substr(value,0,charLimit); }
		mementoMgr.push(0,(clearOnClick ? ("") : label.text),false,true);
		mementoMgr.push(0,(clearOnClick ? ("") : newval), true, true);
		label.text=newval;
	} }

	array<int> selected = array<int>(2);
	int iselectStart;
	float mselectStart;
	float carrotPos;
	int carrot=-1;

	string fetchSelectedText() {
		if(text=="" || clearOnClick || text.length()==0 || selected[0]==selected[1]) { return ""; }
		return String::substr(text,selected[0]+1,selected[1]);
	}
	void updateCarrot() { if(carrot==-1) { carrotPos=0; } else { carrotPos=String::substrWidth(font,fontScale,text,-1,carrot); } }


	// # Clicking and character selection
	void selectCharacters() {
		float relMouse = (GUI::mouse().x-label.paintPos.x);
		selected = String::findCharsBetweenPoints(font,fontScale,text,mselectStart,relMouse);
		carrot = (mselectStart < relMouse ? selected[1] : selected[0]);
		iselectStart=carrot;
		updateCarrot();
	}


	void doClick() { GUI::startTextEntering(@this); onStartTextEntering(); }
	void onStartTextEntering() {}
	void onStopTextEntering() { if(text=="") { clearOnClick=true; text=defaultText; } }
	void stopClick() { selectCharacters(); }
	void startClick(Vector2f mpos) {
		if(clearOnClick) { text=""; carrot=-1; clearOnClick=false; }
		mselectStart=(mpos.x-label.paintPos.x);
		iselectStart=String::findCharFromPoint(font,fontScale,text,mselectStart);
		selectCharacters();
	}

	// # Keyboard functions
	bool shiftDown() { return Input::anyShiftDown(); }
	bool shortcutDown() { return Input::anyShortcutDown(); }
	void deleteSelected() {
		int sublen=(selected[1]-selected[0]);
		text=String::subtractAt(text,selected[0],sublen);
		mementoMgr.push(carrot,String::substr(text,carrot-sublen,sublen), false, true);
		carrot=Math::maxInt(carrot-sublen,-1);
		selected={carrot,carrot};
		updateCarrot();
	}
	void deselectAll() { selected={carrot,carrot}; }
	void selectRight() { selected={carrot,text.length()-1}; carrot=selected[1]; }
	void selectLeft() { selected={-1,carrot}; carrot=selected[0]; }
	void keyboardDoArrow(bool right) {
		if (Input::anyShortcutDown() && Input::anyShiftDown()) {
			if(right) { selectRight(); } else { selectLeft(); }
		} else if (Input::anyShortcutDown()) {
			if(right) { carrot=text.length()-1; } else { carrot=-1; }
			selected={carrot,carrot};
		} else {
			if(right) { carrot=Math::minInt(carrot+1,text.length()-1); }
			else { carrot=Math::maxInt(carrot-1,-1); }
			if(!Input::anyShiftDown()) { selected={carrot,carrot}; } else {
				if(right) { if(carrot>selected[1]) { selected[1]=carrot; } else { selected[0]=carrot; } }
				else { if(carrot<selected[0]) { selected[0]=carrot; } else { selected[1]=carrot; } }
			}
		}
		updateCarrot();
	}
	void keyboardDoDelete(bool del) { if(!del && selected[1]==selected[0]) { selected={Math::maxInt(carrot-1,-1),carrot}; } deleteSelected(); }
	void keyboardDoSelectAll() { float mlen=text.length(); selected={-1,mlen-1}; carrot=selected[1]; updateCarrot(); }
	void keyboardDoCopy(bool cut) { Input::setClipboardText(fetchSelectedText()); }
	void keyboardDoPaste() { string chr=Input::getClipboardText(); if(chr!="") { keyboardDoTextInput(chr); } }

	void keyboardDoUndo() { mementoMgr.execute(text,carrot,true); }
	void keyboardDoRedo() { mementoMgr.execute(text,carrot,false); }

	void keyboardEscape() {
		GUI::stopTextEntering();
		onStopTextEntering();
	}
	void keyboardDoMouse1(int clicks) {
		Vector2f mpos=GUI::mouse();
		if(!GUI::pointInSquare(mpos,paintPos,paintSize)) { keyboardEscape(); return; }
	}
	void keyboardDoMouse2(int clicks) {
		Vector2f mpos=GUI::mouse();
		if(!GUI::pointInSquare(mpos,paintPos,paintSize)) { keyboardEscape(); return; }
	}
	void keyboardDoTextInput(string&in append) {
		if(selected[0]!=selected[1]) { keyboardDoDelete(true); }
		text=String::appendAt(text,carrot,append);
		mementoMgr.push(carrot,append,true,true);
		carrot+=append.length();
		selected={carrot,carrot};
		updateCarrot();

	}
	void keyboardDoEnter() { if(@inputFunc!=null) { inputFunc(text); } text=""; }

	void kbDebug() {
		Debug::log("Selected: " + toString(selected[0]) + ", " + toString(selected[1]) + ", with carrot: " + toString(carrot) + ", and label: " + text );
	}

	// Keyboard input hook
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

		kbDebug();
	}

	// Rendering
	void paint() {
		if(Environment::loading) { return; }
		if(@GUI::textEntryFocus==@this) {
			UI::setTextureless();

			if(selected[1]!=selected[0]) {
				float highlightStart=String::substrWidth(font,fontScale,text,-1,selected[0]);
				float highlightEnd=highlightStart+String::substrWidth(font,fontScale,text,selected[0],selected[1]);
				UI::setColor(Color::Green);
				UI::addRect(Rectanglef(label.textPos+Vector2f(highlightStart,0),label.textPos+Vector2f(highlightEnd,label.textSize.y)));
			}
			Vector2f caretPos=Vector2f(label.textPos.x+carrotPos-0.05,label.textPos.y);
			UI::setColor(Color::White);
			UI::addRect(Rectanglef(caretPos,Vector2f(caretPos.x+0.1,label.textPos.y+label.textSize.y)));
		}
	}
}