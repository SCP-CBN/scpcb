

class menu_Pause : GUI {
	GUI@ canvas;

	GUI@ canvasMain;
	GUI@ canvasDeveloper;
	GUI@ canvasCheats;
	GUI@ canvasOptions;

	GUIScrollPanel@ scrollTest;

	menu_Pause() { super("PauseMenu");

	align=Alignment::Center;
	size=Vector2f(70,70);
	visible=false;

	GUILabel@ header=GUILabel(@this);
	header.text="PAUSED";
	header.align=Alignment::Top;
	header.height=GUI::Resolution.y*0.07;
	header.fontScale=3;
	header.margin={4,GUI::Resolution.y*0.035,4,1};

	@canvas=GUI(@this);
	canvas.align=Alignment::Fill;
	canvas.margin={GUI::Resolution.x*0.07,GUI::Resolution.y*0.01,2,0};


	// Main section ----

	@canvasMain=GUI(@canvas);
	canvasMain.align=Alignment::Fill;

	menu_Pause_TextPanel@ textPanel = menu_Pause_TextPanel(@canvasMain);
	textPanel.align=Alignment::Top;
	textPanel.height=8;
	textPanel.margin={1,0,1,0.5};

	@PauseMenu_ButtonPanel=menu_Pause_ButtonPanel(@canvasMain);
	PauseMenu_ButtonPanel.align=Alignment::Fill;
	PauseMenu_ButtonPanel.margin={1,0.5,1,1};
	//PauseMenu_ButtonPanel.width=GUI::Resolution.x*0.375;

	@PauseMenu_ContinueBtn=menu_Pause_ContinueButton(@PauseMenu_ButtonPanel);
	PauseMenu_ContinueBtn.align=Alignment::Top;
	PauseMenu_ContinueBtn.margin={1,1,1,0};
	PauseMenu_ContinueBtn.height=8;
	PauseMenu_ContinueBtn.text="Continue";

	@PauseMenu_LoadBtn=menu_Pause_LoadButton(@PauseMenu_ButtonPanel);
	PauseMenu_LoadBtn.align=Alignment::Top;
	PauseMenu_LoadBtn.margin={1,1,1,0};
	PauseMenu_LoadBtn.height=8;
	PauseMenu_LoadBtn.text="Load";

	@PauseMenu_DebugBtn=menu_Pause_DebugButton(@PauseMenu_ButtonPanel);
	PauseMenu_DebugBtn.align=Alignment::Top;
	PauseMenu_DebugBtn.margin={1,1,1,0};
	PauseMenu_DebugBtn.height=8;
	PauseMenu_DebugBtn.text="Debug Menu";

	@PauseMenu_OptionsBtn=menu_Pause_OptionsButton(@PauseMenu_ButtonPanel);
	PauseMenu_OptionsBtn.align=Alignment::Top;
	PauseMenu_OptionsBtn.margin={1,1,1,0};
	PauseMenu_OptionsBtn.height=8;
	PauseMenu_OptionsBtn.text="Options";

	@PauseMenu_QuitBtn=menu_Pause_QuitButton(@PauseMenu_ButtonPanel);
	PauseMenu_QuitBtn.align=Alignment::Top;
	PauseMenu_QuitBtn.margin={1,1,1,0};
	PauseMenu_QuitBtn.height=8;
	PauseMenu_QuitBtn.text="Quit to Main";


	// Developer Section ----

	@canvasDeveloper=GUI(@canvas);
	canvasDeveloper.align=Alignment::Fill;
	canvasDeveloper.visible=false;

	menu_Pause_BackButton@ devBackBtn = menu_Pause_BackButton(@canvasDeveloper);
	devBackBtn.align=Alignment::Bottom;
	devBackBtn.margin={1,1,1,1};
	devBackBtn.height=8;
	devBackBtn.text="Back";

	GUIButtonLabel@ btnIconEditor=GUIButtonLabel(@canvasDeveloper);
	btnIconEditor.align=Alignment::Top;
	btnIconEditor.margin={1,1,1,0};
	btnIconEditor.height=8;
	btnIconEditor.text="Icon Editor";

	menu_Pause_Dev_CheatsButton@ devCheatsBtn = menu_Pause_Dev_CheatsButton(@canvasDeveloper);
	devCheatsBtn.align=Alignment::Top;
	devCheatsBtn.margin={1,1,1,0};
	devCheatsBtn.height=8;
	devCheatsBtn.text="Cheats Menu";

	menu_Pause_Dev_tpToZeroButton@ devtpToZeroBtn = menu_Pause_Dev_tpToZeroButton(@canvasDeveloper);
	devtpToZeroBtn.align=Alignment::Top;
	devtpToZeroBtn.margin={1,1,1,0};
	devtpToZeroBtn.height=8;
	devtpToZeroBtn.text="Teleport to (0,0,0)";


	// Cheats Section ----

	@canvasCheats=GUI(@canvas);
	canvasCheats.align=Alignment::Fill;
	canvasCheats.visible=false;

	menu_Pause_BackButton@ cheatBackBtn = menu_Pause_BackButton(@canvasCheats);
	cheatBackBtn.align=Alignment::Bottom;
	cheatBackBtn.margin={1,1,1,1};
	cheatBackBtn.height=8;
	cheatBackBtn.text="Back";

	GUIButtonLabel@ cheatFirstBtn=GUIButtonLabel(@canvasCheats);
	cheatFirstBtn.align=Alignment::Top;
	cheatFirstBtn.margin={1,1,1,0};
	cheatFirstBtn.height=8;
	cheatFirstBtn.text="Placeholder Cheats";

	menu_Pause_Dev_tpToZeroButton@ cheatSecondBtn = menu_Pause_Dev_tpToZeroButton(@canvasCheats);
	cheatSecondBtn.align=Alignment::Top;
	cheatSecondBtn.margin={1,1,1,0};
	cheatSecondBtn.height=8;
	cheatSecondBtn.text="Placeholder";


	GUIButton@ testentryPanel=GUIButton(@canvasCheats);
	testentryPanel.align=Alignment::Top;
	testentryPanel.margin={1,1,1,0};
	testentryPanel.height=8;

	GUITextEntry@ testEntry=GUITextEntry(@testentryPanel);
	testEntry.align=Alignment::Fill;
	testEntry.margin={1,1,1,0};
	testEntry.height=4;


	// Options Section ----

	@canvasOptions=GUI(@canvas);
	canvasOptions.align=Alignment::Fill;
	canvasOptions.visible=false;

	menu_Pause_BackButton@ optionsBackBtn = menu_Pause_BackButton(@canvasOptions);
	optionsBackBtn.align=Alignment::Bottom;
	optionsBackBtn.margin={1,1,1,1};
	optionsBackBtn.height=8;
	optionsBackBtn.text="Back";

	GUIButtonLabel@ optionsFirstBtn=GUIButtonLabel(@canvasOptions);
	optionsFirstBtn.align=Alignment::Top;
	optionsFirstBtn.margin={1,1,1,0};
	optionsFirstBtn.height=8;
	optionsFirstBtn.text="Placeholder Options";

	menu_Pause_Dev_tpToZeroButton@ optionsSecondBtn = menu_Pause_Dev_tpToZeroButton(@canvasOptions);
	optionsSecondBtn.align=Alignment::Top;
	optionsSecondBtn.margin={1,1,1,0};
	optionsSecondBtn.height=8;
	optionsSecondBtn.text="Placeholder";

	@scrollTest=GUIScrollPanel(@canvasOptions);
	scrollTest.align=Alignment::Fill;

	for(int i=0; i<30; i++) {
		GUIButtonLabel@ btn = GUIButtonLabel(@scrollTest);
		btn.text="Test: " + (i+64);
		btn.align=Alignment::Top;
		btn.height=8;
	}

}

	void doneLayout() {
		Debug::log("Layed out Pause Menu");
		square=Rectanglef((paintPos)-GUI::Center,(paintPos+paintSize)-GUI::Center);
	}
	Rectanglef square;
	void Paint() {
		UI::setTextured(GUI::Skin::menuPause, false);
		UI::setColor(Color(1.f,1.f,1.f,1.f));
		UI::addRect(square);
		UI::setTextureless();
	}


	void open() {
		visible=true;
		canvasMain.visible=true;
		canvasDeveloper.visible=false;
		canvasCheats.visible=false;
		canvasOptions.visible=false;
	}

	void unpause() {
		visible=false;
		World::paused=false;
	}
}

class menu_Pause_ButtonPanel : GUI {
	menu_Pause_ButtonPanel(GUI@&in parent) { super(@parent,"menu_Pause_ButtonPanel"); }
}

class menu_Pause_TextPanel : GUI {
	menu_Pause_TextPanel(GUI@&in parent) { super(@parent,"menu_Pause_ButtonPanel");
		GUILabel@ difficulty=GUILabel(@this);
		difficulty.align=Alignment::Top;
		difficulty.height=2.5;
		difficulty.margin={0,0.02,0,0.02};
		difficulty.text="Difficulty: Keter";
		difficulty.fontScale=1;
		difficulty.alignHorizontal=Alignment::Left;

		GUILabel@ savefile=GUILabel(@this);
		savefile.align=Alignment::Top;
		savefile.height=2.5;
		savefile.margin={0,0.02,0,0.02};
		savefile.text="savefile: 100% Keter NMG speedrun";
		savefile.fontScale=1;
		savefile.alignHorizontal=Alignment::Left;

		GUILabel@ seednum=GUILabel(@this);
		seednum.align=Alignment::Top;
		seednum.height=2.5;
		seednum.margin={0,0.02,0,0.02};
		seednum.text="Seed: 133769";
		seednum.fontScale=1;
		seednum.alignHorizontal=Alignment::Left;
	}
}

class menu_Pause_BackButton : GUIButtonLabel {
	menu_Pause_BackButton(GUI@&in parent) { super(@parent,"menu_Pause_Dev_BackBtn"); }
	void doClick() {
		PauseMenu.open();
		PauseMenu.invalidateLayout();
	}
}

class menu_Pause_Dev_tpToZeroButton : GUIButtonLabel {
	menu_Pause_Dev_tpToZeroButton(GUI@&in parent) { super(@parent,"menu_Pause_tpToZeroBtn"); }
	void doClick() {
		Player::Controller.position=Vector3f(0,Player::Height+5,0);
		PauseMenu.unpause();
	}
}

class menu_Pause_Dev_CheatsButton : GUIButtonLabel {
	menu_Pause_Dev_CheatsButton(GUI@&in parent) { super(@parent,"menu_Pause_CheatsBtn"); }
	void doClick() {
		PauseMenu.canvasCheats.visible=true;
		PauseMenu.canvasDeveloper.visible=false;
		PauseMenu.invalidateLayout();
	}
}


class menu_Pause_ContinueButton : GUIButtonLabel {
	menu_Pause_ContinueButton(GUI@&in parent) { super(@parent,"menu_Pause_ContinueButton"); }
	void doClick() {
		PauseMenu.unpause();
	}
}
class menu_Pause_NewGameButton : GUIButtonLabel {
	menu_Pause_NewGameButton(GUI@&in parent) { super(@parent,"menu_Pause_NewGameButton"); }
	void doClick() {
	}
}
class menu_Pause_LoadButton : GUIButtonLabel {
	menu_Pause_LoadButton(GUI@&in parent) { super(@parent,"menu_Pause_LoadButton"); }
	void doClick() {
	}
}
class menu_Pause_DebugButton : GUIButtonLabel {
	menu_Pause_DebugButton(GUI@&in parent) { super(@parent,"menu_Pause_DebugButton"); }
	void doClick() {
		PauseMenu.canvasDeveloper.visible=true;
		PauseMenu.canvasMain.visible=false;
		PauseMenu.invalidateLayout();
	}
}

class menu_Pause_OptionsButton : GUIButtonLabel {
	menu_Pause_OptionsButton(GUI@&in parent) { super(@parent,"menu_Pause_OptionsButton"); }
	void doClick() {
		PauseMenu.canvasOptions.visible=true;
		PauseMenu.canvasMain.visible=false;
		PauseMenu.invalidateLayout();
	}
}

class menu_Pause_QuitButton : GUIButtonLabel {
	menu_Pause_QuitButton(GUI@&in parent) { super(@parent,"menu_Pause_QuitButton"); }
	void doClick() {
		PauseMenu.visible=false;
		MainMenu.visible=true;
	}
}


menu_Pause@ PauseMenu;
menu_Pause_ButtonPanel@ PauseMenu_ButtonPanel;
menu_Pause_ContinueButton@ PauseMenu_ContinueBtn;
menu_Pause_NewGameButton@ PauseMenu_NewGameBtn;
menu_Pause_LoadButton@ PauseMenu_LoadBtn;
menu_Pause_DebugButton@ PauseMenu_DebugBtn;
menu_Pause_OptionsButton@ PauseMenu_OptionsBtn;
menu_Pause_QuitButton@ PauseMenu_QuitBtn;

