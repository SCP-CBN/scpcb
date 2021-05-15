// # *INTERNAL* : GUIScrollBarTopArrow --------
// The upper arrow of the scrollbar.
shared class GUIScrollBarTopArrow : GUIScrollBarArrow {
	GUIScrollBarTopArrow(GUI@&in parent, string vcls="GUI::ScrollBarTopArrow") { super(@parent,vcls);
		align=GUI::Align::Top;
		@graphic.texture=@GUI::Skin::ScrollBar::topArrowTexture;
		isTopArrow=true;
	}
}

// # *INTERNAL* : GUIScrollBarBtmArrow --------
// The lower arrow of the scrollbar.
shared class GUIScrollBarBtmArrow : GUIScrollBarArrow {
	GUIScrollBarBtmArrow(GUI@&in parent, string vcls="GUI::ScrollBarBtmArrow") { super(@parent,vcls);
		align=GUI::Align::Bottom;
		@graphic.texture=@GUI::Skin::ScrollBar::btmArrowTexture;
		isTopArrow=false;
	}
}

// # *INTERNAL* : GUIScrollBarArrow --------
// Baseclass for the scrollbar arrows
shared class GUIScrollBarArrow : GUIButton {

	// # Constructor
	GUIPanel@ graphic;
	GUIScrollBarArrow(GUI@&in parent, string vcls="GUI::ScrollBarArrow") { super(@parent,vcls);
		// Skin
		height=GUI::Skin::ScrollBar::arrowHeight;
		@background.texture=@GUI::Skin::ScrollBar::bgtexture;
		foreground.margin=GUI::Skin::ScrollBar::fgMargin;
		@foreground.texture=@GUI::Skin::ScrollBar::fgtexture;
		foreground.color=GUI::Skin::ScrollBar::fgColor;
		background.color=GUI::Skin::ScrollBar::bgColor;

		// Arrow graphic
		@graphic=GUIPanel(@this);
		graphic.align=GUI::Align::Fill;
		graphic.margin=GUI::Skin::ScrollBar::arrowMargin;
		graphic.color=GUI::Skin::ScrollBar::whiteColor;
	}

	// # Arrow handler
	bool isTopArrow;

	// # Click state
	void updateClickable() {
		if(pressed) {
			background.color=GUI::Skin::ScrollBar::hoverColor;
			foreground.color=GUI::Skin::ScrollBar::downColor;
		} else if(isHovered()) {
			background.color=GUI::Skin::ScrollBar::hoverColor;
			foreground.color=GUI::Skin::ScrollBar::whiteColor;
		} else {
			background.color=GUI::Skin::ScrollBar::whiteColor;
			foreground.color=GUI::Skin::ScrollBar::whiteColor;
		}
	}

	void doClick() {
		if(isTopArrow) {

		} else {

		}
	}
}


// # *INTERNAL* : GUIScrollBarHandle --------
// The physical bar of the scrollbar that is clicked and dragged.
shared class GUIScrollBarHandle : GUIButton {

	// # Constructor
	GUIScrollBarHandle(GUI@&in parent, string vcls="GUI::ScrollBarHandle") { super(@parent,vcls);
		align=GUI::Align::Manual;
		foreground.margin=GUI::Skin::ScrollBar::barfgMargin;
		@background.texture=@GUI::Skin::ScrollBar::bgtexture;
		@foreground.texture=@GUI::Skin::ScrollBar::barfgtexture;
		background.color=GUI::Skin::ScrollBar::barbgColor;
		foreground.color=GUI::Skin::ScrollBar::barfgColor;
	}

	// # Click state
	Vector2f originClick;
	void internalStartClick(Vector2f mpos) { originClick=mpos; }

	void updateClickable() {
		if(pressed) {
			float my=GUI::mouse().y;
			if(my!=pos.y) { pos.y=my; _parent._parent.invalidateLayout(); }
			background.color=GUI::Skin::ScrollBar::hoverColor;
			foreground.color=GUI::Skin::ScrollBar::downColor;

		} else if(isHovered()) {
			background.color=GUI::Skin::ScrollBar::hoverColor;
			foreground.color=GUI::Skin::ScrollBar::whiteColor;
		} else {
			background.color=GUI::Skin::ScrollBar::whiteColor;
			foreground.color=GUI::Skin::ScrollBar::whiteColor;
		}
	}
}

// # *INTERNAL* : GUIScrollBar --------
// The entire panel on the right hand side which contains the scrollbar and the arrows, and generally deals with the scrolling part of the scrollbar.
shared class GUIScrollBar : GUI {

	// # Constructor
	GUIScrollBarArrow@ topArrow;
	GUIScrollBarArrow@ btmArrow;
	GUIScrollBarHandle@ barHandle;
	GUIScrollBar(GUI@&in parent,string vcls="GUI::ScrollBar") { super(@parent,vcls);
		align=GUI::Align::Right;
		width=GUI::Skin::ScrollBar::width;
		@topArrow=GUIScrollBarTopArrow(@this);
		@btmArrow=GUIScrollBarBtmArrow(@this);
		@barHandle=GUIScrollBarHandle(@this);

	}

	// # Scrollbar handle handler.
	float barLength; // This is set by the parent scrollbar

	void manualLayoutChild(GUI@&in child, array<float> &layout) {
		GUIScrollBarHandle@ chandle=cast<GUIScrollBarHandle@>(child);
		GUIScrollPanel@ scroller=cast<GUIScrollPanel@>(_parent);
		if(@chandle==null || @scroller==null) { Debug::error("Tried to lay out a scrollbar without a handle or scrollpanel!"); return; }
		chandle.paintSize.x=paintSize.x-layout[0]-layout[2]-chandle.margin[0]-chandle.margin[2]-padding[0]-padding[2];
		chandle.paintSize.y=paintSize.y-layout[1]-layout[3]-chandle.margin[1]-chandle.margin[3]-padding[1]-padding[3];

		float barLen=1-Math::maxFloat(barLength,0.1);
		chandle.paintSize.y=chandle.paintSize.y-chandle.paintSize.y*barLen;

		float originPosY=(paintPos.y+layout[1]+chandle.margin[1]+padding[1]+chandle.paintSize.y/2);
		float originMaxY=originPosY+(paintSize.y-layout[1]-layout[3]-chandle.margin[1]-chandle.margin[3]-padding[1]-padding[3]-chandle.paintSize.y);
		chandle.paintPos=Vector2f(paintPos.x,originPosY);

		float capY=Math::maxFloat(Math::minFloat(chandle.pos.y,originMaxY),originPosY)-originPosY;
		float Yrange=originMaxY-originPosY;
		float pctY=capY/Yrange;
		if(scroller.reverse) { pctY=1-pctY; }
		chandle.paintPos.y=chandle.paintPos.y+capY-chandle.paintSize.y/2;
		chandle.isInParent();
		scroller.scroll=pctY;
	}
}

// # *INTERNAL* : GUIScrollPanelCanvas --------
// A blank panel which all elements parented to the scrollpanel will actually be parented to, to enable special layout handling for the scrollbar and scrolling.
// And yes, all elements need to be calculated to determine scroll position versus element sizes.
// While most scrollpanels will have elements of the same size, this doesn't let you expand/contract some panels for inspection.
shared class GUIScrollPanelCanvas : GUI {

	// # Constructor
	GUIScrollPanelCanvas(GUI@&in parent, string vcls="GUI::ScrollPanelCanvas") { super(@parent,vcls); align=GUI::Align::Fill; }

	// # Scroll manager
	void invalidateLayout() { _parent.invalidateLayout(); }
	void internalDoLayout() {
		GUIScrollPanel@ scroller=cast<GUIScrollPanel@>(_parent);
		float layoutHeight = layout[1]+layout[3]+0.1;
		float layoutOffset = (scroller.scroll*(layoutHeight-paintSize.y));
		if(scrollReverse) { layoutOffset = -layoutOffset; }
		for(int i=0; i<_children.length(); i++) {
			GUI@ child=@_children[i];
			child.paintPos.y=child.paintPos.y-layoutOffset;
			child.isInParent();
		}
	}

	bool scrollReverse;
	void addChild(GUI@&in child) { hasChild=true; if(!scrollReverse) { _children.insertLast(@child); } else { _children.insertAt(0,@child); } onChildAdded(@child); }
}

// # GUIScrollPanel --------
// The actual scroll panel. It can be treated like a regular panel, all scrolling/whatnot is handled automatically.
shared class GUIScrollPanel : GUI {

	// # Constructor
	GUIScrollBar@ scrollbar;
	GUIScrollPanelCanvas@ canvas;
	GUIScrollPanel(GUI@&in parent, string ccls="GUI::ScrollPanel") { super(@parent,ccls);
		@scrollbar=GUIScrollBar(@this);
		@canvas=GUIScrollPanelCanvas(@this);
	}
	// # Scroll parenting
	bool _reverse;
	bool reverse { get { return canvas.scrollReverse; } set { canvas.scrollReverse=value; } }
	void onChildAdded(GUI@&in child) { if(@canvas != null) { child.setParent(@canvas); removeChild(@child); } }

	// # Scroll scrolling
	// This requires reverse handling to translate a scroll percentage into a position where the mouse would be to achieve that percentage.
	// This is probably not needed for anything though.
	bool scrollEnabled;
	float _scroll;
	float scroll { get { return _scroll; } set { _scroll=value; } } 

	void internalPostLayout() {
		float layoutHeight=canvas.layout[1]+canvas.layout[3]+0.1;
		scrollEnabled=(canvas.paintSize.y<layoutHeight);
		if(!scrollEnabled) { scrollbar.visible=false; } else {
			scrollbar.visible=true;
			scrollbar.barLength=canvas.paintSize.y/layoutHeight;
		}
	}

	void scrollBottom() { scrollbar.barHandle.pos.y=GUI::resolution.y;  }
	void scrollTop() { scrollbar.barHandle.pos.y=0; }
}