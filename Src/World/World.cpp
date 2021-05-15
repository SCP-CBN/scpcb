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
#include "../Save/Config.h"
#include "../Input/KeyBinds.h"
#include "../Input/Input.h"
#include "../Input/MouseData.h"
#include "../Utils/LocalizationManager.h"
#include "../Graphics/ModelImageGenerator.h"
#include "../Utils/MathUtil.h"
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
    config = new Config("options.ini");

    camera = new Camera(gfxRes, config->getWidth(), config->getHeight());

    graphics = PGE::Graphics::create("SCP - Containment Breach", config->getWidth(), config->getHeight(), false);
    graphics->setViewport(PGE::Rectanglei(0, 0, config->getWidth(), config->getHeight()));
    io = PGE::IO::create(graphics);

    timing = new Timing(60);

    gfxRes = new GraphicsResources(graphics, config);

    FT_Init_FreeType(&ftLibrary);
    largeFont = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/Inconsolata-Regular.ttf"), 20);
    fontInconsolataLarge = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/Inconsolata-Regular.ttf"), 20);
    fontInconsolataSmall = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/Inconsolata-Regular.ttf"), 11);
    fontAppleLarge = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/HomemadeApple-Regular.ttf"), 20);
    fontAppleSmall = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/HomemadeApple-Regular.ttf"), 11);
    fontCrystalLarge = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/LiquidCrystal-Normal.otf"), 20);
    fontCrystalSmall = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/LiquidCrystal-Normal.otf"), 11);
    fontSubotypeLarge = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/Subotype.otf"), 20);
    fontSubotypeSmall = new Font(ftLibrary, gfxRes, config, PGE::FilePath::fromStr("SCPCB/GFX/Font/Subotype.otf"), 11);

    uiMesh = new UIMesh(gfxRes);
    keyBinds = new KeyBinds(io);
    mouseData = new MouseData(io, config);

    locMng = new LocalizationManager(config->languageCode->value);
    
    io->setMouseVisibility(false);
    io->setMousePosition(PGE::Vector2f((float)config->getWidth() / 2, (float)config->getHeight() / 2));

    pickMng = new PickableManager(camera, uiMesh, keyBinds);

    billMng = new BillboardManager(graphics, gfxRes, camera);

    oldPaused = false;
    paused = false;

    miGen = new ModelImageGenerator(graphics, gfxRes);
    miGen->initialize(256);

    scripting = new ScriptWorld(this, gfxRes, camera, keyBinds, mouseData, io, locMng, pickMng, uiMesh, config, (float)timing->getTimeStep(), billMng, miGen);

    miGen->deinitialize();

    applyConfig(config);

    //lol = new CBR(gfxRes, "asd.cbr");

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

    delete io;
    delete graphics;
    delete gfxRes;
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
    SysEvents::update();
    io->update();
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
            io->setMouseVisibility(true);
        } else {
            io->setMouseVisibility(false);
            io->setMousePosition(PGE::Vector2f((float)config->getWidth() / 2, (float)config->getHeight() / 2));
        }
    }
}

void World::draw(float interpolation, RenderType r) {
    if (r != RenderType::UIOnly) {
        drawPlaying(interpolation);
        scripting->drawGame(interpolation);
        //lol->render(PGE::Matrix4x4f::constructWorldMat(PGE::Vector3f(0, 0, 0), PGE::Vector3f(0.1, 0.1, 0.1), PGE::Vector3f(0, 0, 0)));
    }

    if (r != RenderType::NoUI) {
        graphics->setDepthTest(false);
        scripting->drawMenu(interpolation);
        graphics->setDepthTest(true);
    }

    graphics->swap();
}

void World::updatePlaying(float timeStep) {
    PGE::Vector2f center = PGE::Vector2f((float)config->getWidth(), (float)config->getHeight()).multiply(0.5f);
    
    PGE::Vector2f addAngle = io->getMousePosition().subtract(center).multiply(config->sensitivity->value / 30000.f);
    camera->addAngle(addAngle.x, addAngle.y);

    // Reset mouse to center.
    io->setMousePosition(center);

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

Font* World::getFontAppleLarge() const {
    return fontAppleLarge;
}
Font* World::getFontAppleSmall() const {
    return fontAppleLarge;
}
Font* World::getFontInconsolataLarge() const {
    return fontInconsolataLarge;
}
Font* World::getFontInconsolataSmall() const {
    return fontInconsolataSmall;
}
Font* World::getFontCrystalLarge() const {
    return fontCrystalLarge;
}
Font* World::getFontCrystalSmall() const {
    return fontCrystalLarge;
}
Font* World::getFontSubotypeLarge() const {
    return fontSubotypeLarge;
}
Font* World::getFontSubotypeSmall() const {
    return fontSubotypeLarge;
}
Font* World::getFontBoldLarge() const {
    return fontBoldLarge;
}
Font* World::getFontBoldSmall() const {
    return fontBoldLarge;
}