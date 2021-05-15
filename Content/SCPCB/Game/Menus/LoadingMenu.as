
menu_Loading@ LoadingMenu;
namespace Loadscreen {

	Texture@ defaultLoadingTexture = Texture::get(rootDirLoadscreens+"loadingback");

	array<GUILoadscreen@> screens;
	GUI@ canvas;
	GUILoadscreen@ activeScreen;
	float progress;
	
	void initialize() {
		@LoadingMenu=menu_Loading();
		@canvas=@LoadingMenu.screenCanvas;
		GUILoadscreen@ scp173 = GUILoadscreen("SCP-173",Vector2f(372,500),Texture::get(rootDirLoadscreens+"173"),false,GUI::Align::Left,GUI::Align::Bottom,
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
	void activate(string key) {
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
	GUI::Align alignHorizontal;
	GUI::Align alignVertical;

	array<string> stages(4);
	bool bgtex;

	GUIPanel@ background;
	GUIPanel@ graphic;
	GUILabel@ text;
	GUILabel@ heading;

	GUILoadscreen(string ttl, Vector2f size, Texture@ texture, bool bgtexture, GUI::Align alignX, GUI::Align alignY, string txt1="", string txt2="", string txt3="", string txt4="") {
		super(@Loadscreen::canvas,"GUILoadscreen");
		Loadscreen::screens.insertLast(@this);
		align=GUI::Align::Fill;

		@background=GUIPanel(@this);
		background.align=GUI::Align::Fill;

		@graphic=GUIPanel(@this);
		graphic.align=GUI::Align::None;
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
			case GUI::Align::Left:
				break;
			case GUI::Align::Right:
				vpos.x=GUI::resolution.x-graphic.size.x/2;
				break;
			default:
				vpos=GUI::center-graphic.size/2;
				break;
		}
		switch(alignVertical) {
			case GUI::Align::Top:
				break;
			case GUI::Align::Bottom:
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
		align=GUI::Align::Fill;
		visible=false;

		@screenCanvas=GUI(@this);
		screenCanvas.align=GUI::Align::Fill;

		@canvas=GUI(@this);
		canvas.align=GUI::Align::Center;
		canvas.pos=GUI::center-GUI::resolution/4;
		canvas.size=Vector2f(GUI::resolution.x/2,GUI::resolution.y/1.75);

		@loadpct=GUILabel(@canvas);
		loadpct.align=GUI::Align::Top;
		loadpct.alignHorizontal=GUI::Align::Center;
		loadpct.alignVertical=GUI::Align::Center;
		loadpct.text="LOADING - 69 %";
		loadpct.fontScale=1;
		loadpct.height=5;
		loadpct.margin={8,8,8,1};

		@loadbar=GUILabel(@canvas);
		loadbar.align=GUI::Align::Top;
		loadbar.alignHorizontal=GUI::Align::Center;
		loadbar.alignVertical=GUI::Align::Center;
		loadbar.text="insert progress bar here";
		loadbar.fontScale=1;
		loadbar.height=5;
		loadbar.margin={8,1,8,12};

		@loadTitle=GUILabel(@canvas);
		loadTitle.align=GUI::Align::Top;
		loadTitle.alignHorizontal=GUI::Align::Center;
		loadTitle.alignVertical=GUI::Align::Center;
		loadTitle.text="LoadTitle";
		loadTitle.fontScale=4;
		loadTitle.height=2.5;
		loadTitle.margin={8,12,8,1};

		@loadText=GUILabelBox(@canvas);
		loadText.align=GUI::Align::Fill;
		loadText.alignHorizontal=GUI::Align::Center;
		loadText.alignVertical=GUI::Align::Top;
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
