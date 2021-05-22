// # Cup ----
namespace Item { namespace Cup { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Cup"; // "cup"
			@pickSound	= Item::Sound(); // 2
			@model		= Item::Model(rootDirGFXItems + name + "/" + name + ".fbx",0.4);
			@icon		= Item::Icon(rootDirGFXItems + name + "/" + "inv_" + name);
			@iconModel	= Item::Icon::Model(model.path,model.scale,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
		array<Liquid@> liquids;
	}
	class Instance : Item { Instance() {super(@thisTemplate);};
		Liquid@ liquid;
		void doTest() {
			Debug::log("I'm a " + thisTemplate.name);
		}
	}
	class Spawner : Item::Spawner {
		Spawner() {
		}
	}



	class Liquid {
		string name; // "cup of" or "a cup of".
		string description;

		Color color;

		bool lethal;
		float lethalTimer; // *70
		string lethalMessage;

		bool drinkable;
		string drinkMessage;

		float injuries; // ;*temp
		float bloodloss; // ;*temp

		float blink; // *refinedMultiplier
		float blinkDuration; // *refinedMultiplier

		float stamina; // *refinedMultiplier
		float staminaDuration; // *refinedMultiplier

		float blurTimer; // *70; *temp? I couldn't find a definition for ;*temp.
		float vomitTimer; // *70; *temp?
		float camshakeTimer; //
		string sound; // playsound_strict; temp sound;

		int refinedMultiplier; // scp914 -- Fine = x2, very fine = x3?x4?

		string refuseMessage;
		float msgTimerMSec=70*6 *10; // I assume this is in 10th's of a second. =420 = 4.2 seconds. Means timers are *10 off milliseconds. Used for all timers?

		bool stomachache; // SCP1025state[3]=1

		Liquid(string&in nm, Color&in col) {
			name=nm;
			color=col;
		}
	}

}};


// # Empty Cup ----
namespace Item { namespace EmptyCup { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "EmptyCup"; // "emptycup"
			@pickSound	= Item::Sound(); // 2
			@model		= Item::Model(rootDirGFXItems + "Cup/Cup.fbx",0.4);
			@icon		= Item::Icon(rootDirGFXItems + "Cup/inv_cup");
			@iconModel	= Item::Icon::Model(model.path,model.scale,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
		}
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



/* Originals --------------------------------------


draw_gui_item





				Case "cup"
					;[Block]
					If CanUseItem(False,False,True)
						
		;the state of refined items is more than 1.0 (fine setting increases it by 1, very fine doubles it)
		x2 = (SelectedItem\state+1.0)
		Local iniStr$ = "DATA\SCP-294.ini"

		strtemp = GetINIString2(iniStr, loc, "message")

		BlurTimer = GetINIInt2(iniStr, loc, "blur")*70;*temp
		If VomitTimer = 0 Then VomitTimer = GetINIInt2(iniStr, loc, "vomit")
		CameraShakeTimer = GetINIString2(iniStr, loc, "camerashake")
		Injuries = Max(Injuries + GetINIInt2(iniStr, loc, "damage"),0);*temp
		Bloodloss = Max(Bloodloss + GetINIInt2(iniStr, loc, "blood loss"),0);*temp
		DeathTimer=GetINIInt2(iniStr, loc, "deathtimer")*70
		If GetINIInt2(iniStr, loc, "stomachache") Then SCP1025state[3]=1
			
		BlinkEffect = Float(GetINIString2(iniStr, loc, "blink effect", 1.0))*x2
		BlinkEffectTimer = Float(GetINIString2(iniStr, loc, "blink effect timer", 1.0))*x2			
		StaminaEffect = Float(GetINIString2(iniStr, loc, "stamina effect", 1.0))*x2
		StaminaEffectTimer = Float(GetINIString2(iniStr, loc, "stamina effect timer", 1.0))*x2
						
		it.Items = CreateItem("Empty Cup", "emptycup", 0,0,0)
		it\Picked = True
		RemoveInventoryItem(SelectedItem)						
		SelectedItem = Null
					EndIf
					;[End Block]

*/

