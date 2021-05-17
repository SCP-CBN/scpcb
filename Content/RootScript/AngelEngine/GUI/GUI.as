// # GUI::Align ----

namespace GUI { shared enum Align {
    Center = 0x0,

    Left = 0x1,
    Right = 0x2,
    Top = 0x4,
    Bottom = 0x8,

    Forward = 0x10,
    Backward = 0x20,

    Fill = 0x10,
    Manual = 0x20,

    None = 0x40,
} }




// # GUI Skin --------
// All the colors and textures and stuff.

namespace GUI { namespace Skin {
	shared Texture@ menublack = Texture::get(rootDirGFXMenu + "menublack");
	shared Texture@ menuwhite = Texture::get(rootDirGFXMenu + "menuwhite");
	shared Texture@ menuMain = Texture::get(rootDirGFXMenu + "back");
	shared Texture@ menuPause = Texture::get(rootDirGFXMenu + "pausemenu");
	shared Texture@ menuSCPLabel = Texture::get(rootDirGFXMenu + "scptext");
	shared Texture@ menuSCP173 = Texture::get(rootDirGFXMenu + "173back");

	namespace Button {
		shared Texture@ fgtexture = Texture::get(rootDirGFXMenu + "menublack");
		shared Texture@ bgtexture = Texture::get(rootDirGFXMenu + "menuwhite");
		shared const Color hoverColor = Color(70, 70, 150);
		shared const Color downColor = Color(100, 100, 175);
		shared const Color lockedColor = Color(100,100,100);
		shared const Color whiteColor = Color::White;
		shared const array<float> fgMargin = {0.5,0.5,0.5,0.5};
		shared const array<float> labelMargin = {0.5,0.5,0.5,0.5};

		shared Font@ font = Font::large;
		shared const Color fontColor = Color::White;
		shared const float fontScale = 2;
	}

	namespace Label {
		shared Font@ font = Font::large;
		shared const Color fontColor = Color::White;
		shared const float fontScale = 2;
	}

	namespace ScrollBar {
		shared Texture@ btmArrowTexture = Texture::get(rootDirGFXMenu + "arrow");
		shared Texture@ topArrowTexture = Texture::get(rootDirGFXMenu + "arrow");
		shared const float width=4;
		shared const float arrowHeight=4;

		shared Texture@ bgtexture = Texture::get(rootDirGFXMenu + "menublack");
		shared const Color bgColor = Color::White;
		shared Texture@ fgtexture = Texture::get(rootDirGFXMenu + "menuwhite");
		shared const Color fgColor = Color::White;
		shared const array<float> barfgMargin = {0.1,0.1,0.1,0.1};
		shared const array<float> fgMargin = {0.1,0.1,0.1,0.1};
		shared const array<float> arrowMargin = {0.1,0.1,0.1,0.1};

		shared Texture@ barbgtexture = Texture::get(rootDirGFXMenu + "menublack");
		shared const Color barbgColor = Color::White;
		shared Texture@ barfgtexture = Texture::get(rootDirGFXMenu + "menuwhite");
		shared const Color barfgColor = Color::White;

		shared const Color hoverColor = Color(70, 70, 150);
		shared const Color downColor = Color(100, 100, 175);
		shared const Color whiteColor = Color::White;



	}
	namespace ScrollPanel {


	}
		
} }

// # GUI Paint Helper functions --------
// All the colors and textures and stuff.


namespace GUI { namespace Paint { shared class Border {
    private Rectanglef top;
    private Rectanglef left;
    private Rectanglef bottom;
    private Rectanglef right;

    Border(float x, float y, float width, float height, float thickness) {
        top = Rectanglef(x, y, x + width, y + thickness);
        left = Rectanglef(x, y + thickness, x + thickness, y + height - thickness);
        bottom = Rectanglef(x, y + height - thickness, x + width, y + height);
        right = Rectanglef(x + width - thickness, y + thickness, x + width, y + height - thickness);
    }

    void addToUI() {
        UI::addRect(top);
        UI::addRect(left);
        UI::addRect(bottom);
        UI::addRect(right);
    }
} } }


// # GUI Namespace --------
// Gui central.

namespace GUI {
	// #### Math & Generic ----
	shared bool squareInSquare(Vector2f&in pos, Vector2f&in size, Vector2f&in sPos, Vector2f&in sSize) {
		return (pos.x>=sPos.x && pos.y>=sPos.y && (pos.x+size.x)<=(sPos.x+sSize.x) && (pos.y+size.y)<=(sPos.y+sSize.y));
	}
	shared bool pointInSquare(Vector2f&in point, Vector2f&in pos, Vector2f&in size) { return (point.x>=pos.x&&point.y>=pos.y&&point.x<=(pos.x+size.x)&&point.y<=(pos.y+size.y)); }

	// #### GUI Base Instances ----
	// basically, any gui element that does not have a parent is a baseinstance, i.e mainmenu, pausemenu etc.
	shared array<GUI@> baseInstances;


	// #### GUI Resolution Scaling ----
	shared float tileScale=0.04f; // Why is this even a thing??? :[

	// # Origin resolution, if you need it.
	shared float originAspect=1280.f/720.f;
	shared Vector2f originResolution=Vector2f(1280.f,720.f)*tileScale*originAspect*2.f;

	// # Resolution data
	shared Vector2f resolution;
	shared float aspectScale;
	shared Vector2f center; // Center of screen from origin.

	// # Resolution change hook.
	shared void updateResolution(int screenWidth=UI::getScreenWidth(),int screenHeight=UI::getScreenHeight()) {
		aspectScale=tileScale*UI::getAspectRatio()*2.f;
		resolution=Vector2f(screenWidth,screenHeight)*aspectScale;
		center=resolution/2;
		for(int i=0; i<baseInstances.length(); i++) { baseInstances[i].invalidateLayout(); } // Update all menus.
	}


	// #### Layout manager ----
	// Cascade method to update all elements in a gui parent/child tree.
	// Layouts run at the start of each frame.
	// This system is special, where gui element trees can be updated part-way down the tree.
	// this is so that only the things that have changed are updated.
	// call gui_element.invalidateLayout(); to mark a GUI element as invalid to be updated next frame.
	shared array<GUI@> invalidLayout;
	shared bool isInvalidLayout;

	// Cascade layout validator entrypoint
	shared void executeLayout() { if(isInvalidLayout) { isInvalidLayout=false; while(invalidLayout.length()>0) {
		GUI@ x=invalidLayout[0]; invalidLayout.removeAt(0); x.drillLayout();
	} } }

	// When an element is updated, remove itself from the invalid layouts list so it is not updated twice. This is can probably be removed.
	shared void markValid(GUI@&in element) { int idx=invalidLayout.findByRef(@element); if(idx>=0) { invalidLayout.removeAt(idx); } }

	// Mark an element as invalid and trigger a layout update next frame.
	shared void markInvalid(GUI@&in element) { isInvalidLayout=true; if(invalidLayout.findByRef(@element)<0) { invalidLayout.insertLast(@element); } }

	// #### Main Click & Mouse handler ----
	// Cascade method to run a click operation on all elements underneath the mouse.
	// All menu elements are positioned relative to 0,0, so it is easier for the mouse to be positioned there and not vica-versa.
	// A lot of the math simply does not work with the negatives involved otherwise, how the top left corner of the screen is -resolution/2.
	shared Vector2f mouse() { return Input::getMousePosition()+center; }
	shared bool isMouse1Down;

	// # onClick() global event.
	shared void onClick() {
		Vector2f mpos = mouse();
		clickedTextEntering(mpos); // Update text entering (defocus if click outside)

		// If a menu changes the menu, new elements could be clicked in this call, so this deals with that.
		array<GUI@> clickables;
		for(int i=0; i<baseInstances.length(); i++) {
			GUI@ instance=baseInstances[i];
			if( instance.visible&&GUI::pointInSquare(mpos,instance.paintPos,instance.paintSize) ) { baseInstances[i].drillClick(mpos,clickables); }
		}
		for(int i=0; i<clickables.length(); i++) { clickables[i].callClick(mpos); }
	}

	// # Monitor the mouse for clicks.
	shared void updateMouse() {
		// bool is1hit=Input::Mouse1::isHit(); // This is not necessary.
		bool is1down=Input::Mouse1::isDown();
		if(is1down) { if(!isMouse1Down) { onClick(); isMouse1Down=true; } }
		else if (!is1down && isMouse1Down) { isMouse1Down=false; }
	}


	// #### Text Entry ----
	// Handles textentry focus and the input capturer.
	// Mostly used and managed by GUI::TextEntry instances.
	shared GUITextEntry@ textEntryFocus;
	shared bool validTextEntering() { if(@textEntryFocus!=null) { if(!textEntryFocus.visible) { @textEntryFocus=null; return false; } return true; } return false; }
	shared void startTextEntering(GUITextEntry@ gui) { @textEntryFocus=@gui; Input::startTextInputCapture(); }
	shared void stopTextEntering() { @textEntryFocus=null; Input::stopTextInputCapture(); }
	shared void updateTextEntering() { if(validTextEntering()) { textEntryFocus.updateTextEntering(); } }
	shared void clickedTextEntering(Vector2f mpos) {
		if(validTextEntering() && !pointInSquare(mpos,textEntryFocus.paintPos,textEntryFocus.paintSize)) { stopTextEntering(); }
	}
	shared funcdef void TextEnteredFunc(string&in input);


	// #### Cascade GUI Renderer & Updater.
	shared float interp;
	shared void startRender(float interp) {
		GUI::interp=interp;
		UI::setTextureless();
		UI::setColor(Color::White);
		for(int i=0; i<baseInstances.length(); i++) { if(baseInstances[i].visible) { baseInstances[i].drillPreRender(); } }
		executeLayout();
		for(int i=0; i<baseInstances.length(); i++) { if(baseInstances[i].visible) { baseInstances[i].drillRender(); } }
		UI::setTextureless();
		UI::setColor(Color::White);
	}

	shared void startUpdate(float interp) {
		GUI::interp=interp;
		updateMouse();
		updateTextEntering();
		int baseLen=baseInstances.length();
		for(int i=0; i<baseLen; i++) { if(baseInstances[i].visible) { baseInstances[i].drillUpdate(); } }

	}

	shared void initialize() {
		updateResolution();
	}	
}




// # GUI Base Class --------
// The base GUI class on which all GUI classes are based.
// On its own, it acts like a container for other GUI elements.
// All GUI elements are derived from this class with overrides and constructors to give behaviour and purpose.
// Created with GUI@ gui_panel = GUI();
// To create a panel parented to another, simply use GUI@ child_panel = GUI(@parent_panel);
// Then configure the child, such as .align=GUI::Align::Fill.
// To manage layouts, you must call invalidateLayout() manually as-needed (in the majority of cases), as this is rarely called automatically.
// layout updates are costly, requiring repositioning and resizing of all children elements, but the elements do not change often so this is worthwhile.
// And sometimes you must change layout data without triggering an update, so having no automatic updates helps with that.

shared class GUI {

	// #### Base Class ----

	// # Class
	// Stores a string representing the type of the current GUI element.
	string cls = "GUI";

	// # Visibility
	// Elements with .visible=false are ignored in most operations like rendering and updating.
	// This also stops child elements from being rendered.
	bool visible;

	// # Opacity
	// Generally, the alpha color property. It is drilled down from the element it is set to, enabling fading animations.
	// the opacity property is offered as a tool for this purpose and is used by default wherever possible.
	float _opacity;
	float opacity { get { return _opacity; } set { _opacity=value; if(hasChild) { for(int i=0; i<_children.length(); i++) { _children[i].opacity=value; } } } }

	// #### Parenting system ----
	array<GUI@> _children;
	GUI@ _parent;
	bool hasChild;
	bool hasParent;

	void setParent() { if(hasParent) { _parent.removeChild(@this); @_parent=null; hasParent=false; } } // setparent to null, for whatever reason?
	void setParent(GUI@&in parx) {
		GUI@ par=@parx; // crash prevention
		GUI@ ppar=@_parent;
		if(not hasParent) { @_parent=@par; _parent.addChild(@this); }
		else if(@_parent != @par) { _parent.removeChild(@this); @_parent=@par; _parent.addChild(@this); }
		hasParent=true;
		onSetParent(@par,@ppar);
	}
	void removeChildren() { for(int i=_children.length()-1; i>=0; i--) { onChildRemoved(@_children[i],i); _children.removeLast(); } }
	void removeChild(GUI@&in child) { int at = _children.findByRef(@child); onChildRemoved(@_children[at],at); _children.removeAt(at); hasChild=(_children.length()>0); }
	void removeChildAt(int at) { onChildRemoved(@_children[at],at); _children.removeAt(at); hasChild=(_children.length()>0); }
	void addChild(GUI@&in child) { hasChild=true; _children.insertLast(@child); onChildAdded(@child); }
	int findChild(GUI@&in child) { for(int i=0; i<_children.length(); i++) { if(@_children[i]==@child) { return i; } } return -1; }

	// # overrides
	void onSetParent(GUI@&in parent,GUI@&in prevParent) {}
	void onChildRemoved(GUI@&in child, int&in at) {onChildRemoved(@child);}
	void onChildRemoved(GUI@&in child) {}
	void onChildAdded(GUI@&in child) {}

	// Mostly used to avoid rendering scrollpanel elements outside of the scroll area.
	// That can probably be done better, but this function is still useful.
	bool inParent;
	bool isInParent() { if(!hasParent) { inParent=true; } else { inParent=_parent.contains(@this); } return inParent; }
	bool contains(GUI@&in panel) { return GUI::squareInSquare(panel.paintPos+1,panel.paintSize-1,paintPos-1,paintSize+1); }

	// #### Docking Layout Positioning and GUI::Align System ----
	// Aligns menu elements to the parent element, or the screen in the case of no parent.
	// Uses a delayed drill system to shift all elements of a gui parent/child tree at once so there are no weird visual artifacts.
	// Efficient enough to be used in animated menus.
	// Depending on the GUI::Align, the menu will behave differently.
	// In all cases except GUI::Align::Manual, the output position is relative to the GUI Origin (0+,0+).
	// In the case of GUI::Align::Left/Right/Top/Bottom, the remaining height/width refers to how child element sizes are accumulated.
	// In essence, the layout array accumulates the sizes and margins of children to determine the offset of the next element.
	// This works in all directions, such that if there is a panel on the left with width 10 is on the left, the next panel on the top will be less 10 width.
	// While left/right inherits the height of the panel, the width of a left/right panel is deterimed by size.x, and vica-versa to size.y for top/bottom.
	// Panels are layed out in the order of _children, which is the same order as they are created, unless that is changed.
	// This panel operation ordering also applies to rendering.
	// Because the GUI Origin is in the center of the screen, draw functions must subtract GUI::center to draw in the correct location on the physical monitor.
	// GUI::mouse() exists to align the mouse to the GUI Origin.
	// Margin adds an offset for each direction on a child element.
	// Padding adds an offset for each direction for each child element contained within the element with padding. This can probably be removed, margin is better imho.
	// When a layout is completed, the final position and size of the element is stored in .paintPos and .paintSize, and the total size of all aligned children stored in .layout.
	// These variables can be written to directly to change where an element will be rendered, and stores the calculated size.
	//
	// A list GUI::Align effects are as follows:
	//	- GUI::Align::Left/Right = Aligns to the left/right edges of the parent, and stretches to the height (remaining) of the parent.
	//	- GUI::Align::Top/Bottom = Aligns to an edge of the parent, and stretches to the width (remaining) of the parent.
	//	- GUI::Align::None = Align to .pos and .size relative to GUI Origin, regardless of parent.
	//	- GUI::Align::Center = Align to the center of the parent, relative to GUI Origin using .size.
	//	- GUI::Align::Fill = Aligns to the center of the parent, and stretches to the width AND height (remaining) of the parent. Does not add to layout[n].
	//	- GUI::Align::Manual = GUI::Align is handled by a function.
	//
	// margin/layout[0] = left
	// margin/layout[1] = top
	// margin/layout[2] = right
	// margin/layout[3] = bottom
	//
	// Usage:
	// call this.invalidateLayout() when changing the position or size of a gui element, or
	//  something that affects position or size. (usually in an animation).

	Vector2f pos;
	Vector2f size;
	float x { get { return pos.x; } set { pos.x=value; } }
	float y { get { return pos.y; } set { pos.y=value; } }
	float width { get { return size.x; } set { size.x=value; } }
	float height { get { return size.y; } set { size.y=value; } }

	GUI::Align align=GUI::Align::None;
	array<float> padding;
	array<float> margin;

	array<float> layout;
	Vector2f paintPos;
	Vector2f paintSize;

	bool alwaysLayout;

	// # Layout validator drill ----
	// Triggers a layout update operation.
	void invalidateLayout() { GUI::markInvalid(@this); }

	// Executes a cascading layout update operation.
	void drillLayout() {
		GUI::markValid(@this);
		layout={0,0,0,0};
		// executePreLayout();
		layoutThis();
		internalPreLayout();
		preLayout();

		// executeLayout();
		if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible || _children[i].alwaysLayout) { layoutChild(@_children[i]); } } }
		internalDoLayout();
		doLayout();

		// executePostLayout();
		if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible || _children[i].alwaysLayout) { _children[i].drillLayout(); } } }
		internalPostLayout();
		postLayout();
	}


	// # Primary overrides ----
	void internalPreLayout() {} // Override
	void internalDoLayout() {} // Override for base classes
	void internalPostLayout() {} // base class

	void preLayout() {} // override
	void doLayout() {} //override
	void postLayout() {} // override


	// # Layout functions ----
	void layoutThis() {
		if(!hasParent) { switch(align) {
			case GUI::Align::None:
				paintPos=pos-GUI::center;
				paintSize=size;
				break;
			case GUI::Align::Center:
				paintSize=size;
				paintPos=GUI::center-(paintSize/2);
				break;
			case GUI::Align::Left:
				paintSize=Vector2f(width-(margin[0]+margin[2]),GUI::resolution.y-(margin[1]+margin[3]));
				paintPos=Vector2f(margin[0],margin[1]);
				break;
			case GUI::Align::Right:
				paintSize=Vector2f(width-(margin[0]+margin[2]),GUI::resolution.y-(margin[1]+margin[3]));
				paintPos=Vector2f(GUI::resolution.x-width-margin[2],margin[1]);
				break;
			case GUI::Align::Bottom:
				paintSize=Vector2f(GUI::resolution.x-(margin[0]+margin[3]),height-(margin[1]+margin[3]));
				paintPos=Vector2f(margin[0],GUI::resolution.y-height-margin[1]);
				break;
			case GUI::Align::Top:
				paintSize=Vector2f(GUI::resolution.x-(margin[0]+margin[3]),height-(margin[1]+margin[3]));
				paintPos=Vector2f(margin[0],margin[1]);
				break;
			case GUI::Align::Fill:
				paintPos=Vector2f(margin[0],margin[1]);
				paintSize=GUI::resolution;
				break;
			default:
				manualLayoutThis();
				break;
		} }
	}
	void manualLayoutThis() {} // GUI::Align::Manual override.

	void layoutChild(GUI@&in child) {
		switch(child.align) {
			case GUI::Align::None:
				child.paintPos=child.pos;
				child.paintSize=child.size;
				break;
			case GUI::Align::Center:
				child.paintSize=child.size;
				child.paintPos=(paintPos+paintSize/2)-(child.paintSize/2);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0],child.margin[1]+padding[1]);
				break;
			case GUI::Align::Left:
				child.paintSize=Vector2f(child.width,paintSize.y-layout[1]-layout[3]);
				child.paintPos=Vector2f(paintPos.x,paintPos.y);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+layout[0]+padding[0],child.margin[1]+layout[1]+padding[1]);
				layout[0] = layout[0]+ child.width+child.margin[0]+child.margin[2]+padding[0]+padding[2];
				// Can't do array[n] += ?????
				break;
			case GUI::Align::Right:
				child.paintSize=Vector2f(child.width,paintSize.y-layout[1]-layout[3]);
				child.paintPos=Vector2f((paintPos.x+paintSize.x)-child.width-layout[2],paintPos.y);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0],child.margin[1]+padding[1]+layout[1]);
				layout[2] = layout[2]+ child.width+child.margin[0]+child.margin[2]+padding[0]+padding[2];
				break;
			case GUI::Align::Bottom:
				child.paintSize=Vector2f(paintSize.x-layout[0]-layout[2],child.height);
				child.paintPos=Vector2f(paintPos.x,(paintPos.y+paintSize.y)-child.height-child.margin[3]-padding[3]-layout[3]);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0]+layout[0],child.margin[1]+padding[1]);
				layout[3] = layout[3]+ child.height+padding[1]+padding[3]+child.margin[1]+child.margin[3];
				break;
			case GUI::Align::Top:
				child.paintSize=Vector2f(paintSize.x-layout[0]-layout[2],child.height);
				child.paintPos=Vector2f(paintPos.x,paintPos.y);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0]+layout[0],child.margin[1]+layout[1]+padding[1]);
				layout[1] = layout[1]+ child.height+padding[1]+padding[3]+child.margin[1]+child.margin[3];
				break;
			case GUI::Align::Fill:
				child.paintSize=Vector2f(paintSize.x-layout[0]-layout[2],paintSize.y-layout[1]-layout[3]);
				child.paintPos=Vector2f(paintPos.x,paintPos.y);
				child.paintSize -= Vector2f(child.margin[0]+child.margin[2]+padding[0]+padding[2],child.margin[1]+child.margin[3]+padding[1]+padding[3]);
				child.paintPos += Vector2f(child.margin[0]+padding[0]+layout[0],child.margin[1]+padding[1]+layout[1]);
				break;
			default:
				manualLayoutChild(@child,layout);
				break;
		}
		child.layoutParent(@this);
		postLayoutChild(@child);
	}
	void manualLayoutChild(GUI@&in child, array<float> &layout) {} // GUI::Align::Manual override (ONLY where @child has GUI::Align::Manual).
	void layoutParent(GUI@&in parent) {} //override, for a child to affect its parents layout.
	void postLayoutChild(GUI@&in child) {} // override

	// #### Mouse handling ----
	// Exactly what it says on the tin.

	// # isHovered();
	// Must be called manually in the update function for panels that use it.
	bool hovering;
	bool wasHovered;
	bool isHovered() {
		Vector2f mpos=GUI::mouse();
		bool hover=GUI::pointInSquare(mpos, paintPos, paintSize);
		if(wasHovered && !hover) { internalStopHover(); hovering=false; }
		else if(!wasHovered && hover) { internalStartHover(); hovering=true; }
		wasHovered=hovering;
		return hovering;
	}
	void internalStopHover() { stopHovering(); }
	void internalStartHover() { startHovering(); }
	void stopHovering() {}; // override
	void startHovering() {}; // override

	// # Clicking
	// Generally handled by GUI::Clickable, but the base class requires the click drill functions to propogate clicks to the clickables.
	Util::Function@ clickFunc;

	void drillClick(Vector2f mpos,array<GUI@> &clickables) { clickables.insertLast(@this); if(hasChild) { for(int i=0; i<_children.length(); i++) {
		GUI@ child=@_children[i]; if( child.visible && GUI::pointInSquare(mpos,child.paintPos,child.paintSize)) { child.drillClick(mpos,clickables); }
	} } }

	void callClick(Vector2f mpos) { internalClick(mpos); doClick(mpos); hovering=false; wasHovered=false; if(@clickFunc!=null) { clickFunc(); } }
	void internalClick(Vector2f mpos) {} // internal override
	void doClick(Vector2f mpos) {doClick();} // Vector2f override
	void doClick() {} // Override without Vector2f / alias.

	// #### Update/Tick/Think functions ----
	void drillUpdate() { doUpdate(); if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible) { _children[i].drillUpdate(); } } } }
	void doUpdate() { internalUpdate(); update(); }

	void internalUpdate() {} // override
	void update() {} // override

	// #### Rendering function ----
	// Named `paint` because reasons.

	void drillPreRender() { preRender(); if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible && _children[i].inParent) { _children[i].drillPreRender(); } } } }
	void drillRender() { doRender(); if(hasChild) { for(int i=0; i<_children.length(); i++) { if(_children[i].visible && _children[i].inParent) { _children[i].drillRender(); } } } }
	void doRender() { internalPaint(); paint(); }
	void preRender() { internalPrePaint(); prePaint(); }

	void internalPrePaint() {}
	void internalPaint() {}

	void prePaint() {} // override
	void paint() {} // override


	// #### Constructor ----
	bool baseInstance;
	GUI(string clstype="GUI") {
		GUI::baseInstances.insertLast(@this);
		cls=clstype;
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


	// #### Destructor ----
	~GUI() { } // Destructor(); }
}

// # TODO: Console menu stuff.

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
