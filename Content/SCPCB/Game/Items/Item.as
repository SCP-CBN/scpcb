
// # Item::Model@ ----
namespace Item { class Model {
	string path;
	string skin;
	float scale;
	bool pickable;
	Model(string iPath, float&in iScale=1.f, string&in iSkin="") { path=iPath; scale=iScale; skin=iSkin; }
	Game::Model@ instantiate() { return (pickable ? Game::Model(path,scale,skin) : Game::Model::Picker(path,scale,skin)); }
} }

// # Item::Sound@ ----
namespace Item { class Sound {
	string path;
	Sound() {}
	Sound(int i) {} // picksoundid
	Sound(string&in iPath, float&in iScale, string&in iSkin="") { path=iPath; }
} }

// # Item::Icon@ and Item::Icon::Model@ ----
namespace Item {
	// Item::Icon@ ----
	class Icon : Util::Icon { Icon() {super();} Icon(string&in texStr) {super(texStr);} Icon(Texture@&in tex) {super(@tex);} }

	// Item::Icon::Model@ ----
	namespace Icon { class Model : Util::Icon::Model {
		Model(string&in iPath, float&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") {super(iPath,iScale,iRotation,iPos,iSkin);}
	} }
}



// # ??? : Item::Template@ ----
namespace Item { interface TemplateInterface { Item@ instantiate(); } }
namespace Item { abstract class Template : Item::TemplateInterface {
	Item@ instantiate() {return null;}
	Template() { Item::templates.insertLast(@this); }
	void construct() {
		if(@model!=null) { model.pickable=(@pickSound != null && (@icon != null || @iconModel != null)); }
		localName = Local::getTxt("Items."+name+".Name");
		if(@iconModel!=null) { iconModel.generate(); }
		if(@icon==null && @iconModel!=null) { @icon=@iconModel; }
	}

	string name = "SCP-000";
	string localName = "000";

	string description = "513475634257986431";
	Item::Model@ model;
	bool pickable;

	Item::Sound@ pickSound;
	Util::Icon@ icon;
	Util::Icon::Model@ iconModel;

} }

// # ??? : Item::Spawner@ ----
namespace Item { interface SpawnerInterface { } }
namespace Item { abstract class Spawner : Item::SpawnerInterface {
	Spawner() { }

	string name = "SCP-000";
} }



// # ??? : Item; (Item Instance) ----
abstract class Item {
	Item() {};
	Item(Item::Template@&in temp) { 
		Item::Template@ antiCrashWorkaround=@temp;
		@template=@antiCrashWorkaround;
		if(@template.model!=null) { @model=template.model.instantiate(); }
		
	}
	Item::Template@ template;
	Item::Icon@ iconInventory; // Must be calculated per item, i.e empty clipboard. Does not need to be saved.

	Game::Model@ model;
	bool pickable { get { return model.pickable; } set { model.pickable=value; } }
	Vector3f position { get { return model.position; } set { model.position=value; } }
	Vector3f rotation { get { return model.rotation; } set { model.rotation=value; } }
	Vector3f scale { get { return model.scale; } set { model.scale=value; } }
	string skin { get { return model.skin; } set { model.skin=value; } }
	void render() { model.render(); }
	void update() {}

}

// # Item:: (Namespace) ----
namespace Item {
	array<Item@> instances;
	array<Item::Template@> templates;

	void startLoading() {
		Game::loadMax=templates.length();
		ModelImageGenerator::initialize(256);
	}
	void finishLoading() {
		ModelImageGenerator::deinitialize();
	}
	bool load() {
		if(Game::loadDone>=templates.length()-1) { finishLoading(); return true; }
		Item::Template @template=templates[Game::loadDone];
		template.construct();
		Game::loadDone++;
		Game::loadMessage=template.name;
		return false;
	}

	void Initialize() {
		for(int i=0;i<templates.length();i++) { templates[i].construct(); }
	}

	Item@ spawn(const string&in name) { return spawn(name,Vector3f(),Vector3f()); }
	Item@ spawn(const string&in name, const Vector3f&in position) { return spawn(name,position,Vector3f()); }
	Item@ spawn(const string&in name, const Vector3f&in position, const Vector3f&in rotation) {
		Item::Template@ template;
		for(int i=0; i<templates.length(); i++) { if(templates[i].name==name) { @template=@templates[i]; break; } }
		if(@template==null) { Debug::error("Item Spawn failed - Item Template not found: " + name); return null; }
		Item@ instance=template.instantiate();
		instance.position=position;
		instance.rotation=rotation;
		instances.insertLast(@instance);
		return @instance;
	}
	void updateAll() { for (int i=0; i<instances.length(); i++) { instances[i].update(); } }
	void renderAll() { for (int i=0; i<instances.length(); i++) { instances[i].render(); } }
}

/* SAMPLE ITEM

// # Item::<myItemName>::Template@ and Item::<myItemName>::Instance@; and Item::<myItemName>::Spawner@ ----
namespace Item { namespace Battery9v { Template@ thisTemplate=Template();

	// # Item::<myItemName>::Template@ ----
	class Template : Item::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			name		= "Battery9v";
			@pickSound	= Item::Sound();
			@model		= Item::Model( rootDirGFXItems + name + "/" + name + ".fbx", 0.08, rootDirGFXItems + "Battery/battery.jpg" );
			@icon		= Item::Icon( rootDirGFXItems + name + "/inv_" + name + ".jpg" );
			@iconModel	= Item::Icon::Model(model.path, model.scale, Vector3f(2.3,2.7,0), Vector2f(0,0.2));
		}
		string banana="cheese";
	}

	// # Item::<myItemName>::Instance@ ----
	class Instance : Item { Instance() {super(@thisTemplate);};
		void doTest() {
			print "I'm a " + thisTemplate.banana;
		}
	}

	// # Item::<myItemName>::Spawner@ ----
	class Spawner : Item::Spawner {
		Spawner() {
		}
	}

}}; // Close item

*/ 
