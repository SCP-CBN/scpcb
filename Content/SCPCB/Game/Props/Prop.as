
// # Prop::Model@ ----
namespace Prop { class Model : Util::Model {
	Model(string iPath, float&in iScale=1.f, string&in iSkin="") { super(iPath,Vector3f(iScale),iSkin); }
	Model(string iPath, Vector3f&in iScale, string&in iSkin="") { super(iPath,iScale,iSkin); }
} }

// # Prop::Sound@ ----
namespace Prop { class Sound {
	string path;
	Sound() {}
	Sound(int i) {} // picksoundid
	Sound(string&in iPath, float&in iScale, string&in iSkin="") { path=iPath; }
} }

// # Prop::Icon@ and Prop::Icon::Model@ ----
namespace Prop {
	// Prop::Icon@ ----
	class Icon : Util::Icon { Icon() {super();} Icon(string&in texStr) {super(texStr);} Icon(Texture@&in tex) {super(@tex);} }

	// Prop::Icon::Model@ ----
	namespace Icon { class Model : Util::Icon::Model {
		Model(string&in iPath, float&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") {super(iPath,iScale,iRotation,iPos,iSkin);}
		Model(string&in iPath, Vector3f&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") {super(iPath,iScale,iRotation,iPos,iSkin);}
	} }
}



// # ??? : Prop::Template@ ----
namespace Prop { interface TemplateInterface { Prop@ instantiate(); } }
namespace Prop { abstract class Template : Prop::TemplateInterface {
	Prop@ instantiate() {return null;}
	Template() { Prop::templates.insertLast(@this); }
	void internalConstruct() {
		if(@model!=null) { model.pickable=(@pickSound != null && (@icon != null || @iconModel != null)); model.construct(); }
		localName = Local::getTxt("Props."+name+".Name");
		if(@iconModel!=null) { iconModel.generate(); }
		if(@icon!=null) { icon.generate(); }
		if(@icon==null && @iconModel!=null) { @icon=@iconModel; }
		construct();
	}
	void construct() {} // override

	string name = "SCP-000";
	string localName = "000";

	string description = "513475634257986431";
	Prop::Model@ model;
	bool pickable;

	Prop::Sound@ pickSound;
	Util::Icon@ icon;
	Util::Icon::Model@ iconModel;

} }

// # ??? : Prop::Spawner@ ----
namespace Prop { interface SpawnerInterface { } }
namespace Prop { abstract class Spawner : Prop::SpawnerInterface {
	Spawner() { }

	string name = "SCP-000";
} }



// # ??? : Prop; (Prop Instance) ----
abstract class Prop {
	Prop() {};
	Prop(Prop::Template@&in temp) { 
		Prop::Template@ antiCrashWorkaround=@temp;
		@template=@antiCrashWorkaround;
		if(@template.model!=null) { @model=template.model.instantiate(); }
	}
	void construct() {} // override
	Prop::Template@ template;
	Prop::Icon@ iconInventory; // Must be calculated per Prop, i.e empty clipboard. Does not need to be saved.

	Game::Model@ model;
	bool pickable { get { return model.pickable; } set { model.pickable=value; } }
	Vector3f position { get { return model.position; } set { model.position=value; } }
	Vector3f rotation { get { return model.rotation; } set { model.rotation=value; } }
	Vector3f scale { get { return model.scale; } set { model.scale=value; } }
	string skin { get { return model.skin; } set { model.skin=value; } }
	void render() { model.render(); }
	void update() {}
	void onPicked() {}
}

// # Prop:: (Namespace) ----
namespace Prop {
	array<Prop@> instances;
	array<Prop::Template@> templates;

	void startLoading() {
		Environment::loadMax=templates.length();
		ModelImageGenerator::initialize(256);
	}
	void finishLoading() {
		if(ModelImageGenerator::getInitialized()) { ModelImageGenerator::deinitialize(); }
	}
	bool load() {
		if(Environment::loadDone>templates.length()-1) { finishLoading(); return true; }
		Prop::Template @template=templates[Environment::loadDone];
		Environment::loadMessage=template.name;
		if(!ModelImageGenerator::getInitialized()) { ModelImageGenerator::initialize(256); }
		template.internalConstruct();
		return false;
	}

	Prop@ spawn(const string&in name) { return spawn(name,Vector3f(),Vector3f()); }
	Prop@ spawn(const string&in name, const Vector3f&in position) { return spawn(name,position,Vector3f()); }
	Prop@ spawn(const string&in name, const Vector3f&in position, const Vector3f&in rotation) {
		Prop::Template@ template;
		for(int i=0; i<templates.length(); i++) { if(templates[i].name==name) { @template=@templates[i]; break; } }
		if(@template==null) { Debug::error("Prop Spawn failed - Prop Template not found: " + name); return null; }
		Prop@ instance=template.instantiate();
		instance.position=position;
		instance.rotation=rotation;
		instances.insertLast(@instance);
		instance.construct();
		if(instance.model.isPickable) {
			Game::Model::Picker@ picker=cast<Game::Model::Picker>(@instance.model);
			@picker.onPicked=@Util::Function(instance.onPicked);
		}
		return @instance;
	}
	void updateAll() { for (int i=0; i<instances.length(); i++) { instances[i].update(); } }
	void renderAll() { for (int i=0; i<instances.length(); i++) { instances[i].render(); } }
}

/* SAMPLE Prop

// # Prop::<myPropName>::Template@ and Prop::<myPropName>::Instance@; and Prop::<myPropName>::Spawner@ ----
namespace Prop { namespace Battery9v { Template@ thisTemplate=Template();

	// # Prop::<myPropName>::Template@ ----
	class Template : Prop::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			name		= "Battery9v";
			@pickSound	= Prop::Sound();
			@model		= Prop::Model( rootDirGFXProps + name + "/" + name + ".fbx", 0.08, rootDirGFXProps + "Battery/battery.jpg" );
			@icon		= Prop::Icon( rootDirGFXProps + name + "/inv_" + name + ".jpg" );
			@iconModel	= Prop::Icon::Model(model.path, model.scale, Vector3f(2.3,2.7,0), Vector2f(0,0.2));
		}
		string banana="cheese";
	}

	// # Prop::<myPropName>::Instance@ ----
	class Instance : Prop { Instance() {super(@thisTemplate);};
		void doTest() {
			print "I'm a " + thisTemplate.banana;
		}
	}

	// # Prop::<myPropName>::Spawner@ ----
	class Spawner : Prop::Spawner {
		Spawner() {
		}
	}

}}; // Close Prop

*/ 
