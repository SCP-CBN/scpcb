Function FillRoom_tnnl_nuke_2(r.Rooms)
    Local d.Doors, d2.Doors, sc.SecurityCams, de.Decals, r2.Rooms, sc2.SecurityCams
	Local it.Items, i%
	Local xtemp%, ytemp%, ztemp%
	
	Local t1;, Bump
    
    ;"tuulikaapin" ovi
    d = CreateDoor(r\zone, r\x + 576.0 * RoomScale, 0.0, r\z - 152.0 * RoomScale, 90, r, False, False, 5)
    d\autoClose = False : d\open = False
    PositionEntity(d\buttons[0], r\x + 608.0 * RoomScale, EntityY(d\buttons[0],True), r\z - 284.0 * RoomScale,True)
    PositionEntity(d\buttons[1], r\x + 544.0 * RoomScale, EntityY(d\buttons[1],True), r\z - 284.0 * RoomScale,True)			
    
    d = CreateDoor(r\zone, r\x - 544.0 * RoomScale, 1504.0*RoomScale, r\z + 738.0 * RoomScale, 90, r, False, False, 5)
    d\autoClose = False : d\open = False			
    PositionEntity(d\buttons[0], EntityX(d\buttons[0],True), EntityY(d\buttons[0],True), r\z + 608.0 * RoomScale,True)
    PositionEntity(d\buttons[1], EntityX(d\buttons[1],True), EntityY(d\buttons[1],True), r\z + 608.0 * RoomScale,True)
    
    ;yl�kerran hissin ovi
    r\RoomDoors[0] = CreateDoor(r\zone, r\x + 1192.0 * RoomScale, 0.0, r\z, 90, r, True)
    r\RoomDoors[0]\autoClose = False : r\RoomDoors[0]\open = True
    ;yl�kerran hissi
    r\Objects[4] = CreatePivot()
    PositionEntity(r\Objects[4], r\x + 1496.0 * RoomScale, 240.0 * RoomScale, r\z)
    EntityParent(r\Objects[4], r\obj)
    ;alakerran hissin ovi
    r\RoomDoors[1] = CreateDoor(r\zone, r\x + 680.0 * RoomScale, 1504.0 * RoomScale, r\z, 90, r, False)
    r\RoomDoors[1]\autoClose = False : r\RoomDoors[1]\open = False
    ;alakerran hissi
    r\Objects[5] = CreatePivot()
    PositionEntity(r\Objects[5], r\x + 984.0 * RoomScale, 1744.0 * RoomScale, r\z)
    EntityParent(r\Objects[5], r\obj)
    
    For n% = 0 To 1
        r\Levers[n] = CreateLever()
        
        ScaleEntity(r\Levers[n]\obj, 0.04, 0.04, 0.04)
        ScaleEntity(r\Levers[n]\baseObj, 0.04, 0.04, 0.04)
        PositionEntity (r\Levers[n]\obj, r\x - 975.0 * RoomScale, r\y + 1712.0 * RoomScale, r\z - (502.0-132.0*n) * RoomScale, True)
        PositionEntity (r\Levers[n]\baseObj, r\x - 975.0 * RoomScale, r\y + 1712.0 * RoomScale, r\z - (502.0-132.0*n) * RoomScale, True)
        
        EntityParent(r\Levers[n]\obj, r\obj)
        EntityParent(r\Levers[n]\baseObj, r\obj)

        RotateEntity(r\Levers[n]\baseObj, 0, -90-180, 0)
        RotateEntity(r\Levers[n]\obj, 10, -90 - 180-180, 0)
        
        ;EntityPickMode(r\Levers[n]\obj, 2)
        EntityPickMode r\Levers[n]\obj, 1, False
        EntityRadius r\Levers[n]\obj, 0.1
        ;makecollbox(r\Levers[n]\obj)
    Next
    
    it = CreateItem("Nuclear Device Document", "paper", r\x - 768.0 * RoomScale, r\y + 1684.0 * RoomScale, r\z - 768.0 * RoomScale)
    EntityParent(it\collider, r\obj)
    
    it = CreateItem("Ballistic Vest", "vest", r\x - 944.0 * RoomScale, r\y + 1652.0 * RoomScale, r\z - 656.0 * RoomScale)
    EntityParent(it\collider, r\obj) : RotateEntity(it\collider, 0, -90, 0)
    
    it = CreateItem("Dr L's Note", "paper", r\x + 800.0 * RoomScale, 88.0 * RoomScale, r\z + 256.0 * RoomScale)
    EntityParent(it\collider, r\obj)
    
    sc.SecurityCams = CreateSecurityCam(r\x+624.0*RoomScale, r\y+1888.0*RoomScale, r\z-312.0*RoomScale, r)
    sc\angle = 90
    sc\turn = 45
    TurnEntity(sc\cameraObj, 20, 0, 0)
    sc\ID = 6
End Function


Function UpdateEvent_tnnl_nuke_2(e.Events)
	Local dist#, i%, temp%, pvt%, strtemp$, j%, k%

	Local p.Particles, n.NPCs, r.Rooms, e2.Events, it.Items, em.Emitters, sc.SecurityCams, sc2.SecurityCams

	Local CurrTrigger$ = ""

	Local x#, y#, z#

	Local angle#

	;[Block]
	If mainPlayer\currRoom = e\room Then
		e\eventState2 = UpdateElevators(e\eventState2, e\room\RoomDoors[0], e\room\RoomDoors[1], e\room\Objects[4], e\room\Objects[5], e)
		
		e\eventState = e\room\Levers[0]\succ
	EndIf
	;[End Block]
End Function


;~IDEal Editor Parameters:
;~C#Blitz3D