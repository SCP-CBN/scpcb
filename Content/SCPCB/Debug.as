

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
Model@ mask;
Model@ mask2;
Model@ scp173;

int fps;
int tick = 0;
//GUIText@ fpsCounter;
float time = 0.f;
float blinkTimer = 10.f;
Util::FloatInterpolator@ blinkInterpolator = Util::FloatInterpolator();


void Initialize() { // This is the first function that is called lol.
	Debug::log("AngelDebug - Start Testing Area");


	@testController=@Player::Controller;
	@testCollCollection=@Game::World::Collision;

	Vector2f test = Vector2f(10.0, 10.0);
	Vector2f test2 = Vector2f(15.0, 10.0);
	@lol = Billboard::create("SCPCB/GFX/Sprites/smoke_white", Vector3f(1, 7, 5), 0.5, test, Color(1.0, 0.8, 0.5));

	Billboard::create("SCPCB/GFX/Map/Textures/dirtymetal", Vector3f(1, 4, 1), Vector3f(0, 3, 0), test2, Color(0.0, 1.0, 1.0));
	@two = Billboard::create("SCPCB/GFX/Map/Textures/dirtymetal", Vector3f(2, 7, 15), Vector3f(0, 3, 0), test2, Color(1.0, 0.0, 1.0));

	@mask = Model::create("SCPCB/GFX/Items/Gasmask/gasmask.fbx");
	mask.position = Vector3f(10, 5, 0);
	mask.rotation = Vector3f(-1, 0.1, 0);
	@mask2 = Model::create("SCPCB/GFX/Items/Gasmask/gasmask.fbx");
	mask2.position = Vector3f(-8, 4, 1);
	mask2.rotation = Vector3f(-1, -0.1, 0);

	// The 173 model takes a long time to load so commented
	//@scp173 = Model::create("SCPCB/GFX/NPCs/SCP173/173.fbx");
	//scp173.position = Vector3f(-4, 0, 1);
	//scp173.rotation = Vector3f(0, 0, 0);

	Debug::log("Spawning item");

	Item::spawn("Gasmask", Vector3f(-15.0, 5.0, 20.0));
	Debug::log("Spawned gasmask");

	Item::spawn("FirstAid", Vector3f(0.0, 20.0, 20.0));
	Item::spawn("SmallFirstAid", Vector3f(10.0, 20.0, 20.0));
	Item::spawn("BlueFirstAid", Vector3f(5.0, 20.0, 22.0));

	Item::spawn("Battery9v", Vector3f(-12.0, 5.0, 20.0));
	Item::spawn("Battery18v", Vector3f(-8.0, 5.0, 20.0));
	Item::spawn("StrangeBattery", Vector3f(-4.0, 5.0, 20.0));
}
void update(float deltaTime) {
	if (!World::paused) {
		__UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(testController, Input::getDown(), deltaTime);
		lcz.update(deltaTime);
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
	mask.render();
	mask2.render();
	//scp173.render();
	Billboard::renderAll();

	//fpsCounter.render();


	if (test_shared_global == null) { return; }
	test_shared_global.render(interpolation);

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
