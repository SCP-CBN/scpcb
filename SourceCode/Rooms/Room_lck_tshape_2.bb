Function FillRoom_lck_tshape_2(r.Room)
    Local d.Door, d2.Door, sc.SecurityCam, de.Decal, r2.Room, sc2.SecurityCam
    Local it.Item, i%
    Local xtemp%, ytemp%, ztemp%

    Local t1%;, Bump

    d = CreateDoor(r\zone, r\x, 0, r\z + 528.0 * RoomScale, 0, r, True)
    d\autoClose = False ;: d\buttons[0] = False
    PositionEntity(d\buttons[0], r\x - 832.0 * RoomScale, 0.7, r\z + 160.0 * RoomScale, True)
    PositionEntity(d\buttons[1], r\x + 160.0 * RoomScale, 0.7, r\z + 536.0 * RoomScale, True)
    ;RotateEntity(d\buttons[1], 0, 90, 0, True)

    d2 = CreateDoor(r\zone, r\x, 0, r\z - 528.0 * RoomScale, 180, r, True)
    d2\autoClose = False
	FreeEntity(d2\buttons[0])
	d2\buttons[0] = 0
    PositionEntity(d2\buttons[1], r\x +160.0 * RoomScale, 0.7, r\z - 536.0 * RoomScale, True)
    ;RotateEntity(d2\buttons[1], 0, 90, 0, True)

    r\objects[0] = CreatePivot()
    PositionEntity(r\objects[0], r\x - 832.0 * RoomScale, 0.5, r\z)
    EntityParent(r\objects[0], r\obj)

    d2\linkedDoor = d : d\linkedDoor = d2

    d\open = False : d2\open = True
End Function


Function UpdateEventRoom2doors173(e.Event)
	Local dist#, i%, temp%, pvt%, strtemp$, j%, k%

	Local p.Particle, n.NPC, r.Room, e2.Event, it.Item, em.Emitter, sc.SecurityCam, sc2.SecurityCam

	Local CurrTrigger$ = ""

	Local x#, y#, z#

	Local angle#

	;[Block]
	If (mainPlayer\currRoom = e\room) Then
		If (e\eventState = 0 And Curr173\idle = 0) Then
			If (Not EntityInView(Curr173\obj, mainPlayer\cam)) Then
				e\eventState = 1
				PositionEntity(Curr173\collider, EntityX(e\room\objects[0], True), 0.5, EntityZ(e\room\objects[0], True))
				ResetEntity(Curr173\collider)
				RemoveEvent(e)
			EndIf
		EndIf
	EndIf
	;[End Block]
End Function


;~IDEal Editor Parameters:
;~C#Blitz3D