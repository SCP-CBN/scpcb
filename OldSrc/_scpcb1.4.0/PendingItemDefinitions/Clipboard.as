/*

!!! BROKEN MODEL !!!

namespace Item { namespace Clipboard { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Clipboard"; // "clipboard"
			@pickSound	= Item::Sound(); // 1, probably
			@model		= Item::Model(rootDirGFXItems + name + "/" + name + ".fbx", 0.003);
			@icon		= Item::Icon(rootDirGFXItems + name + "/inv_" + name + ".jpg");
			@iconModel	= Item::Icon::Model(model.path,0.08,Vector3f(2.3,2.7,0),Vector2f(0,0.2));

			@iconClipboardEmpty = Item::Icon(rootDirGFXItems + name + "/inv_" + name + "_empty.jpg");
		}
		Item::Icon@ iconClipboardEmpty;
	}
	class Instance : Item { Instance() {super(@thisTemplate);};
		void doTest() {
			Debug::log("I'm a " + thisTemplate.name);
		}
	}
	class Spawner : Item::Spawner {
		Spawner() {
		}
	}
}};

*/


/* Originals --------------------------------------

Definitions

	it = CreateItemTemplate("Wallet","wallet", "GFX\items\wallet.b3d", "GFX\items\INVwallet.jpg", "", 0.0005,"","",1) : it\sound = 2
	it = CreateItemTemplate("Clipboard", "clipboard", "GFX\items\clipboard.b3d", "GFX\items\INVclipboard.jpg", "", 0.003, "", "GFX\items\INVclipboard2.jpg", 1)

*/
