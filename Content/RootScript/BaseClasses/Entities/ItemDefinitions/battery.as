// 9v Battery --------------------------------------

class ItemTemplate_Battery : Item::Template {
	Item@ MakeInstance() {
		Item @instance = Item_Battery(@this);
		return @instance;
	}
	ItemTemplate_Battery() { super();
		
		name = "Battery9v"; //"bat"
		modelPath = "SCPCB/GFX/Items/Battery/battery.fbx";
		modelSkin = "SCPCB/GFX/Items/Battery/battery.jpg";
		modelScale = 0.08;

		pickSoundID=1;

		useModelIcon=true;
		iconImage = "SCPCB/GFX/Items/Battery/inv_battery.jpg";
		iconScale = 0.08;
		iconRot = Vector3f(2.3,2.7,0);
		iconPos = Vector2f(0,0.2);

		Item::Register(@this);
	}
}
ItemTemplate_Battery OriginItem_Battery;


shared class Item_Battery : Item {
	Item_Battery(Item::Template@&in origin) { super(@origin);
		// onConstructed();
	}

	void Test() {
		Debug::log("Im a 9v Battery");
	}
}


// 18v Battery --------------------------------------

class ItemTemplate_Battery18v : Item::Template {
	Item@ MakeInstance() {
		Item @instance = Item_Battery18v(@this);
		return @instance;
	}
	ItemTemplate_Battery18v() { super();
		
		name = "Battery18v"; // "18vbat"
		modelPath = "SCPCB/GFX/Items/Battery/battery.fbx";
		modelSkin = "SCPCB/GFX/Items/Battery/battery_18v.jpg";
		modelScale = 0.12;

		pickSoundID=1;

		useModelIcon=true;
		iconImage = "SCPCB/GFX/Items/inv_battery_18v.jpg";
		iconScale = 0.1;
		iconRot = Vector3f(2.3,2.7,0);
		iconPos = Vector2f(0,0.2);

		Item::Register(@this);
	}
}
ItemTemplate_Battery18v OriginItem_Battery18v;


shared class Item_Battery18v : Item {
	Item_Battery18v(Item::Template@&in origin) { super(@origin);
		// onConstructed();
	}

	void Test() {
		Debug::log("Im a Battery18v");
	}
}


// 18v Battery --------------------------------------

class ItemTemplate_StrangeBattery : Item::Template {
	Item@ MakeInstance() {
		Item @instance = Item_StrangeBattery(@this);
		return @instance;
	}
	ItemTemplate_StrangeBattery() { super();
		
		name = "StrangeBattery"; //"killbat"
		modelPath = "SCPCB/GFX/Items/Battery/Battery.fbx";
		modelSkin = "SCPCB/GFX/Items/Battery/battery_strange.jpg";
		modelScale = 0.12;

		pickSoundID=1;

		useModelIcon=true;
		iconImage = "SCPCB/GFX/Items/inv_battery_strange.jpg";
		iconScale = 0.08;
		iconRot = Vector3f(2.3,2.7,0);
		iconPos = Vector2f(0,0.2);

		Item::Register(@this);
	}
}
ItemTemplate_StrangeBattery OriginItem_StrangeBattery;


shared class Item_StrangeBattery : Item {
	Item_StrangeBattery(Item::Template@&in origin) { super(@origin);
		// onConstructed();
	}

	void Test() {
		Debug::log("Im a Strange Battery");
	}
}


/* Originals --------------------------------------

	CreateItemTemplate("9V Battery", "bat", "GFX\items\Battery\Battery.x", "GFX\items\Battery\INVbattery9v.jpg", "", 0.008)
	CreateItemTemplate("18V Battery", "18vbat", "GFX\items\Battery\Battery.x", "GFX\items\Battery\INVbattery18v.jpg", "", 0.01, "GFX\items\Battery\Battery 18V.jpg")
	CreateItemTemplate("Strange Battery", "killbat", "GFX\items\Battery\Battery.x", "GFX\items\Battery\INVbattery22900.jpg", "", 0.01,"GFX\items\Battery\Strange Battery.jpg")

*/