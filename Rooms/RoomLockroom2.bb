;TODO: Remove?
Function FillRoomLockroom2(r.Rooms)
    Local d.Doors, d2.Doors, sc.SecurityCams, de.Decals, r2.Rooms, sc2.SecurityCams
	Local it.Items, i%
	Local xtemp%, ytemp%, ztemp%
	
	Local t1;, Bump

    For i = 0 To 5
        de.Decals = CreateDecal(Rand(2,3), r\x+Rnd(-392,520)*RoomScale, 3.0*RoomScale+Rnd(0,0.001), r\z+Rnd(-392,520)*RoomScale,90,Rnd(360),0)
        de\Size = Rnd(0.3,0.6)
        ScaleSprite(de\obj, de\Size,de\Size)
        CreateDecal(Rand(15,16), r\x+Rnd(-392,520)*RoomScale, 3.0*RoomScale+Rnd(0,0.001), r\z+Rnd(-392,520)*RoomScale,90,Rnd(360),0)
        de\Size = Rnd(0.1,0.6)
        ScaleSprite(de\obj, de\Size,de\Size)
        CreateDecal(Rand(15,16), r\x+Rnd(-0.5,0.5), 3.0*RoomScale+Rnd(0,0.001), r\z+Rnd(-0.5,0.5),90,Rnd(360),0)
        de\Size = Rnd(0.1,0.6)
        ScaleSprite(de\obj, de\Size,de\Size)
    Next

    sc.SecurityCams = CreateSecurityCam(r\x + 512.0 * RoomScale, r\y + 384 * RoomScale, r\z + 384.0 * RoomScale, r, True)
    sc\angle = 45 + 90
    sc\turn = 45
    TurnEntity(sc\CameraObj, 40, 0, 0)
    EntityParent(sc\obj, r\obj)

    PositionEntity(sc\ScrObj, r\x + 668 * RoomScale, 1.1, r\z - 96.0 * RoomScale)
    TurnEntity(sc\ScrObj, 0, 90, 0)
    EntityParent(sc\ScrObj, r\obj)

    sc.SecurityCams = CreateSecurityCam(r\x - 384.0 * RoomScale, r\y + 384 * RoomScale, r\z - 512.0 * RoomScale, r, True)
    sc\angle = 45 + 90 + 180
    sc\turn = 45

    TurnEntity(sc\CameraObj, 40, 0, 0)
    EntityParent(sc\obj, r\obj)				

    PositionEntity(sc\ScrObj, r\x + 96.0 * RoomScale, 1.1, r\z - 668.0 * RoomScale)
    EntityParent(sc\ScrObj, r\obj)
End Function

Function UpdateEventLockroom096(e.Events)
	Local dist#, i%, temp%, pvt%, strtemp$, j%, k%

	Local p.Particles, n.NPCs, r.Rooms, e2.Events, it.Items, em.Emitters, sc.SecurityCams, sc2.SecurityCams

	Local CurrTrigger$ = ""

	Local x#, y#, z#

	Local angle#

	;[Block]
	If mainPlayer\currRoom = e\room Then
		If Curr096=Null Then
			Curr096 = CreateNPC(NPCtype096, EntityX(e\room\obj,True), 0.3, EntityZ(e\room\obj,True))
			RotateEntity Curr096\Collider, 0, e\room\angle+45, 0, True
		EndIf
		RemoveEvent(e)
	End If
	;[End Block]
End Function

