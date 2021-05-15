

class menu_Console : GUI {
	GUIScrollPanel@ canvas;

	menu_Console() { super("ConsoleMenu");

		align=GUI::Align::Top;
		height=GUI::resolution.y*0.4;
		visible=false;


		GUIPanel@ textPanel=GUIPanel(@this);
		textPanel.align=GUI::Align::Bottom;
		textPanel.height=7;
		textPanel.margin={1,0,1,0.25};
		@textPanel.texture=@GUI::Skin::menuwhite;

		GUIPanel@ textPanelFG=GUIPanel(@textPanel);
		textPanelFG.align=GUI::Align::Left;
		textPanelFG.width=20;
		textPanelFG.margin={1,0.25,0.0625,0.125};
		@textPanelFG.texture=@GUI::Skin::menublack;

		GUILabel@ textEntryLabel=GUILabel(@textPanelFG);
		textEntryLabel.align=GUI::Align::Fill;
		textEntryLabel.text="Command:";
		textEntryLabel.fontScale=1.25;
		textEntryLabel.fontColor=Color::White;

		GUIPanel@ textEntryFG=GUIPanel(@textPanel);
		textEntryFG.align=GUI::Align::Fill;
		textEntryFG.margin={0.0625,0.25,0.25,0.25};
		@textEntryFG.texture=@GUI::Skin::menublack;
		
		GUITextEntry@ textEntry=GUITextEntry(@textEntryFG);
		textEntry.align=GUI::Align::Fill;
		textEntry.fontColor=Color::White;
		textEntry.margin={1,1,4,1};
		textEntry.setText("help");
		@textEntry.inputFunc=GUI::TextEnteredFunc(onTextEntered);



		GUIPanel@ outputPanelBG=GUIPanel(@this);
		outputPanelBG.align=GUI::Align::Fill;
		outputPanelBG.margin={1.1,1.1,1.1,0};
		@outputPanelBG.texture=@GUI::Skin::menuwhite;

		GUIPanel@ outputPanelFG=GUIPanel(@outputPanelBG);
		outputPanelFG.align=GUI::Align::Fill;
		@outputPanelFG.texture=@GUI::Skin::menublack;
		outputPanelFG.margin={0.125,0.125,0.125,0};

		GUIPanel@ headerPanel=GUIPanel(@outputPanelFG);
		headerPanel.align=GUI::Align::Top;
		headerPanel.height=4;
		headerPanel.margin={GUI::resolution.x*0.35,0.2,GUI::resolution.x*0.35,0.2};
		@headerPanel.texture=@GUI::Skin::menuwhite;

		GUILabel@ header=GUILabel(@headerPanel);
		header.align=GUI::Align::Fill;
		header.alignVertical=GUI::Align::Center;
		header.height=4;
		header.fontScale=1;
		header.fontColor=Color::Black;
		header.text="CONSOLE MENU";

		@canvas=GUIScrollPanel(@outputPanelFG);
		canvas.align=GUI::Align::Fill;
		canvas.margin={GUI::resolution.x*0.01,1,GUI::resolution.x*0.01,1};
		canvas.reverse=true;
		canvas.scrollBottom();

	}

	void doLayout() {
		square=Rectanglef((paintPos)-GUI::center,(paintPos+paintSize)-GUI::center);
	}
	Rectanglef square;
	void paint() {
		UI::setTextured(GUI::Skin::menublack, false);
		UI::setColor(Color(1.f,1.f,1.f,1.f));
		//UI::addRect(square);
	}

	void onTextEntered(string&in input) {
		Debug::log("Got text entry: " + input);
		GUILabelBox@ lbl=GUILabelBox(@canvas);
		lbl.align=GUI::Align::Bottom;
		lbl.alignHorizontal=GUI::Align::Left;
		lbl.fontScale=2;
		lbl.height=4;
		lbl.text=input;
		if(canvas._children.length()>=40) { canvas.removeChildAt(40); }
		canvas.invalidateLayout();
	}


	void open() {
		visible=true;
		World::paused=true;
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
		difficulty.align=GUI::Align::Top;
		difficulty.height=2.5;
		difficulty.margin={0,0.02,0,0.02};
		difficulty.text="Difficulty: Keter";
		difficulty.fontScale=1;
		difficulty.alignHorizontal=GUI::Align::Left;

		GUILabel@ savefile=GUILabel(@this);
		savefile.align=GUI::Align::Top;
		savefile.height=2.5;
		savefile.margin={0,0.02,0,0.02};
		savefile.text="savefile: 100% Keter NMG speedrun";
		savefile.fontScale=1;
		savefile.alignHorizontal=GUI::Align::Left;

		GUILabel@ seednum=GUILabel(@this);
		seednum.align=GUI::Align::Top;
		seednum.height=2.5;
		seednum.margin={0,0.02,0,0.02};
		seednum.text="Seed: 133769";
		seednum.fontScale=1;
		seednum.alignHorizontal=GUI::Align::Left;
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

