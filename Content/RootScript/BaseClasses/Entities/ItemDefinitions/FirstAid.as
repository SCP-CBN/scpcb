class ItemTemplate_FirstAid : Item::Template {
	Item@ MakeInstance() { Item @instance = Item_FirstAid(@this); return @instance; }
	ItemTemplate_FirstAid() { super();
		name = "FirstAid";
		modelPath = "SCPCB/GFX/Items/FirstAid/FirstAid.fbx";

		iconScale = 0.1;
		iconRot = Vector3f(-2.3,-0.3,0.2);
		iconPos = Vector2f(0,0.05);
		Item::Register(@this);
	}
}
ItemTemplate_FirstAid OriginItem_FirstAid;


shared class Item_FirstAid : Item {
	Item_FirstAid(Item::Template@&in origin) { super(@origin);
		// onConstructed();
	}

	void Test() {
		Debug::log("Im a FirstAid");
	}
	void Localize(Item@&in instance) {
	}
}
