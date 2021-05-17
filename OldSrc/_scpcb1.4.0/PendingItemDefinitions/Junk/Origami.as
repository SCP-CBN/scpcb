/*

!!! MODEL IS BROKEN // MISSING TEXTURE! !!!

namespace Item { namespace Origami { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Origami"; // "origami"
			@pickSound	= Item::Sound(); // 0
			@model		= Item::Model(rootDirGFXItems + "Junk/" + name + "/" + name + ".fbx",0.03);
			@icon		= Item::Icon(rootDirGFXItems + "Junk/" + name + "/inv_" + name + ".jpg");
			@iconModel	= Item::Icon::Model(model.path,model.scale,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
	}
	class Instance : Item { Instance() {super(@thisTemplate);} }
	class Spawner : Item::Spawner { Spawner() {} }
}};

*/


/* Originals --------------------------------------
	it = CreateItemTemplate("Origami", "misc", "GFX\items\origami.b3d", "GFX\items\INVorigami.jpg", "", 0.003) : it\sound = 0
*/

