

class menu_Console : GUI {
	GUI@ canvas;

	GUI@ canvasMain;
	GUI@ canvasDeveloper;
	GUI@ canvasCheats;
	GUI@ canvasOptions;

	GUIScrollPanel@ scrollTest;

	menu_Console() { super("ConsoleMenu");

	align=Alignment::Center;
	size=Vector2f(70,70);
	visible=false;

	GUILabel@ header=GUILabel(@this);
	header.text="CONSOLE MENU";
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

	menu_Console_TextPanel@ textPanel = menu_Console_TextPanel(@canvasMain);
	textPanel.align=Alignment::Top;
	textPanel.height=8;
	textPanel.margin={1,0,1,0.5};

	@ConsoleMenu_ButtonPanel=menu_Console_ButtonPanel(@canvasMain);
	ConsoleMenu_ButtonPanel.align=Alignment::Fill;
	ConsoleMenu_ButtonPanel.margin={1,0.5,1,1};
	//ConsoleMenu_ButtonPanel.width=GUI::Resolution.x*0.375;

	@ConsoleMenu_ContinueBtn=menu_Console_ContinueButton(@ConsoleMenu_ButtonPanel);
	ConsoleMenu_ContinueBtn.align=Alignment::Top;
	ConsoleMenu_ContinueBtn.margin={1,1,1,0};
	ConsoleMenu_ContinueBtn.height=8;
	ConsoleMenu_ContinueBtn.text="Continue";

	@ConsoleMenu_LoadBtn=menu_Console_LoadButton(@ConsoleMenu_ButtonPanel);
	ConsoleMenu_LoadBtn.align=Alignment::Top;
	ConsoleMenu_LoadBtn.margin={1,1,1,0};
	ConsoleMenu_LoadBtn.height=8;
	ConsoleMenu_LoadBtn.text="Load";

	@ConsoleMenu_DebugBtn=menu_Console_DebugButton(@ConsoleMenu_ButtonPanel);
	ConsoleMenu_DebugBtn.align=Alignment::Top;
	ConsoleMenu_DebugBtn.margin={1,1,1,0};
	ConsoleMenu_DebugBtn.height=8;
	ConsoleMenu_DebugBtn.text="Debug Menu";

	@ConsoleMenu_OptionsBtn=menu_Console_OptionsButton(@ConsoleMenu_ButtonPanel);
	ConsoleMenu_OptionsBtn.align=Alignment::Top;
	ConsoleMenu_OptionsBtn.margin={1,1,1,0};
	ConsoleMenu_OptionsBtn.height=8;
	ConsoleMenu_OptionsBtn.text="Options";

	@ConsoleMenu_QuitBtn=menu_Console_QuitButton(@ConsoleMenu_ButtonPanel);
	ConsoleMenu_QuitBtn.align=Alignment::Top;
	ConsoleMenu_QuitBtn.margin={1,1,1,0};
	ConsoleMenu_QuitBtn.height=8;
	ConsoleMenu_QuitBtn.text="Quit to Main";


	// Developer Section ----

	@canvasDeveloper=GUI(@canvas);
	canvasDeveloper.align=Alignment::Fill;
	canvasDeveloper.visible=false;

	menu_Console_BackButton@ devBackBtn = menu_Console_BackButton(@canvasDeveloper);
	devBackBtn.align=Alignment::Bottom;
	devBackBtn.margin={1,1,1,1};
	devBackBtn.height=8;
	devBackBtn.text="Back";

	GUIButtonLabel@ btnIconEditor=GUIButtonLabel(@canvasDeveloper);
	btnIconEditor.align=Alignment::Top;
	btnIconEditor.margin={1,1,1,0};
	btnIconEditor.height=8;
	btnIconEditor.text="Icon Editor";

	menu_Console_Dev_CheatsButton@ devCheatsBtn = menu_Console_Dev_CheatsButton(@canvasDeveloper);
	devCheatsBtn.align=Alignment::Top;
	devCheatsBtn.margin={1,1,1,0};
	devCheatsBtn.height=8;
	devCheatsBtn.text="Cheats Menu";

	menu_Console_Dev_tpToZeroButton@ devtpToZeroBtn = menu_Console_Dev_tpToZeroButton(@canvasDeveloper);
	devtpToZeroBtn.align=Alignment::Top;
	devtpToZeroBtn.margin={1,1,1,0};
	devtpToZeroBtn.height=8;
	devtpToZeroBtn.text="Teleport to (0,0,0)";


	// Cheats Section ----

	@canvasCheats=GUI(@canvas);
	canvasCheats.align=Alignment::Fill;
	canvasCheats.visible=false;

	menu_Console_BackButton@ cheatBackBtn = menu_Console_BackButton(@canvasCheats);
	cheatBackBtn.align=Alignment::Bottom;
	cheatBackBtn.margin={1,1,1,1};
	cheatBackBtn.height=8;
	cheatBackBtn.text="Back";

	GUIButtonLabel@ cheatFirstBtn=GUIButtonLabel(@canvasCheats);
	cheatFirstBtn.align=Alignment::Top;
	cheatFirstBtn.margin={1,1,1,0};
	cheatFirstBtn.height=8;
	cheatFirstBtn.text="Placeholder Cheats";

	menu_Console_Dev_tpToZeroButton@ cheatSecondBtn = menu_Console_Dev_tpToZeroButton(@canvasCheats);
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

	menu_Console_BackButton@ optionsBackBtn = menu_Console_BackButton(@canvasOptions);
	optionsBackBtn.align=Alignment::Bottom;
	optionsBackBtn.margin={1,1,1,1};
	optionsBackBtn.height=8;
	optionsBackBtn.text="Back";

	GUIButtonLabel@ optionsFirstBtn=GUIButtonLabel(@canvasOptions);
	optionsFirstBtn.align=Alignment::Top;
	optionsFirstBtn.margin={1,1,1,0};
	optionsFirstBtn.height=8;
	optionsFirstBtn.text="Placeholder Options";

	menu_Console_Dev_tpToZeroButton@ optionsSecondBtn = menu_Console_Dev_tpToZeroButton(@canvasOptions);
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

class menu_Console_ButtonPanel : GUI {
	menu_Console_ButtonPanel(GUI@&in parent) { super(@parent,"menu_Console_ButtonPanel"); }
}

class menu_Console_TextPanel : GUI {
	menu_Console_TextPanel(GUI@&in parent) { super(@parent,"menu_Console_ButtonPanel");
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

class menu_Console_BackButton : GUIButtonLabel {
	menu_Console_BackButton(GUI@&in parent) { super(@parent,"menu_Console_Dev_BackBtn"); }
	void doClick() {
		ConsoleMenu.open();
		ConsoleMenu.invalidateLayout();
	}
}

class menu_Console_Dev_tpToZeroButton : GUIButtonLabel {
	menu_Console_Dev_tpToZeroButton(GUI@&in parent) { super(@parent,"menu_Console_tpToZeroBtn"); }
	void doClick() {
		Player::Controller.position=Vector3f(0,Player::Height+5,0);
		ConsoleMenu.unpause();
	}
}

class menu_Console_Dev_CheatsButton : GUIButtonLabel {
	menu_Console_Dev_CheatsButton(GUI@&in parent) { super(@parent,"menu_Console_CheatsBtn"); }
	void doClick() {
		ConsoleMenu.canvasCheats.visible=true;
		ConsoleMenu.canvasDeveloper.visible=false;
		ConsoleMenu.invalidateLayout();
	}
}


class menu_Console_ContinueButton : GUIButtonLabel {
	menu_Console_ContinueButton(GUI@&in parent) { super(@parent,"menu_Console_ContinueButton"); }
	void doClick() {
		ConsoleMenu.unpause();
	}
}
class menu_Console_NewGameButton : GUIButtonLabel {
	menu_Console_NewGameButton(GUI@&in parent) { super(@parent,"menu_Console_NewGameButton"); }
	void doClick() {
	}
}
class menu_Console_LoadButton : GUIButtonLabel {
	menu_Console_LoadButton(GUI@&in parent) { super(@parent,"menu_Console_LoadButton"); }
	void doClick() {
	}
}
class menu_Console_DebugButton : GUIButtonLabel {
	menu_Console_DebugButton(GUI@&in parent) { super(@parent,"menu_Console_DebugButton"); }
	void doClick() {
		ConsoleMenu.canvasDeveloper.visible=true;
		ConsoleMenu.canvasMain.visible=false;
		ConsoleMenu.invalidateLayout();
	}
}

class menu_Console_OptionsButton : GUIButtonLabel {
	menu_Console_OptionsButton(GUI@&in parent) { super(@parent,"menu_Console_OptionsButton"); }
	void doClick() {
		ConsoleMenu.canvasOptions.visible=true;
		ConsoleMenu.canvasMain.visible=false;
		ConsoleMenu.invalidateLayout();
	}
}

class menu_Console_QuitButton : GUIButtonLabel {
	menu_Console_QuitButton(GUI@&in parent) { super(@parent,"menu_Console_QuitButton"); }
	void doClick() {
		ConsoleMenu.visible=false;
		MainMenu.visible=true;
	}
}


menu_Console@ ConsoleMenu;
menu_Console_ButtonPanel@ ConsoleMenu_ButtonPanel;
menu_Console_ContinueButton@ ConsoleMenu_ContinueBtn;
menu_Console_NewGameButton@ ConsoleMenu_NewGameBtn;
menu_Console_LoadButton@ ConsoleMenu_LoadBtn;
menu_Console_DebugButton@ ConsoleMenu_DebugBtn;
menu_Console_OptionsButton@ ConsoleMenu_OptionsBtn;
menu_Console_QuitButton@ ConsoleMenu_QuitBtn;

