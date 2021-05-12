namespace MainMenu {
	void Initialize() {
		MainMenu=menu_Main();
	}
}




menu_Main@ MainMenu;
menu_Main_ButtonPanel@ MainMenu_ButtonPanel;

menu_Main_ContinueButton@ MainMenu_ContinueBtn;
menu_Main_NewGameButton@ MainMenu_NewGameBtn;
menu_Main_LoadButton@ MainMenu_LoadBtn;
menu_Main_OptionsButton@ MainMenu_OptionsBtn;
menu_Main_QuitButton@ MainMenu_QuitBtn;

class menu_Main : GUI {

	GUIPanel@ SCP173;
	Random@ rnjesus;

	menu_Main() { super("MainMenu");

	align=Alignment::Fill;
	visible=true;

	@MainMenu_ButtonPanel=menu_Main_ButtonPanel(@this);
	MainMenu_ButtonPanel.align=Alignment::Left;
	MainMenu_ButtonPanel.margin={GUI::Resolution.x*0.14,GUI::Resolution.y*0.3,0,GUI::Resolution.y*0.1};
	MainMenu_ButtonPanel.width=GUI::Resolution.x*0.35;

	@MainMenu_ContinueBtn=menu_Main_ContinueButton(@MainMenu_ButtonPanel);
	MainMenu_ContinueBtn.align=Alignment::Top;
	MainMenu_ContinueBtn.margin={1,1,1,0};
	MainMenu_ContinueBtn.height=8;
	MainMenu_ContinueBtn.text="Continue";

	@MainMenu_NewGameBtn=menu_Main_NewGameButton(@MainMenu_ButtonPanel);
	MainMenu_NewGameBtn.align=Alignment::Top;
	MainMenu_NewGameBtn.margin={1,1,1,0};
	MainMenu_NewGameBtn.height=8;
	MainMenu_NewGameBtn.text="New Game";

	@MainMenu_LoadBtn=menu_Main_LoadButton(@MainMenu_ButtonPanel);
	MainMenu_LoadBtn.align=Alignment::Top;
	MainMenu_LoadBtn.margin={1,1,1,0};
	MainMenu_LoadBtn.height=8;
	MainMenu_LoadBtn.text="Load";
	MainMenu_LoadBtn.locked=true;

	@MainMenu_OptionsBtn=menu_Main_OptionsButton(@MainMenu_ButtonPanel);
	MainMenu_OptionsBtn.align=Alignment::Top;
	MainMenu_OptionsBtn.margin={1,1,1,0};
	MainMenu_OptionsBtn.height=8;
	MainMenu_OptionsBtn.text="Options";

	@MainMenu_QuitBtn=menu_Main_QuitButton(@MainMenu_ButtonPanel);
	MainMenu_QuitBtn.align=Alignment::Top;
	MainMenu_QuitBtn.margin={1,1,1,0};
	MainMenu_QuitBtn.height=8;
	MainMenu_QuitBtn.text="Quit";

	float SCPwidth=GUI::Resolution.x*0.3;
	float SCPheight=SCPwidth*(60.f/550.f);
	GUIPanel@ SCPLabel=GUIPanel(@this);
	SCPLabel.align=Alignment::None;
	SCPLabel.pos=Vector2f(GUI::Center.x-SCPwidth/2,GUI::Resolution.y-SCPheight-4);
	SCPLabel.size=Vector2f(SCPwidth,SCPheight);
	@SCPLabel.texture=GUI::Skin::menuSCPLabel;

	float height173=GUI::Resolution.y*0.55;
	GUI@ SCP173panel=GUI(@this);
	SCP173panel.align=Alignment::Right;
	SCP173panel.width=height173*( 312.f/441.f );

	@SCP173=GUIPanel(@SCP173panel);
	SCP173.align=Alignment::Bottom;
	SCP173.height=height173;
	@SCP173.texture=GUI::Skin::menuSCP173;

	GUILabel@ version=GUILabel(@this);
	version.align=Alignment::None;
	version.pos=Vector2f(4,GUI::Resolution.y-4);
	version.alignHorizontal=Alignment::Left;
	version.alignVertical=Alignment::Bottom;
	version.text="v1.4.0 Beta";
	version.fontScale=1;

	@rnjesus=Random();
	rngLerp=FloatInterpolator();
	}
	void doneLayout() {
		Debug::log("Layed out Main Menu");
		square=Rectanglef((paintPos)-GUI::Center,(paintPos+paintSize)-GUI::Center);
	}
	Rectanglef square;

	float opacityanim;
	float opacitysin;
	float opacitycos;

	FloatInterpolator rngLerp;

	void PrePaint() {
		float rng=rnjesus.nextFloat(); // rnjesus.pray();
		rng/=2;
		rng+=0.1;
		rngLerp.update(rng); // smoothing
		SCP173.opacity=rngLerp.lerp(rng);
	}
	void Paint() {
		UI::setTextured(GUI::Skin::menuMain, false);
		UI::setColor(Color(1.f,1.f,1.f,1.f));
		UI::addRect(square);
		UI::setTextureless();
	}
}

class menu_Main_ButtonPanel : GUI {
	menu_Main_ButtonPanel(GUI@&in parent) { super(@parent,"menu_Main_ButtonPanel"); }
}


class menu_Main_ContinueButton : GUIButtonLabel {
	menu_Main_ContinueButton(GUI@&in parent) { super(@parent,"menu_Main_ContinueButton"); }
	void doClick() {
		World::paused = false;
		MainMenu.visible=false;
	}
}
class menu_Main_NewGameButton : GUIButtonLabel {
	menu_Main_NewGameButton(GUI@&in parent) { super(@parent,"menu_Main_NewGameButton"); }
	void doClick() {
		QueueNewGame();
	}
}
class menu_Main_LoadButton : GUIButtonLabel {
	menu_Main_LoadButton(GUI@&in parent) { super(@parent,"menu_Main_LoadButton"); }
	void doClick() {
	}
}

class menu_Main_OptionsButton : GUIButtonLabel {
	menu_Main_OptionsButton(GUI@&in parent) { super(@parent,"menu_Main_OptionsButton"); }
	void doClick() {
	}
}

class menu_Main_QuitButton : GUIButtonLabel {
	menu_Main_QuitButton(GUI@&in parent) { super(@parent,"menu_Main_QuitButton"); }
	void doClick() {
		Loadscreen::Activate("SCP-173");
		MainMenu.visible=false;

	}
}

