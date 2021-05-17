
/*
// # Item::Type::Key(@item); <Cast as Key> ----
namespace Item { namespace Type { Item::Type::Key::Instance@ Key(Item@ obj) { return cast<Item::Type::Key::Instance>(obj); } } }

// # Item::Type::Key::Type; (enum) ----
namespace Item { namespace Type { namespace Key { enum Type {
	keycard=0,
	hand=1,
	
} } } }

// # Item::Type::Key (parent item type); ----
namespace Item { namespace Type { namespace Key {

	// # Item::Type::Key::Template; ----
	abstract class Template : Item::Template { Template() { super(); }
		int keyType=0;
		int keyLevel=2;
	}

	// # Item::Type::Key::Instance; ----
	abstract class Instance : Item { Instance(Item::Template@ subTemplate) {super(@subTemplate);}
	}

	// # Item::Type::Key::Spawner; ----
	abstract class Spawner : Item { Spawner() {super();}
	}
} } }


// # Sample Item
namespace Item { namespace Keycard_1 { Template@ thisTemplate=Template();
	class Instance : Item::Type::Key::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Type::Key::Spawner { Spawner() { super(); } }
	class Template : Item::Type::Key::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			name		= "Keycard"; // "wallet"
			@pickSound	= Item::Sound(); // 2
			@model		= Item::Model(rootDirGFXItems + name + "s/" + name + ".fbx", 0.005);
			@icon		= Item::Icon(rootDirGFXItems + name + "/inv_" + name + ".jpg");
			@iconModel	= Item::Icon::Model(model.path,0.08,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
	}
} }

*/