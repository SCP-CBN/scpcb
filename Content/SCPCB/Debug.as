

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
Texture@ tmpTex;
CMaterial@ testerMat;

void load() {
	@testController=@Player::Controller;
	@testCollCollection=@Game::World::Collision;
}

void initialize() { // This is the first function that is called lol.
	Debug::log("AngelDebug - Start Testing Area");
	string testMatPath = rootDirGFXItems + "Battery/battery_18v";
	@tmpTex=@Texture::get(testMatPath);
	@testerMat = @CMaterial::create(@tmpTex);
	Debug::log("Made a material");

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

	Item::spawn("keycard1", Vector3f(-20.0, 5.0, 40.0));
	Item::spawn("keycard2", Vector3f(-20.0, 5.0, 50.0));
	Item::spawn("keycard3", Vector3f(-20.0, 5.0, 60.0));
	Item::spawn("keycard4", Vector3f(-20.0, 5.0, 70.0));
	Item::spawn("keycard5", Vector3f(-30.0, 5.0, 40.0));
	Item::spawn("keycard6", Vector3f(-30.0, 5.0, 50.0));
	Item::spawn("playingcard1", Vector3f(-30.0, 5.0, 60.0));
	Item::spawn("mastercard1", Vector3f(-30.0, 5.0, 70.0));


	Prop::spawn("button",Vector3f(-20,5,-20));
	Prop::spawn("buttoncode",Vector3f(-20,5,-25));
	Prop::spawn("buttonelevator",Vector3f(-20,5,-30));
	Prop::spawn("buttonkeycard",Vector3f(-20,5,-35));
	Prop::spawn("buttonscanner",Vector3f(-20,5,-40));

	Prop::spawn("door",Vector3f(20,5,40),Vector3f(0,Math::PI*0.125,0));
	Prop::spawn("heavydoor",Vector3f(20,5,80),Vector3f(0,Math::PI*0.125,0));
	Prop::spawn("containmentdoor",Vector3f(20,5,140),Vector3f(0,Math::PI*0.125,0));

	int perRow = 10;
	int dist = 300;
	Vector3f origin=Vector3f(300,0,300);
	for(int i=0; i<Room::templates.length(); i++) {
		int xpos = Math::floor( float(i)/float(perRow) );
		int ypos = Math::floor( i%perRow );
		Vector3f newpos = origin+Vector3f(xpos*dist,0,ypos*dist);
	//	Room::spawn(Room::templates[i].name,newpos);
	}


	// The 173 model takes a long time to load so commented
	int i=40;
	int iAdd=40;
	string folder=rootDirGFX+"Items/";

	@mdl = CModel::create(folder + "Battery/battery.fbx");
	mdls.insertLast(@mdl); mdl.position=Vector3f(-15,0,i); i+=iAdd;
	//int texID=mdl.createTexture(rootDirGFX + "Map/Textures/dirtymetal");
	//mdl.setTexture(texID);
	mdl.setMaterial(@testerMat);



}
void update(float deltaTime) {
	if (!Environment::paused) {
		//__UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(testController, Input::getDown(), deltaTime);
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
		//__UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(testController, Input::getDown(), 0.f);
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
