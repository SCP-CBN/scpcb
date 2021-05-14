

/*

Definitions

	it = CreateItemTemplate("Some SCP-420-J", "420", "GFX\items\420.x", "GFX\items\INV420.jpg", "", 0.0005)
	it\sound = 2
	it = CreateItemTemplate("Cigarette", "cigarette", "GFX\items\420.x", "GFX\items\INV420.jpg", "", 0.0004) : it\sound = 2
	
	it = CreateItemTemplate("Joint", "420s", "GFX\items\420.x", "GFX\items\INV420.jpg", "", 0.0004) : it\sound = 2
	
	it = CreateItemTemplate("Smelly Joint", "420s", "GFX\items\420.x", "GFX\items\INV420.jpg", "", 0.0004) : it\sound = 2
	


drawgui

				Case "cigarette"
					;[Block]
					If CanUseItem(False,False,True)
						If SelectedItem\state = 0 Then
							Select Rand(6)
								Case 1
									Msg = Chr(34)+"I don't have anything to light it with. Umm, what about that... Nevermind."+Chr(34)
								Case 2
									Msg = "You are unable to get lit."
								Case 3
									Msg = Chr(34)+"I quit that a long time ago."+Chr(34)
									RemoveItem(SelectedItem)
								Case 4
									Msg = Chr(34)+"Even if I wanted one, I have nothing to light it with."+Chr(34)
								Case 5
									Msg = Chr(34)+"Could really go for one now... Wish I had a lighter."+Chr(34)
								Case 6
									Msg = Chr(34)+"Don't plan on starting, even at a time like this."+Chr(34)
									RemoveItem(SelectedItem)
							End Select
							SelectedItem\state = 1 
						Else
							Msg = "You are unable to get lit."
						EndIf
						
						MsgTimer = 70 * 5
					EndIf
					;[End Block]
				Case "420"
					;[Block]
					If CanUseItem(False,False,True)
						If Wearing714=1 Then
							Msg = Chr(34) + "DUDE WTF THIS SHIT DOESN'T EVEN WORK" + Chr(34)
						Else
							Msg = Chr(34) + "MAN DATS SUM GOOD ASS SHIT" + Chr(34)
							Injuries = Max(Injuries-0.5, 0)
							BlurTimer = 500
							GiveAchievement(Achv420)
							PlaySound_Strict LoadTempSound("SFX\Music\420J.ogg")
						EndIf
						MsgTimer = 70 * 5
						RemoveItem(SelectedItem)
					EndIf
					;[End Block]
				Case "420s"
					;[Block]
					If CanUseItem(False,False,True)
						If Wearing714=1 Then
							Msg = Chr(34) + "DUDE WTF THIS SHIT DOESN'T EVEN WORK" + Chr(34)
						Else
							DeathMSG = "Subject D-9341 found in a comatose state in [DATA REDACTED]. The subject was holding what appears to be a cigarette while smiling widely. "
							DeathMSG = DeathMSG+"Chemical analysis of the cigarette has been inconclusive, although it seems to contain a high concentration of an unidentified chemical "
							DeathMSG = DeathMSG+"whose molecular structure is remarkably similar to that of tetrahydrocannabinol."
							Msg = Chr(34) + "UH WHERE... WHAT WAS I DOING AGAIN... MAN I NEED TO TAKE A NAP..." + Chr(34)
							KillTimer = -1						
						EndIf
						MsgTimer = 70 * 6
						RemoveItem(SelectedItem)
					EndIf
					;[End Block]
*/