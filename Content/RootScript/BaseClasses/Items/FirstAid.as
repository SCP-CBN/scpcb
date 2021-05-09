
shared class item_FirstAid : Item {
	item_FirstAid(Item@&in other) { super(other); }
	item_FirstAid() { super();
		name = "FirstAid";
		modelPath = "SCPCB/GFX/Items/FirstAid/FirstAid.fbx";

		iconScale = 0.1;
		iconRot = Vector3f(-2.3,-0.3,0.2);
		iconPos = Vector2f(0,0.05);
		this.register();
	}

	Item@ MakeInstance() {
		Item @newinstance = item_FirstAid(cast<Item>(this));
		return @newinstance;
	}
	void Test() {
		Debug::log("Im a FirstAid");
	}
	void Localize(Item@&in instance) {
	}
}
item_FirstAid origin_FirstAid;
