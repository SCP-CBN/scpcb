// # gasmask ----

namespace Item { namespace Gasmask { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "Gasmask"; // "gasmask"
			@pickSound	= Item::Sound(); // 2
			@model		= Item::Model("SCPCB/GFX/Items/Gasmask/Gasmask.fbx",0.2);
			@icon		= Item::Icon("SCPCB/GFX/Items/Gasmask/inv_gasmask.jpg");
			@iconModel	= Item::Icon::Model(model.path,0.08,Vector3f(2.3,2.7,0),Vector2f(0,0.2));
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

	it = CreateItemTemplate("Gas Mask", "gasmask", "GFX\items\gasmask.b3d", "GFX\items\INVgasmask.jpg", "", 0.02) : it\sound = 2
	it = CreateItemTemplate("Gas Mask", "supergasmask", "GFX\items\gasmask.b3d", "GFX\items\INVgasmask.jpg", "", 0.021) : it\sound = 2
	it = CreateItemTemplate("Heavy Gas Mask", "gasmask3", "GFX\items\gasmask.b3d", "GFX\items\INVgasmask.jpg", "", 0.021) : it\sound = 2

DrawGuiItem
				Case "gasmask", "supergasmask", "gasmask3"
					;[Block]
					If Wearing1499 = 0 And WearingHazmat = 0 Then
						If WearingGasMask Then
							Msg = "You removed the gas mask."
						Else
							If SelectedItem\itemtemplate\tempname = "supergasmask"
								Msg = "You put on the gas mask and you can breathe easier."
							Else
								Msg = "You put on the gas mask."
							EndIf
							If WearingNightVision Then CameraFogFar = StoredCameraFogFar
							WearingNightVision = 0
							WearingGasMask = 0
						EndIf
						If SelectedItem\itemtemplate\tempname="gasmask3" Then
							If WearingGasMask = 0 Then WearingGasMask = 3 Else WearingGasMask=0
						ElseIf SelectedItem\itemtemplate\tempname="supergasmask"
							If WearingGasMask = 0 Then WearingGasMask = 2 Else WearingGasMask=0
						Else
							WearingGasMask = (Not WearingGasMask)
						EndIf
					ElseIf Wearing1499 > 0 Then
						Msg = "You need to take off SCP-1499 in order to put on the gas mask."
					Else
						Msg = "You need to take off the hazmat suit in order to put on the gas mask."
					EndIf
					SelectedItem = Null
					MsgTimer = 70 * 5
					;[End Block]

*/

