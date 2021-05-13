// Script: RootScript/BaseClasses/World.as
// Purpose: Generic baseclasses such as World::Model with a model and coordinates.


namespace Util {
	shared int tick;
	shared class Model {
		::Model@ mesh;
		Model(string&in cpath) {
			@mesh=::Model::create(cpath);
			mesh.position=Vector3f(0,0,0);
			mesh.rotation=Vector3f(0,0,0);
			mesh.scale=Vector3f(1,1,1);
		}
		~Model() { ::Model::destroy(mesh); }
		Vector3f position { get { return mesh.position; } set { mesh.position = value; } }
		Vector3f rotation { get { return mesh.rotation; } set { mesh.rotation = value; } }
		Vector3f scale { get { return mesh.scale; } set { mesh.scale = value; } }
		void render() { mesh.render(); }

		bool physAlive;
		int physGravity = 0.5;
	}


	shared abstract class Icon {

		// Texture must be built during execution stage.

		Texture@ texture;

		Icon() {}

	}

	shared class ModelPicker : Model {
		Pickable@ picker;
		ModelPicker(string&in cpath) { super(cpath);
			@picker=Pickable();
			picker.position=Vector3f(0,0,0);
			pickable(true);
		}
		~ModelPicker() { ::Model::destroy(mesh); pickable(false); }
		Vector3f position { get { return mesh.position; } set { mesh.position = value; picker.position = value; } }
		bool picked { get { return picker.getPicked(); } }
		void pickable(bool pick) {
			if(pick) {
				Pickable::activatePickable(picker);
			} else {
				Pickable::deactivatePickable(picker);
			}
		}
	}

	shared class ModelIcon : Icon {
		string iconPath;
		float iconScale;
		Vector3d iconRot;
		Vector2d iconPos;
		ModelIcon(string&in cpath, float&in cscale, Vector3d&in crot, Vector2d&in cpos) { super();
			iconPath=cpath;
			iconScale=cscale;
			iconRot=crot;
			iconPos=cpos;
			@texture = ModelImageGenerator::generate(iconPath, iconScale, iconRot(), iconPos());
		}
	}

}


namespace Hook {
	shared funcdef void Function();
	shared array<Hook@> hooks;
	shared Hook@ Fetch(string name) {
		for(int i=0; i<hooks.length(); i++) { if(hooks[i].name==name) { return @hooks[i]; } }
		return null;
	}
	shared Hook@ Create(string name) { Hook@ h = Hook(name); return @h; }
	shared void Destroy(Hook@&in h) { for(int i=0; i<hooks.length(); i++) { if(@hooks[i]==@h) { hooks.removeAt(i); return; } } }
}

shared class Hook {
	Hook(string nm) { Hook::hooks.insertLast(@this); name=nm; }
	~Hook() {}
	string name;
	array<Hook::Function@> funcs;
	void add(Hook::Function@&in func) { funcs.insertLast(@func); }
	void call() { for(int i=0; i<funcs.length(); i++) { funcs[i](); } }
	void remove(Hook::Function@&in func) { for(int i=0; i<funcs.length(); i++) { if(@func==@funcs[i]) { funcs.removeAt(i); return; } } }
}



shared class TickTimer {
	int tickTarget;
	Timer::Function@ func;
	TickTimer(int tick, Timer::Function@&in f) { tickTarget=tick; @func=@f; }
	void Test() { if(Util::tick>=tickTarget) { func(); } }
}
shared class Timer {
	int tickTarget;
	int tickStart;
	Timer::Repeater@ func;
	Timer(int tick, Timer::Repeater@&in f) { tickStart=Util::tick+tick; tickTarget=tick; @func=@f; }
	void Test() { if((Util::tick-tickStart)%tickTarget==0) { func(@this); } }
}

//external int Game::tick;
namespace Timer {
	funcdef void Function();
	funcdef void Repeater(Timer@&in);
	shared array<TickTimer@> tickTimers;
	shared array<Timer@> tickRepeaters;
	shared void Start(int tock, Function@ func) {
		TickTimer@ ticker=TickTimer(Util::tick+tock,@func);
		tickTimers.insertLast(@ticker);
	}
	shared void On(int tock, Function@ func) {
		TickTimer@ ticker=TickTimer(tock,@func);
		tickTimers.insertLast(@ticker);
	}
	shared Timer@ Repeat(int tock, Repeater@ func) {
		Timer@ ticker=Timer(tock,@func);
		tickRepeaters.insertLast(@ticker);
		return @ticker;
	}
	shared void Stop(Timer@ tmr) {
		for(int i=0; i<tickRepeaters.length(); i++) { if(@tickRepeaters[i]==@tmr) { tickRepeaters.removeAt(i); break; } }
	}
	shared void Stop(TickTimer@ tmr) {
		for(int i=0; i<tickTimers.length(); i++) { if(@tickTimers[i]==@tmr) { tickTimers.removeAt(i); break; } }
	}

	shared void update() {
		for(int i=0; i<tickTimers.length(); i++) { tickTimers[i].Test(); }
		for(int i=0; i<tickRepeaters.length(); i++) { tickRepeaters[i].Test(); }
	}
}


shared class FloatInterpolator {
	private float prevValue = 0.f;
	private float currValue = 0.f;


	void update(float value) {prevValue = currValue;currValue = value;}

	float lerp(float interpolation) {return prevValue + (currValue - prevValue) * interpolation;}

}

