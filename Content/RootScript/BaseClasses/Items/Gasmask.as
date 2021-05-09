
shared class item_Gasmask : Item {
	item_Gasmask(Item@&in other) { super(other); }
	item_Gasmask() { super();
		name = "Gasmask";
		modelPath = "SCPCB/GFX/Items/Gasmask/gasmask.fbx";

		iconScale = 0.08;
		iconRot = Vector3f(2.3,2.7,0);
		iconPos = Vector2f(0,0.2);
		this.register();
	}

	Item@ MakeInstance() {
		Item @newinstance = item_Gasmask(cast<Item>(this));
		return @newinstance;
	}
	void Test() {
		Debug::log("Im a gasmask");
	}
	void Localize(Item@&in instance) {
	}
}
item_Gasmask origin_Gasmask;