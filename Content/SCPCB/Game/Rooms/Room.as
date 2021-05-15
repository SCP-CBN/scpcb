
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

}


// # ??? : Room::Template@ ----
namespace Room { interface TemplateInterface { Room@ instantiate(); } }
namespace Room { abstract class Template : Room::TemplateInterface {
	Room@ instantiate() {return null;}
	Template() { Room::templates.insertLast(@this); }
	void construct() {
		@mesh=model.instantiate();
	}

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
		if(@template.model!=null) { @model=template.model.instantiate(); }
	}
	Room::Template@ template;

	Game::Room@ model;
	void render() { model.render(); }
	void update() {}

}

// # Room:: (Namespace) ----
namespace Room {
	array<Room@> instances;
	array<Room::Template@> templates;

	void startLoading() {
		Game::loadMax=templates.length();
		
	}
	void finishLoading() {
		
	}
	bool load() {
		if(Game::loadDone>=templates.length()-1) { finishLoading(); return true; }
		Room::Template @template=templates[Game::loadDone];
		template.construct();
		Game::loadDone++;
		Game::loadMessage=template.zone + ":" + template.name;
		return false;
	}

	void Initialize() {
		for(int i=0;i<templates.length();i++) { templates[i].construct(); }
	}

	Room@ spawn(const string&in name) { return spawn(name,Vector3f(),Vector3f()); }
	Room@ spawn(const string&in name, const Vector3f&in position) { return spawn(name,position,Vector3f()); }
	Room@ spawn(const string&in name, const Vector3f&in position, const Vector3f&in rotation) {
		Room::Template@ template;
		for(int i=0; i<templates.length(); i++) { if(templates[i].name==name) { @template=@templates[i]; break; } }
		if(@template==null) { Debug::error("Room Spawn failed - Room Template not found: " + name); return null; }
		Room@ instance=template.instantiate();
		//instance.position=position;
		//instance.rotation=rotation;
		instances.insertLast(@instance);
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
