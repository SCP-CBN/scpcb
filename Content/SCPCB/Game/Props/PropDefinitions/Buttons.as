
// # Prop::Cast::Buttons(@prop); <Cast as Button> ----
namespace Prop { namespace Cast { Prop::Buttons::Instance@ Buttons(Prop@ obj) { return cast<Prop::Buttons::Instance>(@obj); } } }

// # Prop::Buttons (parent prop type, note Button[S] from regular button); ----
namespace Prop { namespace Buttons {
	enum Type {
		normal=0,
		code=1,
		elevator=2,
		keycard=3,
		scanner=4
	}
	// # Prop::Buttons::Template; ----
	abstract class Template : Prop::Template {
		Template() { super();
			@pickSound	= Prop::Sound(); // 2
			@model		= Prop::Model(rootDirGFXProps + "Buttons/error.fbx", 1.f);
			model.pickable	= true;
			@iconModel	= Prop::Icon::Model(model.path,0.8,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
		void registerButton() {
			name = buttonClass;
			model.path = rootDirGFXProps + "Buttons/" + name + ".fbx";
			iconModel.path=model.path;
		}
		string buttonClass;
	}

	// # Prop::Buttons::Instance; ----
	abstract class Instance : Prop {
		Instance(Prop::Template@ subTemplate) {super(@subTemplate);
		}
		Prop::Doors::Instance@ door;
	}

	// # Prop::Buttons::Spawner; ----
	abstract class Spawner : Prop::Spawner { Spawner() {super();}
	}
} }


// # Sample Prop
namespace Prop { namespace Button { Template@ thisTemplate=Template();
	class Instance : Prop::Buttons::Instance { Instance() {super(@thisTemplate);}
		void onPicked() {
			Debug::log("onPicked -> Standard [Button]");
			if(@door!=null) { door.toggle(); }
		}
	}
	class Spawner : Prop::Buttons::Spawner { Spawner() { super(); } }
	class Template : Prop::Buttons::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			buttonClass="button";
			// buttonType=Prop::Buttons::Type::normal; // is this really necessary?
			registerButton();
		}
	}
} }

namespace Prop { namespace ButtonCode { Template@ thisTemplate=Template();
	class Instance : Prop::Buttons::Instance { Instance() {super(@thisTemplate);}
		void onPicked() {
			Debug::log("onPicked -> [ButtonCode]");
		}
	}
	class Spawner : Prop::Buttons::Spawner { Spawner() { super(); } }
	class Template : Prop::Buttons::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			buttonClass="buttoncode";
			// buttonType=Prop::Buttons::Type::code; // is this really necessary?
			registerButton();
		}
	}
} }


namespace Prop { namespace ButtonElevator { Template@ thisTemplate=Template();
	class Instance : Prop::Buttons::Instance { Instance() {super(@thisTemplate);}
		void onPicked() {
			Debug::log("onPicked -> [ButtonElevator]");
		}
	}
	class Spawner : Prop::Buttons::Spawner { Spawner() { super(); } }
	class Template : Prop::Buttons::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			buttonClass="buttonelevator";
			// buttonType=Prop::Buttons::Type::elevator; // is this really necessary?
			registerButton();
		}
	}
} }

namespace Prop { namespace ButtonKeycard { Template@ thisTemplate=Template();
	class Instance : Prop::Buttons::Instance { Instance() {super(@thisTemplate);}
		void onPicked() {
			Debug::log("onPicked -> [ButtonKeycard]");
		}
	}
	class Spawner : Prop::Buttons::Spawner { Spawner() { super(); } }
	class Template : Prop::Buttons::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			buttonClass="buttonkeycard";
			// buttonType=Prop::Buttons::Type::keycard; // is this really necessary?
			registerButton();
		}
	}
} }

namespace Prop { namespace ButtonScanner { Template@ thisTemplate=Template();
	class Instance : Prop::Buttons::Instance { Instance() {super(@thisTemplate);}
		void onPicked() {
			Debug::log("onPicked -> [ButtonScanner]");
		}
	}
	class Spawner : Prop::Buttons::Spawner { Spawner() { super(); } }
	class Template : Prop::Buttons::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			buttonClass="buttonscanner";
			// buttonType=Prop::Buttons::Type::scanner; // is this really necessary?
			registerButton();
		}
	}
} }
