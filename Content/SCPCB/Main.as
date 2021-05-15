// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: SCPCB/Main.as						//
// Source: https://github.com/juanjp600/scpcb/Content/			//
// Purpose:								//
//	- Import externals						//
//	- Prepare environment						//
//	- Engine hooks							//
//	- Game entrypoint						//
//									//
// -------------------------------------------------------------------- //
// Links:								//
//	- Website : https://www.scpcbgame.com				//
//	- Discord : https://discord.gg/undertow				//
//									//
//									//
//									//
// -------------------------------------------------------------------- \\
// Documentation
//
//
//	1. Import
//		# Util
//		- AngelMath : General math functions and offsets/directions etc for Angelscript.
//		- AngelString : General string functions for Angelscript.
//		- AngelUI : General draw functions
//		- IconHandler : Generic icon handler for polymorphism to modelIcons.
//		- Hook : A function call replicator.
//		# GUI
//		- GUI : User Interface / Menu Engine.
//		# Console
//		- Console : C++ interface.
//
//	2. Entrypoint
//		- Engine Hooks : Tick/render/exit/etc.
//		- main() : void main, the entry point to the SCPCB script.
//
//	3. Scrap code
//		- If you don't have a better place to put it...
//
//									//
// -------------------------------------------------------------------- \\
// Begin Script

bool DEBUGGING = true;

// # import(RootScript/RootMain.as); ----
string rootDir		= "SCPCB/";
string rootDirScript	= rootDir + "Game/";

external string rootDirAssets;

external string rootDirLoadscreens;

external string rootDirGFX;
external string rootDirGFXItems;
external string rootDirGFXMenu;

external string rootDirSFX;
external string rootDirCBR;


// #### SECTION 1. Import ----

// # import(RootScript/BaseClasses/Utility/Util.as); ----

namespace Util { external funcdef void Function(); }

// # util->AngelMath ----
namespace Util { external class FloatInterpolator; } // Number smoothing

// # util->AngelString ----
external int String::findFirstChar(string&in str,string&in delim);
external string String::substr(string&in str, int&in start, int&in end);
external array<string> String::explode(string&in str, string&in delim);
external string String::implode(array<string>&in words, string&in delim);

// # util->AngelUI ----
external void UI::drawSquare(Rectanglef&in square, Color&in col=Color::White, Texture@&in tex=null, bool tileTexture=false);

// # util->IconHandler ----
namespace Util { external class Icon; } // Generic abstract icon
namespace Util { external class Icon::Model; } // Model icon

// # util->Hook
external class Hook;
external void Hook::destroy(Hook@&in h);
external Hook@ Hook::fetch(string&in name);


// # import(RootScript/BaseClasses/GUI.as); ----
namespace GUI { external enum Align; }
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
	external funcdef void TextEnteredFunc(string&in input);
	external Texture@ Skin::menublack;
	external Texture@ Skin::menuwhite;
	external Texture@ Skin::menuMain;
	external Texture@ Skin::menuPause;
	external Texture@ Skin::menuSCPLabel;
	external Texture@ Skin::menuSCP173;
}

// # import(RootScript/BaseClasses/Entities/Item.as); ----
//external class Item;

//external void Item::updateAll();
//external void Item::renderAll();

//external Item@ Item::spawn(const string&in name, const Vector3f&in position);
//external Item@ Item::spawn(const string&in name, const Vector3f&in position, const Vector3f&in rotation);


// # import(RootScript/BaseClasses/Utility/GUI.as -> $C++/Console); ----
//external class ConsoleMenu { ConsoleMenu@ instance; }
//ConsoleMenu@ ConsoleMenu::instance;
//external void Console::addMessage(const string&in msg, const Color&in color = Color::White);

// #### SECTION 2. Entrypoint ----


// # Engine Hooks --------
void renderMenu(float interp) { Game::renderMenu(interp); }
void render(float interp) { Game::render(interp); }
void update(float interp) { Game::update(interp); }
void mainEngine() { PerTick::register(update); PerFrameGame::register(render); PerFrameMenu::register(renderMenu); }
void exit() { Game::exit(); Debug::log("GAME OVER, YEAH!"); }
void main() { mainEngine(); Game::initialize(); }


// --------------------------------
// SECTION 4. Scrap Code

// # Misc --------
bool queuedNewGame=false;
void QueueNewGame() {
	World::paused=false;
	Loadscreen::activate("SCP-173");
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




