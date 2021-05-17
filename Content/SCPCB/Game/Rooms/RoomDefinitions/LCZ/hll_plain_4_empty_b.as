namespace Room { namespace hll_plain_4_empty_b { Template@ thisTemplate=Template();
	class Template : Room::Template { Room@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "hll_plain_4_empty_b";
			zone		= "LCZ";
			@model		= Room::Model(rootDirCBR_LCZ + name + "/" + name + ".rm2");
		}
	}
	class Instance : Room { Instance() {super(@thisTemplate);};
		void doTest() {
			Debug::log("I'm a " + thisTemplate.name);
		}
	}
	class Spawner : Room::Spawner {
		Spawner() {
		}
	}
}};
