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
external string rootDirGFXProps;
external string rootDirGFXMenu;

external string rootDirSFX;
external string rootDirCBR;
external string rootDirCBRTextures;
external string rootDirCBR_SCP;
external string rootDirCBR_LCZ;
external string rootDirCBR_HCZ;
external string rootDirCBR_ETZ;
external string rootDirCBR_Objects;


namespace Environment {
	float fpsFactor; // todo
	float interp; // todo
}

namespace Util { external float fpsFactor(float interp); }


// #### SECTION 1. Import ----

// # import(RootScript/BaseClasses/Utility/Util.as); ----

namespace Util {
	external funcdef void Function();
	external funcdef void TickFunction(uint32 tick, float interp);
	external funcdef void RenderFunction(float interp);
	external void noop();
	external void noopTick(uint32 tick, float interp);
	external void noopRender(float interp);
}

// # util->AngelMath ----
namespace Util { external class FloatInterpolator; } // Number smoothing
namespace Util { namespace Vector2f {
	external Vector2f rotate(Vector2f&in vec, float&in ang);
} }
namespace Math {
	shared float pi2f=Math::PI*2.f;
	shared float PI2f=Math::PI*2.f;
}

// Vector3f::rotate(Vec,angle);
namespace Util { namespace Vector3f {
	external Vector3f rotate(Vector3f&in vec, float&in angle);
	external Vector3f rotate(Vector3f&in vec, Vector3f&in angle);
	external Vector3f localToWorldPos(Vector3f&in origin, Vector3f&in originAng, Vector3f&in localPos);
	external Vector3f localToWorldPos(Vector3f&in origin, float&in originAng, Vector3f&in localPos);
} }

// # util->AngelString ----
namespace String {
	external int findFirstChar(string&in str,string&in delim);
	external string substr(string&in str, int&in start, int&in end);
	external array<string> explode(string&in str, string&in delim);
	external string implode(array<string>&in words, string&in delim);
	external string appendAt(string&in str, int&in at, string&in with);
	external string subtractAt(string&in str, int&in at, int&in amt);
	external array<int> findCharsBetweenPoints(Font@&in font, float&in fontScale, string&in msg, float&in startPos, float&in endPos);
	external int findCharFromChar(Font@&in font, float&in fontScale, string&in msg, int&in start, float&in endPos);
	external int findCharFromPoint(Font@&in font, float&in fontScale, string&in msg, float&in point);
	external float substrWidth(Font@&in font, float&in fontScale, string&in msg, int&in char, int&in start=0);

	external class Glitch;
}

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
external class GUIProgressBar; // for blink panel and thelike.

external bool GUI::squareInSquare(Vector2f&in pos, Vector2f&in size, Vector2f&in sPos, Vector2f&in sSize);
external bool GUI::pointInSquare(Vector2f&in point, Vector2f&in pos, Vector2f&in size);

external float GUI::interp;
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
void render(float interp) { Game::render(interp); }
void renderMenu(float interp) { Game::renderMenu(interp); }
void renderLoading(float interp) { Game::renderLoading(interp); }
void renderAlways(float interp) { Game::renderAlways(interp); }
void update(uint32 tick, float interp) { Game::update(tick, interp); }
void updateAlways(uint32 tick, float interp) { Game::updateAlways(tick, interp); }
void updateLoading(float interp) { Game::updateLoading(interp); }
void resolutionChanged(int newWidth, int newHeight) { Game::resolutionChanged(newWidth, newHeight); }
void mainEngine() {
	PerFrame::register(render);
	PerMenuFrame::register(renderMenu);
	PerLoadFrame::register(renderLoading);
	PerEveryFrame::register(renderAlways);
	PerTick::register(update);
	PerLoadTick::register(updateLoading);
	PerEveryTick::register(updateAlways);
	ResolutionChanged::register(resolutionChanged);
}
void exit() { Game::exit(); Debug::log("GAME OVER, YEAH!"); }
void main() { mainEngine(); Game::initialize(); }


// --------------------------------
// SECTION 4. Scrap Code

// # Misc --------
bool queuedNewGame=false;
void QueueNewGame() {
	Environment::paused=false;
	Loadscreen::activate("SCP-173");
	queuedNewGame=true;
}
void BuildNewGame() {
	Environment::paused=true;
	//initRooms_OBSOLETE();
	Player::Controller.position=Vector3f(0,Player::height+5,0);
	Environment::paused=false;
	MainMenu.visible=false;
	Menu::Pause::instance.close();
	LoadingMenu.visible=false;
}


//external class Room;
//serialize LightContainmentZone@ lcz;
//external Zone@ test_shared_global;

//external enum RoomType;
//external int testCounter;

void initRooms_OBSOLETE() {

	// OBSOLETE REGISTRATION CODE AND ZONE TESTING --------

/*
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

*/

}




