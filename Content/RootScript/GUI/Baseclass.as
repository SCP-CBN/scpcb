// # GUI@ base class ----
// The base GUI class on which all GUI classes are based.
// On its own, it acts like a container for other GUI elements.
// All GUI elements are derived from this class with overrides and constructors to give behaviour and purpose.
// Created with GUI@ gui_panel = GUI();
// To create a panel parented to another, use GUI@ child_panel = GUI(@parent_panel);
// Then configure the child, such as .align=GUI::Align::Fill.
// To manage layouts, you must call invalidateLayout() manually as-needed (in the majority of cases), as this is rarely called automatically.
// layout updates are costly, requiring repositioning and resizing of all children elements, but the elements do not change often so this is worthwhile.
// And sometimes you must change layout data without triggering an update, so having no automatic updates helps with that.

shared class GUI { // GUI baseclass

	// #### Basics

	// # .cls
	// Stores a string representing the type of the current GUI element.
	// named cls to avoid ambiguity madness with "type".
	string cls = "GUI";

	// # .hidden
	// The element behave as if alive in layouts (non-recursive), but does not render or click (recursive).
	bool hidden;

	// # .visible
	// Elements with .visible=false are ignored in most operations like rendering, clicking, and layouts (recursive).
	bool visible;

	// # .opacity
	// A self-recursing alpha color property.
	protected float _opacity;
	float opacity { get const { return _opacity; } set { _opacity=value; for(int i=0; i<children.length(); i++) { children[i].opacity=value; } } }

	// #.parent
	// The GUI element (if any) that we are parented to.
	// Any panel without a parent is automatically sized and positioned as full screen.
	// There is no meaningful reason to have two different sets of alignment functions.
	private GUI@ _parent;
	GUI@ parent { get const { return @_parent; } set {
		if(@_parent!=null) { _parent.removeChild(@this); }
		@_parent=@value;
		if(@_parent!=null) { _parent.addChild(@this); }
		onSetParent(@_parent);
		if(@_parent==null) { square=GUI::Square(Vector2f(),GUI::resolution); frame=square; }
	} }

	void onSetParent(GUI@&in host) {} // override

	// # .children
	// An array of all gui elements parented to this one.
	array<GUI@> children;
	void removeChildren() { for(int i=children.length()-1; i>-1; i--) { onChildRemoved(@children[i],i); children.removeLast(); } }
	void removeChild(int&in at) { onChildRemoved(@children[at],at); children.removeAt(at); }
	void removeChild(GUI@&in child) { for(int i=0; i<children.length(); i++) { if(@children[i]==@child) { onChildRemoved(@child,i); children.removeAt(i); return; } } }
	void addChild(GUI@&in child) { children.insertLast(@child); onChildAdded(@child,children.length()-1); }
	void addChild(GUI@&in child, int&in at) { children.insertAt(at,@child); onChildAdded(@child,at); }

	void onChildAdded(GUI@&in child, int&in at) {} // override. always called AFTER the child is added to the children table.
	void onChildRemoved(GUI@&in child, int&in at) {} // override. always called BEFORE the child is removed from the children table.

	// #### Layouts

	// # .square
	// The position and size of the GUI element
	GUI::Square square;
	Vector2f position { get { return square.position; } set { square.position=value; } }
	Vector2f size { get { return square.size; } set { square.size=value; } }
	float x { get { return square.x; } set { square.x=value; } }
	float y { get { return square.y; } set { square.y=value; } }
	float w { get { return square.w; } set { square.w=value; } }
	float h { get { return square.h; } set { square.h=value; } }
	float width=w; // alias
	float height=h; // alias

	// # .frame
	// The aligned rendering square relative to the parent.
	GUI::Square frame;
	Vector2f framePosition { get { return frame.position; } set { frame.position=value; } }
	Vector2f frameSize { get { return frame.size; } set { frame.size=value; } }
	float frameX { get { return frame.x; } set { frame.x=value; } }
	float frameY { get { return frame.y; } set { frame.y=value; } }
	float frameW { get { return frame.w; } set { frame.w=value; } }
	float frameH { get { return frame.h; } set { frame.h=value; } }
	float frameWidth=frameW; // alias
	float frameHeight=frameH; // alias

	// # .layout
	// A square containing the current total calculated layout.
	GUI::Square@ layout;

	// # .margin
	// An array of padding dimensions (relative to GUI::scale).
	// [0]=left, [1]=top, [2]=right, [3]=bottom.
	array<float> margin;

	// # .align
	// The alignment of an element within its parent. See included Utilities/Align.as for description.
	GUI::Align align;

	// # .sizeToChildren
	// Whether the panel should stretch its height to match its children elements after its layout event.
	bool sizeToChildren;

	// # .invalidateLayout()
	// Queues a recursive validation event for the start of the next frame.
	// Don't cause multiple invalid layouts in the same gui tree for no good reason, unless they are unrelated events.
	void invalidateLayout() { GUI::markInvalid(@this); }

	// # .performRecursiveLayout()
	// A recursive function that prepares and executes the layout function on this panel and its children
	void performRecursiveLayout(float&in interp=0) {
		@layout=GUI::Square();
		internalPreLayout();
		preLayout();
		if(!hidden) { for(int i=0; i<children.length(); i++) { if(shouldLayoutChild(@children[i],i)) { layoutChild(@children[i],i); } } }
		internalDoLayout();
		doLayout();
		if(!hidden) { for(int i=0; i<children.length(); i++) { if(shouldLayoutChild(@children[i],i)) { children[i].performRecursiveLayout(interp); } } }
		if(sizeToChildren) { frame.h=Math::maxFloat(frame.h,layout.y+layout.h); }
		internalPostLayout();
		postLayout();
	}
	protected bool shouldLayoutChild(GUI@&in child, int&in at) { return child.visible; } // override. called twice per child.

	void preLayout() {} // override, before any children layouts
	void doLayout() {} // override, after finished laying out all children.
	void postLayout() {} // override, after finished children recursive layout

	void internalPreLayout() {} // override internal
	void internalDoLayout() {} // override internal
	void internalPostLayout() {} // override internal

	// # .layoutChild()
	// Performs the layout function on a child element, called by the recursion function.
	protected void layoutChild(GUI@&in child, int&in at) {
		GUI::Square@ childMargins=GUI::Square(child.margin)*GUI::scale;
		GUI::Square@ childSquare=(child.square*GUI::scale);
		preLayoutChild(@child,at);
		switch(child.align) {
			case GUI::Align::CENTER:
				child.frame.position=(childSquare.position)-(childSquare.size/2);
				child.frame-=childMargins;
				break;
			case GUI::Align::LEFT:
				child.frame.position=childSquare.position+frame.position+layout.position;
				child.frame.size=Vector2f(childSquare.w,frame.h-layout.y-layout.h);
				layout.x+=child.frame.w;
				child.frame-=childMargins;
				break;
			case GUI::Align::TOP:
				child.frame.position=childSquare.position+frame.position+layout.position;
				child.frame.size=Vector2f(frame.w-layout.x-layout.w,childSquare.h);
				layout.y+=child.frame.h;
				child.frame-=childMargins;
				break;
			case GUI::Align::RIGHT:
				child.frame.position=childSquare.position+frame.position+Vector2f(frame.w-childSquare.w-layout.w,layout.y);
				child.frame.size=Vector2f(childSquare.w,frame.h-layout.y-layout.h);
				layout.w+=child.frame.w;
				child.frame-=childMargins;
				break;
			case GUI::Align::BOTTOM:
				child.frame.position=childSquare.position+frame.position+Vector2f(layout.x,frame.h-childSquare.h-layout.h);
				child.frame.size=Vector2f(frame.w-layout.x-layout.w,childSquare.h);
				layout.h+=child.frame.h;
				child.frame-=childMargins;
				break;
			case GUI::Align::TOP_LEFT:
				child.frame.position=childSquare.position+frame.position+layout.position;
				child.frame.size=childSquare.size;
				child.frame-=childMargins;
				break;
			case GUI::Align::TOP_RIGHT:
				child.frame.position=childSquare.position+frame.position+Vector2f(frame.w-childSquare.w-layout.w,layout.y);
				child.frame.size=childSquare.size;
				child.frame-=childMargins;
				break;
			case GUI::Align::BOTTOM_LEFT:
				child.frame.position=childSquare.position+frame.position+Vector2f(frame.w-childSquare.w-layout.w,frame.h-childSquare.h-layout.h);
				child.frame.size=childSquare.size;
				child.frame-=childMargins;
				break;
			case GUI::Align::BOTTOM_RIGHT:
				child.frame.position=childSquare.position+frame.position+Vector2f(frame.w-childSquare.w-layout.w,frame.h-layout.h-childSquare.h);
				child.frame.size=childSquare.size;
				child.frame-=childMargins;
				break;
			case GUI::Align::FILL:
				child.frame.position=childSquare.position+frame.position+layout.position;
				child.frame.size=frame.size-layout.position-layout.size;
				child.frame-=childMargins;
				break;
			case GUI::Align::MANUAL:
				child.frame=childSquare;
				manualLayoutChild(@child,at);
				child.frame-=childMargins;
				break;
			case GUI::Align::NONE:
				child.frame=childSquare;
				child.frame-=childMargins;
				break;
			default:
				Debug::error("Invalid alignment on GUI element");
				break;
		}
		child.layoutParent(@this, at);
		postLayoutChild(@child, at);
	}

	void manualLayoutChild(GUI@&in child, int&in at) {} // GUI::Align::MANUAL override (ONLY where @child has GUI::Align::MANUAL).
	void layoutParent(GUI@&in parent, int&in at) {} //override, for a child to affect its parents layout.
	void preLayoutChild(GUI@&in child, int&in at) {} // override, before laying out a child, i.e set its size.
	void postLayoutChild(GUI@&in child, int&in at) {} // override, to finish laying out a child.

	// #### Mouse handling
	// Exactly what it says on the tin.

	// # .hovered and .testHovered()
	// Returns whether or not the panel is currently underneath the mouse.
	// call testHovering() in the tick function.
	// There are several ways to do this, but the simplest is for all visible elements that need hovering functions to check it themselves.
	protected bool _isHovered;
	bool hovered { set { _isHovered=value; } get { return _isHovered; } }
	bool testHovered() {
		if(!hidden && frame.contains(GUI::mouse())) { if(!_isHovered) { _isHovered=true; startHovering(); } return true; }
		else if(_isHovered) { _isHovered=false; stopHovering(); }
		return false;
	}

	void startHovering() {} // override. RunOnce function on started hovering.
	void internalStartHovering() {} // override

	void stopHovering() {} // override. RunOnce function on stopped hovering.
	void internalStopHovering() {} // override


	// # .clickFunc
	// A void/noop function with zero parameters that can be set to any function.
	// Useful for spawning buttons that do not need to do anything complicated.
	GUI::ClickFunction@ clickFunc;

	// # .performRecursiveClick(GUI::mouse, array of clicked elements)
	// The simplest and most efficient method of implementing a broadly capably click function, i.e if a child is clicked.
	// Saves keeping track of which elements are clickables, which aren't, whats visible, what isnt, etc.
	void performRecursiveClick(Vector2f&in mpos, array<GUI@> &clickables) { clickables.insertLast(@this);
		for(int i=0; i<children.length(); i++) { if(shouldClickChild(mpos,@children[i])) { performRecursiveClick(mpos,clickables); } }
	}
	protected bool shouldClickChild(Vector2f&in mpos, GUI@&in child) { return (child.visible && !child.hidden && child.frame.contains(mpos)); }

	// # .performClick(mouse position)
	// Called after performRecursiveClick to ensure clicks do not propogate to changes in the menu.
	void performClick(Vector2f&in mpos) { click(mpos); if(@clickFunc!=null) { clickFunc(mpos); } }

	void click(Vector2f&in mpos) {} // override

	// #### Update/Tick/Think functions
	// Exactly what it says on the tin.

	// # .performRecursiveTick(tick)
	void performRecursiveTick(int&in t) {
		tickInternal(t); tick(t); for(int i=0; i<children.length(); i++) { if(shouldTickChild(@children[i])) { children[i].performRecursiveTick(t); } }
	}
	protected bool shouldTickChild(GUI@&in child) { return (child.visible && !child.hidden); }

	void tick(int&in t) {} // override
	void tickInternal(int&in t) {} // override

	// #### Paint and Rendering functions.
	// Exactly what it says on the tin.

	// # performRecursiveRender(interp)
	// Exactly what it says on the tin.
	void performRecursiveRender(float&in interp) {
		render(interp);
		for(int i=0; i<children.length(); i++) { if(shouldRenderChild(@children[i])) { children[i].performRecursiveRender(interp); } }
	}
	protected bool shouldRenderChild(GUI@&in child) { return (child.visible && !child.hidden); }

	void render(float&in interp) {} // override

	// #### Constructor ----

	// # .internalConstruct( classname )
	protected void internalConstruct(string&in vcls) {
		cls=vcls;
		square=GUI::Square(Vector2f(),GUI::resolution);
		frame=square;
		margin={0,0,0,0};
		visible=true;
		hidden=false;
		_opacity=1.f;
	}

	// # ~Construct(classname)
	// Constructs a non-parented menu frame/panel.
	GUI(string&in vcls="GUI::class_name_missing") {
		GUI::baseInstances.insertLast(@this);
		internalConstruct(vcls);
		invalidateLayout(); // This assumes all recursive child elements are created at the same time the parentless element is.
	}

	// # ~Construct(gui@ parent, classname)
	// Constructs a parented gui frame/panel. Assumes the originating GUI element is was invalid() earlier this frame.
	GUI(GUI@&in par, string&in vcls="GUI::class_name_missing") {
		internalConstruct(vcls);
		_opacity=par.opacity;
		@parent=@par;
	}

} // close GUI class