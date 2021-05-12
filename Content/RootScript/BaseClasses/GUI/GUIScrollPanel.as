

// GUIPanel --------
// A simple panel that draws a box.
//
// Use "GUI(@parent)" for a panel that doesn't draw anything.

shared class GUIScrollBarTopArrow : GUIScrollBarArrow {
	GUIScrollBarTopArrow(GUI@&in parent) { super(@parent,"scrollbarTopArrow"); align=Alignment::Top; @graphic.texture=@GUI::Skin::ScrollBar::topArrowTexture; top=true; }
}
shared class GUIScrollBarBtmArrow : GUIScrollBarArrow {
	GUIScrollBarBtmArrow(GUI@&in parent) { super(@parent,"scrollbarBtmArrow"); align=Alignment::Bottom; @graphic.texture=@GUI::Skin::ScrollBar::btmArrowTexture; top=false; }
}
shared class GUIScrollBarArrow : GUIButton {
	GUIPanel@ graphic;
	bool top;
	GUIScrollBarArrow(GUI@&in parent,string scls="scrollbarArrow") { super(@parent,scls);
		height=GUI::Skin::ScrollBar::arrowHeight;
		@background.texture=@GUI::Skin::ScrollBar::bgtexture;
		foreground.margin=GUI::Skin::ScrollBar::fgMargin;
		@foreground.texture=@GUI::Skin::ScrollBar::fgtexture;
		foreground.color=GUI::Skin::ScrollBar::fgColor;
		background.color=GUI::Skin::ScrollBar::bgColor;

		@graphic=GUIPanel(@this);
		graphic.align=Alignment::Fill;
		graphic.visible=true;
		graphic.margin=GUI::Skin::ScrollBar::arrowMargin;
		graphic.color=GUI::Skin::ScrollBar::whiteColor;

	}

	void skinColors() {
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
}
shared class GUIScrollBarHandle : GUIButton {
	GUIScrollBarHandle(GUI@&in parent) { super(@parent,"scrollBarHandle");
		align=Alignment::Manual;
		foreground.margin=GUI::Skin::ScrollBar::barfgMargin;
		@background.texture=@GUI::Skin::ScrollBar::bgtexture;
		@foreground.texture=@GUI::Skin::ScrollBar::barfgtexture;
		background.color=GUI::Skin::ScrollBar::barbgColor;
		foreground.color=GUI::Skin::ScrollBar::barfgColor;
	}

	void skinColors() {
		if(pressed) {
			background.color=GUI::Skin::ScrollBar::hoverColor;
			foreground.color=GUI::Skin::ScrollBar::downColor;
			float my=GUI::Mouse().y;
			if(my!=pos.y) { _pos.y=my; _parent._parent.invalidateLayout(); }
		} else if(isHovered()) {
			background.color=GUI::Skin::ScrollBar::hoverColor;
			foreground.color=GUI::Skin::ScrollBar::whiteColor;
		} else {
			background.color=GUI::Skin::ScrollBar::whiteColor;
			foreground.color=GUI::Skin::ScrollBar::whiteColor;
		}
	}

	void performLayout() {}

	Vector2f originClick;
	void startClick(Vector2f mpos) { originClick=mpos; }
}
shared class GUIScrollBar : GUI {
	GUIScrollBarArrow@ topArrow;
	GUIScrollBarArrow@ btmArrow;
	GUIButton@ bar;
	float barLength;
	GUIScrollBar(GUI@&in parent,string ccls="scrollBar") { super(@parent,ccls);
		align=Alignment::Right;
		width=GUI::Skin::ScrollBar::width;
		@topArrow=GUIScrollBarTopArrow(@this);
		@btmArrow=GUIScrollBarBtmArrow(@this);
		@bar=GUIScrollBarHandle(@this);

	}

	void doneChildLayout() {
		//_parent.layout[1]+=80;
	}

	void performChildLayout(GUI@&in child, array<float> &layout) { // handle
		GUIScrollBarHandle@ chandle=cast<GUIScrollBarHandle@>(child);
		GUIScrollPanel@ scroller=cast<GUIScrollPanel@>(_parent);
		if(@chandle==null || @scroller==null) {Debug::log("nohandle!"); return; }
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
		scroller.scroll=pctY;
		chandle.paintPos.y=chandle.paintPos.y+capY-chandle.paintSize.y/2;
	}
}

shared class GUIScrollPanelCanvas : GUI {
	GUIScrollPanelCanvas(GUI@&in parent,string ccls="scrollpanelCanvas") { super(@parent,ccls);
		align=Alignment::Fill;
	}
	void internalDoneLayout() {
		GUIScrollPanel@ scroller=cast<GUIScrollPanel@>(_parent);
		for(int i=0; i<_children.length(); i++) {
			GUI@ child=@_children[i];
			child.paintPos.y=child.paintPos.y-(scroller.scroll*(layout[1]-paintSize.y));
			child.isInParent();
		}
	}
	void invalidateLayout() { _parent.invalidateLayout(); }


}
shared class GUIScrollPanel : GUI {
	GUIScrollBar@ scrollbar;
	GUIScrollPanelCanvas@ canvas;

	GUIScrollPanel(GUI@&in parent, string ccls="scrollpanel") { super(@parent,ccls);
		@scrollbar=GUIScrollBar(@this);
		@canvas=GUIScrollPanelCanvas(@this);
	}
	void onAddChild(GUI@&in child) { if(@canvas != null) { child.setParent(@canvas); } }
	void onRemoveChild(GUI@&in child) {}

	float scroll=0.f;
	bool scrollEnabled;

	Rectanglef square;
	void internalPostLayout() {
		scrollEnabled=canvas.paintSize.y<canvas.layout[1];
		if(scrollEnabled) { layoutScroll(); } else { scrollbar.visible=false; }
		square=Rectanglef((paintPos)-GUI::Center,(paintPos+paintSize)-GUI::Center);
	}
	void layoutScroll() {
		scrollbar.visible=true;
		scrollbar.barLength=canvas.paintSize.y/(canvas.layout[1]-canvas.paintSize.y);
	}

	void Paint() {
		//UI::addRect(square);
	}

}
