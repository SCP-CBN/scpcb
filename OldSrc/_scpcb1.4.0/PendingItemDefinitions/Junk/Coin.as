/* .FBX is missing

namespace Item { namespace Coin { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Coin"; // "misc"
			@pickSound	= Item::Sound(); // 1, probably
			@model		= Item::Model(rootDirItems + "Junk/" + name + "/" + name + ".fbx",0.011);
			@icon		= Item::Icon(rootDirItems + "Junk/" + name + "/inv_" + name + ".jpg");
			@iconModel	= Item::Icon::Model(model.path,model.scale,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
	}
	class Instance : Item { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Spawner {Spawner() {}}
}};

*/

/* Originals --------------------------------------
*/
