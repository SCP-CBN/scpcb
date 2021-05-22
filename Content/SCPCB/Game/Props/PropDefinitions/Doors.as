
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
			model.pickable	= false;
			@doorInnerModel	= Prop::Model(rootDirGFXProps + "Doors/door.fbx",Vector3f(1.8,1.3,1.5));
			@doorOuterModel	= Prop::Model(rootDirGFXProps + "Doors/door.fbx",Vector3f(1.8,1.3,1.5));
			@iconModel	= Prop::Icon::Model(doorInnerModel.path,0.2,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
		void registerDoor() {
			name = doorClass;
			iconModel.path=doorInnerModel.path;
		}
		float doorScale=1.f;
		float slideSize=8.95;
		float slideInset=1.15;
		string doorClass;
		Util::Model@ doorInnerModel;
		Util::Model@ doorOuterModel;
	}

	// # Prop::Doors::Instance; ----
	abstract class Instance : Prop {
		Template@ doorTemplate;
		Game::Model@ doorInner;
		Game::Model@ doorOuter;
		float slideSize;
		float slideInset;
		Vector3f position { get { return model.position; } set {
			model.position=value;
			updateButtonPositions();
		} }
		Vector3f rotation { get { return model.rotation; } set {
			model.rotation=value;
			doorInner.rotation=value+Vector3f(0,Math::PI,0);
			doorOuter.rotation=value;
			updateButtonPositions();
		} }
		void updateDoorPositions() {
			float angle=-rotation.y;

			float doorPct=1.f+Math::cos(accum);
			Vector2f innerDoorSlide=Util::Vector2f::rotate(Vector2f(doorTemplate.slideSize*doorPct-0.5,-doorTemplate.slideInset),angle);
			Vector2f outerDoorSlide=Util::Vector2f::rotate(Vector2f(-doorTemplate.slideSize*doorPct+0.5,doorTemplate.slideInset),angle);

			doorInner.position=position+Vector3f(innerDoorSlide.x,0.25f,innerDoorSlide.y);
			doorOuter.position=position+Vector3f(outerDoorSlide.x,0.25f,outerDoorSlide.y);
		}
		Instance(Prop::Doors::Template@ subTemplate) { super(@subTemplate);
			@doorTemplate=@subTemplate;
			@doorInner=@subTemplate.doorInnerModel.instantiate();
			@doorOuter=@subTemplate.doorOuterModel.instantiate();

			@btnInner=Prop::Cast::Buttons(@Prop::spawn("button"));
			@btnOuter=Prop::Cast::Buttons(@Prop::spawn("button"));
			@btnInner.door=@this;
			@btnOuter.door=@this;
		}
		Prop::Buttons::Instance@ btnInner;
		Prop::Buttons::Instance@ btnOuter;
		void updateButtonPositions() {
			btnInner.position=Util::Vector3f::localToWorldPos(position,rotation,Vector3f(15.f,15.f,5.f));
			btnOuter.position=Util::Vector3f::localToWorldPos(position,rotation,Vector3f(-15.f,15.f,-5.f));
			btnInner.rotation=rotation+Vector3f(0,Math::PI,0);
		}

		array<Prop::Buttons::Instance@> buttons;
		void render() {
			model.render();
			doorInner.render();
			doorOuter.render();
		}
		float accum=Math::PI;
		bool animating;
		bool isOpen=false;
		void open() {
			isOpen=true;
			animating=true;
		}
		void close() {
			isOpen=false;
			animating=true;
		}
		void toggle() { if(!animating) { if(!isOpen) { open(); } else { close(); } } }
		void update() {
			if(animating) {
				if(isOpen) {
					if(accum < Math::PI2f) {
						accum=Math::minFloat(accum+Environment::interp*2,Math::PI2f);
					} else {
						accum=0.f;
						animating = false;
					}
				} else {
					if(accum < Math::PI) {
						accum=Math::minFloat(accum+Environment::interp*2,Math::PI);
					} else {
						accum=Math::PI;
						animating=false;
					}
				}
			}
			// if(template.name=="door") { Debug::log(accum); } // relative to math.pi because math.sin.
			//rotation=Vector3f(rotation.x,rotation.y+0.1,rotation.z);
			updateDoorPositions();
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
			doorInnerModel.scale=Vector3f(0.1);
			doorOuterModel.scale=Vector3f(0.1);
			slideInset=0.f;
			registerDoor();
		}
	}
} }


namespace Prop { namespace ContainmentDoor { Template@ thisTemplate=Template();
	class Spawner : Prop::Doors::Spawner { Spawner() { super(); } }
	class Template : Prop::Doors::Template { Prop@ instantiate() { return Instance(); }
		Template() { super();
			doorClass="containmentdoor";
			model.path = rootDirGFXProps + "Doors/ContDoorFrame.fbx";
			model.scale=Vector3f(5);
			doorInnerModel.path = rootDirGFXProps + "Doors/ContDoorLeft.fbx";
			doorOuterModel.path = rootDirGFXProps + "Doors/ContDoorRight.fbx";
			doorInnerModel.scale=Vector3f(5);
			doorOuterModel.scale=Vector3f(5);
			slideInset=0.f;
			slideSize=-16.f;
			registerDoor();
		}
	}
	class Instance : Prop::Doors::Instance { Instance() {super(@thisTemplate);}
		Vector3f rotation { get { return model.rotation; } set {
			model.rotation=value;
			doorInner.rotation=value;
			doorOuter.rotation=value;
		} }
	}
} }
