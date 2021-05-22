namespace Item { namespace Electronics { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Electronics"; // "misc"
			@pickSound	= Item::Sound(); // 1, probably
			@model		= Item::Model(rootDirGFXItems + "Junk/" + name + "/" + name + ".fbx",0.011);
			@icon		= Item::Icon(rootDirGFXItems + "Junk/" + name + "/inv_" + name);
			@iconModel	= Item::Icon::Model(model.path,model.scale,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
	}
	class Instance : Item { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Spawner {Spawner() {}}
}};
/* Originals --------------------------------------
*/
