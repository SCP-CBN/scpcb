#include "World.h"

#include <iostream>
#include <cmath>
#include <PGE/Color/Color.h>
#include <filesystem>

#include "Timing.h"
#include "Pickable.h"
#include "ScriptWorld.h"
#include "../Graphics/Camera.h"
#include "../Graphics/GraphicsResources.h"
#include "../Graphics/DebugGraphics.h"
#include "../Models/CBR.h"
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

#include <PGE/Math/Random.h>
#include <chrono>

static CBR* lol;

World::World() {
    config = new Config("options.ini");

    camera = new Camera(gfxRes, config->getWidth(), config->getHeight());

    graphics = PGE::Graphics::create("SCP - Containment Breach", config->getWidth(), config->getHeight());
    graphics->setViewport(PGE::Rectanglei(0, 0, config->getWidth(), config->getHeight()));
    inputManager = PGE::InputManager::create(*graphics);

    timing = new Timing(60);

    gfxRes = new GraphicsResources(graphics, config);

    FT_Init_FreeType(&ftLibrary);
    largeFont = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/Inconsolata-Regular.ttf"), 20);
    uiMesh = new UIMesh(gfxRes);
    keyBinds = new KeyBinds(inputManager);
    mouseData = new MouseData(inputManager, config);

    locMng = new LocalizationManager(config->languageCode->value);
    
    inputManager->setMouseRelativeInput(true);
    inputManager->setMousePosition(PGE::Vector2f((float)config->getWidth() / 2, (float)config->getHeight() / 2));

    pickMng = new PickableManager(camera, uiMesh, keyBinds);

    billMng = new BillboardManager(graphics, gfxRes, camera);

    oldPaused = false;
    paused = false;

    miGen = new ModelImageGenerator(graphics, gfxRes);
    miGen->initialize(256);

    scripting = new ScriptWorld(this, gfxRes, camera, keyBinds, mouseData, inputManager, locMng, pickMng, uiMesh, config, (float)timing->getTimeStep(), billMng, miGen);

    miGen->deinitialize();

    applyConfig(config);

    lol = new CBR(gfxRes, "asd.cbr");

    shutdownRequested = false;
}

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

    delete inputManager;
    delete gfxRes;
    delete graphics;
}

void World::applyConfig(const Config* config) {
    graphics->setVsync(config->vsync);
    const Config::KeyBindsMap& keyboardMappings = config->getKeyboardBindings();
    for (const auto& it : keyboardMappings) {
        keyBinds->bindInput(it.first, it.second);
    }
}

bool World::run() {
    if (shutdownRequested) {
        return false;
    }

    // Game logic updates first, use accumulator.
    while (timing->tickReady()) {
        timing->updateInterpolationFactor();
        runTick((float)timing->getTimeStep());
        timing->subtractTick();
    }

    // Rendering next, don't use accumulator.
    graphics->update();

    graphics->resetRenderTarget();
    graphics->clear(PGE::Color(1.f, 0.f, 1.f));
    draw((float)timing->getInterpolationFactor(), RenderType::All);

    // Get elapsed seconds since last run.
    double secondsPassed = timing->getElapsedSeconds();
    timing->addSecondsToAccumulator(secondsPassed);

    return graphics->isWindowOpen();
}

void World::runTick(float timeStep) {
    PGE::SysEvents::update();
    inputManager->update();
    keyBinds->update();
    mouseData->update();

    Input downInputs = keyBinds->getDownInputs();
    Input hitInputs = keyBinds->getHitInputs();

    if (!paused) {
        updatePlaying(timeStep);
    }

    scripting->update(timeStep);

    // If the game was (un-/)paused this tick then reset the mouse position.
    if (paused != oldPaused) {
        oldPaused = paused;
        if (paused) {
            // Null all interpolator differences.
            runTick(0.f);
            updatePlaying(0.f);
            inputManager->setMouseRelativeInput(false);
            inputManager->setMousePosition(PGE::Vector2f((float)config->getWidth() / 2, (float)config->getHeight() / 2));
        } else {
            inputManager->setMouseRelativeInput(true);
        }
    }
}

void World::draw(float interpolation, RenderType r) {
    if (r != RenderType::UIOnly) {
        drawPlaying(interpolation);
        scripting->drawGame(interpolation);
        lol->render(PGE::Matrix4x4f::constructWorldMat(PGE::Vector3f(0, 100, 0), PGE::Vector3f(0, 0, 0), PGE::Vector3f(0.1, 0.1, 0.1)));
    }

    if (r != RenderType::NoUI) {
        graphics->setDepthTest(false);
        scripting->drawMenu(interpolation);
        graphics->setDepthTest(true);
    }

    graphics->swap();
}

void World::updatePlaying(float timeStep) {
    PGE::Vector2f center = PGE::Vector2f((float)config->getWidth(), (float)config->getHeight()) * 0.5f;
    
    PGE::Vector2f addAngle = mouseData->getDelta() * (config->sensitivity->value / 30000.f);
    camera->addAngle(addAngle.x, addAngle.y);

    // Reset mouse to center.
    inputManager->setMousePosition(center);

    // View/Projection matrix.
    camera->update();

    pickMng->update();
}

void World::drawPlaying(float interpolation) {
    camera->updateDrawTransform(interpolation);
    gfxRes->setCameraUniforms(camera);
    pickMng->render();
}

void World::quit() {
    shutdownRequested = true;
}

Font* World::getFont() const {
    return largeFont;
}
