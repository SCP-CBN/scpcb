// # Room::Type ----
namespace Room { enum Type {
    R1 = 1,
    R2 = 2,
    R2C = 3,
    R3 = 4,
    R4 = 5
} }

// # Room::Model@ ----
namespace Room { class Model {
	string path;
	Model(string&in iPath) { path=iPath; }
	Game::Room@ instantiate() { return Game::Room(path); }
} }

// # Room::Sound@ ----
namespace Room { class Sound {
	string path;
	Sound() {}
	Sound(int i) {} // picksoundid
	Sound(string&in iPath, float&in iScale, string&in iSkin="") { path=iPath; }
} }

// # Room::Icon@ and Room::Icon::Model@ ----
namespace Room {
	// Room::Icon@ ----
	class Icon : Util::Icon { Icon() {super();} Icon(string&in texStr) {super(texStr);} Icon(Texture@&in tex) {super(@tex);} }

	// Room::Icon::Model@ ----
	namespace Icon { class Model : Util::Icon::Model {
		Model(string&in iPath, float&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") {super(iPath,iScale,iRotation,iPos,iSkin);}
		Model(string&in iPath, Vector3f&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") {super(iPath,iScale,iRotation,iPos,iSkin);}
	} }
}


// # ??? : Room::Template@ ----
namespace Room { interface TemplateInterface { Room@ instantiate(); } }
namespace Room { abstract class Template : Room::TemplateInterface {
	Room@ instantiate() {return null;}
	Template() { Room::templates.insertLast(@this); }
	void internalConstruct() {
		@mesh=model.instantiate();
		construct();
	}
	void construct() {} // override

	string name = "SCP-000";
	string zone = "000";

	string description = "513475634257986431";
	Room::Model@ model;
	Game::Room@ mesh;

	Util::Icon@ iconMapEditor;
} }

// # ??? : Room::Spawner@ ----
namespace Room { interface SpawnerInterface { } }
namespace Room { abstract class Spawner : Room::SpawnerInterface {
	Spawner() { }

	string name = "SCP-000";
} }



// # ??? : Room; (Room Instance) ----
abstract class Room {
	Room() {};
	Room(Room::Template@&in temp) { 
		Room::Template@ antiCrashWorkaround=@temp;
		@template=@antiCrashWorkaround;
		//if(@template.model!=null) { @model=template.model.instantiate(); }
	}
	Room::Template@ template;
	void construct() {} // override

	Vector3f _position;
	Vector3f position { get { return _position; } set { _position=value; recalculateWorldMatrix(); } }
	float _rotation;
	float rotation { get { return _rotation; } set { _rotation=value; recalculateWorldMatrix(); } }
	Vector3f _scale=Vector3f(0.1, 0.1, 0.1);
	Vector3f scale { get { return _scale; } set { _scale=value; recalculateWorldMatrix(); } }

	Matrix4x4f _worldMatrix;
	Matrix4x4f worldMatrix { get { return _worldMatrix; } }

	void recalculateWorldMatrix() { doCalculateMatrix(); updatePosition(); }
	void doCalculateMatrix() {
		_worldMatrix = Matrix4x4f::constructWorldMat(position, scale, Vector3f(0.0, rotation, 0.0));
	}
	void updatePosition() {} // override
	void render() { template.mesh.render(worldMatrix); }
	void update() {
	}

}

// # Room:: (Namespace) ----
namespace Room {
	array<Room@> instances;
	array<Room::Template@> templates;

	void startLoading() {
		Environment::loadMax=templates.length();
		
	}
	void finishLoading() {
		
	}
	bool load() {
		if(Environment::loadDone>=templates.length()-1) { finishLoading(); return true; }
		Room::Template @template=templates[Environment::loadDone];
		Environment::loadMessage=template.zone + ":" + template.name;
		template.internalConstruct();
		return false;
	}

	void Initialize() {
		for(int i=0;i<templates.length();i++) { templates[i].construct(); }
	}

	Room@ spawn(const string&in name, const Vector3f&in position=Vector3f(), const float&in rotation=0) {
		Room::Template@ template;
		for(int i=0; i<templates.length(); i++) { if(templates[i].name==name) { @template=@templates[i]; break; } }
		if(@template==null) { Debug::error("Room Spawn failed - Room Template not found: " + name); return null; }
		Room@ instance=template.instantiate();
		instance.position=position;
		instance.rotation=rotation;
		instances.insertLast(@instance);
		instance.recalculateWorldMatrix();
		template.mesh.appendCollisionsToWorld(instance.worldMatrix);
		Debug::log("Spawned room : " + template.name);
		instance.construct();
		return @instance;
	}
	void updateAll() { for (int i=0; i<instances.length(); i++) { instances[i].update(); } }
	void renderAll() { for (int i=0; i<instances.length(); i++) { instances[i].render(); } }
}

/* SAMPLE ITEM

// # Room::<myRoomName>::Template@ and Room::<myRoomName>::Instance@; and Room::<myRoomName>::Spawner@ ----
namespace Room { namespace LCZ_MyRoom { Template@ thisTemplate=Template();

	// # Room::<myRoomName>::Template@ ----
	class Template : Room::Template { Room@ instantiate() { return Instance(); }
		Template() { super();
			name		= "SCP-000";
			zone		= "LCZ";
			@model		= Room::Model(rootDirCBR + zone + "/" + name + "/" + name + ".rm2");
		}
		string banana="cheese";
	}

	// # Room::<myRoomName>::Instance@ ----
	class Instance : Room { Instance() {super(@thisTemplate);};
		void doTest() {
			print "I'm a " + thisTemplate.banana;
		}
	}

	// # Room::<myRoomName>::Spawner@ ----
	class Spawner : Room::Spawner {
		Spawner() {
		}
	}

}}; // Close Room

*/ 
