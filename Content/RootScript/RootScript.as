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

	void initialize() { GUI::initialize(); }
	//void render(float interp) {}
	void renderMenu(float interp) { GUI::startRender(); }
	//void renderAlways(float interp) {}
	//void update(uint32 tick, float timeStep) {}
	void updateAlways(uint32 tick, float timeStep) { GUI::startUpdate(); }
	void resolutionChanged(int newWidth, int newHeight) { GUI::updateResolution(); }
	void exit() { }
}
void main() {
	RootScript::initialize();
	//PerFrame::register(RootScript::render);
	PerMenuFrame::register(RootScript::renderMenu);
	//PerEveryFrame::register(RootScript::renderAlways);
	//PerTick::register(RootScript::update);
	PerEveryTick::register(RootScript::updateAlways);
	ResolutionChanged::register(RootScript::resolutionChanged);
}
void exit() { RootScript::exit(); }

