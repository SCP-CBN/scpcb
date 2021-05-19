// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: SCPCB/Game/Game.as						//
// Source: https://github.com/juanjp600/scpcb/Content/			//
// Script File Author(s): Pyro-Fire					//
// Purpose:								//
//	- General purpose Game namespace				//
//									//
//									//
// -------------------------------------------------------------------- \\
// Documentation
//
//	SECTION 1. Game Platform
//		- Game : General purpose Game namespace.
//		- Game::World : The gameworld and physics and stuff
//		- Misc : Other general stuff not yet sorted to a better place.
//		- Timer : Used for delayed functions.
//
//									//
// -------------------------------------------------------------------- \\
// #### SECTION 1. Game Platform ----
namespace Game {

}


namespace Game {

	// # Tick updates
	int tick { get { return Environment::tick; } set { Environment::tick=value; } }
	Hook@ tickHook=Hook("tick");

	//Util::TickFunction@ updateFunc=@Util::noopTick;

	void initialize() {
		Environment::paused = true;
		initLoad();
	}
	void exit() {

	}

	// Inputs are updated before each tick update
	// Is not called while Environment::paused==true.
	void update(uint32 tick, float interp) { // tick++;
		Environment::interp=interp;
		Environment::fpsFactor=Util::fpsFactor(interp);
		//Debug::log("Tick: " + toString(tick) + "," + toString(interp) + ", Real " + toString(Environment::tickRate) + ", Est " + toString(1/avgTickrate));
		Timer::update(tick);
		tickHook.call();
		Game::Pickables::update(tick,interp);
		Game::World::update(tick,interp);
	}
	void updateAlways(uint32 tick, float interp) {
		Environment::interp=interp;
		Environment::fpsFactor=Util::fpsFactor(interp);
		updateMenuState(tick,interp);
		Game::World::updateAlways(tick,interp);
		if(queuedNewGame) {
			BuildNewGame();
			queuedNewGame=false;
		}
		if(DEBUGGING) { AngelDebug::update(interp); }
		float deltaCtrl=0.f;
		if(!Environment::paused) { deltaCtrl=interp; }
		__UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(Player::Controller, Input::getDown(), deltaCtrl );
	}
	void render(float interp) {
		Environment::interp=interp;
		Environment::fpsFactor=Util::fpsFactor(interp);
		if(DEBUGGING) { AngelDebug::render(interp); }
		Game::World::render(interp);
	}
	void renderMenu(float interp) {
		Environment::interp=interp;
		Environment::fpsFactor=Util::fpsFactor(interp);
		//Debug::log("Render: " + toString(interp) + ", Real " + toString(Environment::frameRate) + ", Est " + toString(1/avgFramerate));
		if(DEBUGGING) { AngelDebug::renderMenu(interp); }
		//Game::World::renderMenu(interp);
	}
	void renderAlways(float interp) {
		Environment::interp=interp;
		Environment::fpsFactor=Util::fpsFactor(interp);
		Game::World::renderAlways(interp);
	}

	void resolutionChanged(int newWidth, int newHeight) {
	}




	void updateMenuState(uint32 tick,float interp) {
		if(Input::getHit() & Input::Inventory != 0) { Debug::log("hotkey Open Inventory"); }
		else if(Input::getHit() & Input::ToggleConsole != 0) { Debug::log("hotkey Open Console"); ConsoleMenu.open(); }
		else if(Input::getHit() & Input::Crouch != 0) { Debug::log("hotkey Crouch"); }
		else if(Input::Escape::isHit()) {
			Debug::log("Escape was pressed11"); // Apparently this code doesn't run without calling a Debug.log. isHit() is weird.
			bool menuWasOpen=false;
			for(int i=0; i<GUI::baseInstances.length(); i++) {
				if(GUI::baseInstances[i].visible==true && GUI::baseInstances[i].cls!="HUD") {
					menuWasOpen=true;
					GUI::baseInstances[i].visible=false;
				}
			}
			if(menuWasOpen==true) {
				Environment::paused=false;
			} else {
				Menu::pause();
			}
		}
	}
}


// # Game::load; Used by a repeating timer.
namespace Environment {
	string loadPart="Booting up...";
	string loadMessage="[$/C++]";
}

namespace Game {
	void initLoad() {
		Debug::log(Environment::loadPart + " " + Environment::loadMessage);
		//Introscreen::initialize(); // Ahh!!
		// PlayIntroMovie();
		Loadscreen::initialize();
		Loadscreen::activate("SCP-173");
		Environment::loadMessage="scripts";
	}
	void loadNext(string&in nextPart) {
		Debug::log("Loading Next: " + nextPart + " --------");
		Environment::loadPart="Loaded : " + nextPart + "...";
		Environment::loadMessage="";
		Environment::loadState++;
		Environment::loadDone=0;
	}
	string loadMessage { set { Environment::loadMessage=value; } }
	void renderLoading(float interp) {}
	void updateLoading(float interp) {
		Debug::log(Environment::loadPart + " " + Environment::loadMessage);
		LoadingMenu.setProgress(0.f);

		switch(Environment::loadState) {
		case 0:
			loadNext("World");
			World::initialize();
			loadMessage="done!";
			break;
		case 1:
			LoadingMenu.setProgress(0.1f);
			loadNext("Player");
			Player::Initialize();
			loadMessage="done!";
			break;
		case 2:
			LoadingMenu.setProgress(0.2f);
			loadNext("Items");
			Item::startLoading();
			break;
		case 3:
			LoadingMenu.setProgress(0.2f+(Environment::loadDone/Environment::loadMax)*0.2f);
			if(Item::load()) { Item::finishLoading(); Prop::startLoading(); loadNext("Props"); }
			else { Environment::loadDone++; }
			break;
		case 4:
			LoadingMenu.setProgress(0.4f+(Environment::loadDone/Environment::loadMax)*0.2f);
			if(Prop::load()) { Prop::finishLoading(); Room::startLoading(); loadNext("Rooms"); }
			else { Environment::loadDone++; }
			break;
		case 5:
			LoadingMenu.setProgress(0.6f+(Environment::loadDone/Environment::loadMax)*0.2f);
			if(Environment::loadDone >= 10) { loadNext("SKIP LOADING TOO MANY ROOMS"); } // it takes a while
			else if(Room::load()) { Room::finishLoading(); loadNext("Game"); }
			else { Environment::loadDone++; }
			break;
		case 6:
			LoadingMenu.setProgress(0.85f);
			loadNext("Zones...");
		//	@lcz = LightContainmentZone();
		//	@test_shared_global = @lcz;
			loadMessage="done!";
			break;
		case 7:
			LoadingMenu.setProgress(0.9f);
			loadNext("AngelDebug");
			if(DEBUGGING) { AngelDebug::load(); }
			loadMessage="done!";
			break;
		case 8:
			LoadingMenu.setProgress(0.95f);
			loadNext("Starting up");
			if(DEBUGGING) { AngelDebug::initialize(); }
			@MainMenu=menu_Main();
			Menu::Pause::load();
			@ConsoleMenu=menu_Console();
			LoadingMenu.setProgress(1.f);
			break;
		case 9:
			loadNext("Finished!");
			LoadingMenu.visible=false;
			MainMenu.visible=true;
			Menu::Pause::instance.visible=false;
			break;
		default:
			Environment::loading=false;
			HUD::initialize();

			break;
		}
	}
}

// # Utility Models ----
namespace Util {
	// Primary purpose is to store resource data without actually loading the resource.
	// Secondary purpose is to abstractify this resource data and generate instances of the resources without creating new copies.
	// This is defined here instead of util because of the need for Game::Model@ instantiate(), unless that too is ported to Util.

	// # Util::Model@ ----
	abstract class Model {
		string path;
		string skin;
		Vector3f scale;
		bool pickable;
		Texture@ texture; //keep-texture-alive;
		CMaterial@ material;
		Model(string iPath, float&in iScale=1.f, string&in iSkin="") { path=iPath; scale=Vector3f(iScale); skin=iSkin; }
		Model(string iPath, Vector3f&in iScale, string&in iSkin="") { path=iPath; scale=iScale; skin=iSkin; }
		void construct() {
			if(skin!="") {
				@texture=@Texture::get(skin);
				@material=@CMaterial::create(@texture);
			}
		}
		Game::Model@ instantiate() { return (pickable ? cast<Game::Model@>(Game::Model::Picker(@this)) : (Game::Model(@this))); }
	}
}

// # Game::Model@ ----
// A CModel mesh object.
namespace Game { class Model {
	CModel@ mesh;
	Model(string&in cPath, float&in cScale=1.f, CMaterial@ cMaterial=null) { create(cPath,Vector3f(cScale),@cMaterial); }
	Model(string&in cPath, Vector3f&in cScale, CMaterial@ cMaterial=null) { create(cPath,cScale,@cMaterial); }
	Model(Util::Model@&in iMdl) { create(iMdl.path,iMdl.scale,@iMdl.material); }
	void create(string&in cPath, Vector3f&in cScale=Vector3f(1.f), CMaterial@ mat=null) {
		@mesh=CModel::create(cPath);
		mesh.position=Vector3f(0,0,0);
		mesh.rotation=Vector3f(0,0,0);
		mesh.scale=cScale;
		@material=@mat;
		if(@material != null) { mesh.setMaterial(@material); }
	}
	~Model() { CModel::destroy(mesh); }
	bool isPickable;
	bool pickable;
	Vector3f position { get { return mesh.position; } set { mesh.position = value; } }
	Vector3f rotation { get { return mesh.rotation; } set { mesh.rotation = value; } }
	Vector3f scale { get { return mesh.scale; } set { mesh.scale = value; } }
	CMaterial@ material;
	string skin;
	// string skin { get { return mesh.skin; } set { mesh.skin=value; } }
	void render() { mesh.render(); }

	bool physAlive;
	int physGravity = 0.5;
} }


// # Game::Pickables; (namespace) ----
// Pickable manager

namespace Game { namespace Pickables {
	array<Game::Model::Picker@> activePickers;
	void activate(Game::Model::Picker@&in picker) {
		if(!picker._pickerActive) { // runOnce
			picker._pickerActive=true;
			Pickable::activatePickable(picker._picker);
			activePickers.insertLast(@picker);
		}
	}
	void deactivate(Game::Model::Picker@&in picker) {
		if(picker._pickerActive) {
			picker._pickerActive=false;
			Pickable::deactivatePickable(picker._picker);
			// Util::Array::removeByValue(activePickers,@picker);
			for(int i=0; i<activePickers.length(); i++) { if(@activePickers[i]==@picker) { activePickers.removeAt(i); break; } }
		}
	}
	void update(uint32&in tick, float&in interp) {
		for(int i=0; i<activePickers.length(); i++) {
			Game::Model::Picker@ picker=activePickers[i];
			if(picker.picked) {
				if(!picker.wasPicked) {
					picker.wasPicked=true;
					picker.onPicked();
				}
			} else if(picker.wasPicked) {
				picker.wasPicked=false;
			}
		}
	}
} }

// # Game::Model::Pickable@ ----
// A world-model mesh object with a world picker.
namespace Game { namespace Model { class Picker : Game::Model {
	Pickable@ _picker;
	bool _pickerActive;
	Util::Function@ onPicked;
	Picker(string cPath, float&in cScale=1.f, CMaterial@&in cMaterial=null) { super(cPath,Vector3f(cScale),@cMaterial); createPicker(); }
	Picker(string cPath, Vector3f&in cScale, CMaterial@&in cMaterial=null) { super(cPath,cScale,@cMaterial); createPicker(); }
	Picker(Util::Model@&in iMdl) { super(@iMdl); createPicker(); }
	void createPicker() {
		@_picker=Pickable();
		_picker.position=position;
		pickable=true;
		isPickable=true;
		@onPicked=@Util::noop;
	}

	~Picker() { CModel::destroy(mesh); Pickable::deactivatePickable(_picker); }
	Vector3f position { get { return mesh.position; } set { mesh.position = value; _picker.position = value; } }
	bool picked { get { return _picker.getPicked(); } }
	bool wasPicked;
	bool _pickable;
	bool pickable { get { return _pickable; } set { _pickable=value;
		if(value) { Game::Pickables::activate(@this); }
		else { Game::Pickables::deactivate(@this); }
	} }


} } }




// # Game::Room@ ----
// A world matrix mesh

namespace Game { class Room {
	RM2@ mesh;
	Room() {}
	Room(string&in cPath) { create(cPath); }
	Room(Room::Model@&in iMdl) { create(iMdl.path); }
	void create(string&in cPath) {
		@mesh=RM2::load(cPath);
	}
	~Room() { RM2::delete(@mesh); }

	Collision::Collection@ meshCollisions;

	void render(Matrix4x4f&in matrix) { mesh.render(matrix); }
	array<Collision::Instance> getCollision() { return array<Collision::Instance>(mesh.collisionMeshCount()); }
	void appendCollisionsToWorld(Matrix4x4f&in matrix) {
		auto meshes=array<Collision::Instance>(mesh.collisionMeshCount());
		for(int i=0; i<mesh.collisionMeshCount(); i++) {
			Collision::Instance collider = Game::World::Collision.addInstance(mesh.getCollisionMesh(i),matrix);
			Game::World::Collision.updateInstance(collider,matrix);
		}
	}

} }

// # Game::RoomCBR@ ----
// A world matrix mesh

namespace Game { class RoomCBR : Room {
	CBR@ meshcbr;
	RoomCBR(string&in cPath) { super(); create(cPath); }
	RoomCBR(Room::ModelCBR@&in iMdl) { create(iMdl.path); }
	void create(string&in cPath) { @meshcbr=CBR::load(cPath); }
	~RoomCBR() { CBR::delete(@meshcbr); }

	void render(Matrix4x4f&in matrix) { meshcbr.render(matrix); }
	array<Collision::Instance> getCollision() { return array<Collision::Instance>(meshcbr.collisionMeshCount()); }
	void appendCollisionsToWorld(Matrix4x4f&in matrix) {
		array<Collision::Instance> meshes=array<Collision::Instance>(meshcbr.collisionMeshCount());
		for(int i=0; i<meshcbr.collisionMeshCount(); i++) {
			Collision::Instance collider = Game::World::Collision.addInstance(meshcbr.getCollisionMesh(i),matrix);
			Game::World::Collision.updateInstance(collider,matrix);
		}
	}

} }




// # Game::World --------
namespace Game { namespace World {
	Collision::Collection@ Collision;
	void initialize() {
		@Collision=Collision::Collection();
	}
	void update(uint32 tick, float interp) { // tick++;

	}
	void updateAlways(uint32 tick, float interp) {
		Item::updateAll();
		Room::updateAll();
		Prop::updateAll();
	}
	void render(float interp) {

	}
	void renderAlways(float interp) {
		Item::renderAll();
		Room::renderAll();
		Prop::renderAll();
	}
} }


// #### SECTION 6. Timer ----

// # util->Timer ----
//external class Timer;
//external class TickTimer;
//namespace Timer { external funcdef void Repeater(Timer@&in tmr); }
//external void Timer::start(int tock, Util::Function@ func);
//external void Timer::on(int tock, Util::Function@ func);
//external Timer@ Timer::repeat(int tock, Timer::Repeater@ func);
//external void Timer::Stop(Timer@ tmr);
//external void Timer::Stop(TickTimer@ tmr);
//external void Timer::update(uint32 tick);

// # TickTimer@ ----
// A one-time timer.
class TickTimer {
	int tickTarget;
	Util::Function@ func;
	TickTimer(int tick, Util::Function@&in f) { tickTarget=tick; @func=@f; }
	void tryTimer(uint32 tick) { if(tick>=tickTarget) { func(); } }
	void stop() { Timer::Stop(@this); }
}

// # Timer@ ----
// A repeating timer.
class Timer {
	int tickTarget;
	int tickStart;
	Timer::Repeater@ func;
	Timer(int tick, Timer::Repeater@&in f) { tickStart=Game::tick+tick; tickTarget=tick; @func=@f; }
	void tryTimer(uint32 tick) { if((tick-tickStart)%tickTarget==0) { func(@this); } }
	void stop() { Timer::Stop(@this); }
}

// # Timer:: ----
// Timer namespace for calling, creating and managing timers.

namespace Timer {
	funcdef void Repeater(Timer@&in);
	array<TickTimer@> tickTimers;
	array<Timer@> tickRepeaters;
	void start(int tock, Util::Function@ func) {
		TickTimer@ ticker=TickTimer(Game::tick+tock,@func);
		tickTimers.insertLast(@ticker);
	}
	void on(int tock, Util::Function@ func) {
		TickTimer@ ticker=TickTimer(tock,@func);
		tickTimers.insertLast(@ticker);
	}
	Timer@ repeat(int tock, Repeater@ func) {
		Timer@ ticker=Timer(tock,@func);
		tickRepeaters.insertLast(@ticker);
		return @ticker;
	}
	void Stop(Timer@ tmr) {
		for(int i=0; i<tickRepeaters.length(); i++) { if(@tickRepeaters[i]==@tmr) { tickRepeaters.removeAt(i); break; } }
	}
	void Stop(TickTimer@ tmr) {
		for(int i=0; i<tickTimers.length(); i++) { if(@tickTimers[i]==@tmr) { tickTimers.removeAt(i); break; } }
	}

	void update(uint32 tick) {
		for(int i=0; i<tickTimers.length(); i++) { tickTimers[i].tryTimer(tick); }
		for(int i=0; i<tickRepeaters.length(); i++) { tickRepeaters[i].tryTimer(tick); }
	}
}




