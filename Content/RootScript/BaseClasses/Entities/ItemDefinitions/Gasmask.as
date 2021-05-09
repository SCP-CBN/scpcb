class ItemTemplate_Gasmask : Item::Template {
	Item@ MakeInstance() { Item @instance = Item_Gasmask(@this); return @instance; }
	ItemTemplate_Gasmask() { super();
		name = "Gasmask";
		modelPath = "SCPCB/GFX/Items/Gasmask/Gasmask.fbx";

		iconScale = 0.08;
		iconRot = Vector3f(2.3,2.7,0);
		iconPos = Vector2f(0,0.2);
		Item::Register(@this);
	}
}
ItemTemplate_Gasmask OriginItem_Gasmask;


shared class Item_Gasmask : Item {
	Item_Gasmask(Item::Template@&in origin) { super(@origin);
		// onConstructed();
	}

	void Test() {
		Debug::log("Im a gasmask");
	}
	void Localize(Item@&in instance) {
	}
}
