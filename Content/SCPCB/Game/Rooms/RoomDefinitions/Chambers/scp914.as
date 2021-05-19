namespace Room { namespace test914 { Template@ thisTemplate=Template();
	class Template : Room::Template { Room@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "scp914";
			zone		= "LCZ";
			@model		= Room::ModelCBR("Assets/CBR/test914.cbr");
		}
	}

	class Instance : Room {
		Instance() {super(@thisTemplate); };
		void construct() {
			float ang=rotation;
			Vector3f doorPos=position+Util::Vector3f::rotate(Vector3f(0,0,-101),-ang);
			Prop::spawn("door",doorPos,Vector3f(0,ang,0));

			Vector3f heavydoorPos=position+Util::Vector3f::rotate(Vector3f(0,0,101),-ang);
			Prop::Doors::Instance@ heavydoor=Prop::Cast::Doors(Prop::spawn("containmentdoor",heavydoorPos,Vector3f(0,ang,0)));
			
		}

	}
	class Spawner : Room::Spawner {
		Spawner() {
		}
	}
}};
