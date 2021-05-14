// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: SCPCB/Main.as						//
// Purpose:								//
//	- Base Game							//
//	- Import externals						//
//	- Prepare environment						//
//									//
// -------------------------------------------------------------------- //
// Authors:								//
//	- Pyro-Fire							//
//									//
//									//
//									//
// -------------------------------------------------------------------- \\
// Documentation
//
//
//	1. Importing
//		- AngelMath : General math functions and offsets/directions etc for Angelscript.
//		- AngelString : General string functions for Angelscript.
//		- Util : Generic utility space, currently used for Model/ModelPicker/ModelIcon utils.
//		- Hook : A function call replicator.
//		- Timer : Used for delayed functions.
//		- FloatInterpolator : Smooths numbers over time.
//		- GUI : User Interface / Menu Engine.
//		- Item : Item libraries and register.
//		- Console : C++ interface.
//
//	2. Game Platform
//		- Player : The player controller.
//		- Game : General purpose Game namespace.
//		- Game::World : The gameworld and physics and stuff
//		- Misc : Other general stuff not yet sorted to a better place.
//
//	3. Entrypoint
//		- Engine Hooks : Tick/render/exit/etc.
//		- main() : void main, the entry point to the SCPCB script.
//
//	4. Scrap code
//		- If you don't have a better place to put it...
//
//
// -------------------------------------------------------------------- //
// Begin Script

bool DEBUGGING = true;

// --------------------------------
// SECTION 1. Import

// # import(RootScript/BaseClasses/Utility/AngelMath.as);
external enum Alignment;


//external class Vector2d; // Angel 2d vector lib
//external class Vector3d; // Angel 3d vector lib
//external class Vector4d; // Angel 4d vector lib
//external class Square; // Angel square/rectangle lib
//external class Angle; // angle lib


// # import(RootScript/BaseClasses/Utility/AngelString.as);
external array<string> String::explode(string str, string delim);
external string String::implode(array<string> words, string delim);

// # import(RootScript/BaseClasses/Utility/Util.as);
external class Util::Model;
external class Util::ModelPicker;
external class Util::ModelIcon;
external class Util::Icon;
external int Util::tick;

external class Hook;
external void Hook::Destroy(Hook@&in h);
external Hook@ Hook::Create(string name);

external class TickTimer;
external class Timer;
namespace Timer {
	external funcdef void Function();
	external funcdef void Repeater(Timer@&in tmr);
}

external void Timer::Start(int tock, Timer::Function@ func);
external void Timer::On(int tock, Timer::Function@ func);
external Timer@ Timer::Repeat(int tock, Timer::Repeater@ func);
external void Timer::Stop(Timer@ tmr);
external void Timer::Stop(TickTimer@ tmr);
external void Timer::update();

external class FloatInterpolator;


// # import(RootScript/BaseClasses/Utility/GUI.as);
external class GUI; // Blank GUIComponent / container for other GUIComponents.
external class GUILabel; // Generic text drawer
external class GUILabelBox; // A word-wrapped GUILabel.
external class GUIPanel; // Generic panel that draws a box either colored or textured.
external class GUIClickable; // A slimmed GUIButton with no textures.
external class GUIButton; // Generic clickable component.
external class GUIButtonLabel; // Generic clickable button with text.
external class GUIScrollPanel; // Panel with a scrollbar
external class GUITextEntry; // Shoop da whoop

external bool GUI::squareInSquare(Vector2f&in pos, Vector2f&in size, Vector2f&in sPos, Vector2f&in sSize);
external bool GUI::pointInSquare(Vector2f&in point, Vector2f&in pos, Vector2f&in size);

external void GUI::Initialize();
external void GUI::startRender();
external void GUI::startUpdate();
external void GUI::updateResolution();

external float GUI::tileScale;
external float GUI::aspectScale;

external Vector2f GUI::mouse();
external Vector2f GUI::resolution;
external Vector2f GUI::center;

external array<GUI@> GUI::baseInstances; // temporaryz

namespace GUI {
	external Texture@ Skin::menublack;
	external Texture@ Skin::menuwhite;
	external Texture@ Skin::menuMain;
	external Texture@ Skin::menuPause;
	external Texture@ Skin::menuSCPLabel;
	external Texture@ Skin::menuSCP173;
}

// # import(RootScript/BaseClasses/Entities/Item.as); ----------------
external class Item;

external void Item::updateAll();
external void Item::renderAll();

external Item@ Item::spawn(const string&in name, const Vector3f&in position);
external Item@ Item::spawn(const string&in name, const Vector3f&in position, const Vector3f&in rotation);


// # import(RootScript/BaseClasses/Utility/GUI.as -> $C++/Console) ----------------
//external class ConsoleMenu { ConsoleMenu@ instance; }
//ConsoleMenu@ ConsoleMenu::instance;
//external void Console::addMessage(const string&in msg, const Color&in color = Color::White);

// --------------------------------
// SECTION 2. Game Platform

// # Player{} --------
namespace Player {
	PlayerController@ Controller;
	float Height=15.f;
	float Radius=Height*(5.f/15.f);

	Vector3f pos { get { return Controller.position; }
		set { Controller.position=value; }
	}

	void Initialize() {
		@Controller=PlayerController(Radius,Height);
		Controller.setCollisionCollection(@Game::World::Collision);
		pos=Vector3f(0,Height+5,0);

	}
}	

// # Game{} --------
namespace Game {
	int tick { get { return Util::tick; } set { Util::tick=value; } }
	Hook@ tickHook=Hook("tick");

	void Initialize() {
		Game::World::Initialize();
		Player::Initialize();

		GUI::Initialize();
		Loadscreen::Initialize();
		@MainMenu=menu_Main();
		@PauseMenu=menu_Pause();
		@ConsoleMenu=menu_Console();
	}

	void update(float interp) {
		updateMenuState(); // Escape doesn't always capture in renderMenu ??
		tick=tick+1;
		Timer::update();
		GUI::startUpdate();
		Game::World::update();
		tickHook.call();
		if(queuedNewGame) {
			BuildNewGame();
			queuedNewGame=false;
		}
		Item::updateAll();
		if(DEBUGGING) { AngelDebug::update(interp); }
	}
	void render(float interp) {
		Game::World::render();
		if(DEBUGGING) { AngelDebug::render(interp); }
	}
	void renderMenu(float interp) {
		GUI::startRender();
		if(DEBUGGING) { AngelDebug::renderMenu(interp); }
	}

	void exit() {

	}



	void updateMenuState() {
		if(Input::getHit() & Input::Inventory != 0) { Debug::log("hotkey Open Inventory"); }
		else if(Input::getHit() & Input::ToggleConsole != 0) { Debug::log("hotkey Open Console"); ConsoleMenu.visible=true; }
		else if(Input::getHit() & Input::Crouch != 0) { Debug::log("hotkey Crouch"); }
		else if(Input::Escape::isHit()) {
			Debug::log("Escape was pressed11"); // Apparently this code doesn't run without calling a Debug::log. isHit() is weird.
			bool menuIsOpen=false;
			for(int i=0; i<GUI::baseInstances.length(); i++) {
				if(GUI::baseInstances[i].visible==true) {
					menuIsOpen=true;
					GUI::baseInstances[i].visible=false;
				}
			}
			if(menuIsOpen==true) {
				World::paused=false;
			} else {
				World::paused=true;
				PauseMenu.open();
			}
		}
	}
}




// # Game::World --------
namespace Game { namespace World {
	Collision::Collection@ Collision;
	void Initialize() {
		::World::paused = true;
		@Collision=Collision::Collection();
	}
	void update() {
	}
	void render() {
	}
} }

// # Misc --------
bool queuedNewGame=false;
void QueueNewGame() {
	World::paused=false;
	Loadscreen::Activate("SCP-173");
	queuedNewGame=true;
}
void BuildNewGame() {
	World::paused=true;
	initRooms_OBSOLETE();
	Player::Controller.position=Vector3f(0,Player::Height+5,0);
	World::paused=false;
	MainMenu.visible=false;
	PauseMenu.visible=false;
	LoadingMenu.visible=false;
}

// --------------------------------
// SECTION 3. Entrypoint


// # Engine Hooks --------
void renderMenu(float interp) { Game::renderMenu(interp); if(DEBUGGING) { AngelDebug::renderMenu(interp); } }
void render(float interp) { Game::render(interp); if(DEBUGGING) { AngelDebug::render(interp); } }
void update(float interp) { Game::update(interp); if(DEBUGGING) { AngelDebug::update(interp); } }
void exit() { Game::exit(); Debug::log("GAME OVER, YEAH!"); }

// # main() --------
void main() {
	Game::Initialize();

	@lcz = LightContainmentZone();
	@test_shared_global = @lcz;

	if(DEBUGGING) { AngelDebug::Initialize(); }

	PerTick::register(update);
	PerFrameGame::register(render);
	PerFrameMenu::register(renderMenu);

}


// --------------------------------
// SECTION 4. Scrap Code



external class Room;
serialize LightContainmentZone@ lcz;
external Zone@ test_shared_global;

external enum RoomType;
external int testCounter;

void initRooms_OBSOLETE() {

	// OBSOLETE REGISTRATION CODE AND ZONE TESTING --------
	lcz.registerRoom("hll_plain_4_empty_a", Room4);
	lcz.registerRoom("hll_plain_4_empty_b", Room4);
	lcz.registerRoom("hll_plain_4_walkway", Room4);

	lcz.registerRoom("hll_plain_3_empty_a", Room3);
	lcz.registerRoom("hll_plain_3_empty_b", Room3);
	lcz.registerRoom("hll_plain_3_elecbox", Room3);
	lcz.registerRoom("hll_plain_3_pipes", Room3);
	lcz.registerRoom("hll_plain_3_walkway", Room3);

	lcz.registerRoom("hll_plain_2c_empty_a", Room2C);
	lcz.registerRoom("hll_plain_2c_empty_b", Room2C);
	lcz.registerRoom("hll_plain_2c_elecbox", Room2C);
	lcz.registerRoom("hll_plain_2c_fan", Room2C);
	lcz.registerRoom("hll_plain_2c_walkway", Room2C);

	lcz.registerRoom("hll_plain_2_empty", Room2);
	lcz.registerRoom("hll_plain_2_cornerdoor", Room2);
	lcz.registerRoom("hll_plain_2_elecbox", Room2);
	lcz.registerRoom("hll_plain_2_fan", Room2);
	lcz.registerRoom("hll_plain_2_pipes", Room2);
	lcz.registerRoom("hll_plain_2_ventdoors", Room2);
	lcz.registerRoom("hll_plain_2_ventgate", Room2);
	lcz.registerRoom("hll_plain_2_walkway", Room2);

	lcz.registerRoom("hll_plain_1_empty_a", Room1);
	lcz.registerRoom("hll_plain_1_empty_b", Room1);
	lcz.generate();
}




