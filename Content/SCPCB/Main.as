external class Room;

serialize LightContainmentZone@ lcz;

external class Item;
external class ItemTemplate;

// TODO: remove these globals, they only exist for testing purposes
serialize Vector3f whVy = Vector3f(17, 14, 14);
serialize string uh = "aaah";
serialize Matrix4x4f worldMatrix = Matrix4x4f::constructWorldMat(Vector3f(0.0, 0.0, 0.0), Vector3f(0, 0, 0), Vector3f(1.0, 1.0, 1.0));

PlayerController@ testController;
Collision::Collection@ testCollCollection;

external enum RoomType;

external Zone@ test_shared_global;
external int testCounter;

void Test(int i, int i2, int i3 = 5) {
    //Debug::log("Parameter: "+testString);
}

Billboard@ lol;
Billboard@ two;

Model@ mask;
Model@ mask2;

external void Item::register(const string&in name, const string&in model, float iconScl, const Vector3f&in iconRot, const Vector2f&in iconPos, float scale);
external Item@ Item::spawn(const string&in name, const Vector3f&in position);
external void Item::updateAll();
external void Item::renderAll();

external class MenuManager;
MenuManager@ menuManager;

int fps;
external class GUIText;
GUIText@ fpsCounter;

external enum Alignment;

external class ConsoleMenu;
external ConsoleMenu@ ConsoleMenu::instance;
external class HUDMenu;
//external HUDMenu@ HUDMenu::instance; // TODO why doesn't this work?
external void Console::addMessage(const string&in msg, const Color&in color = Color::White);

abstract class Testt {
    abstract int member { get const; }
}

class TestImpl : Testt {
    int member const override => 2;
}

class TestImpl2 : Testt {
    int member { get const override => 2; };
}

int test() => 5;

funcdef bool CMP(int first, int second);
funcdef void ASD();

void myOtherFunc(CMP @f) {

}

void myFunc(ASD @f) {

}

void doSomething() {}

void main() {
    myFunc(() => { doSomething(); });
    myOtherFunc((a, b) => a == b);

    Debug::log("Starting up!");

    Testt@ test_abstract_TODO_REMOVE;
    @test_abstract_TODO_REMOVE = TestImpl();
    Debug::log("TestAbstract result: "+toString(test_abstract_TODO_REMOVE.member));

    @menuManager = MenuManager();

    @fpsCounter = GUIText(null, -50.0 * UI::getAspectRatio(), -50.0, false, false, false);
    fpsCounter.text = "test";

    //Msg::set("LOL");

    Item::register("FirstAid", "SCPCB/GFX/Items/Firstaid/firstaid.fbx", 0.1, Vector3f(-2.3, -0.3, 0.2), Vector2f(0, 0.05), 0.5);
    Item::register("Gasmask", "SCPCB/GFX/Items/Gasmask/gasmask.fbx", 0.08, Vector3f(2.3, 2.7, 0), Vector2f(0, 0.2), 0.5);

    Item::spawn("FirstAid", Vector3f(0.0, 20.0, 20.0));
    Item::spawn("FirstAid", Vector3f(10.0, 20.0, 20.0));
    Item::spawn("Gasmask", Vector3f(-15.0, 5.0, 20.0));
    
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

    //Debug::log(test_shared_global);

    Console::register("mytest", "THIS COMKMAND IS VERY EPIC", Test);
    Console::register(
        "teleport",
        "Teleports the player to the coordinates sent as input.",
        (float x,float y,float z) => {
            Debug::log("Called teleport!");
            testController.position = Vector3f(x,y,z);
        }
    );
	Console::register(
        "hElP",
        ":(",
        function(string s) {
            Debug::log(s);
        }
    );
    Console::register(
        "jorge",
        "There is no help available for you.",
        (int i, int i2, int i3) => {
            Console::addMessage("" + 74 + 111 + 114 + 103 + 101 + 32 + 104 + 97 + 115 + 32 + 98 + 101 + 101 + 110 + 32 + 101 + 120 + 112 + 101 + 99 + 116 + 105 + 110 + 103 + 32 + 121 + 111 + 117 + 46, Color::Orange);
        }
    );
    Console::register(
        "clear",
        "Clears the console.",
        () => {
            ConsoleMenu::instance.clear();
        }
    );
    
    @lcz = LightContainmentZone();
    @test_shared_global = @lcz;
    @testCollCollection = Collision::Collection();
    @testController = PlayerController(5.0, 15.0);
    testController.position = Vector3f(0,16,0);
    testController.setCollisionCollection(testCollCollection);
    lcz.registerRoom("hll_plain_4_empty_a", Room4);
    lcz.registerRoom("hll_plain_4_empty_b", Room4);
    lcz.registerRoom("hll_plain_4_walkway", Room4);

    lcz.registerRoom("hll_plain_3_empty_a", Room3);
    lcz.registerRoom("hll_plain_3_empty_b", Room3);
    lcz.registerRoom("hll_plain_3_elecbox", Room3);
    lcz.registerRoom("hll_plain_3_pipes", Room3);
    lcz.registerRoom("hll_plain_3_walkway", Room3);

    lcz.registerRoom("hll_plain_2c_empty_a", Room2C);
    lcz.registerRoom("hll_plain_2c_empty_b", Room2C);
    lcz.registerRoom("hll_plain_2c_elecbox", Room2C);
    lcz.registerRoom("hll_plain_2c_fan", Room2C);
    lcz.registerRoom("hll_plain_2c_walkway", Room2C);

    lcz.registerRoom("hll_plain_2_empty", Room2);
    lcz.registerRoom("hll_plain_2_cornerdoor", Room2);
    lcz.registerRoom("hll_plain_2_elecbox", Room2);
    lcz.registerRoom("hll_plain_2_fan", Room2);
    lcz.registerRoom("hll_plain_2_pipes", Room2);
    lcz.registerRoom("hll_plain_2_ventdoors", Room2);
    lcz.registerRoom("hll_plain_2_ventgate", Room2);
    lcz.registerRoom("hll_plain_2_walkway", Room2);

    lcz.registerRoom("hll_plain_1_empty_a", Room1);
    lcz.registerRoom("hll_plain_1_empty_b", Room1);
    lcz.generate();
    PerTick::register(update);
    PerFrameGame::register(renderGame);
    PerFrameMenu::register(renderMenu);
}

void exit() {
    Debug::log("YEAH");
}

float time = 0.f;
float blinkTimer = 10.f;

external class FloatInterpolator;
FloatInterpolator@ blinkInterpolator = FloatInterpolator();

void update(float deltaTime) {
    if (!World::paused) {
        __UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(testController, Input::getDown(), deltaTime);
        lcz.update(deltaTime);
        time += deltaTime;
        if (time > 1.f) { // So you don't get a fucking seizure.
            lol.visible = !lol.visible;
            time = 0.f;
            fpsCounter.text = "FPS: " + toString(fps);
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
        aaaa.blinkMeter.value = Math::ceil(blinkTimer / 10.f * aaaa.blinkMeter.maxValue);
    } else if (deltaTime == 0.f) {
        __UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(testController, Input::getDown(), 0.f);
    }
    Item::updateAll();
    menuManager.update();
}

HUDMenu@ aaaa = HUDMenu();

void renderGame(float interpolation) {
    if (test_shared_global == null) { return; }
    test_shared_global.render(interpolation);
    mask.render();
    mask2.render();
    Billboard::renderAll();
    Item::renderAll();
    fpsCounter.render();

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
    menuManager.render();
    aaaa.render();
}
