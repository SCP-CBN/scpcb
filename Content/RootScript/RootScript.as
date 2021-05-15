// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: RootScript/RootMain.as						//
// Source: https://github.com/juanjp600/scpcb/Content/			//
// Purpose:								//
//	- Background engine tasks					//
//									//
// -------------------------------------------------------------------- //
// Authors:								//
//	- Juan								//
//	- Salvage							//
//	- Pyro-Fire							//
//									//
//									//
// -------------------------------------------------------------------- //
// Links:								//
//	- Website : https://www.scpcbgame.com				//
//	- Discord : https://discord.gg/undertow				//
//									//
//									//
//									//
// -------------------------------------------------------------------- //
// Licence:								\\
// 
// insert license here
// 
//									//
// -------------------------------------------------------------------- \\
// Documentation
//
//
//	SECTION 1. x
//		- Root engine hooks
//
//									//
// -------------------------------------------------------------------- \\
// #### SECTION 1. Engine Hooks ----

string rootDir		= "RootScript/";
string rootDirScript	= rootDir + "BaseClasses/";

// Global Paths
shared string rootDirAssets	= "SCPCB/";


shared string rootDirGFX	= rootDirAssets + "GFX/";
shared string rootDirLoadscreens = rootDirGFX + "Loadscreens/";
shared string rootDirGFXItems	= rootDirGFX + "Items/";
shared string rootDirGFXMenu	= rootDirGFX + "Menu/";

shared string rootDirCBR	= rootDirAssets + "CBR/";
shared string rootDirCBR_LCZ	= rootDirCBR + "LCZ/";
shared string rootDirCBR_HCZ	= rootDirCBR + "HCZ/";
shared string rootDirCBR_ETZ	= rootDirCBR + "ETZ/";

shared string rootDirSFX	= rootDirAssets + "SFX/";


/*

namespace RootScript {
	void Initialize() {
	}
	void renderMenu(float interp) {
	}
	void render(float interp) {
		
	}
	void update(float interp) {
	}
	void exit() { }
}
void main() { RootScript::Initialize(); PerTick::register(RootScript::update); PerFrameGame::register(RootScript::render); PerFrameMenu::register(RootScript::renderMenu); }
void exit() { RootScript::exit(); }
*/
