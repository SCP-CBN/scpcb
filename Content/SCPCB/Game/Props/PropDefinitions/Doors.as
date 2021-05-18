
// # Prop::Cast::Doors(@prop); <Cast as Button> ----
namespace Prop { namespace Cast { Prop::Doors::Instance@ Doors(Prop@ obj) { return cast<Prop::Doors::Instance>(@obj); } } }

// # Prop::Doors (parent prop type, note Button[S] from regular button); ----
namespace Prop { namespace Doors {
	enum Type {
	}
	// # Prop::Doors::Template; ----
	abstract class Template : Prop::Template {
		Template() { super();
			@pickSound	= Prop::Sound(); // 2
			@model		= Prop::Model(rootDirGFXProps + "Doors/DoorFrame.fbx", 0.1);
			@doorInnerModel	= Prop::Model(rootDirGFXProps + "Doors/door.fbx",1.35);
			@doorOuterModel	= Prop::Model(rootDirGFXProps + "Doors/door.fbx",1.35);
			@iconModel	= Prop::Icon::Model(model.path,0.8,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
		void registerDoor() {
			name = doorClass;
			iconModel.path=doorInnerModel.path;
		}

		string doorClass;
		Util::Model@ doorInnerModel;
		Util::Model@ doorOuterModel;
	}

	// # Prop::Doors::Instance; ----
	abstract class Instance : Prop {
		Game::Model@ doorInner;
		Game::Model@ doorOuter;
		Vector3f position { get { return model.position; } set {
			model.position=value;
			updateDoorPositions(value);
		} }
		Vector3f rotation { get { return model.rotation; } set {
			model.rotation=value;
			doorInner.rotation=value+Vector3f(0,Math::PI,0);
			doorOuter.rotation=value;
		} }
		void updateDoorPositions(Vector3f&in vec) {
			doorInner.position=vec+Vector3f(-1,0,-1);
			doorOuter.position=vec+Vector3f(1,0,1);
		}
		Instance(Prop::Doors::Template@ subTemplate) { super(@subTemplate);
			@doorInner=@subTemplate.doorInnerModel.instantiate();
			@doorOuter=@subTemplate.doorOuterModel.instantiate();
		}
		array<Prop@> buttons;
		void render() {
			model.render();
			doorInner.render();
			doorOuter.render();
		}
		float accum;
		void update() {
			accum+=Environment::interp*0.5;
			float sinx=Math::sin(accum);
			doorInner.position=position+Vector3f(sinx*15,0,0);
			doorOuter.position=position-Vector3f(sinx*15,0,0);
		}
	}

	// # Prop::Doors::Spawner; ----
	abstract class Spawner : Prop::Spawner { Spawner() {super();}
	}
} }


// # Sample Prop
namespace Prop { namespace Door { Template@ thisTemplate=Template();
	class Instance : Prop::Doors::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Prop::Doors::Spawner { Spawner() { super(); } }
	class Template : Prop::Doors::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			doorClass="door";
			registerDoor();
		}
	}
} }

namespace Prop { namespace HeavyDoor { Template@ thisTemplate=Template();
	class Instance : Prop::Doors::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Prop::Doors::Spawner { Spawner() { super(); } }
	class Template : Prop::Doors::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			doorClass="heavydoor";
			//model.path = rootDirGFXProps + "Doors/" + doorFrameModel + ".fbx";
			doorInnerModel.path = rootDirGFXProps + "Doors/heavydoor1.fbx";
			doorOuterModel.path = rootDirGFXProps + "Doors/heavydoor2.fbx";
			registerDoor();
		}
	}
} }


namespace Prop { namespace ContainmentDoor { Template@ thisTemplate=Template();
	class Instance : Prop::Doors::Instance { Instance() {super(@thisTemplate);} }
	class Spawner : Prop::Doors::Spawner { Spawner() { super(); } }
	class Template : Prop::Doors::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			doorClass="containmentdoor";
			model.path = rootDirGFXProps + "Doors/ContDoorFrame.fbx";
			doorInnerModel.path = rootDirGFXProps + "Doors/ContDoorLeft.fbx";
			doorOuterModel.path = rootDirGFXProps + "Doors/ContDoorRight.fbx";
			registerDoor();
		}
	}
} }
