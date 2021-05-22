#include "World.h"

#include <iostream>
#include <cmath>
#include <Color/Color.h>
#include <filesystem>

#include "Timing.h"
#include "Pickable.h"
#include "ScriptWorld.h"
#include "../Graphics/Camera.h"
#include "../Graphics/GraphicsResources.h"
#include "../Graphics/DebugGraphics.h"
#include "../Models/CBR.h"
#include "../Sound/SoundResources.h"
#include "../Save/Config.h"
#include "../Input/KeyBinds.h"
#include "../Input/Input.h"
#include "../Input/MouseData.h"
#include "../Utils/LocalizationManager.h"
#include "../Graphics/ModelImageGenerator.h"
#include "../Scripting/ScriptObject.h"
#include "../Graphics/UIMesh.h"
#include "../Graphics/Billboard.h"
#include "../Graphics/Font.h"
#include "../Input/KeyBinds.h"
#include "../Save/Config.h"

#include <Math/Random.h>
#include <chrono>

static CBR* lol;

World::World() {
    // World Config
    config = new Config("options.ini");

    camera = new Camera(gfxRes, config->getWidth(), config->getHeight());

    // Graphics
    graphics = PGE::Graphics::create("SCP - Containment Breach", config->getWidth(), config->getHeight(), false);
    graphics->setViewport(PGE::Rectanglei(0, 0, config->getWidth(), config->getHeight()));
    io = PGE::IO::create(graphics);

    timing = new Timing(60, 60);

    gfxRes = new GraphicsResources(graphics, config);

    sndRes = new SoundResources(config);


    // Fonts
    FT_Init_FreeType(&ftLibrary);
    PGE::String fontPath = PGE::String("SCPCB/GFX/Font/");
    largeFont = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "Inconsolata-Regular.ttf"), 20);
    fontInconsolataLarge = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "Inconsolata-Regular.ttf"), 20);
    fontInconsolataSmall = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "Inconsolata-Regular.ttf"), 11);
    fontAppleLarge = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "HomemadeApple-Regular.ttf"), 20);
    fontAppleSmall = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "HomemadeApple-Regular.ttf"), 11);
    fontCrystalLarge = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "LiquidCrystal-Normal.otf"), 20);
    fontCrystalSmall = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "LiquidCrystal-Normal.otf"), 11);
    fontSubotypeLarge = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "Subotype.otf"), 20);
    fontSubotypeSmall = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr(fontPath + "Subotype.otf"), 11);

    // World Management Objects
    uiMesh = new UIMesh(gfxRes);

    // Setup input
    keyBinds = new KeyBinds(io);
    mouseData = new MouseData(io, config);
    locMng = new LocalizationManager(config->languageCode->value);

    io->setMouseVisibility(true);
    io->setMousePosition(PGE::Vector2f((float)config->getWidth() / 2, (float)config->getHeight() / 2));

    pickMng = new PickableManager(camera, uiMesh, keyBinds);
    billMng = new BillboardManager(graphics, gfxRes, camera);

    // ScriptWorld
    paused = false;
    loading = true;
    loadState = 0;
    loadDone = 0;
    tick = 0;

    miGen = new ModelImageGenerator(graphics, gfxRes);
    miGen->initialize(256);
    scripting = new ScriptWorld(this, gfxRes, camera, keyBinds, mouseData, io, locMng, pickMng, uiMesh, config, billMng, miGen);
    miGen->deinitialize();

    applyConfig(config);

    // Scrap code / testing area
    //lol = new CBR(gfxRes, "asd.cbr");

    // Footer
    shutdownRequested = false;
}

// Exterminate
World::~World() {
    delete scripting;

    delete pickMng;
    delete billMng;
    delete uiMesh;
    delete keyBinds;
    delete mouseData;

    delete camera;
    delete timing;
    delete locMng;
    delete miGen;

    delete io;
    delete graphics;
    delete gfxRes;
}

// Config?
void World::applyConfig(const Config* config) {
    graphics->setVsync(config->vsync);
    const Config::KeyBindsMap& keyboardMappings = config->getKeyboardBindings();
    for (const auto& it : keyboardMappings) {
        keyBinds->bindInput(it.first, it.second);
    }
}

// Timer interface
int World::getTickRate() const { return timing->getTickRate(); }
int World::getFrameRate() const { return timing->getFrameRate(); }
float World::getAvgFrameRate() const { return timing->getAvgFrameRate(); }
float World::getAvgTickRate() const { return timing->getAvgTickRate(); }
void World::setTickRate(int rate) { return timing->setTickRate(rate); }
void World::setFrameRate(int rate) { return timing->setFrameRate(rate); }

// Lifecycle
void World::quit() { shutdownRequested = true; }
bool World::run() {
    if (shutdownRequested) { return false; } // Shutdown

    // Game logic updates first. // oki
    if (timing->tickReady()) { startTick(timing->getSinceTick()); }
    if (timing->frameReady()) { startFrame(timing->getSinceFrame()); }
    return graphics->isWindowOpen();
}


void World::runEveryFrame(float interp) { scripting->updateEveryFrame(interp); }
void World::runMenuFrame(float interp) { scripting->updateMenuFrame(interp); }
void World::runLoadFrame(float interp) { scripting->updateLoadFrame(interp); }
void World::runFrame(float interp) { scripting->updateFrame(interp); }
void World::runTick(uint32_t tick, float interp) { scripting->updateTick(tick, interp); }
void World::runLoadTick(float interp) { scripting->updateLoadTick(interp); }
void World::runEveryTick(uint32_t tick, float interp) { scripting->updateEveryTick(tick, interp); }

// Lifecycle - Ticking
void World::startTick(float sinceLast) {
    // Only need to get the inputs once.
    SysEvents::update();
    io->update();
    keyBinds->update();
    mouseData->update();
    Input downInputs = keyBinds->getDownInputs();
    Input hitInputs = keyBinds->getHitInputs();
    PGE::Vector2f mousePos = io->getMousePosition();
    //printf("Runtick : %s\n", paused ? "PAUSED" : "NOT paused");
    if (loading) { // convenience function to only run the updateAll function.
        paused = true;
        runLoadTick(sinceLast);
        return;
    }

    bool wasPaused = paused;
    bool wasUnpaused=false;
    runEveryTick(tick, sinceLast); // If anything is going to unpause the game, it's going to be originating from here
    if (!paused && wasPaused) {
        menuMousePos = mousePos;
        io->setMouseVisibility(false);
        io->setMousePosition(gameMousePos);
        wasUnpaused = true;
    }
    if (!paused) {
        applyCameraMouseMovement(io->getMousePosition());
        gameMousePos = io->getMousePosition();
        runTick(tick,sinceLast);
        tick++;
    }
    if (paused) {
        if (wasUnpaused) { // Remember mouse pos if advanceOneTick();
            io->setMousePosition(menuMousePos);
        } else if(!wasPaused) {
            io->setMouseVisibility(true);
        }
    }
}
void World::applyCameraMouseMovement(PGE::Vector2f mousePos) {
    // View/Projection matrix. Apply mouse movements to camera rotation.
    PGE::Vector2f screenCenter = PGE::Vector2f((float)config->getWidth(), (float)config->getHeight()) * (0.5f);
    PGE::Vector2f addAngle =(mousePos - screenCenter) * (config->sensitivity->value / 30000.f);
    camera->addAngle(addAngle.x, addAngle.y);
    io->setMousePosition(screenCenter);
    //camera->update();
    pickMng->update();
}

// Lifecycle - Frames Per Second
void World::startFrame(float interpolation) {
    if (loading) {
        graphics->setDepthTest(false);
        scripting->updateLoadFrame(interpolation);
        graphics->setDepthTest(true);
        graphics->swap();
        return;
    }

    graphics->update();
    graphics->resetRenderTarget();
    graphics->clear(PGE::Color(1.f, 0.f, 1.f));

     // 1.f works alrighty.

    camera->update();
    pickMng->render();

    scripting->updateEveryFrame(interpolation);
    if (!paused) {
        scripting->updateFrame(interpolation);
        camera->updateDrawTransform(1.f);
    } else {
        camera->updateDrawTransform(1.f);
    }
    gfxRes->setCameraUniforms(camera);

    graphics->setDepthTest(false);
    scripting->updateMenuFrame(interpolation);
    graphics->setDepthTest(true);

    //lol->render(PGE::Matrix4x4f::constructWorldMat(PGE::Vector3f(0, 0, 0), PGE::Vector3f(0.1, 0.1, 0.1), PGE::Vector3f(0, 0, 0)));

    graphics->swap();
}

// World Fonts
Font* World::getFont() const {return largeFont;}
Font* World::getFontAppleLarge() const { return fontAppleLarge; }
Font* World::getFontAppleSmall() const { return fontAppleLarge; }
Font* World::getFontInconsolataLarge() const { return fontInconsolataLarge; }
Font* World::getFontInconsolataSmall() const { return fontInconsolataSmall; }
Font* World::getFontCrystalLarge() const { return fontCrystalLarge; }
Font* World::getFontCrystalSmall() const { return fontCrystalLarge; }
Font* World::getFontSubotypeLarge() const { return fontSubotypeLarge; }
Font* World::getFontSubotypeSmall() const { return fontSubotypeLarge; }
Font* World::getFontBoldLarge() const { return fontBoldLarge; }
Font* World::getFontBoldSmall() const { return fontBoldLarge; }