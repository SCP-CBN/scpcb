

/*

Definitions

	it = CreateItemTemplate("Night Vision Goggles", "supernv", "GFX\items\NVG.b3d", "GFX\items\INVsupernightvision.jpg", "", 0.02) : it\sound = 2
	it = CreateItemTemplate("Night Vision Goggles", "nvgoggles", "GFX\items\NVG.b3d", "GFX\items\INVnightvision.jpg", "", 0.02) : it\sound = 2
	it = CreateItemTemplate("Night Vision Goggles", "finenvgoggles", "GFX\items\NVG.b3d", "GFX\items\INVveryfinenightvision.jpg", "", 0.02) : it\sound = 2
	


drawgui

				Case "nvgoggles"
					;[Block]
					If Wearing1499 = 0 And WearingHazmat=0 Then
						If WearingNightVision = 1 Then
							Msg = "You removed the goggles."
							CameraFogFar = StoredCameraFogFar
						Else
							Msg = "You put on the goggles."
							WearingGasMask = 0
							WearingNightVision = 0
							StoredCameraFogFar = CameraFogFar
							CameraFogFar = 30
						EndIf
						
						WearingNightVision = (Not WearingNightVision)
					ElseIf Wearing1499 > 0 Then
						Msg = "You need to take off SCP-1499 in order to put on the goggles."
					Else
						Msg = "You need to take off the hazmat suit in order to put on the goggles."
					EndIf
					SelectedItem = Null
					MsgTimer = 70 * 5
					;[End Block]

				Case "supernv"
					;[Block]
					If Wearing1499 = 0 And WearingHazmat=0 Then
						If WearingNightVision = 2 Then
							Msg = "You removed the goggles."
							CameraFogFar = StoredCameraFogFar
						Else
							Msg = "You put on the goggles."
							WearingGasMask = 0
							WearingNightVision = 0
							StoredCameraFogFar = CameraFogFar
							CameraFogFar = 30
						EndIf
						
						WearingNightVision = (Not WearingNightVision) * 2
					ElseIf Wearing1499 > 0 Then
						Msg = "You need to take off SCP-1499 in order to put on the goggles."
					Else
						Msg = "You need to take off the hazmat suit in order to put on the goggles."
					EndIf
					SelectedItem = Null
					MsgTimer = 70 * 5
					;[End Block]
				Case "finenvgoggles"
					;[Block]
					If Wearing1499 = 0 And WearingHazmat = 0 Then
						If WearingNightVision = 3 Then
							Msg = "You removed the goggles."
							CameraFogFar = StoredCameraFogFar
						Else
							Msg = "You put on the goggles."
							WearingGasMask = 0
							WearingNightVision = 0
							StoredCameraFogFar = CameraFogFar
							CameraFogFar = 30
						EndIf
						
						WearingNightVision = (Not WearingNightVision) * 3
					ElseIf Wearing1499 > 0 Then
						Msg = "You need to take off SCP-1499 in order to put on the goggles."
					Else
						Msg = "You need to take off the hazmat suit in order to put on the goggles."
					EndIf
					SelectedItem = Null
					MsgTimer = 70 * 5
					;[End Block]


*/
