class ItemTemplate_Gasmask : Item::Template {
	Item@ MakeInstance() {
		Item @instance = Item_Gasmask(@this);
		return @instance;
	}
	ItemTemplate_Gasmask() { super();
		
		name = "Gasmask";
		modelPath = "SCPCB/GFX/Items/Gasmask/Gasmask.fbx";
		modelScale = 0.02;

		pickSoundID=2;

		useModelIcon=true;
		iconImage = "GFX\items\INVgasmask.jpg";
		iconScale = 0.08;
		iconRot = Vector3f(2.3,2.7,0);
		iconPos = Vector2f(0,0.2);

		Item::Register(@this);
	}
}
ItemTemplate_Gasmask OriginItem_Gasmask;


shared class Item_Gasmask : Item {
	Item_Gasmask(Item::Template@&in origin) { super(@origin);
		// onConstructed();
	}

	void Test() {
		Debug::log("Im a gasmask");
	}
}


/*

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
