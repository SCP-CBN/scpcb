namespace PaperStates {
	string doc079="GFX\items\doc079.jpg";
	string doc095="GFX\items\doc895.jpg";
}



/*
Definitions


	it = CreateItemTemplate("Document SCP-079", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc079.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-895", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc895.jpg", 0.003) : it\sound = 0 
	it = CreateItemTemplate("Document SCP-860", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc860.jpg", 0.003) : it\sound = 0 	
	it = CreateItemTemplate("Document SCP-860-1", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc8601.jpg", 0.003) : it\sound = 0 	
	it = CreateItemTemplate("SCP-093 Recovered Materials", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc093rm.jpg", 0.003) : it\sound = 0 	
	it = CreateItemTemplate("Document SCP-106", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc106.jpg", 0.003) : it\sound = 0	
	it = CreateItemTemplate("Dr. Allok's Note", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc106_2.jpg", 0.0025) : it\sound = 0
	it = CreateItemTemplate("Recall Protocol RP-106-N", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docRP.jpg", 0.0025) : it\sound = 0
	it = CreateItemTemplate("Document SCP-682", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc682.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-173", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc173.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-372", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc372.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-049", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc049.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-096", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc096.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-008", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc008.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-012", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc012.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-500", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc500.png", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-714", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc714.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-513", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc513.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-035", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc035.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("SCP-035 Addendum", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc035ad.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-939", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc939.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-966", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc966.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-970", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc970.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-1048", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc1048.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-1123", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc1123.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-1162", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc1162.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document SCP-1499", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc1499.png", 0.003) : it\sound = 0
	it = CreateItemTemplate("Incident Report SCP-1048-A", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc1048a.jpg", 0.003) : it\sound = 0
	
	it = CreateItemTemplate("Drawing", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\doc1048.jpg", 0.003) : it\sound = 0
	
	it = CreateItemTemplate("Leaflet", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\leaflet.jpg", 0.003, "GFX\items\notetexture.jpg") : it\sound = 0
	
	it = CreateItemTemplate("Dr. L's Note", "paper", "GFX\items\paper.x", "GFX\items\INVnote.jpg", "GFX\items\docL1.jpg", 0.0025, "GFX\items\notetexture.jpg") : it\sound = 0
	it = CreateItemTemplate("Dr L's Note", "paper", "GFX\items\paper.x", "GFX\items\INVnote.jpg", "GFX\items\docL2.jpg", 0.0025, "GFX\items\notetexture.jpg") : it\sound = 0
	it = CreateItemTemplate("Blood-stained Note", "paper", "GFX\items\paper.x", "GFX\items\INVnote.jpg", "GFX\items\docL3.jpg", 0.0025, "GFX\items\notetexture.jpg") : it\sound = 0
	it = CreateItemTemplate("Dr. L's Burnt Note", "paper", "GFX\items\paper.x", "GFX\items\INVbn.jpg", "GFX\items\docL4.jpg", 0.0025, "GFX\items\BurntNoteTexture.jpg") : it\sound = 0
	it = CreateItemTemplate("Dr L's Burnt Note", "paper", "GFX\items\paper.x", "GFX\items\INVbn.jpg", "GFX\items\docL5.jpg", 0.0025, "GFX\items\BurntNoteTexture.jpg") : it\sound = 0
	it = CreateItemTemplate("Scorched Note", "paper", "GFX\items\paper.x", "GFX\items\INVbn.jpg", "GFX\items\docL6.jpg", 0.0025, "GFX\items\BurntNoteTexture.jpg") : it\sound = 0
	
	it = CreateItemTemplate("Journal Page", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docGonzales.jpg", 0.0025) : it\sound = 0
	
	
	it = CreateItemTemplate("Log #1", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\f4.jpg", 0.004, "GFX\items\f4.jpg") : it\sound = 0
	it = CreateItemTemplate("Log #2", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\f5.jpg", 0.004, "GFX\items\f4.jpg") : it\sound = 0
	it = CreateItemTemplate("Log #3", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\f6.jpg", 0.004, "GFX\items\f4.jpg") : it\sound = 0
	
	it = CreateItemTemplate("Strange Note", "paper", "GFX\items\paper.x", "GFX\items\INVnote.jpg", "GFX\items\docStrange.jpg", 0.0025, "GFX\items\notetexture.jpg") : it\sound = 0
	
	it = CreateItemTemplate("Nuclear Device Document", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docNDP.jpg", 0.003) : it\sound = 0	
	it = CreateItemTemplate("Class D Orientation Leaflet", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docORI.jpg", 0.003) : it\sound = 0	
	
	it = CreateItemTemplate("Note from Daniel", "paper", "GFX\items\note.x", "GFX\items\INVnote2.jpg", "GFX\items\docdan.jpg", 0.0025) : it\sound = 0
	
	it = CreateItemTemplate("Burnt Note", "paper", "GFX\items\paper.x", "GFX\items\INVbn.jpg", "GFX\items\bn.it", 0.003, "GFX\items\BurntNoteTexture.jpg")
	it\img = BurntNote : it\sound = 0
	
	it = CreateItemTemplate("Mysterious Note", "paper", "GFX\items\paper.x", "GFX\items\INVnote.jpg", "GFX\items\sn.it", 0.003, "GFX\items\notetexture.jpg") : it\sound = 0	
	
	it = CreateItemTemplate("Mobile Task Forces", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docMTF.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Security Clearance Levels", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docSC.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Object Classes", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docOBJC.jpg", 0.003) : it\sound = 0
	it = CreateItemTemplate("Document", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docRAND3.jpg", 0.003) : it\sound = 0 
	it = CreateItemTemplate("Addendum: 5/14 Test Log", "paper", "GFX\items\paper.x", "GFX\items\INVnote.jpg", "GFX\items\docRAND2.jpg", 0.003, "GFX\items\notetexture.jpg") : it\sound = 0 
	it = CreateItemTemplate("Notification", "paper", "GFX\items\paper.x", "GFX\items\INVnote.jpg", "GFX\items\docRAND1.jpg", 0.003, "GFX\items\notetexture.jpg") :it\sound = 0 	
	it = CreateItemTemplate("Incident Report SCP-106-0204", "paper", "GFX\items\paper.x", "GFX\items\INVpaper.jpg", "GFX\items\docIR106.jpg", 0.003) : it\sound = 0 



draw_gui_item

				Case "paper", "ticket"
					;[Block]
					If SelectedItem\itemtemplate\img = 0 Then
						Select SelectedItem\itemtemplate\name
							Case "Burnt Note" 
								SelectedItem\itemtemplate\img = LoadImage_Strict("GFX\items\bn.it")
								SetBuffer ImageBuffer(SelectedItem\itemtemplate\img)
								Color 0,0,0
								AAText 277, 469, AccessCode, True, True
								Color 255,255,255
								SetBuffer BackBuffer()
							Case "Document SCP-372"
								SelectedItem\itemtemplate\img = LoadImage_Strict(SelectedItem\itemtemplate\imgpath)	
								SelectedItem\itemtemplate\img = ResizeImage2(SelectedItem\itemtemplate\img, ImageWidth(SelectedItem\itemtemplate\img) * MenuScale, ImageHeight(SelectedItem\itemtemplate\img) * MenuScale)
								
								SetBuffer ImageBuffer(SelectedItem\itemtemplate\img)
								Color 37,45,137
								AASetFont Font5
								temp = ((Int(AccessCode)*3) Mod 10000)
								If temp < 1000 Then temp = temp+1000
								AAText 383*MenuScale, 734*MenuScale, temp, True, True
								Color 255,255,255
								SetBuffer BackBuffer()
							Case "Movie Ticket"
								;don't resize because it messes up the masking
								SelectedItem\itemtemplate\img=LoadImage_Strict(SelectedItem\itemtemplate\imgpath)	
								
								If (SelectedItem\state = 0) Then
									Msg = Chr(34)+"Hey, I remember this movie!"+Chr(34)
									MsgTimer = 70*10
									PlaySound_Strict LoadTempSound("SFX\SCP\1162\NostalgiaCancer"+Rand(1,5)+".ogg")
									SelectedItem\state = 1
								EndIf
							Default 
								SelectedItem\itemtemplate\img=LoadImage_Strict(SelectedItem\itemtemplate\imgpath)	
								SelectedItem\itemtemplate\img = ResizeImage2(SelectedItem\itemtemplate\img, ImageWidth(SelectedItem\itemtemplate\img) * MenuScale, ImageHeight(SelectedItem\itemtemplate\img) * MenuScale)
						End Select
						
						MaskImage(SelectedItem\itemtemplate\img, 255, 0, 255)
					EndIf
					
					DrawImage(SelectedItem\itemtemplate\img, GraphicWidth / 2 - ImageWidth(SelectedItem\itemtemplate\img) / 2, GraphicHeight / 2 - ImageHeight(SelectedItem\itemtemplate\img) / 2)
					;[End Block]
*/