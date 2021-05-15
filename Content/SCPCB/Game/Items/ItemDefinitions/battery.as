// # 9v Battery ----
namespace Item { namespace Battery9v { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Battery9v"; // "bat"
			@pickSound	= Item::Sound(); // 1
			@model		= Item::Model("SCPCB/GFX/Items/Battery/battery.fbx",0.08,"SCPCB/GFX/Items/Battery/battery.jpg");
			@icon		= Item::Icon("SCPCB/GFX/Items/Battery/inv_battery.jpg");
			@iconModel	= Item::Icon::Model(model.path,model.scale,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
	}
	class Instance : Item { Instance() {super(@thisTemplate);};
		void doTest() {
			Debug::log("I'm a " + thisTemplate.name);
		}
	}
	class Spawner : Item::Spawner {
		Spawner() {
		}
	}
}};


// # 18v Battery ----
namespace Item { namespace Battery18v { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Battery18v"; // "18vbat"
			@pickSound	= Item::Sound(); // 1
			@model		= Item::Model("SCPCB/GFX/Items/Battery/battery.fbx",0.12,"SCPCB/GFX/Items/Battery/battery_18v.jpg");
			@icon		= Item::Icon("SCPCB/GFX/Items/Battery/inv_battery_18v.jpg");
			@iconModel	= Item::Icon::Model(model.path,model.scale,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
	}
	class Instance : Item { Instance() {super(@thisTemplate);};
		void doTest() {
			Debug::log("I'm a " + thisTemplate.name);
		}
	}
	class Spawner : Item::Spawner {
		Spawner() {
		}
	}
}};



// # Strange Battery ----
namespace Item { namespace StrangeBattery { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "StrangeBattery"; // "killbat"
			@pickSound	= Item::Sound(); // 1
			@model		= Item::Model("SCPCB/GFX/Items/Battery/battery.fbx",0.12,"SCPCB/GFX/Items/Battery/battery_strange.jpg");
			@icon		= Item::Icon("SCPCB/GFX/Items/Battery/inv_battery_strange.jpg");
			@iconModel	= Item::Icon::Model(model.path,model.scale,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
	}
	class Instance : Item { Instance() {super(@thisTemplate);};
		void doTest() {
			Debug::log("I'm a " + thisTemplate.name);
		}
	}
	class Spawner : Item::Spawner {
		Spawner() {
		}
	}
}};

/* Originals --------------------------------------

	CreateItemTemplate("9V Battery", "bat", "GFX\items\Battery\Battery.x", "GFX\items\Battery\INVbattery9v.jpg", "", 0.008)
	CreateItemTemplate("18V Battery", "18vbat", "GFX\items\Battery\Battery.x", "GFX\items\Battery\INVbattery18v.jpg", "", 0.01, "GFX\items\Battery\Battery 18V.jpg")
	CreateItemTemplate("Strange Battery", "killbat", "GFX\items\Battery\Battery.x", "GFX\items\Battery\INVbattery22900.jpg", "", 0.01,"GFX\items\Battery\Strange Battery.jpg")

*/

