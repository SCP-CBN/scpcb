
// Item::Type::InventoryContainer ??

namespace Item { namespace Wallet { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Wallet"; // "wallet"
			@pickSound	= Item::Sound(); // 2
			@model		= Item::Model(rootDirGFXItems + name + "/" + name + ".fbx", 0.005);
			@icon		= Item::Icon(rootDirGFXItems + name + "/inv_" + name);
			@iconModel	= Item::Icon::Model(model.path,0.08,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
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

