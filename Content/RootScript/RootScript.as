// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: RootScript/RootMain.as					//
// Source: https://github.com/juanjp600/scpcb/Content/			//
// Purpose:								//
//	- Background engine tasks					//
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
shared string rootDirData	= "Data/";

shared string rootDirGFX	= rootDirAssets + "GFX/";
shared string rootDirLoadscreens = rootDirGFX + "Loadingscreens/";
shared string rootDirGFXItems	= rootDirGFX + "Items/";
shared string rootDirGFXMenu	= rootDirGFX + "Menu/";

shared string rootDirCBR	= rootDirAssets + "Map/";
shared string rootDirCBR_LCZ	= rootDirCBR + "LightContainmentZone/";
shared string rootDirCBR_HCZ	= rootDirCBR + "HeavyContainmentZone/";
shared string rootDirCBR_ETZ	= rootDirCBR + "EntranceZone/";

shared string rootDirSFX	= rootDirAssets + "SFX/";



namespace RootScript {

	void initialize() {
		GUI::Initialize();
	}
	void renderMenu(float interp) {
		GUI::startRender();
	}
	void render(float interp) {
	}
	void update(uint32 tick, float timeStep) {
	}
	void updateAlways(uint32 tick, float timeStep) {
		GUI::startUpdate();
	}
	void exit() { }
}
void main() {
	RootScript::initialize();
	PerTick::register(RootScript::update);
	PerEveryTick::register(RootScript::updateAlways);
	PerFrame::register(RootScript::render);
	PerEveryFrame::register(RootScript::renderMenu);
}
void exit() { RootScript::exit(); }

