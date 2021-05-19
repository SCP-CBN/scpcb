// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: SCPCB/Game/Player.as						//
// Source: https://github.com/juanjp600/scpcb/Content/			//
// Purpose:								//
//	- Player Manager						//
//									//
//									//
// -------------------------------------------------------------------- \\
// Documentation
//
//	SECTION 1. Game Platform
//		- Player : The player controller.
//									//
// -------------------------------------------------------------------- \\
// #### SECTION 1. Player ----


namespace Player {
	PlayerController@ Controller;
	float height=25.f/2.f;
	float radius=5.f;

	float stamina;
	float maxStamina=100.f;

	float curSpeed=0.f;
	float speedWalk=0.5f;
	float speedSprint=2.5f;

	float fpsFactor=1.f; // I think this is meant to be interp

	float shake=0.f;
	float shakeTimer=0.f;

	bool moving { get { return curSpeed>0; } }

	Vector3f pos { get { return Controller.position; } set { Controller.position=value; } }

	void Initialize() {
		@Controller=PlayerController(radius,height);
		Controller.setCollisionCollection(@Game::World::Collision);
		pos=Vector3f(0,height+5,0);

	}



	void updateStamina(float interp) {
		float stamAdd;
		if(moving) { stamAdd=0.15*fpsFactor/1.25; }
		else { stamAdd=0.15*fpsFactor*1.25; }
		stamina=Math::minFloat(stamina+stamAdd, maxStamina);
	}

	void updateMouse(float interp) {
		

	}
}