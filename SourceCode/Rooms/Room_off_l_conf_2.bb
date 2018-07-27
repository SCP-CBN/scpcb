Function FillRoom_off_l_conf_2(r.Room)
    Local d.Door, d2.Door, sc.SecurityCam, de.Decal, r2.Room, sc2.SecurityCam
	Local it.Item, i%
	Local xtemp%, ytemp%, ztemp%

	Local t1%;, Bump

    d = CreateDoor(r\x + 240.0 * RoomScale, 0.0, r\z + 48.0 * RoomScale, 270, r, False, DOOR_TYPE_DEF, r\roomTemplate\name)
    PositionEntity(d\buttons[0], r\x + 224.0 * RoomScale, EntityY(d\buttons[0],True), r\z + 176.0 * RoomScale,True)
    PositionEntity(d\buttons[1], r\x + 256.0 * RoomScale, EntityY(d\buttons[1],True), EntityZ(d\buttons[1],True),True)
    d\autoClose = False : d\open = False

    r\doors[0] = CreateDoor(r\x - 432.0 * RoomScale, 0.0, r\z, 90, r, False, DOOR_TYPE_DEF, "", "1234")
    PositionEntity(r\doors[0]\buttons[0], r\x - 416.0 * RoomScale, EntityY(r\doors[0]\buttons[0],True), r\z + 176.0 * RoomScale,True)
    FreeEntity(r\doors[0]\buttons[1])
	r\doors[0]\buttons[1] = 0
    r\doors[0]\autoClose = False : r\doors[0]\open = False : r\doors[0]\locked = True

    de = CreateDecal(DECAL_CORROSION, r\x - 808.0 * RoomScale, 0.005, r\z - 72.0 * RoomScale, 90, Rand(360), 0)
    EntityParent(de\obj, r\obj)
    de = CreateDecal(DECAL_BLOOD_SPREAD, r\x - 808.0 * RoomScale, 0.01, r\z - 72.0 * RoomScale, 90, Rand(360), 0)
    de\size = 0.3 : ScaleSprite(de\obj, de\size, de\size) : EntityParent(de\obj, r\obj)

    de = CreateDecal(DECAL_CORROSION, r\x - 432.0 * RoomScale, 0.01, r\z, 90, Rand(360), 0)
    EntityParent(de\obj, r\obj)

    r\objects[0] = CreatePivot(r\obj)
    PositionEntity(r\objects[0], r\x - 808.0 * RoomScale, 1.0, r\z - 72.0 * RoomScale, True)

    it = CreatePaper("drL1", r\x - 688.0 * RoomScale, 1.0, r\z - 16.0 * RoomScale)
    EntityParent(it\collider, r\obj)

    it = CreatePaper("drL5", r\x - 808.0 * RoomScale, 1.0, r\z - 72.0 * RoomScale)
    EntityParent(it\collider, r\obj)
End Function


Function UpdateEvent_off_l_conf_2(e.Event)
	Local dist#, i%, temp%, pvt%, strtemp$, j%, k%

	Local p.Particle, n.NPC, r.Room, e2.Event, it.Item, em.Emitter, sc.SecurityCam, sc2.SecurityCam

	Local CurrTrigger$ = ""

	Local x#, y#, z#

	Local angle#

	;[Block]
	If (mainPlayer\currRoom = e\room) Then
		If (e\eventState = 0) Then
			If (e\room\doors[0]\open = True) Then
				If (e\room\doors[0]\openstate = 180) Then
					e\eventState = 1
					;TODO: load temp sound.
					;TODO: fix
					;PlaySound2(HorrorSFX(5))
				EndIf
			Else
				If (EntityDistance(mainPlayer\collider, e\room\doors[0]\obj)<1.5) And (RemoteDoorOn) Then
					e\room\doors[0]\open = True
				EndIf
			EndIf
		Else
			If (EntityDistance(e\room\objects[0], mainPlayer\collider) < 2.0) Then
				;HeartBeatVolume = CurveValue(0.5, HeartBeatVolume, 5)
				mainPlayer\heartbeatIntensity = CurveValue(120, mainPlayer\heartbeatIntensity, 150)
				;TODO: fix
				;e\soundChannels[0] = LoopRangedSound(OldManSFX(4), e\soundChannels[0], mainPlayer\cam, e\room\obj, 5.0, 0.3)
				Curr106\state=Curr106\state-timing\tickDuration*3
			EndIf

		EndIf
	EndIf
	;[End Block]
End Function

;~IDEal Editor Parameters:
;~C#Blitz3D