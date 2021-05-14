
menu_Loading@ LoadingMenu;
namespace Loadscreen {

	string LoadscreenPath = "SCPCB/Loadingscreens/";
	Texture@ defaultLoadingTexture = Texture::get(LoadscreenPath+"loadingback");

	array<GUILoadscreen@> screens;
	GUI@ canvas;
	GUILoadscreen@ activeScreen;
	float progress;
	
	void Initialize() {
		@LoadingMenu=menu_Loading();
		@canvas=@LoadingMenu.screenCanvas;
		GUILoadscreen@ scp173 = GUILoadscreen("SCP-173",Vector2f(372,500),Texture::get(LoadscreenPath+"173"),false,Alignment::Left,Alignment::Bottom,
			"SCP-173 is constructed from concrete and rebar with traces of Krylon brand spray paint. It is animate and extremely hostile.",
			"The object cannot move while within a direct line of sight. Line of sight must not be broken at any time with SCP-173. Personnel assigned to enter container are instructed to alert one another before blinking.",
			"",
			""
		);
		screens.insertLast(@scp173);
		
	}

	GUILoadscreen@ Fetch(string key) {
		for(int i=0; i<screens.length(); i++) {
			if(screens[i].title==key) { return @screens[i]; }
		}
		return null;
	}
	void Activate(string key) {
		for(int i=0; i<screens.length(); i++) { screens[i].visible=false; }
		GUILoadscreen@ scn = Fetch(key);
		scn.visible=true;
		scn.updateGraphicPosition();
		@activeScreen=@scn;

		LoadingMenu.visible=true;
		LoadingMenu.loadTitle.text=scn.title;
		LoadingMenu.loadText.text=scn.stages[0];
		LoadingMenu.invalidateLayout();
	}
	void setProgress(float n) {
		progress=n;
	}
}
class GUILoadscreen : GUI {
	string title;
	Alignment alignHorizontal;
	Alignment alignVertical;

	array<string> stages(4);
	bool bgtex;

	GUIPanel@ background;
	GUIPanel@ graphic;
	GUILabel@ text;
	GUILabel@ heading;

	GUILoadscreen(string ttl, Vector2f size, Texture@ texture, bool bgtexture, Alignment alignX, Alignment alignY, string txt1="", string txt2="", string txt3="", string txt4="") {
		super(@Loadscreen::canvas,"GUILoadscreen");
		Loadscreen::screens.insertLast(@this);
		align=Alignment::Fill;

		@background=GUIPanel(@this);
		background.align=Alignment::Fill;

		@graphic=GUIPanel(@this);
		graphic.align=Alignment::None;
		graphic.pos=Vector2f();
		graphic.size=size*GUI::aspectScale;
		if(bgtexture) {
			graphic.visible=false;
			@background.texture=@texture;
		} else {
			@graphic.texture=@texture;
			@background.texture=@Loadscreen::defaultLoadingTexture;
		}
		title=ttl;
		bgtex=bgtexture;
		alignHorizontal=alignX;
		alignVertical=alignY;
		stages[0]=txt1;
		stages[1]=txt2;
		stages[2]=txt3;
		stages[3]=txt4;
	}
	void updateGraphicPosition() {
		if(bgtex) { graphic.pos=Vector2f(0,0); graphic.size=GUI::resolution; return; }
		Vector2f vpos=Vector2f(0,0);
		switch(alignHorizontal) {
			case Alignment::Left:
				break;
			case Alignment::Right:
				vpos.x=GUI::resolution.x-graphic.size.x/2;
				break;
			default:
				vpos=GUI::center-graphic.size/2;
				break;
		}
		switch(alignVertical) {
			case Alignment::Top:
				break;
			case Alignment::Bottom:
				vpos.y=GUI::resolution.y-graphic.size.y; break;
			default:
				vpos.y=GUI::center.y-graphic.size.y/2; break;
		}
		graphic.pos=vpos;
	}
}


// LoadingMenu.activate("SCP-173");

class menu_Loading : GUI {

	GUI@ screenCanvas; // draw GUILoadscreen under everything.
	GUI@ canvas; // Textbox

	GUILabel@ loadbar;
	GUILabel@ loadpct;
	GUILabel@ loadTitle;
	GUILabelBox@ loadText;

	menu_Loading() { super("LoadingMenu");
		align=Alignment::Fill;
		visible=false;

		@screenCanvas=GUI(@this);
		screenCanvas.align=Alignment::Fill;

		@canvas=GUI(@this);
		canvas.align=Alignment::Center;
		canvas.pos=GUI::center-GUI::resolution/4;
		canvas.size=Vector2f(GUI::resolution.x/2,GUI::resolution.y/1.75);

		@loadpct=GUILabel(@canvas);
		loadpct.align=Alignment::Top;
		loadpct.alignHorizontal=Alignment::Center;
		loadpct.alignVertical=Alignment::Center;
		loadpct.text="LOADING - 69 %";
		loadpct.fontScale=1;
		loadpct.height=5;
		loadpct.margin={8,8,8,1};

		@loadbar=GUILabel(@canvas);
		loadbar.align=Alignment::Top;
		loadbar.alignHorizontal=Alignment::Center;
		loadbar.alignVertical=Alignment::Center;
		loadbar.text="insert progress bar here";
		loadbar.fontScale=1;
		loadbar.height=5;
		loadbar.margin={8,1,8,12};

		@loadTitle=GUILabel(@canvas);
		loadTitle.align=Alignment::Top;
		loadTitle.alignHorizontal=Alignment::Center;
		loadTitle.alignVertical=Alignment::Center;
		loadTitle.text="LoadTitle";
		loadTitle.fontScale=4;
		loadTitle.height=2.5;
		loadTitle.margin={8,12,8,1};

		@loadText=GUILabelBox(@canvas);
		loadText.align=Alignment::Fill;
		loadText.alignHorizontal=Alignment::Center;
		loadText.alignVertical=Alignment::Top;
		loadText.text="LoadText";
		loadText.fontScale=1;
		loadText.height=4;
		loadText.margin={8,1,8,0};
	}

	void doLayout() {
		square=Rectanglef((paintPos)-GUI::center,(paintPos+paintSize)-GUI::center);
	}
	Rectanglef square;



	void prePaint() {
		// float rng=rnjesus.nextFloat(); // rnjesus.pray();
	}
	void paint() {
		UI::setTextureless();
		UI::setColor(Color(0.f,0.f,0.f,1.f));
		UI::addRect(square);
		UI::setTextureless();
	}
}
