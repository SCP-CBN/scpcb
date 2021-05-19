
// # Item::Cast::Keycard(@item); <Cast as Keycard> ----
namespace Item { namespace Cast { Item::Keycard::Instance@ Keycard(Item@ obj) { return cast<Item::Keycard::Instance>(@obj); } } }

// # Item::Keycard (parent item type); ----
namespace Item { namespace Keycard {
	enum Type {
		keycard=0,
		hand=1
	}
	// # Item::Type::Key::Template; ----
	abstract class Template : Item::Template {
		Template() { super();
			@pickSound	= Item::Sound(); // 2
			@model		= Item::Model(rootDirGFXItems + "Keycards/keycard.fbx", 0.005);
			@icon		= Item::Icon(rootDirGFXItems + "Keycards/keycard/inv_keycard1.jpg");
			@iconModel	= Item::Icon::Model(model.path,0.08,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
		void registerKeycard() {
			name = keyClass + toString(keyLevel); //
			model.skin = rootDirGFXItems + "Keycards/" + keyClass + "/" + keyClass + toString(keyLevel);
			icon.path = rootDirGFXItems + "Keycards/" + keyClass + "/inv_" + keyClass + toString(keyLevel);
			iconModel.skin = model.skin;
		}
		string keyClass;
		int keyLevel;
		Item::Keycard::Type keyType;
	}

	// # Item::Type::Key::Instance; ----
	abstract class Instance : Item { Instance(Item::Template@ subTemplate) {super(@subTemplate);}
	}

	// # Item::Type::Key::Spawner; ----
	abstract class Spawner : Item::Spawner { Spawner() {super();}
	}
} }


// # Sample Item
namespace Item { namespace Keycard1 { Template@ thisTemplate=Template();
	class Instance : Item::Keycard::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Keycard::Spawner { Spawner() { super(); } }
	class Template : Item::Keycard::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			keyClass="keycard";
			keyLevel=1;
			// keyType=Item::Keycard::Type::keycard; // is this really necessary?
			registerKeycard();
		}
	}
} }

namespace Item { namespace Keycard2 { Template@ thisTemplate=Template();
	class Instance : Item::Keycard::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Keycard::Spawner { Spawner() { super(); } }
	class Template : Item::Keycard::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			keyClass="keycard";
			keyLevel=2;
			// keyType=Item::Keycard::Type::keycard; // is this really necessary?
			registerKeycard();
		}
	}
} }

namespace Item { namespace Keycard3 { Template@ thisTemplate=Template();
	class Instance : Item::Keycard::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Keycard::Spawner { Spawner() { super(); } }
	class Template : Item::Keycard::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			keyClass="keycard";
			keyLevel=3;
			// keyType=Item::Keycard::Type::keycard; // is this really necessary?
			registerKeycard();
		}
	}
} }

namespace Item { namespace Keycard4 { Template@ thisTemplate=Template();
	class Instance : Item::Keycard::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Keycard::Spawner { Spawner() { super(); } }
	class Template : Item::Keycard::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			keyClass="keycard";
			keyLevel=4;
			// keyType=Item::Keycard::Type::keycard; // is this really necessary?
			registerKeycard();
		}
	}
} }

namespace Item { namespace Keycard5 { Template@ thisTemplate=Template();
	class Instance : Item::Keycard::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Keycard::Spawner { Spawner() { super(); } }
	class Template : Item::Keycard::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			keyClass="keycard";
			keyLevel=5;
			// keyType=Item::Keycard::Type::keycard; // is this really necessary?
			registerKeycard();
		}
	}
} }

namespace Item { namespace KeycardOmni { Template@ thisTemplate=Template();
	class Instance : Item::Keycard::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Keycard::Spawner { Spawner() { super(); } }
	class Template : Item::Keycard::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			keyClass="keycard";
			keyLevel=6;
			// keyType=Item::Keycard::Type::keycard; // is this really necessary?
			registerKeycard();
		}
	}
} }

namespace Item { namespace Playingcard { Template@ thisTemplate=Template();
	class Instance : Item::Keycard::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Keycard::Spawner { Spawner() { super(); } }
	class Template : Item::Keycard::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			keyClass="playingcard";
			keyLevel=1;
			// keyType=Item::Keycard::Type::keycard; // is this really necessary?
			registerKeycard();
		}
	}
} }

namespace Item { namespace Mastercard { Template@ thisTemplate=Template();
	class Instance : Item::Keycard::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Keycard::Spawner { Spawner() { super(); } }
	class Template : Item::Keycard::Template { Item@ instantiate() { return Instance(); }
		Template() { super();
			keyClass="mastercard";
			keyLevel=1;
			// keyType=Item::Keycard::Type::keycard; // is this really necessary?
			registerKeycard();
		}
	}
} }
