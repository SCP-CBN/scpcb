// # First Aid ----
namespace Item { namespace FirstAid { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "FirstAid"; // "bat"
			@pickSound	= Item::Sound(); // 1
			@model		= Item::Model(rootDirGFXItems + "FirstAid/firstaid.fbx",0.5,rootDirGFXItems + "FirstAid/firstaid.jpg");
			@icon		= Item::Icon(rootDirGFXItems + "FirstAid/inv_firstaid.jpg");
			@iconModel	= Item::Icon::Model(model.path,0.1,Vector3f(-2.3,-0.3,0.2),Vector2f(0,0.05));
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

// # Small First Aid ----
namespace Item { namespace SmallFirstAid { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "SmallFirstAid"; // "firstaid"
			@pickSound	= Item::Sound(); // 1
			@model		= Item::Model(rootDirGFXItems + "FirstAid/firstaid.fbx",0.3,rootDirGFXItems + "FirstAid/firstaid.jpg");
			@icon		= Item::Icon(rootDirGFXItems + "FirstAid/inv_firstaid.jpg");
			@iconModel	= Item::Icon::Model(model.path,0.07,Vector3f(-2.3,-0.3,0.2),Vector2f(0,0.05));
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



// # Blue First Aid ----
namespace Item { namespace BlueFirstAid { Template@ thisTemplate=Template();
	class Template : Item::Template { Item@ instantiate() { return (Instance()); }
		Template() { super();
			name		= "BlueFirstAid"; // "bluefirstaid"
			@pickSound	= Item::Sound(); // 1
			@model		= Item::Model(rootDirGFXItems + "FirstAid/firstaid.fbx",0.5,rootDirGFXItems + "FirstAid/firstaid_blue.jpg");
			@icon		= Item::Icon(rootDirGFXItems + "FirstAid/inv_firstaid_blue.jpg");
			@iconModel	= Item::Icon::Model(model.path,0.1,Vector3f(-2.3,-0.3,0.2),Vector2f(0,0.05));
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

Definitions

	it = CreateItemTemplate("First Aid Kit", "firstaid", "GFX\items\firstaid.x", "GFX\items\INVfirstaid.jpg", "", 0.05)
	it = CreateItemTemplate("Small First Aid Kit", "finefirstaid", "GFX\items\firstaid.x", "GFX\items\INVfirstaid.jpg", "", 0.03)
	it = CreateItemTemplate("Blue First Aid Kit", "firstaid2", "GFX\items\firstaid.x", "GFX\items\INVfirstaid2.jpg", "", 0.03, "GFX\items\firstaidkit2.jpg")

	it = CreateItemTemplate("Strange Bottle", "veryfinefirstaid", "GFX\items\eyedrops.b3d", "GFX\items\INVbottle.jpg", "", 0.002, "GFX\items\bottle.jpg")	
	



drawgui

				Case "firstaid", "finefirstaid", "firstaid2"
					;[Block]
					If Bloodloss = 0 And Injuries = 0 Then
						Msg = "You do not need to use a first aid kit right now."
						MsgTimer = 70*5
						SelectedItem = Null
					Else
						If CanUseItem(False, True, True)
							CurrSpeed = CurveValue(0, CurrSpeed, 5.0)
							Crouch = True
							
							DrawImage(SelectedItem\itemtemplate\invimg, GraphicWidth / 2 - ImageWidth(SelectedItem\itemtemplate\invimg) / 2, GraphicHeight / 2 - ImageHeight(SelectedItem\itemtemplate\invimg) / 2)
							
							width% = 300
							height% = 20
							x% = GraphicWidth / 2 - width / 2
							y% = GraphicHeight / 2 + 80
							Rect(x, y, width+4, height, False)
							For  i% = 1 To Int((width - 2) * (SelectedItem\state / 100.0) / 10)
								DrawImage(BlinkMeterIMG, x + 3 + 10 * (i - 1), y + 3)
							Next
							
							SelectedItem\state = Min(SelectedItem\state+(FPSfactor/5.0),100)			
							
							If SelectedItem\state = 100 Then
								If SelectedItem\itemtemplate\tempname = "finefirstaid" Then
									Bloodloss = 0
									Injuries = Max(0, Injuries - 2.0)
									If Injuries = 0 Then
										Msg = "You bandaged the wounds and took a painkiller. You feel fine."
									ElseIf Injuries > 1.0
										Msg = "You bandaged the wounds and took a painkiller, but you were not able to stop the bleeding."
									Else
										Msg = "You bandaged the wounds and took a painkiller, but you still feel sore."
									EndIf
									MsgTimer = 70*5
									RemoveItem(SelectedItem)
								Else
									Bloodloss = Max(0, Bloodloss - Rand(10,20))
									If Injuries => 2.5 Then
										Msg = "The wounds were way too severe to staunch the bleeding completely."
										Injuries = Max(2.5, Injuries-Rnd(0.3,0.7))
									ElseIf Injuries > 1.0
										Injuries = Max(0.5, Injuries-Rnd(0.5,1.0))
										If Injuries > 1.0 Then
											Msg = "You bandaged the wounds but were unable to staunch the bleeding completely."
										Else
											Msg = "You managed to stop the bleeding."
										EndIf
									Else
										If Injuries > 0.5 Then
											Injuries = 0.5
											Msg = "You took a painkiller, easing the pain slightly."
										Else
											Injuries = 0.5
											Msg = "You took a painkiller, but it still hurts to walk."
										EndIf
									EndIf
									
									If SelectedItem\itemtemplate\tempname = "firstaid2" Then 
										Select Rand(6)
											Case 1
												SuperMan = True
												Msg = "You have becomed overwhelmedwithadrenalineholyshitWOOOOOO~!"
											Case 2
												InvertMouse = (Not InvertMouse)
												Msg = "You suddenly find it very difficult to turn your head."
											Case 3
												BlurTimer = 5000
												Msg = "You feel nauseated."
											Case 4
												BlinkEffect = 0.6
												BlinkEffectTimer = Rand(20,30)
											Case 5
												Bloodloss = 0
												Injuries = 0
												Msg = "You bandaged the wounds. The bleeding stopped completely and you feel fine."
											Case 6
												Msg = "You bandaged the wounds and blood started pouring heavily through the bandages."
												Injuries = 3.5
										End Select
									EndIf
									
									MsgTimer = 70*5
									RemoveItem(SelectedItem)
								EndIf							
							EndIf
						EndIf
					EndIf
					;[End Block]


				Case "veryfinefirstaid"
					;[Block]
					If CanUseItem(False, False, True)
						Select Rand(5)
							Case 1
								Injuries = 3.5
								Msg = "You started bleeding heavily."
								MsgTimer = 70*7
							Case 2
								Injuries = 0
								Bloodloss = 0
								Msg = "Your wounds are healing up rapidly."
								MsgTimer = 70*7
							Case 3
								Injuries = Max(0, Injuries - Rnd(0.5,3.5))
								Bloodloss = Max(0, Bloodloss - Rnd(10,100))
								Msg = "You feel much better."
								MsgTimer = 70*7
							Case 4
								BlurTimer = 10000
								Bloodloss = 0
								Msg = "You feel nauseated."
								MsgTimer = 70*7
							Case 5
								BlinkTimer = -10
								Local roomname$ = PlayerRoom\RoomTemplate\Name
								If roomname = "dimension1499" Or roomname = "gatea" Or (roomname="exit1" And EntityY(Collider)>1040.0*RoomScale)
									Injuries = 2.5
									Msg = "You started bleeding heavily."
									MsgTimer = 70*7
								Else
									For r.Rooms = Each Rooms
										If r\RoomTemplate\Name = "pocketdimension" Then
											PositionEntity(Collider, EntityX(r\obj),0.8,EntityZ(r\obj))		
											ResetEntity Collider									
											UpdateDoors()
											UpdateRooms()
											PlaySound_Strict(Use914SFX)
											DropSpeed = 0
											Curr106\State = -2500
											Exit
										EndIf
									Next
									Msg = "For some inexplicable reason, you find yourself inside the pocket dimension."
									MsgTimer = 70*8
								EndIf
						End Select
						
						RemoveItem(SelectedItem)
					EndIf
					;[End Block]
*/
