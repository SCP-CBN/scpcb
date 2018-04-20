

Function UpdateEventTunnel106(e.Events)
	Local dist#, i%, temp%, pvt%, strtemp$, j%, k%

	Local p.Particles, n.NPCs, r.Rooms, e2.Events, it.Items, em.Emitters, sc.SecurityCams, sc2.SecurityCams

	Local CurrTrigger$ = ""

	Local x#, y#, z#

	Local angle#

	;[Block]
	If e\EventState = 0 Then
		If e\room\dist < 5.0 And e\room\dist > 0 Then
			If Curr106\State >= 0 Then e\EventState = 1	
		ElseIf Contained106
			RemoveEvent(e)
		EndIf
	ElseIf e\EventState = 1
		
		If e\room\dist < 3.0 Or Rand(7000)=1 Then
			e\EventState = 2
			d.Decals = CreateDecal(0, EntityX(e\room\obj), 445.0*RoomScale, EntityZ(e\room\obj), -90, Rand(360), 0)
			d\Size = Rnd(0.5, 0.7) : EntityAlpha(d\obj, 0.7) : d\ID = 1 : ScaleSprite(d\obj, d\Size, d\Size)
			EntityAlpha(d\obj, Rnd(0.7, 0.85))
			
			;PlaySound_Strict HorrorSFX(10)
		ElseIf e\room\dist > 8.0
			If Rand(5) = 1 Then
				Curr106\Idle = False
				RemoveEvent(e)
			Else
				Curr106\Idle = False
				Curr106\State = -10000
				RemoveEvent(e)
			End If
		EndIf
	Else
		e\EventState = e\EventState+timing\tickDuration
		
		PositionEntity(Curr106\Collider, EntityX(e\room\obj, True) - Sin(MilliSecs2() / 150.0) / 4.0, EntityY(mainPlayer\collider) + 1.0 - Min(Sin(e\EventState)*1.5,1.1), EntityZ(e\room\obj, True) - Sin(MilliSecs2() / 190.0) / 4.0)
		
		;TranslateEntity(Curr106\Collider, 0, -Max((3.0-dist),0), 0, True)
		PointEntity(Curr106\Collider, mainPlayer\cam)
		Curr106\State = -11
		AnimateNPC(Curr106, 55, 104, 0.1)
		Curr106\Idle = True
		
		If e\EventState > 180 Then
			Curr106\Idle = False
			PositionEntity(Curr106\Collider, EntityX(Curr106\Collider), -3.0, EntityZ(Curr106\Collider), True)
			
			RemoveEvent(e)
		EndIf
		
	EndIf
	;[End Block]
	
End Function



Function UpdateEvent682roar(e.Events)
	Local dist#, i%, temp%, pvt%, strtemp$, j%, k%

	Local p.Particles, n.NPCs, r.Rooms, e2.Events, it.Items, em.Emitters, sc.SecurityCams, sc2.SecurityCams

	Local CurrTrigger$ = ""

	Local x#, y#, z#

	Local angle#

	;[Block]
	If e\EventState = 0 Then
		If mainPlayer\currRoom = e\room Then e\EventState = 70 * Rand(300,1000)
	ElseIf mainPlayer\currRoom\RoomTemplate\Name <> "pocketdimension" And mainPlayer\currRoom\RoomTemplate\Name <> "room860" And mainPlayer\currRoom\RoomTemplate\Name <> "room1123" And mainPlayer\currRoom\RoomTemplate\Name <> "dimension1499" 
		e\EventState = e\EventState-timing\tickDuration
		
		If e\EventState < 17*70 Then
			If	e\EventState+timing\tickDuration => 17*70 Then LoadEventSound(e,"SFX\SCP\682\Roar.ogg") : e\SoundCHN = PlaySound_Strict(e\Sound) ;e\Sound = LoadSound_Strict("SFX\SCP\682\Roar.ogg")
			If e\EventState > 17*70 - 3*70 Then mainPlayer\camShake = 0.5
			If e\EventState < 17*70 - 7.5*70 And e\EventState > 17*70 - 11*70 Then mainPlayer\camShake = 2.0				
			If e\EventState < 70 Then 
				If e\Sound<>0 Then FreeSound_Strict (e\Sound) 
				RemoveEvent(e)
			EndIf
		EndIf
	EndIf
	;[End Block]
	
End Function

