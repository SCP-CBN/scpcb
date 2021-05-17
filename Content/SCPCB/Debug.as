

// Testing Stuff ----------------
// TODO: remove these globals, they only exist for testing purposes

serialize Vector3f whVy = Vector3f(17, 14, 14);
serialize string uh = "aaah";
serialize Matrix4x4f worldMatrix = Matrix4x4f::constructWorldMat(Vector3f(0.0, 0.0, 0.0), Vector3f(1.0, 1.0, 1.0), Vector3f(0, 0, 0));


void Test(int i, int i2, int i3 = 5) {
	//Debug::log("Parameter: "+testString);
}


// Gasmask Shrine ----------------

PlayerController@ testController;
Collision::Collection@ testCollCollection;

namespace AngelDebug {

Billboard@ lol;
Billboard@ two;
CModel@ mask;
CModel@ mask2;
CModel@ scp173;
CModel@ mdl;
array<CModel@> mdls;

int fps;
int tick = 0;
//GUIText@ fpsCounter;
float time = 0.f;
float blinkTimer = 10.f;
Util::FloatInterpolator@ blinkInterpolator = Util::FloatInterpolator();
//Texture@ tmpTex=@Texture::get();

void load() {
	@testController=@Player::Controller;
	@testCollCollection=@Game::World::Collision;
}

void initialize() { // This is the first function that is called lol.
	Debug::log("AngelDebug - Start Testing Area");


	Vector2f test = Vector2f(10.0, 10.0);
	Vector2f test2 = Vector2f(15.0, 10.0);
	@lol = Billboard::create(rootDirGFX + "Sprites/smoke_white", Vector3f(1, 7, 5), 0.5, test, Color(1.0, 0.8, 0.5));

	Billboard::create(rootDirGFX + "Map/Textures/dirtymetal", Vector3f(1, 4, 1), Vector3f(0, 3, 0), test2, Color(0.0, 1.0, 1.0));
	@two = Billboard::create(rootDirGFX + "Map/Textures/dirtymetal", Vector3f(2, 7, 15), Vector3f(0, 3, 0), test2, Color(1.0, 0.0, 1.0));

	@mask = CModel::create(rootDirGFX + "Items/Gasmask/gasmask.fbx");
	mask.position = Vector3f(10, 5, 0);
	mask.rotation = Vector3f(-1, 0.1, 0);
	@mask2 = CModel::create(rootDirGFX + "Items/Gasmask/gasmask.fbx");
	mask2.position = Vector3f(-8, 4, 1);
	mask2.rotation = Vector3f(-1, -0.1, 0);


	Item::spawn("Gasmask", Vector3f(-15.0, 5.0, 20.0));


	Item::spawn("FirstAid", Vector3f(0.0, 20.0, 20.0));
	Item::spawn("SmallFirstAid", Vector3f(10.0, 20.0, 20.0));
	Item::spawn("BlueFirstAid", Vector3f(5.0, 20.0, 22.0));

	Item::spawn("Battery9v", Vector3f(-12.0, 5.0, 20.0));
	Item::spawn("Battery18v", Vector3f(-8.0, 5.0, 20.0));
	Item::spawn("StrangeBattery", Vector3f(-4.0, 5.0, 20.0));



	// The 173 model takes a long time to load so commented
	int i=40;
	int iAdd=40;
	string folder=rootDirGFX+"Items/";


	@mdl = CModel::create(folder + "Battery/battery.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	int texID=mdl.createTexture(rootDirGFX + "Map/Textures/dirtymetal");
	mdl.setTexture(texID);

/* # From "Items/SCPs/*"; ----
	string folder=rootDirGFX+"Items/SCPs/";

	@mdl = CModel::create(folder + "scp420j/scp420j.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "scp427/scp427.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "scp1123/scp1123.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "scp1499/scp1499.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;


	//@mdl = CModel::create(folder + "scp860/scp860.fbx"); -- no model
	//mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

	// Corrupt
	@mdl = CModel::create(folder + "scp500/scp500.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "scp1499/scp1499.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
*/

/* # From "Items/*"; ----



	@mdl = CModel::create(folder + "Battery/battery.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Clipboard/clipboard.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Cup/cup.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Firstaid/firstaid.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Gasmask/gasmask.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Hazmat/hazmat.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Junk/electronics/electronics.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Junk/origami/origami.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Keycards/keycard.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Navigator/navigator.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "nvgoggles/nvgoggles.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Paper/paper.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Radio/radio.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Vest/vest.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "Wallet/wallet.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

	// Corrupt models.
	@mdl = CModel::create(folder + "Eyedrops/eyedrops.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
*/



/* # From "Maps/forest/*"; ----

	@mdl = CModel::create(folder + "door.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "door_frame.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "detail/rock.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "detail/rock2.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "detail/treetest4.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "detail/treetest5.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

	// No texture
	@mdl = CModel::create(folder + "wall.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

*/

/* # From "Maps/*_root"; ----

	@mdl = CModel::create(folder + "294.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "914key.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "914knob.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "cambase.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "monitor_checkpoint.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

	// Models without materials
	@mdl = CModel::create(folder + "008_2.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "173_2.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "exit1terrain.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "fan.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "gateatunnel.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "gateawall1.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "gateawall2.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "IntroDesk.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "IntroDrawer.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "lightgun.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "lightgunbase.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

	// Corrupt
	@mdl = CModel::create(folder + "CamHead.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "079.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "monitor.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
*/


/* # From "Props/*"; ----
	@mdl = CModel::create(folder + "boxfile_a.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "boxfile_b.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "cabinet_a.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "cabinet_b.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "ContDoorFrame.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "crate1.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "crate2.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "crate3.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "ElecBox.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "keyboard.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "lamp1.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "lamp2.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "monitor.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

	@mdl = CModel::create(folder + "lamp3.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

	@mdl = CModel::create(folder + "mug.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;

	@mdl = CModel::create(folder + "officeseat_a.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "tank1.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "tank2.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	@mdl = CModel::create(folder + "toilet_and_sink.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
*/



/* # From "Map/Meshes/*"; ----
	@mdl = CModel::create(rootDirGFX + "Props/Buttons/ButtonElevator.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Buttons/Button.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Buttons/ButtonCode.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Buttons/ButtonKeycard.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Buttons/ButtonScanner.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Doors/ContDoorLeft.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Doors/ContDoorRight.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Doors/door.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Doors/DoorColl.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Doors/DoorFrame.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Doors/Windowed/DoorWindowed.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Doors/heavydoor1.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Doors/heavydoor2.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Levers/leverbase.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
	@mdl = CModel::create(rootDirGFX + "Props/Levers/leverhandle.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=20;
*/




}
void update(float deltaTime) {
	if (!Environment::paused) {
		__UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(testController, Input::getDown(), deltaTime);
	//	lcz.update(deltaTime);
		time += deltaTime;
		if (time > 1.f) { // So you don't get a fucking seizure.
			lol.visible = !lol.visible;
			time = 0.f;
			//fpsCounter.text = "FPS: " + toString(fps);
			fps = 0;
		}
		// Blinking
		blinkTimer -= deltaTime;
		if (Input::getHit() & Input::Blink != 0) {
			blinkTimer = 0.f;
		}
		if (Input::getDown() & Input::Blink != 0) {
			blinkTimer = Math::maxFloat(-0.2f, blinkTimer);
		}
		
		if (blinkTimer <= -0.4f) {
			blinkInterpolator.update(-0.4f);
			blinkTimer = 10.f;
		} else {
			blinkInterpolator.update(blinkTimer);
		}
		//aaaa.blinkMeter.value = Math::ceil(blinkTimer / 10.f * aaaa.blinkMeter.maxValue);
	} else if (deltaTime == 0.f) {
		__UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(testController, Input::getDown(), 0.f);
	}
}
void render(float interpolation) {
	for(int i=0; i<mdls.length(); i++) {
		mdls[i].render();
	}

	mask.render();
	mask2.render();
	//scp173.render();
	Billboard::renderAll();

	//fpsCounter.render();


	//if (test_shared_global == null) { return; }
	//test_shared_global.render(interpolation);

	float interpolatedBlink = blinkInterpolator.lerp(interpolation);
	if (interpolatedBlink < 0.f) {
		float alpha = 0.f;
		// Closing eyes.
		if (interpolatedBlink > -0.1f) {
			alpha = Math::sin(Math::absFloat(interpolatedBlink / 0.4f * 2.f * Math::PI));
		// Fully closed.
		} else if (interpolatedBlink > -0.3f) {
			alpha = 1.f;
		// Opening eyes.
		} else {
			alpha = Math::absFloat(Math::sin(interpolatedBlink / 20.f * 2.f * Math::PI));
		}
		UI::setTextureless();
		UI::setColor(Color(0.f, 0.f, 0.f, alpha));
		UI::addRect(Rectanglef(-50.f, -50.f, 50.f, 50.f));
	}

	fps++;


}
void renderMenu(float interpolation) {

}

} // end namespace GasmaskShrine;
