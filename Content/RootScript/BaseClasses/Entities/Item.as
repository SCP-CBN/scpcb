namespace Item {
	shared array<Item::Template@> templates;
	shared array<Item@> instances;
	shared void Register(Item::Template@&in template) {
		template.local_name = Local::getTxt("Items." + template.name + ".Name");
		templates.insertLast(@template);
	}

	shared Item@ spawn(const string&in name, const Vector3f&in position) { return spawn(name,position,Vector3f(0,0,0)); }
	shared Item@ spawn(const string&in name, const Vector3f&in position, const Vector3f&in rotation) {
		Item::Template @template;
		for (int i = 0; i < templates.length(); i++) {
			if(templates[i].name == name) {
				@template=@templates[i];
				break;
			}
		}
		if(template == null) {
			Debug::error("Failed to create item " + name + " - Template not found! - #Templates: " + templates.length() + ".");
			return null;
		}

		Debug::log("Attempting to make1 " + name);
		Item@ instance=template.MakeInstance();
		instance.position=position;
		instance.rotation=rotation;
		return instance;
	}
	shared void updateAll() { for (int i=0; i<instances.length(); i++) { instances[i].update(); } }
	shared void renderAll() { for (int i=0; i<instances.length(); i++) { instances[i].render(); } }
}

shared abstract class Item::Template {
	Template() { Item::templates.insertLast(@this); }
	string name;
	string local_name;
	string modelPath;
	float iconScale;
	Vector3f iconRot;
	Vector2f iconPos;
	Item@ MakeInstance() { Debug::error("Tried to make an instance of a null template!"); return null; }
}

shared abstract class Item {

	// Identity
	string name;

	Item::Template@ template;
	World::Icon@ iconData;
	Texture@ icon;

	// Model/Picker, and alias model position/rotation/picker onto item.position/rotation/picker
	World::ModelPicker@ model;
	Vector3f position { get { return model.position; } set { model.position = value; } }
	Vector3f rotation { get { return model.rotation; } set { model.rotation = value; } }
	bool picked { get { return model.picked; } }
	bool pickable { set { model.pickable(value); } }
	bool carried;

	// Lifecycle
	bool valid;


	// Construction
	Item(Item::Template@&in origin) {
		Item::Template@ originTemplate = @origin; // This may seem like it does nothing, but it's actually stopping a crash.
		@template=@originTemplate;
		World::ModelPicker @mdl = World::ModelPicker(template.modelPath);
		@model=@mdl;

		name=template.name;
		Item::instances.insertLast(@this);

		World::Icon @iconData = World::ModelIcon(template.modelPath, template.iconScale, template.iconRot, template.iconPos);
		@icon=@iconData.texture;
		inPVS=true;
		valid=true;

		Debug::log("Spawned an item in the world: " + name);
	}


	// Potentially Visible Set (PVS) and Tick/Render/Update functions.
	bool inPVS;
	void EnterPVS() { inPVS=true; onEnterPVS(); }
	void ExitPVS() { inPVS=false; onExitPVS(); }

	void render() {
		if(inPVS) { renderPVS(); }
		renderGlobal();
	}
	void update() {
		if(inPVS) {
			updatePickable();
			onUpdatePVS();
		}
		onUpdateGlobal();
	}


	void updatePickable() { if(model.picked) { tryPick(); } }
	bool tryPick() {
		if(!canPick()) { return false; }
		if(InventoryMenu::instance.addItem(this)) {
			carried=true;
			onPick();
			pickable=false;
			ExitPVS();
			return true;
		} else {
			//Msg::set("Inventory full!");
		}
		return false;
	}

	// // // Override functions // // //


	// Lifecycle
	void onSpawned() {}
	void onDestroy() {}

	// PVS
	void onExitPVS() {}
	void onEnterPVS() {}

	// Tick/update functions
	void onUpdatePVS() {}
	void onUpdateGlobal() {}

	// Inventory actions
	bool canUse() { return false; }
	bool onUse() { return false; }
	void onDrop() {}

	// Pickables
	bool canPick() { return true; }
	void onPick() {}

	// Renderables
	void renderPVS() { model.render(); }
	void renderGlobal() {}


	void Test() {
		Debug::log("Im a banana");
	}

}




