// # HUD (namespace) ----
namespace HUD {
	Frame@ instance;
	void initialize() {
		@instance=Frame();
	}
	void load() {
	}
}


// # HUD::Skin (namespace) ----
namespace HUD { namespace Skin {
	Texture@ iconBlink=Texture::get(rootDirGFX + "HUD/BlinkIcon");
	Texture@ barBlinkTex=Texture::get(rootDirGFX + "HUD/BlinkMeter");

	Texture@ iconWalk=Texture::get(rootDirGFX + "HUD/sneakicon");
	Texture@ iconSprint=Texture::get(rootDirGFX + "HUD/sprinticon");
	Texture@ barStaminaTex=Texture::get(rootDirGFX + "HUD/StaminaMeter");

	float barWidth=2.25f;

} }


// # HUD::Frame@ ----
namespace HUD { class Frame : GUI {

	GUIProgressBar@ blinkPanel;
	GUIProgressBar@ staminaPanel;

	Frame(string vcls="HUD") { super(vcls);
		align=GUI::Align::Fill;
		height=10;

		GUI@ statusBar=GUI(@this);
		statusBar.align=GUI::Align::None;
		statusBar.pos=Vector2f(GUI::resolution.x*0.05,GUI::resolution.y*0.95-height);
		statusBar.size=Vector2f(GUI::resolution.x*0.5,height);


		// Blink bar
		GUI@ blinkBar=GUI(@statusBar);
		blinkBar.align=GUI::Align::Top;
		blinkBar.height=4.5;
		blinkBar.margin={0,0,0,0.5};

		GUIPanel@ blinkIconBG=GUIPanel(@blinkBar);
		blinkIconBG.align=GUI::Align::Left;
		blinkIconBG.width=5.1;
		blinkIconBG.margin={0.15,0.15,1,0.15};
		@blinkIconBG.texture=@GUI::Skin::menuwhite;

		GUIPanel@ blinkIconFG=GUIPanel(@blinkIconBG);
		blinkIconFG.align=GUI::Align::Fill;
		blinkIconFG.margin={0.15,0.15,0.15,0.15};
		@blinkIconFG.texture=@GUI::Skin::menublack;

		GUIPanel@ blinkIcon=GUIPanel(@blinkIconFG);
		blinkIcon.align=GUI::Align::Fill;
		blinkIcon.margin={0.15,0.15,0.15,0.15};
		@blinkIcon.texture=@HUD::Skin::iconBlink;

		GUIPanel@ blinkPanelBG=GUIPanel(@blinkBar);
		blinkPanelBG.align=GUI::Align::Fill;
		@blinkPanelBG.texture=@GUI::Skin::menuwhite;

		GUIPanel@ blinkPanelFG=GUIPanel(@blinkPanelBG);
		blinkPanelFG.align=GUI::Align::Fill;
		blinkPanelFG.margin={0.15,0.15,0.15,0.15};
		@blinkPanelFG.texture=@GUI::Skin::menublack;

		@blinkPanel=GUIProgressBar(@blinkPanelFG);
		blinkPanel.align=GUI::Align::Fill;
		blinkPanel.margin={0.5,0.5,0.5,0.5};
		blinkPanel.barWidth=HUD::Skin::barWidth;
		@blinkPanel.texture=@HUD::Skin::barBlinkTex;



		// Stamina bar
		GUI@ staminaBar=GUI(@statusBar);
		staminaBar.align=GUI::Align::Top;
		staminaBar.height=4.5;
		staminaBar.margin={0,0.5,0,0};


		GUIPanel@ staminaIconBG=GUIPanel(@staminaBar);
		staminaIconBG.align=GUI::Align::Left;
		staminaIconBG.width=5.1;
		staminaIconBG.margin={0.15,0.15,1,0.15};
		@staminaIconBG.texture=@GUI::Skin::menuwhite;

		GUIPanel@ staminaIconFG=GUIPanel(@staminaIconBG);
		staminaIconFG.align=GUI::Align::Fill;
		staminaIconFG.margin={0.15,0.15,0.15,0.15};
		@staminaIconFG.texture=@GUI::Skin::menublack;

		GUIPanel@ staminaIcon=GUIPanel(@staminaIconBG);
		staminaIcon.align=GUI::Align::Fill;
		staminaIcon.margin={0.15,0.15,0.15,0.15};
		@staminaIcon.texture=@HUD::Skin::iconWalk;

		GUIPanel@ staminaPanelBG=GUIPanel(@staminaBar);
		staminaPanelBG.align=GUI::Align::Fill;
		@staminaPanelBG.texture=@GUI::Skin::menuwhite;

		GUIPanel@ staminaPanelFG=GUIPanel(@staminaPanelBG);
		staminaPanelFG.align=GUI::Align::Fill;
		staminaPanelFG.margin={0.15,0.15,0.15,0.15};
		@staminaPanelFG.texture=@GUI::Skin::menublack;

		@staminaPanel=GUIProgressBar(@staminaPanelFG);
		staminaPanel.align=GUI::Align::Fill;
		staminaPanel.margin={0.5,0.5,0.5,0.5};
		staminaPanel.barWidth=HUD::Skin::barWidth;
		@staminaPanel.texture=@HUD::Skin::barStaminaTex;





	}


	void update() {
		blinkPanel.amount-=GUI::interp*0.1;
		if(blinkPanel.amount<=0) {
			blinkPanel.amount=1.f;
		}

		staminaPanel.amount+=GUI::interp*0.25;
		if(staminaPanel.amount>=1.f) {
			staminaPanel.amount=0.f;
		}
	}

} }