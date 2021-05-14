namespace Item {
	array<Item::Template@> templates;
	array<Item@> instances;
	void register(Item::Template@&in template) {
		template.localName = Local::getTxt("Items." + template.name + ".Name");
		templates.insertLast(@template);
	}

	Item@ spawn(const string&in name, const Vector3f&in position) { return spawn(name,position,Vector3f(0,0,0)); }
	Item@ spawn(const string&in name, const Vector3f&in position, const Vector3f&in rotation) {
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

		Item@ instance=template.create();
		instance.position=position;
		instance.rotation=rotation;
		return instance;
	}
	void updateAll() { for (int i=0; i<instances.length(); i++) { instances[i].update(); } }
	void renderAll() { for (int i=0; i<instances.length(); i++) { instances[i].render(); } }
}

abstract class Item::Template {
	Template() { Item::templates.insertLast(@this); }
	string name;
	string localName;

	string modelPath;
	string modelSkin;
	float modelScale; // Original model scales appear to be *10 less than what it should be. (0.008, etc)

	// "SFX/Interact/PickItem" + pickSoundID + ".ogg";
	int pickSoundID;

	bool useModelIcon=true;
	string iconImage;

	float iconScale;
	Vector3f iconRot;
	Vector2f iconPos;
	string iconSkin="";
	Item@ create() { Debug::error("Tried to make an instance of a null template!"); return null; }
}

abstract class Item {

	// Identity
	string name;

	Item::Template@ template;
	Util::Icon@ iconData;

	// Model/Picker, and alias model position/rotation/picker onto item.position/rotation/picker
	Game::Model::Picker@ model;
	Vector3f position { get { return model.position; } set { model.position = value; } }
	Vector3f rotation { get { return model.rotation; } set { model.rotation = value; } }
	bool picked { get { return model.picked; } }
	bool pickable { set { model.pickable=value; } }

	Item@ _inventoryBag;
	Item@ inventoryBag;
	int inventory;

	// Save States
	int state;
	int power;
	int equipped;

	// Construction
	Item(Item::Template@&in origin) {
		Item::Template@ originTemplate = @origin; // This may seem like it does nothing, but it's actually stopping a crash.
		@template=@originTemplate;
		Game::Model::Picker @mdl = Game::Model::Picker(template.modelPath);
		@model=@mdl;
		if(template.modelScale != 0) { model.scale=Vector3f(template.modelScale); }
		model.skin=template.modelSkin;

		name=template.name;
		Item::instances.insertLast(@this);

		if(template.useModelIcon) {  @iconData = Util::Icon::Model(template.modelPath, template.iconScale, template.iconRot, template.iconPos); }
		else { @iconData=Util::Icon(); @iconData.texture=Texture::get(template.iconImage); }
		inPVS=true;

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
		if(false) { //InventoryMenu::instance.addItem(this)) {
			inventory=1;
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




