

/*

Definitions

	CreateItemTemplate("Level 1 Key Card", "key1",  "GFX\items\keycard.x", "GFX\items\INVkey1.jpg", "", 0.0004,"GFX\items\keycard1.jpg")
	CreateItemTemplate("Level 2 Key Card", "key2",  "GFX\items\keycard.x", "GFX\items\INVkey2.jpg", "", 0.0004,"GFX\items\keycard2.jpg")
	CreateItemTemplate("Level 3 Key Card", "key3",  "GFX\items\keycard.x", "GFX\items\INVkey3.jpg", "", 0.0004,"GFX\items\keycard3.jpg")
	CreateItemTemplate("Level 4 Key Card", "key4",  "GFX\items\keycard.x", "GFX\items\INVkey4.jpg", "", 0.0004,"GFX\items\keycard4.jpg")
	CreateItemTemplate("Level 5 Key Card", "key5", "GFX\items\keycard.x", "GFX\items\INVkey5.jpg", "", 0.0004,"GFX\items\keycard5.jpg")
	CreateItemTemplate("Playing Card", "misc", "GFX\items\keycard.x", "GFX\items\INVcard.jpg", "", 0.0004,"GFX\items\card.jpg")
	CreateItemTemplate("Mastercard", "misc", "GFX\items\keycard.x", "GFX\items\INVmastercard.jpg", "", 0.0004,"GFX\items\mastercard.jpg")
	CreateItemTemplate("Key Card Omni", "key6", "GFX\items\keycard.x", "GFX\items\INVkeyomni.jpg", "", 0.0004,"GFX\items\keycardomni.jpg")


drawgui

				Case "key1", "key2", "key3", "key4", "key5", "key6", "keyomni", "scp860", "hand", "hand2", "25ct"
					;[Block]
					DrawImage(SelectedItem\itemtemplate\invimg, GraphicWidth / 2 - ImageWidth(SelectedItem\itemtemplate\invimg) / 2, GraphicHeight / 2 - ImageHeight(SelectedItem\itemtemplate\invimg) / 2)
					;[End Block]



				Case "key"
					;[Block]
					If SelectedItem\state = 0 Then
						PlaySound_Strict LoadTempSound("SFX\SCP\1162\NostalgiaCancer"+Rand(6,10)+".ogg")
						
						Msg = Chr(34)+"Isn't this the key to that old shack? The one where I... No, it can't be."+Chr(34)
						MsgTimer = 70*10						
					EndIf
					
					SelectedItem\state = 1
					SelectedItem = Null
					;[End Block]



*/