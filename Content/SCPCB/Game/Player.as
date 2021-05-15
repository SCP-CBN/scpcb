// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: SCPCB/Game/Player.as						//
// Source: https://github.com/juanjp600/scpcb/Content/			//
// Script File Author(s): Pyro-Fire					//
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
	float Height=15.f;
	float Radius=Height*(5.f/15.f);


	Vector3f pos { get { return Controller.position; } set { Controller.position=value; } }

	void Initialize() {
		@Controller=PlayerController(Radius,Height);
		Controller.setCollisionCollection(@Game::World::Collision);
		pos=Vector3f(0,Height+5,0);

	}
}	