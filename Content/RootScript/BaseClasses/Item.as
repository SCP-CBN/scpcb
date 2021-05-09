namespace Item {
	shared array<Item@> templates;
	shared array<Item@> instances;

	shared Item@ spawn(const string&in name, const Vector3f&in position) {
		return spawn(name,position,Vector3f(0,0,0));
	}
	shared Item@ spawn(const string&in name, const Vector3f&in position, const Vector3f&in rotation) {
		Item @template;
		for (int i = 0; i < templates.length(); i++) {
			if(templates[i].name==name) {
				@template=@templates[i];
				break;
			}
		}
		if(template is null) {
			Debug::log("Failed to create item " + name);
			Debug::log("Templates : " + templates.length());
			Debug::error(templates.length());
			return null;
		}
		Item @instance=template.MakeInstance();
		instance.SpawnInWorld(position,rotation,Vector3f(1,1,1));
		return instance;
	}


	shared void updateAll() {
		for (int i=0; i<instances.length(); i++) {
			instances[i].update();
		}
	}
	shared void renderAll() {
		for (int i=0; i<instances.length(); i++) {
			instances[i].render();
		}
	}
}

shared abstract class Item {
	bool valid;
	string name;
	string localName;

	string modelPath;
	Model@ model;

	string iconPath;
	Texture@ icon;

	float iconScale;
	Vector3f iconRot;
	Vector2f iconPos;
	
	Item() {}
	Item(Item@&in other) {
		name = other.name;
		localName=other.localName;
		modelPath=other.modelPath;
		@icon = ModelImageGenerator::generate(modelPath, iconScale, iconRot, iconPos);
		Item::instances.insertLast(@this);
	}
	~Item() {
		if(valid) {
			Model::destroy(model);
			Pickable::deactivatePickable(pickable);
		}
	}

	void register() {
		localName = Local::getTxt("Items." + name + ".Name");
		Item::templates.insertLast(this);
		Debug::log("Registered item: " + this.name);
	}

	Vector3f position {
		get { return model.position; }
		set { model.position = value; pickable.position = value; }
	}
	Vector3f rotation {
		get { return model.rotation; }
		set { model.rotation = value; }
	}
	Vector3f scale {
		get { return model.scale; }
		set { model.scale = value; }
	}

	void SpawnInWorld(Vector3f pos, Vector3f rot, Vector3f scal) {
		@model = Model::create(modelPath);
		@pickable=Pickable();
		Pickable::activatePickable(pickable);
		valid=true;
		inPVS=true;
		position=pos;
		rotation=rot;
		scale=scal;
		Debug::log("Spawned an item in the world: " + name);
	}
	void Localize() {}

	bool inPVS;
	void EnterPVS() {
		inPVS=true;
	}
	void ExitPVS() {
		inPVS=false;
	}
	void UpdatePVS() {
		if(!valid) {
			//ExitPVS();
			return;
		}
		inPVS=true;
		// InPVS=util::IsPotentiallyVisible(position);
	}

	void render() {
		if(!inPVS) { return; }
		model.render();
	}


	Pickable@ pickable;
	bool picked;

	// Returns whether or not the item is now equipped.
	bool onUse() { return false; }
	void onDrop() {}
	void onPick() {}
	// Returns whether or not the item can be picked up.
	bool canPick() { return true; }

	void updatePickable() {
		if(pickable.getPicked()) {
			if(canPick()) {
				if(InventoryMenu::instance.addItem(this)) {
					onPick();
					picked = true;
					ExitPVS();
					Pickable::deactivatePickable(pickable);
				} else {
					//Msg::set("Inventory full!");
				}
			}
		}
	}

	void update() {
		if(inPVS) {
			updatePickable();
		}
	}

	Item@ MakeInstance() {
		Debug::error("Made an item instance frm nothing!");
		return null;
	}

	void Test() {
		Debug::log("Im a banana");
	}
}
