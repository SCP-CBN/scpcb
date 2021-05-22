

// # Menu::Pause (namespace) ----
namespace Menu { namespace Pause {
	Window@ instance;

	Font@ roomBtnFont=Font::inconsolata_small;

	void load() {
		@instance=Window();
	}

} }

// # Menu::pause()
namespace Menu { void pause() {
	Environment::paused=true;
	Pause::instance.open();
} }



// # Menu::Pause::InfoPanel (GUI class) ----
namespace Menu { namespace Pause { class InfoPanel : GUI {
	InfoPanel(GUI@&in parent) { super(@parent,"Menu::Pause::InfoPanel");
		height=8;
		visible=false;

		GUILabel@ difficulty=GUILabel(@this);
		difficulty.align=GUI::Align::Top;
		difficulty.height=2.5;
		difficulty.margin={0,0.02,0,0.02};
		difficulty.text="Difficulty: Keter";
		difficulty.fontScale=0.1;
		difficulty.alignHorizontal=GUI::Align::Left;

		GUILabel@ savefile=GUILabel(@this);
		savefile.align=GUI::Align::Top;
		savefile.height=2.5;
		savefile.margin={0,0.02,0,0.02};
		savefile.text="savefile: 100% Keter NMG speedrun";
		savefile.fontScale=0.1;
		savefile.alignHorizontal=GUI::Align::Left;

		GUILabel@ seednum=GUILabel(@this);
		seednum.align=GUI::Align::Top;
		seednum.height=2.5;
		seednum.margin={0,0.02,0,0.02};
		seednum.text="Seed: 133769";
		seednum.fontScale=0.1;
		seednum.alignHorizontal=GUI::Align::Left;
	}
} } }

// # Menu::Pause::SpawnRoomButton (GUI class) ----
namespace Menu { namespace Pause { class SpawnRoomButton : GUIButtonLabel {
	Room::Template@ room;
	SpawnRoomButton(GUI@ parent, Room::Template@ rm) { super(@parent, "Menu::Pause::SpawnRoomButton");
		@room=@rm;
		text=room.name;
		@label.font=@roomBtnFont;
	}
	void doClick() {
		Debug::log("Wants to spawn Room : " + room.name);
		Room::spawn(room.name, Player::Controller.position-Vector3f(0,20+Player::height,0));
		instance.unpause();
	}
} } }




// # Menu::Pause::Window@ (main class) ----
namespace Menu { namespace Pause { class Window : GUI {

	GUI@ canvas;
	GUIScrollPanel@ scrollTest;

	Window() { super("Menu::Pause::Window");
		align=GUI::Align::Center;
		size=Vector2f(70,70);

		GUILabel@ header=GUILabel(@this);
		header.text="PAUSED";
		header.align=GUI::Align::Top;
		header.height=GUI::resolution.y*0.07;
		header.fontScale=0.3;
		header.margin={4,GUI::resolution.y*0.035,4,1};

		@canvas=GUI(@this);
		canvas.align=GUI::Align::Fill;
		canvas.margin={GUI::resolution.x*0.07,GUI::resolution.y*0.01,2,0};

		constructMain();
		constructLoad();
		constructDebug();
		constructCheats();
		constructOptions();
		constructIconEditor();
		constructItemSpawner();
		constructRoomSpawner();
		constructGUITest();


	}
	void open() {
		visible=true;
		openToMain();
		invalidateLayout();
	}
	void close() {
		visible=false;
	}
	void unpause() {
		Environment::paused=false;
		visible=false;
	}


	void switchPage() { for(int i=0; i<canvas._children.length(); i++) { canvas._children[i].visible=false; } invalidateLayout(); }
	void openToMain() { switchPage(); canvasMain.visible=true; }
	void openToLoad() { switchPage(); canvasLoad.visible=true; }
	void openToDebug() { switchPage(); canvasDebug.visible=true; }
	void openToCheats() { switchPage(); canvasCheats.visible=true; }
	void openToOptions() { switchPage(); canvasOptions.visible=true; }
	void openToIconEditor() { switchPage(); canvasIconEditor.visible=true; }
	void openToItemSpawner() { switchPage(); canvasItemSpawner.visible=true; }
	void openToRoomSpawner() { switchPage(); canvasRoomSpawner.visible=true; }
	void openToGUITest() { switchPage(); canvasGUITest.visible=true; }
	void openToQuit() { visible=false; MainMenu.visible=true; } // change to Menu::Main::instance.visible=true;
	void tpToZero() { Player::Controller.position=Vector3f(0,Player::height+5,0); unpause(); }

	void toggleNoclip() { bool nclip=Player::Controller.noclip; Player::Controller.noclip=!nclip; btnNoclip.text="Noclip ("+ (!nclip ? "ON" : "OFF") +")"; unpause(); }

	GUI@ canvasMain;
	void constructMain() {
		@canvasMain=GUI(@canvas);
		canvasMain.align=GUI::Align::Fill;

		auto@ textPanel = Menu::Pause::InfoPanel(@canvasMain);
		textPanel.align=GUI::Align::Top;
		textPanel.margin={1,0,1,0.5};

		GUI@ panelOfButtons=GUI(@canvasMain);
		panelOfButtons.align=GUI::Align::Fill;
		panelOfButtons.margin={1,0.5,1,1};
		//panelOfButtons.width=GUI::resolution.x*0.375;

		auto@ btnContinue=GUIButtonLabel(@panelOfButtons);
		btnContinue.align=GUI::Align::Top;
		btnContinue.margin={1,1,1,0};
		btnContinue.height=8;
		btnContinue.text="Continue";
		@btnContinue.clickFunc=Util::Function(unpause);

		auto@ btnLoad=GUIButtonLabel(@panelOfButtons);
		btnLoad.align=GUI::Align::Top;
		btnLoad.margin={1,1,1,0};
		btnLoad.height=8;
		btnLoad.text="Load";
		@btnLoad.clickFunc=Util::Function(openToLoad);

		auto@ btnDebug=GUIButtonLabel(@panelOfButtons);
		btnDebug.align=GUI::Align::Top;
		btnDebug.margin={1,1,1,0};
		btnDebug.height=8;
		btnDebug.text="Debug Menu";
		@btnDebug.clickFunc=Util::Function(openToDebug);

		auto@ btnOptions=GUIButtonLabel(@panelOfButtons);
		btnOptions.align=GUI::Align::Top;
		btnOptions.margin={1,1,1,0};
		btnOptions.height=8;
		btnOptions.text="Options";
		@btnOptions.clickFunc=Util::Function(openToOptions);

		auto@ btnQuit=GUIButtonLabel(@panelOfButtons);
		btnQuit.align=GUI::Align::Top;
		btnQuit.margin={1,1,1,0};
		btnQuit.height=8;
		btnQuit.text="Quit to Main";
		@btnQuit.clickFunc=Util::Function(openToQuit);
	}


	GUI@ canvasRoomSpawner;
	void constructRoomSpawner() {
		@canvasRoomSpawner=GUI(@canvas);
		canvasRoomSpawner.align=GUI::Align::Fill;

		auto@ btnBack = GUIButtonLabel(@canvasRoomSpawner);
		btnBack.align=GUI::Align::Bottom;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=Util::Function(openToDebug);

		auto@ panelOfButtons=GUIScrollPanel(@canvasRoomSpawner);
		panelOfButtons.align=GUI::Align::Fill;

		for(int i=0; i<Room::templates.length(); i++) {
			auto@ btnRoom = SpawnRoomButton(@panelOfButtons, @Room::templates[i]);
			btnRoom.align=GUI::Align::Top;
			btnRoom.margin={1,1,1,0};
			btnRoom.height=8;
			//btnRoom.label.fontScale=0.1;
		}
	}


	GUI@ canvasLoad;
	void constructLoad() {
		@canvasLoad=GUI(@canvas);
		canvasLoad.align=GUI::Align::Fill;

		auto@ btnBack = GUIButtonLabel(@canvasLoad);
		btnBack.align=GUI::Align::Bottom;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=Util::Function(openToMain);
	}

	GUI@ canvasIconEditor;
	void constructIconEditor() {
		@canvasIconEditor=GUI(@canvas);
		canvasIconEditor.align=GUI::Align::Fill;

		auto@ btnBack = GUIButtonLabel(@canvasIconEditor);
		btnBack.align=GUI::Align::Bottom;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=Util::Function(openToDebug);
	}

	GUI@ canvasItemSpawner;
	void constructItemSpawner() {
		@canvasItemSpawner=GUI(@canvas);
		canvasItemSpawner.align=GUI::Align::Fill;

		auto@ btnBack = GUIButtonLabel(@canvasItemSpawner);
		btnBack.align=GUI::Align::Bottom;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=Util::Function(openToCheats);
	}


	GUI@ canvasGUITest;
	void constructGUITest() {
		@canvasGUITest=GUI(@canvas);
		canvasGUITest.align=GUI::Align::Fill;

		auto@ btnBack = GUIButtonLabel(@canvasGUITest);
		btnBack.align=GUI::Align::Bottom;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=Util::Function(openToDebug);


		GUIButton@ testentryPanel=GUIButton(@canvasGUITest);
		testentryPanel.align=GUI::Align::Top;
		testentryPanel.margin={1,1,1,0};
		testentryPanel.height=8;

		GUITextEntry@ testEntry=GUITextEntry(@testentryPanel);
		testEntry.align=GUI::Align::Fill;
		testEntry.margin={1,1,1,0};
		testEntry.height=4;
		testEntry.defaultText="testy";


		auto@ scrollTest=GUIScrollPanel(@canvasGUITest);
		scrollTest.align=GUI::Align::Fill;

		for(int i=0; i<30; i++) {
			GUIButtonLabel@ btn = GUIButtonLabel(@scrollTest);
			btn.text="Test: " + (i+64);
			btn.align=GUI::Align::Top;
			btn.height=8;
		}
	}

	GUIButtonLabel@ btnNoclip;
	GUI@ canvasDebug;
	void constructDebug() {
		@canvasDebug=GUI(@canvas);
		canvasDebug.align=GUI::Align::Fill;


		auto@ btnBack = GUIButtonLabel(@canvasDebug);
		btnBack.align=GUI::Align::Bottom;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=Util::Function(openToMain);

		auto@ canvasDebugScroll=GUIScrollPanel(@canvasDebug);
		canvasDebugScroll.align=GUI::Align::Fill;

		bool nclip=Player::Controller.noclip;
		@btnNoclip = GUIButtonLabel(@canvasDebugScroll);
		btnNoclip.align=GUI::Align::Top;
		btnNoclip.margin={1,1,1,0};
		btnNoclip.height=8;
		btnNoclip.text="Noclip ("+ (nclip ? "ON" : "OFF") +")";
		@btnNoclip.clickFunc=Util::Function(toggleNoclip);

		auto@ btnTpToZero = GUIButtonLabel(@canvasDebugScroll);
		btnTpToZero.align=GUI::Align::Top;
		btnTpToZero.margin={1,1,1,0};
		btnTpToZero.height=8;
		btnTpToZero.text="Tp to (0,0,0)";
		@btnTpToZero.clickFunc=Util::Function(tpToZero);

		auto@ btnItemSpawner = GUIButtonLabel(@canvasDebugScroll);
		btnItemSpawner.align=GUI::Align::Top;
		btnItemSpawner.margin={1,1,1,0};
		btnItemSpawner.height=8;
		btnItemSpawner.text="Item Spawn Menu";
		@btnItemSpawner.clickFunc=Util::Function(openToItemSpawner);

		auto@ btnRoomSpawner = GUIButtonLabel(@canvasDebugScroll);
		btnRoomSpawner.align=GUI::Align::Top;
		btnRoomSpawner.margin={1,1,1,0};
		btnRoomSpawner.height=8;
		btnRoomSpawner.text="RoomSpawner Menu";
		@btnRoomSpawner.clickFunc=Util::Function(openToRoomSpawner);

		auto@ btnIconEditor = GUIButtonLabel(@canvasDebugScroll);
		btnIconEditor.align=GUI::Align::Top;
		btnIconEditor.margin={1,1,1,0};
		btnIconEditor.height=8;
		btnIconEditor.text="Icon Editor";
		@btnIconEditor.clickFunc=Util::Function(openToIconEditor);

		auto@ btnGUITest = GUIButtonLabel(@canvasDebugScroll);
		btnGUITest.align=GUI::Align::Top;
		btnGUITest.margin={1,1,1,0};
		btnGUITest.height=8;
		btnGUITest.text="GUI Testing";
		@btnGUITest.clickFunc=Util::Function(openToGUITest);

		auto@ btnCheats = GUIButtonLabel(@canvasDebugScroll);
		btnCheats.align=GUI::Align::Top;
		btnCheats.margin={1,1,1,0};
		btnCheats.height=8;
		btnCheats.text="Cheats Menu";
		@btnCheats.clickFunc=Util::Function(openToCheats);

	}



	GUI@ canvasCheats;
	void constructCheats() {
		@canvasCheats=GUI(@canvas);
		canvasCheats.align=GUI::Align::Fill;

		auto@ btnBack = GUIButtonLabel(@canvasCheats);
		btnBack.align=GUI::Align::Bottom;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=Util::Function(openToDebug);



	}






	GUI@ canvasOptions;
	void constructOptions() {
		@canvasOptions=GUI(@canvas);
		canvasOptions.align=GUI::Align::Fill;

		auto@ btnBack = GUIButtonLabel(@canvasOptions);
		btnBack.align=GUI::Align::Bottom;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=Util::Function(openToMain);
	}


	void doLayout() {
		square=Rectanglef((paintPos)-GUI::center,(paintPos+paintSize)-GUI::center);
	}
	Rectanglef square;
	void paint() {
		UI::setTextured(GUI::Skin::menuPause, false);
		UI::setColor(Color(1.f,1.f,1.f,1.f));
		UI::addRect(square);
	}



} } }
