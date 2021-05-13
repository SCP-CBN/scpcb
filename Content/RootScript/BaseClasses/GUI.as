namespace GUI { namespace Skin {
	shared Texture@ menublack = Texture::get("SCPCB/GFX/Menu/menublack");
	shared Texture@ menuwhite = Texture::get("SCPCB/GFX/Menu/menuwhite");
	shared Texture@ menuMain = Texture::get("SCPCB/GFX/Menu/back");
	shared Texture@ menuPause = Texture::get("SCPCB/GFX/Menu/pausemenu");
	shared Texture@ menuSCPLabel = Texture::get("SCPCB/GFX/Menu/scptext");
	shared Texture@ menuSCP173 = Texture::get("SCPCB/GFX/Menu/173back");

	namespace Button {
		shared Texture@ fgtexture = Texture::get("SCPCB/GFX/Menu/menublack");
		shared Texture@ bgtexture = Texture::get("SCPCB/GFX/Menu/menuwhite");
		shared const Color hoverColor = Color(70, 70, 150);
		shared const Color downColor = Color(100, 100, 175);
		shared const Color lockedColor = Color(100,100,100);
		shared const Color whiteColor = Color::White;
		shared const array<float> fgMargin = {0.5,0.5,0.5,0.5};
		shared const array<float> labelMargin = {0.5,0.5,0.5,0.5};
	}

	namespace Label {
		shared Font@ font = Font::large;
		shared const Color fontColor = Color::White;
		shared const float fontScale = 2;
	}

	namespace ScrollBar {
		shared Texture@ btmArrowTexture = Texture::get("SCPCB/GFX/Menu/arrow");
		shared Texture@ topArrowTexture = Texture::get("SCPCB/GFX/Menu/arrow");
		shared const float width=4;
		shared const float arrowHeight=4;

		shared Texture@ bgtexture = Texture::get("SCPCB/GFX/Menu/menublack");
		shared const Color bgColor = Color::White;
		shared Texture@ fgtexture = Texture::get("SCPCB/GFX/Menu/menuwhite");
		shared const Color fgColor = Color::White;
		shared const array<float> barfgMargin = {0.1,0.1,0.1,0.1};
		shared const array<float> fgMargin = {0.1,0.1,0.1,0.1};
		shared const array<float> arrowMargin = {0.1,0.1,0.1,0.1};

		shared Texture@ barbgtexture = Texture::get("SCPCB/GFX/Menu/menublack");
		shared const Color barbgColor = Color::White;
		shared Texture@ barfgtexture = Texture::get("SCPCB/GFX/Menu/menuwhite");
		shared const Color barfgColor = Color::White;

		shared const Color hoverColor = Color(70, 70, 150);
		shared const Color downColor = Color(100, 100, 175);
		shared const Color whiteColor = Color::White;



	}
	namespace ScrollPanel {


	}
		
} }

namespace GUI {
	shared Texture@ menuwhite = Texture::get("SCPCB/GFX/Menu/menuwhite");
	shared Texture@ menublack = Texture::get("SCPCB/GFX/Menu/menublack");
	shared array<GUI@> baseInstances;

	// Origin Resolution --------
	// The original resolution at which the GUI was constructed

	shared float tileScale=0.04f; // Why is this even a thing??? :[

	shared Vector2f realOriginResolution=Vector2f(1280,720);
	shared Vector2f originResolution=(realOriginResolution*tileScale)*(realOriginResolution.x/realOriginResolution.y)*2.f;


	// Resolution Scaler --------
	// Scaling GUI's proportionately to a different resolution.
	// *width/height*scale for rectangles. w&h *ratio for perfect squares.

	shared Vector2f Resolution;
	shared Vector2f uiScale; // UI scale for bigger monitors compared to origin

	shared Vector2f Center; // Center of screen from origin.

	shared float aspectScale;

	shared void updateResolution() {
		aspectScale=tileScale*UI::getAspectRatio()*2.f;
		Resolution=Vector2f(UI::getScreenWidth(),UI::getScreenHeight())*aspectScale;
		uiScale=Resolution / originResolution;
		Center=Resolution/2;
		for(int i=0; i<baseInstances.length(); i++) { baseInstances[i].invalidateLayout(); }
	}


	// Cascade Layout Validator ----
	// ValidateLayout cascade position/size/alignment update at end of frame --------
	shared array<GUI@> invalidLayout;
	shared bool isInvalidLayout;
	shared void InvalidateLayout(GUI@&in element) { isInvalidLayout=true; if(invalidLayout.findByRef(@element)<0) { invalidLayout.insertLast(@element); } }
	shared void ValidateLayout() { if(isInvalidLayout) { isInvalidLayout=false;
		while(invalidLayout.length()>0) { GUI@ x=invalidLayout[0]; invalidLayout.removeAt(0); x.drillLayout(); }
	} }
	shared void cacheLayout(GUI@&in element) { int idx=invalidLayout.findByRef(@element); if(idx>=0) { invalidLayout.removeAt(idx); } }

	// Animator --------
	shared array<GUI@> animators;
	shared void StartAnimation(GUI@&in element) { if(animators.findByRef(@element)<0) { animators.insertLast(@element); } }
	shared void StopAnimation(GUI@&in element) { int idx=animators.findByRef(@element); if(idx>=0) { animators.removeAt(idx); } }


	// Mouse Clicking --------

	shared Vector2f Mouse() { return Input::getMousePosition()+Center; }
	shared bool isMouse1Down;
	shared void startClick() {
		Vector2f mpos = Mouse();
		if(@textEntryFocus!=null) {
			if(!vectorIsInSquare(mpos,textEntryFocus.paintPos,textEntryFocus.paintSize)) {
				stopTextEntering();
			}
		}

		array<GUI@> clickables; // Stops menu changes causing multiple things to be clicked at the same time when they should not
		for(int i=0; i<baseInstances.length(); i++) {
			GUI@ instance=baseInstances[i];
			if( instance.visible && vectorIsInSquare(mpos, instance.paintPos,instance.paintPos+instance.paintSize) ) { baseInstances[i].drillClick(mpos,clickables); }
		}
		for(int i=0; i<clickables.length(); i++) { clickables[i].callClick(mpos); }
	}
	shared void monitorMouse() {
		bool is1hit=Input::Mouse1::isHit();
		bool is1down=Input::Mouse1::isDown();
		if(is1hit || is1down) {
			if(!isMouse1Down) { startClick(); isMouse1Down=true; }
		} else if (!is1down && isMouse1Down) {
			isMouse1Down=false;
		}
	}

	// Text Entry --------
	shared GUITextEntry@ textEntryFocus;
	shared void startTextEntering(GUITextEntry@ gui) {
		@textEntryFocus=@gui;
		Input::startTextInputCapture();
	}
	shared bool isTextEntering() { return @textEntryFocus!=null; }
	shared void stopTextEntering() {
		@textEntryFocus=null;
		Input::stopTextInputCapture();
	}

	// Initiate Drill Renderers --------
	shared void Draw() {
		UI::setTextureless();
		UI::setColor(Color::White);
		if(animators.length()>0) { for(int i=0; i<animators.length(); i++) { animators[i].Animate(); } }
		int baseLen=baseInstances.length();
		for(int i=0; i<baseLen; i++) { if(baseInstances[i].visible) { baseInstances[i].drillPreRender(); } }
		GUI::ValidateLayout();
		for(int i=0; i<baseLen; i++) { if(baseInstances[i].visible) { baseInstances[i].drillRender(); } }
		UI::setTextureless();
		UI::setColor(Color::White);
	}

	shared void Think() {
		monitorMouse();
		int baseLen=baseInstances.length();
		for(int i=0; i<baseLen; i++) { if(baseInstances[i].visible) { baseInstances[i].drillUpdate(); } }
		if(@textEntryFocus!=null) {
			textEntryFocus.updateText();
		}
	}


	shared void Initialize() {
		updateResolution();
	}
		
}

shared class GUI {
	string cls = "GUI";

	// Parenting system --------
	GUI@ _parent;
	array<GUI@> _children;
	void setParent() {
		if(hasParent) { _parent.removeChild(@this); @_parent=null; hasParent=false; }
	}
	void setParent(GUI@&in parx) {
		GUI@ par=@parx; // crash prevention
		if(not hasParent) {
			@_parent=@par;
			_parent.addChild(@this);
		} else if(@_parent != @par) {
			_parent.removeChild(@this);
			@_parent=@par;
			_parent.addChild(@this);
		}
		hasParent=true;
	}

	bool hasChild;
	bool hasParent;
	bool inParent;
	void isInParent() {
		if(hasParent) {
			inParent=(vectorIsInSquare(paintPos+1,_parent.paintPos,_parent.paintPos+_parent.paintSize) &&
				vectorIsInSquare(paintPos+paintSize-1,_parent.paintPos,_parent.paintPos+_parent.paintSize) );
		} else { inParent=true; }
	}
	void removeChild(GUI@&in child) { _children.removeAt(_children.findByRef(@child)); hasChild=(_children.length()>0); invalidateLayout(); onRemoveChild(@child); }
	void onRemoveChild(GUI@&in child) {}
	void addChild(GUI@&in child) { hasChild=true; _children.insertLast(@child); invalidateLayout(); onAddChild(@child); }
	void onAddChild(GUI@&in child) {}

	int findChild(GUI@&in child) { for(int i=0; i<_children.length(); i++) { if(@_children[i]==@child) { return i; } } return -1; }

	// Generic Immediate-Drill Properties --------
	bool _visible;
	bool visible { get { return _visible; } set { _visible=value; } } // if(hasChild) { for(int i=0; i<_children.length(); i++) { _children[i].visible=value; } } } }
	float _opacity;
	float opacity { get { return _opacity; } set { _opacity=value; if(hasChild) { for(int i=0; i<_children.length(); i++) { _children[i].opacity=value; } } } }

	// Docking Layout System --------
	// Uses a delayed drill system to shift all elements of a gui parent/child at the same time so no weird visual artefacts.
	// Efficient enough to be used in menu animations.
	// invalidate and drill are line-compressed because all validators are the same with different variables.
	// Based on Derma system in Garry's Mod.
	//
	// Usage:
	// call - this.invalidateLayout() when changing the position of a gui element (usually in an animation).

	// Layout (position,size,alignment) ----

	Alignment _align=Alignment::None;
	Alignment align { get { return _align; } set { _align=value; } } // invalidateLayout();

	Vector2f _pos;
	float x { get { return _pos.x; } set { _pos.x=value; } }
	float y { get { return _pos.y; } set { _pos.y=value; } }
	Vector2f pos { get { return _pos; } set { _pos=value; } }

	Vector2f _size;
	float width { get { return _size.x; } set { _size.x=value; } }
	float height { get { return _size.y; } set { _size.y=value; } }
	Vector2f size { get { return _size; } set { _size=value; } }

	array<float> _padding;
	array<float> padding { get { return _padding; } set { _padding=value; } }
	array<float> _margin;
	array<float> margin { get { return _margin; } set { _margin=value; } }

	float rotation; // No rotation for UI::addRect?? :(

	// Layout validator ----
	void invalidateLayout() { GUI::InvalidateLayout(@this); }
	void drillLayout() { 
		GUI::cacheLayout(@this);
		prepareLayout();
		internalPreLayout();
		if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible) { layoutChild(@_children[i]); } } }
		doneLayout();
		internalDoneLayout();
		isInParent();
		if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible) { _children[i].drillLayout(); } } }
		internalPostLayout();
		postLayout();
	}

	void internalDoneLayout() {} // Override for base classes
	void internalPostLayout() {} // base class
	void internalPreLayout() {}

	array<float> layout;
	Vector2f paintPos;
	Vector2f paintSize;

	void prepareLayout() {
		layout={0,0,0,0};
		if(!hasParent) { switch(_align) {
			case Alignment::None:
				paintPos=pos-GUI::Center;
				paintSize=size;
				break;
			case Alignment::Center:
				paintSize=size;
				paintPos=GUI::Center-(paintSize/2);
				break;
			case Alignment::Left:
				paintSize=Vector2f(width-(margin[0]+margin[2]),GUI::Resolution.y-(margin[1]+margin[3]));
				paintPos=Vector2f(margin[0],margin[1]);
				break;
			case Alignment::Right:
				paintSize=Vector2f(width-(margin[0]+margin[2]),GUI::Resolution.y-(margin[1]+margin[3]));
				paintPos=Vector2f(GUI::Resolution.x-width-margin[2],margin[1]);
				break;
			case Alignment::Bottom:
				paintSize=Vector2f(GUI::Resolution.x-(margin[0]+margin[3]),height-(margin[1]+margin[3]));
				paintPos=Vector2f(margin[0],GUI::Resolution.y-height-margin[1]);
				break;
			case Alignment::Top:
				paintSize=Vector2f(GUI::Resolution.x-(margin[0]+margin[3]),height-(margin[1]+margin[3]));
				paintPos=Vector2f(margin[0],margin[1]);
				break;
			case Alignment::Fill:
				paintPos=Vector2f(margin[0],margin[1]);
				paintSize=GUI::Resolution;
				break;
			default:
				performLayout();
				break;
		} }
	}



	void layoutChild(GUI@&in child) {
		switch(child._align) {
			case Alignment::None:
				child.paintPos=child.pos;
				child.paintSize=child.size;
				break;
			case Alignment::Center:
				child.paintSize=child.size;
				child.paintPos=(paintPos+paintSize/2)-(child.paintSize/2);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0],child.margin[1]+padding[1]);
				break;
			case Alignment::Left:
				child.paintSize=Vector2f(child.width,paintSize.y-layout[1]-layout[3]);
				child.paintPos=Vector2f(paintPos.x,paintPos.y);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+layout[0]+padding[0],child.margin[1]+layout[1]+padding[1]);
				layout[0] = layout[0]+ child.width+child.margin[0]+child.margin[2]+padding[0]+padding[2];
				// Can't do array[n] += ?????
				break;
			case Alignment::Right:
				child.paintSize=Vector2f(child.width,paintSize.y-layout[1]-layout[3]);
				child.paintPos=Vector2f((paintPos.x+paintSize.x)-child.width-layout[2],paintPos.y);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0],child.margin[1]+padding[1]+layout[1]);
				layout[2] = layout[2]+ child.width+child.margin[0]+child.margin[2]+padding[0]+padding[2];
				break;
			case Alignment::Bottom:
				child.paintSize=Vector2f(paintSize.x-layout[0]-layout[2],child.height);
				child.paintPos=Vector2f(paintPos.x,(paintPos.y+paintSize.y)-child.height-child.margin[3]-padding[3]-layout[3]);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0]+layout[0],child.margin[1]+padding[1]);
				layout[3] = layout[3]+ child.height+padding[1]+padding[3]+child.margin[1]+child.margin[3];
				break;
			case Alignment::Top:
				child.paintSize=Vector2f(paintSize.x-layout[0]-layout[2],child.height);
				child.paintPos=Vector2f(paintPos.x,paintPos.y);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0]+layout[0],child.margin[1]+layout[1]+padding[1]);
				layout[1] = layout[1]+ child.height+padding[1]+padding[3]+child.margin[1]+child.margin[3];
				break;
			case Alignment::Fill:
				child.paintSize=Vector2f(paintSize.x-layout[0]-layout[2],paintSize.y-layout[1]-layout[3]);
				child.paintPos=Vector2f(paintPos.x,paintPos.y);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0]+layout[0],child.margin[1]+padding[1]+layout[1]);
				break;
			default:
				performChildLayout(@child,layout);
				break;
		}
		child.doneChildLayout();
		performedChildLayout(@child);
	}

	void performLayout() {} //override
	void performChildLayout(GUI@&in child, array<float> &layout) {} //override
	void doneLayout() {} //override
	void doneChildLayout() {} // override
	void performedChildLayout(GUI@&in child) {} // override
	void postLayout() {} // override


	// Constructor --------
	bool baseInstance;
	GUI(string clstype="GUI") {
		cls=clstype;
		GUI::baseInstances.insertLast(@this);
		baseInstance=true;
		pos=Vector2f();
		size=Vector2f(5);
		padding={0,0,0,0};
		margin={0,0,0,0};
		visible=true;
		inParent=true;
		_opacity=1.f;
		invalidateLayout();
	}
	GUI(GUI@&in parent,string clstype="GUI") {
		cls=clstype;
		setParent(@parent);
		padding={0,0,0,0};
		margin={0,0,0,0};
		pos=Vector2f();
		size=Vector2f(5);
		visible=true;
		inParent=true;
		_opacity=_parent.opacity;
	}


	// Destructor
	~GUI() { } // Destructor(); }


	// Mouse handling --------
	bool isHovered() {
		Vector2f mpos=GUI::Mouse();
		bool hover=vectorIsInSquare(mpos, paintPos, paintPos+paintSize);
		if(wasHovered && !hover) {
			exitHover();
			hovering=false;
		} else if(!wasHovered && hover) {
			enterHover();
			hovering=true;
		}
		wasHovered=hovering;
		return hovering;
	}
	bool hovering;
	bool wasHovered;
	void exitHover() {
		stopHovering();
	}
	void enterHover() {
		startHovering();
	}
	void stopHovering() {}; // override
	void startHovering() {}; // override

	void drillClick(Vector2f mpos,array<GUI@> &clickables) {
		clickables.insertLast(@this);
		if(hasChild) {
			for(int i=0; i<_children.length(); i++) {
				GUI@ child=@_children[i];
				if( child.visible && vectorIsInSquare(mpos, child.paintPos,child.paintPos+child.paintSize) ) { child.drillClick(mpos,clickables); }
			}
		}
	}
	void callClick(Vector2f mpos) {
		internalClick(mpos);
		doClick(mpos);
		wasHovered=false;
	}
	void internalClick(Vector2f mpos) {} // internal override
	void doClick(Vector2f mpos) {doClick();} // Vector2f override
	void doClick() {} // Override without Vector2f / alias.

	// Events ----
	void onClose() {}
	void onOpen() {}

	// Tick functions ----
	void drillUpdate() { doUpdate(); if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible) { _children[i].drillUpdate(); } } } }
	void doUpdate() {
		internalUpdate();
		update();
	}
	void internalUpdate() {};
	void update() {}; // override


	// Animations (Runs before Painter) --------

	void startAnimation() { GUI::StartAnimation(@this); onStartAnimation(); }
	void stopAnimation() { GUI::StopAnimation(@this); onStopAnimation(); }
	void onStartAnimation() {};
	void Animate() {};
	void onStopAnimation() {};


	// Painter ----


	void drillPreRender() { PreRender(); if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible && _children[i].inParent) { _children[i].drillPreRender(); } } } }
	void drillRender() { doRender(); if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible && _children[i].inParent) { _children[i].drillRender(); } } } }
	void doRender() {  Paint(); }
	void PreRender() { PrePaint(); }
	void skinColors() {}

	void PrePaint() {} // Override
	void Paint() {} // Override

}


shared class ConsoleMenu {
	ConsoleMenu() {}
	void addConsoleMessage(const string&in msg, const Color&in color) {}
}
namespace ConsoleMenu {
	shared ConsoleMenu@ instance = ConsoleMenu();
}
namespace Console {
    shared void addMessage(const string&in msg, const Color&in color = Color::White) {
        ConsoleMenu::instance.addConsoleMessage(msg, color);
    }
}
