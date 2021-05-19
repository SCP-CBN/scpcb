namespace Room { namespace rroom2C { Template@ thisTemplate=Template();
	class Template : Room::Template { Room@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "room2C";
			zone		= "LCZ";
			@model		= Room::ModelCBR(rootDirCBR + "Import/" + name + ".cbr");
		}
	}

	class Instance : Room {
		Instance() {super(@thisTemplate); };
		void construct() {
			float ang=rotation;
			Vector3f doorPos=position+Util::Vector3f::rotate(Vector3f(0,0,-101),-ang);
			Prop::spawn("door",doorPos,Vector3f(0,ang,0));
		}

	}
	class Spawner : Room::Spawner {
		Spawner() {
		}
	}
}};
