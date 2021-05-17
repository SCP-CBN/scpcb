// # GUIProgressBar --------
// Like the blink panel.

shared class GUIProgressBar : GUI {

	// # Constructor
	GUIProgressBar(string vcls="GUIProgressBar") { super(vcls); }
	GUIProgressBar(GUI@&in parent, string vcls="GUIProgressBar") { super(@parent,vcls); }

	// # Basic background/draw panel.
	Color color=Color::White;
	Texture@ texture;
	bool tiledTexture;

	// # Progress Barrrage
	float amount=0.75f;
	float maxAmount=1.f;
	float amountScale=1.f;
	float barWidth=1.75f;

	void paint() {
		float barMax = ((paintSize.x*amountScale)/barWidth);
		int bars=Math::floor( (barMax*(amount/maxAmount))+0.5 );
		Vector2f paintOrigin=paintPos-GUI::center;
		Vector2f paintOriginSize=(paintPos+Vector2f(barWidth-0.5,paintSize.y))-GUI::center;

		if(@texture==null) { UI::setTextureless(); } else { UI::setTextured(texture, tiledTexture); }
		color.alpha=opacity;
		UI::setColor(color);

		for(int i=0; i<bars; i++) {
			Vector2f offset=Vector2f(i*barWidth,0);
			Rectanglef rect=Rectanglef( (paintOrigin+offset), (paintOriginSize+offset));
			UI::addRect(rect);
		}
	}
}
