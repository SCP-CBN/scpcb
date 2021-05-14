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
	int tick;
	shared Hook@ tickHook=Hook("tick");

	void Initialize() {
		GUI::Initialize();
		Game::World::Initialize();
		Player::Initialize();

		Util::Function @tf = @onTick;
		Hook::fetch("tick").add(@tf);

		Loadscreen::Initialize();
		@MainMenu=menu_Main();
		@PauseMenu=menu_Pause();
		@ConsoleMenu=menu_Console();
	}

	void onTick() { // Immediately after tick is incremented and timers are called
	}

	void update(float interp) {
		tick++;
		Timer::update();
		tickHook.call();
		updateMenuState(); // Escape doesn't always capture in renderMenu ??
		GUI::startUpdate();
		Game::World::update();
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
		else if(Input::getHit() & Input::ToggleConsole != 0) { Debug::log("hotkey Open Console"); ConsoleMenu.open(); }
		else if(Input::getHit() & Input::Crouch != 0) { Debug::log("hotkey Crouch"); }
		else if(Input::Escape::isHit()) {
			Debug::log("Escape was pressed11"); // Apparently this code doesn't run without calling a Debug.log. isHit() is weird.
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

// # Game::Model@ ----
// A world-model mesh object.

namespace Game { class Model {
	::Model@ mesh;
	Model(string&in cpath,string&in skin="") {
		@mesh=::Model::create(cpath);
		mesh.position=Vector3f(0,0,0);
		mesh.rotation=Vector3f(0,0,0);
		mesh.scale=Vector3f(1,1,1);
		//mesh.skin=skin;
	}
	~Model() { ::Model::destroy(mesh); }
	Vector3f position { get { return mesh.position; } set { mesh.position = value; } }
	Vector3f rotation { get { return mesh.rotation; } set { mesh.rotation = value; } }
	Vector3f scale { get { return mesh.scale; } set { mesh.scale = value; } }
	string skin;
	// string skin { get { return mesh.skin; } set { mesh.skin=value; } }
	void render() { mesh.render(); }

	bool physAlive;
	int physGravity = 0.5;
} }


// # Game::Model::Pickable@ ----
// A world-model mesh object with a world picker.

namespace Game { namespace Model { class Picker : Game::Model {
	Pickable@ _picker;
	Picker(string&in cpath,string&in skin="") { super(cpath,skin);
		@_picker=Pickable();
		_picker.position=position;
		pickable=true;
	}
	~Picker() { ::Model::destroy(mesh); pickable=false; }
	Vector3f position { get { return mesh.position; } set { mesh.position = value; _picker.position = value; } }
	bool picked { get { return _picker.getPicked(); } }
	bool _pickable;
	bool pickable { get { return _pickable; } set { _pickable=value;
		if(value) { Pickable::activatePickable(_picker); }
		else { Pickable::deactivatePickable(_picker); }
	} }
} } }



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
//external void Timer::update();

// # TickTimer@ ----
// A one-time timer.
class TickTimer {
	int tickTarget;
	Util::Function@ func;
	TickTimer(int tick, Util::Function@&in f) { tickTarget=tick; @func=@f; }
	void tryTimer() { if(Game::tick>=tickTarget) { func(); } }
	void stop() { Timer::Stop(@this); }
}

// # Timer@ ----
// A repeating timer.
class Timer {
	int tickTarget;
	int tickStart;
	Timer::Repeater@ func;
	Timer(int tick, Timer::Repeater@&in f) { tickStart=Game::tick+tick; tickTarget=tick; @func=@f; }
	void tryTimer() { if((Game::tick-tickStart)%tickTarget==0) { func(@this); } }
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

	void update() {
		for(int i=0; i<tickTimers.length(); i++) { tickTimers[i].tryTimer(); }
		for(int i=0; i<tickRepeaters.length(); i++) { tickRepeaters[i].tryTimer(); }
	}
}




