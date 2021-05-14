

class menu_Console : GUI {
	GUI@ canvas;

	menu_Console() { super("ConsoleMenu");

	align=Alignment::Center;
	size=Vector2f(70,70);
	visible=false;

	GUILabel@ header=GUILabel(@this);
	header.text="CONSOLE MENU";
	header.align=Alignment::Top;
	header.height=GUI::resolution.y*0.07;
	header.fontScale=3;
	header.margin={4,GUI::resolution.y*0.035,4,1};

	@canvas=GUI(@this);
	canvas.align=Alignment::Fill;
	canvas.margin={GUI::resolution.x*0.07,GUI::resolution.y*0.01,2,0};

}

	void doLayout() {
		square=Rectanglef((paintPos)-GUI::center,(paintPos+paintSize)-GUI::center);
	}
	Rectanglef square;
	void paint() {
		UI::setTextured(GUI::Skin::menuwhite, false);
		UI::setColor(Color(1.f,1.f,1.f,1.f));
		UI::addRect(square);
		UI::setTextureless();
	}


	void open() {
		visible=true;
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

		ConsoleMenu.invalidateLayout();
	}
}

class menu_Console_OptionsButton : GUIButtonLabel {
	menu_Console_OptionsButton(GUI@&in parent) { super(@parent,"menu_Console_OptionsButton"); }
	void doClick() {

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

