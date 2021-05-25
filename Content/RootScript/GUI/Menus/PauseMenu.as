

// # Menu::Pause (namespace) ----
namespace Menu { namespace Pause {
	shared Window@ instance;

	shared Font@ roomBtnFont=Font::large;

	shared void load() {
		@instance=Window();
	}

} }

// # Menu::pause()
namespace Menu { shared void pause() {
	World::paused=true;
	Pause::instance.open();
} }



// # Menu::Pause::InfoPanel (GUI class) ----
namespace Menu { namespace Pause { shared class InfoPanel : GUI {
	InfoPanel(GUI@&in parent) { super(@parent,"Menu::Pause::InfoPanel");
		height=8;

		GUI::Label@ difficulty=GUI::Label(@this);
		difficulty.align=GUI::Align::TOP;
		difficulty.height=2.5;
		difficulty.margin={0,0.02,0,0.02};
		difficulty.text="Difficulty: Keter";
		difficulty.fontScale=0.15;
		difficulty.alignText=GUI::Align::LEFT;

		GUI::Label@ savefile=GUI::Label(@this);
		savefile.align=GUI::Align::TOP;
		savefile.height=2.5;
		savefile.margin={0,0.02,0,0.02};
		savefile.text="savefile: 100% Keter NMG speedrun";
		savefile.fontScale=0.15;
		savefile.alignText=GUI::Align::LEFT;

		GUI::Label@ seednum=GUI::Label(@this);
		seednum.align=GUI::Align::TOP;
		seednum.height=2.5;
		seednum.margin={0,0.02,0,0.02};
		seednum.text="Seed: 133769";
		seednum.fontScale=0.15;
		seednum.alignText=GUI::Align::LEFT;
	}
} } }

/* MISSING TEMPLATES

// # Menu::Pause::SpawnRoomButton (GUI class) ----
namespace Menu { namespace Pause { class SpawnRoomButton : ButtonLabel {
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

// # Menu::Pause::SpawnItemButton (GUI class) ----
namespace Menu { namespace Pause { class SpawnItemButton : Button {
	Item::Template@ template;
	GUIPanel@ icon;
	SpawnItemButton(GUI@ parent, Item::Template@ itm) { super(@parent, "Menu::Pause::SpawnItemButton");
		@template=@itm;
		@icon=GUI::Panel(@this);
		icon.align=GUI::Align::FILL;
		icon.margin={0.125,0.125,0.125,0.125};
		@icon.texture=@template.icon.texture;
	}
	void doClick() {
		Item::spawn(template.name, Player::Controller.position+Vector3f(10,0,0));
		instance.unpause();
	}
} } }

// # Menu::Pause::SpawnPropButton (GUI class) ----
namespace Menu { namespace Pause { class SpawnPropButton : Button {
	Prop::Template@ template;
	GUIPanel@ icon;
	SpawnPropButton(GUI@ parent, Prop::Template@ itm) { super(@parent, "Menu::Pause::SpawnPropButton");
		@template=@itm;
		@icon=GUI::Panel(@this);
		icon.align=GUI::Align::FILL;
		icon.margin={0.125,0.125,0.125,0.125};
		@icon.texture=@template.icon.texture;
	}
	void doClick() {
		Prop::spawn(template.name, Player::Controller.position+Vector3f(10,0,0));
		instance.unpause();
	}
} } }

*/

// # Menu::Pause::Window@ (main class) ----
namespace Menu { namespace Pause { shared class Window : GUI {

	GUI@ canvas;
	GUI::Panel@ body;
//	GUIScrollPanel@ scrollTest;

	Window() { super("Menu::Pause::Window");


		@body=GUI::Panel(@this);
		body.align=GUI::Align::CENTER;
		body.size=Vector2f(70,70);
		@body.texture=@GUI::Skin::menuPause;

		GUI::Label@ header=GUI::Label(@body);
		header.text="PAUSED";
		header.align=GUI::Align::TOP;
		header.height=4;
		header.fontScale=0.3;
		header.margin={12+4,3,4,4};

		@canvas=GUI(@body);
		canvas.align=GUI::Align::FILL;
		canvas.margin={12,0,2,1};

		constructMain();
		constructLoad();
		constructDebug();
		constructCheats();
		constructOptions();
		constructIconEditor();
		constructItemSpawner();
		constructRoomSpawner();
		constructPropSpawner();
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
		World::paused=false;
		visible=false;
	}


	void switchPage() { for(int i=0; i<canvas.children.length(); i++) { canvas.children[i].visible=false; } invalidateLayout(); }
	void openToMain() { switchPage(); canvasMain.visible=true; }
	void openToLoad() { switchPage(); canvasLoad.visible=true; }
	void openToDebug() { switchPage(); canvasDebug.visible=true; }
	void openToCheats() { switchPage(); canvasCheats.visible=true; }
	void openToOptions() { switchPage(); canvasOptions.visible=true; }
	void openToIconEditor() { switchPage(); canvasIconEditor.visible=true; }
	void openToItemSpawner() { switchPage(); canvasItemSpawner.visible=true; }
	void openToRoomSpawner() { switchPage(); canvasRoomSpawner.visible=true; }
	void openToPropSpawner() { switchPage(); canvasPropSpawner.visible=true; }
	void openToGUITest() { switchPage(); canvasGUITest.visible=true; }
	void openToQuit() {} // visible=false; MainMenu.visible=true; } // change to Menu::Main::instance.visible=true;
	void tpToZero() { } // rootscript doesnt have access to controller Player::Controller.position=Vector3f(0,25+5,0); unpause(); } // 25=Player::height

	void toggleNoclip() { } // rootscript doesnt have access to controller
		// bool nclip=Player::Controller.noclip; Player::Controller.noclip=!nclip; btnNoclip.text="Noclip ("+ (!nclip ? "ON" : "OFF") +")"; unpause(); }

	GUI@ canvasMain;
	void constructMain() {
		@canvasMain=GUI(@canvas);
		canvasMain.align=GUI::Align::FILL;

		auto@ textPanel = Menu::Pause::InfoPanel(@canvasMain);
		textPanel.align=GUI::Align::TOP;
		textPanel.margin={2,1,1,0.5};

		GUI@ panelOfButtons=GUI(@canvasMain);
		panelOfButtons.align=GUI::Align::FILL;
		panelOfButtons.margin={1,0.5,1,1};
		//panelOfButtons.width=GUI::resolution.x*0.375;

		auto@ btnContinue=GUI::ButtonLabel(@panelOfButtons);
		btnContinue.align=GUI::Align::TOP;
		btnContinue.margin={1,1,1,0};
		btnContinue.height=8;
		btnContinue.text="Continue";
		@btnContinue.clickFunc=GUI::ClickFunction(unpause);

		auto@ btnLoad=GUI::ButtonLabel(@panelOfButtons);
		btnLoad.align=GUI::Align::TOP;
		btnLoad.margin={1,1,1,0};
		btnLoad.height=8;
		btnLoad.text="Load";
		@btnLoad.clickFunc=GUI::ClickFunction(openToLoad);

		auto@ btnDebug=GUI::ButtonLabel(@panelOfButtons);
		btnDebug.align=GUI::Align::TOP;
		btnDebug.margin={1,1,1,0};
		btnDebug.height=8;
		btnDebug.text="Debug Menu";
		@btnDebug.clickFunc=GUI::ClickFunction(openToDebug);

		auto@ btnOptions=GUI::ButtonLabel(@panelOfButtons);
		btnOptions.align=GUI::Align::TOP;
		btnOptions.margin={1,1,1,0};
		btnOptions.height=8;
		btnOptions.text="Options";
		@btnOptions.clickFunc=GUI::ClickFunction(openToOptions);

		auto@ btnQuit=GUI::ButtonLabel(@panelOfButtons);
		btnQuit.align=GUI::Align::TOP;
		btnQuit.margin={1,1,1,0};
		btnQuit.height=8;
		btnQuit.text="Quit to Main";
		@btnQuit.clickFunc=GUI::ClickFunction(openToQuit);
	}


	GUI@ canvasRoomSpawner;
	void constructRoomSpawner() {
		@canvasRoomSpawner=GUI(@canvas);
		canvasRoomSpawner.align=GUI::Align::FILL;

		auto@ btnBack = GUI::ButtonLabel(@canvasRoomSpawner);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToDebug);

/* // missing scrollpanel and templates
		auto@ panelOfButtons=GUI::ScrollPanel(@canvasRoomSpawner);
		panelOfButtons.align=GUI::Align::FILL;

		for(int i=0; i<Room::templates.length(); i++) {
			auto@ btnRoom = SpawnRoomButton(@panelOfButtons, @Room::templates[i]);
			btnRoom.align=GUI::Align::TOP;
			btnRoom.margin={1,1,1,0};
			btnRoom.height=8;
			//btnRoom.label.fontScale=0.1;
		}
*/
	}


	GUI@ canvasLoad;
	void constructLoad() {
		@canvasLoad=GUI(@canvas);
		canvasLoad.align=GUI::Align::FILL;

		auto@ btnBack = GUI::ButtonLabel(@canvasLoad);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToMain);
	}

	GUI@ canvasIconEditor;
	void constructIconEditor() {
		@canvasIconEditor=GUI(@canvas);
		canvasIconEditor.align=GUI::Align::FILL;

		auto@ btnBack = GUI::ButtonLabel(@canvasIconEditor);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToDebug);
	}

	GUI@ canvasItemSpawner;
	void constructItemSpawner() {
		@canvasItemSpawner=GUI(@canvas);
		canvasItemSpawner.align=GUI::Align::FILL;

		auto@ btnBack = GUI::ButtonLabel(@canvasItemSpawner);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToDebug);

/* // missing scrollpanel and templates
		auto@ panelOfButtons=GUI::ScrollPanel(@canvasItemSpawner);
		panelOfButtons.align=GUI::Align::FILL;

		GUI@ topPanel;
		for(int i=0; i<Item::templates.length(); i++) {
			if(i%5==0) {
				@topPanel = GUI(@panelOfButtons);
				topPanel.align=GUI::Align::TOP;
				topPanel.height=9;
				topPanel.margin={0.5,0.5,0.5,0.25};
			}
			auto@ btn = SpawnItemButton(@topPanel, @Item::templates[i]);
			btn.align=GUI::Align::LEFT;
			btn.margin={0.25,0.25,0.25,0.25};
			btn.width=8;
			//btnRoom.label.fontScale=0.1;
		}
*/

	}


	GUI@ canvasPropSpawner;
	void constructPropSpawner() {
		@canvasPropSpawner=GUI(@canvas);
		canvasPropSpawner.align=GUI::Align::FILL;

		auto@ btnBack = GUI::ButtonLabel(@canvasPropSpawner);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToDebug);

/* // missing scrollpanel and templates
		auto@ panelOfButtons=GUI::ScrollPanel(@canvasPropSpawner);
		panelOfButtons.align=GUI::Align::FILL;

		GUI@ topPanel;
		for(int i=0; i<Prop::templates.length(); i++) {
			if(i%4==0) {
				@topPanel = GUI(@panelOfButtons);
				topPanel.align=GUI::Align::TOP;
				topPanel.height=9;
				topPanel.margin={0.5,0.5,0.5,0.25};
			}
			auto@ btn = SpawnPropButton(@topPanel, @Prop::templates[i]);
			btn.align=GUI::Align::LEFT;
			btn.margin={0.25,0.25,0.25,0.25};
			btn.width=8;
			//btnRoom.label.fontScale=0.1;
		}
*/

	}

	GUI@ canvasGUITest;
	void constructGUITest() {
		@canvasGUITest=GUI(@canvas);
		canvasGUITest.align=GUI::Align::FILL;

		auto@ btnBack = GUI::ButtonLabel(@canvasGUITest);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToDebug);


		GUI::Button@ testentryPanel=GUI::Button(@canvasGUITest);
		testentryPanel.align=GUI::Align::TOP;
		testentryPanel.margin={1,1,1,0};
		testentryPanel.height=8;

/* missing text entry
		GUITextEntry@ testEntry=GUI::TextEntry(@testentryPanel);
		testEntry.align=GUI::Align::FILL;
		testEntry.margin={1,1,1,0};
		testEntry.height=8;
		testEntry.defaultText="testy";
*/


/*
		auto@ scrollTest=GUI::ScrollPanel(@canvasGUITest);
		scrollTest.align=GUI::Align::FILL;

		for(int i=0; i<30; i++) {
			GUI::ButtonLabel@ btn = GUI::ButtonLabel(@scrollTest);
			btn.text="Test: " + (i+64);
			btn.align=GUI::Align::TOP;
			btn.height=8;
		}
*/
	}

	GUI::ButtonLabel@ btnNoclip;
	GUI@ canvasDebug;
	void constructDebug() {
		@canvasDebug=GUI(@canvas);
		canvasDebug.align=GUI::Align::FILL;


		auto@ btnBack = GUI::ButtonLabel(@canvasDebug);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToMain);

		auto@ btnTpToZero = GUI::ButtonLabel(@canvasDebug);
		btnTpToZero.align=GUI::Align::TOP;
		btnTpToZero.margin={1,1,1,0};
		btnTpToZero.height=8;
		btnTpToZero.text="Tp to (0,0,0)";
		@btnTpToZero.clickFunc=GUI::ClickFunction(tpToZero);


/*
		auto@ canvasDebugScroll=GUI::ScrollPanel(@canvasDebug);
		canvasDebugScroll.align=GUI::Align::FILL;

		bool nclip=Player::Controller.noclip;
		@btnNoclip = GUI::ButtonLabel(@canvasDebugScroll);
		btnNoclip.align=GUI::Align::TOP;
		btnNoclip.margin={1,1,1,0};
		btnNoclip.height=8;
		btnNoclip.text="Noclip ("+ (nclip ? "ON" : "OFF") +")";
		@btnNoclip.clickFunc=GUI::ClickFunction(toggleNoclip);

		auto@ btnTpToZero = GUI::ButtonLabel(@canvasDebugScroll); -- dupe
		btnTpToZero.align=GUI::Align::TOP;
		btnTpToZero.margin={1,1,1,0};
		btnTpToZero.height=8;
		btnTpToZero.text="Tp to (0,0,0)";
		@btnTpToZero.clickFunc=GUI::ClickFunction(tpToZero);

		auto@ btnItemSpawner = GUI::ButtonLabel(@canvasDebugScroll);
		btnItemSpawner.align=GUI::Align::TOP;
		btnItemSpawner.margin={1,1,1,0};
		btnItemSpawner.height=8;
		btnItemSpawner.text="Spawn Items";
		@btnItemSpawner.clickFunc=GUI::ClickFunction(openToItemSpawner);

		auto@ btnRoomSpawner = GUI::ButtonLabel(@canvasDebugScroll);
		btnRoomSpawner.align=GUI::Align::TOP;
		btnRoomSpawner.margin={1,1,1,0};
		btnRoomSpawner.height=8;
		btnRoomSpawner.text="Spawn Rooms";
		@btnRoomSpawner.clickFunc=GUI::ClickFunction(openToRoomSpawner);

		auto@ btnPropSpawner = GUI::ButtonLabel(@canvasDebugScroll);
		btnPropSpawner.align=GUI::Align::TOP;
		btnPropSpawner.margin={1,1,1,0};
		btnPropSpawner.height=8;
		btnPropSpawner.text="Spawn Props";
		@btnPropSpawner.clickFunc=GUI::ClickFunction(openToPropSpawner);

		auto@ btnIconEditor = GUI::ButtonLabel(@canvasDebugScroll);
		btnIconEditor.align=GUI::Align::TOP;
		btnIconEditor.margin={1,1,1,0};
		btnIconEditor.height=8;
		btnIconEditor.text="Icon Editor";
		@btnIconEditor.clickFunc=GUI::ClickFunction(openToIconEditor);

		auto@ btnGUITest = GUI::ButtonLabel(@canvasDebugScroll);
		btnGUITest.align=GUI::Align::TOP;
		btnGUITest.margin={1,1,1,0};
		btnGUITest.height=8;
		btnGUITest.text="GUI Testing";
		@btnGUITest.clickFunc=GUI::ClickFunction(openToGUITest);

		auto@ btnCheats = GUI::ButtonLabel(@canvasDebugScroll);
		btnCheats.align=GUI::Align::TOP;
		btnCheats.margin={1,1,1,0};
		btnCheats.height=8;
		btnCheats.text="Cheats Menu";
		@btnCheats.clickFunc=GUI::ClickFunction(openToCheats);
*/

	}



	GUI@ canvasCheats;
	void constructCheats() {
		@canvasCheats=GUI(@canvas);
		canvasCheats.align=GUI::Align::FILL;

		auto@ btnBack = GUI::ButtonLabel(@canvasCheats);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToDebug);



	}






	GUI@ canvasOptions;
	void constructOptions() {
		@canvasOptions=GUI(@canvas);
		canvasOptions.align=GUI::Align::FILL;

		auto@ btnBack = GUI::ButtonLabel(@canvasOptions);
		btnBack.align=GUI::Align::BOTTOM;
		btnBack.margin={1,1,1,1};
		btnBack.height=8;
		btnBack.text="Back";
		@btnBack.clickFunc=GUI::ClickFunction(openToMain);
	}


} } }
