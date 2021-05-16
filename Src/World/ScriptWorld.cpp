#include "ScriptWorld.h"

#include <Exception/Exception.h>

#include "../Save/Config.h"
#include "../Input/KeyBinds.h"

#include "../Scripting/RefCounter.h"
#include "../Scripting/ScriptManager.h"
#include "../Scripting/ScriptModule.h"
#include "../Scripting/Script.h"
#include "../Scripting/ScriptFunction.h"
#include "../Scripting/ScriptClass.h"

#include "../Scripting/NativeDefinitions/WorldDefinitions.h"
#include "../Scripting/NativeDefinitions/RegexDefinitions.h"
#include "../Scripting/NativeDefinitions/MementoDefinitions.h"
#include "../Scripting/NativeDefinitions/ConsoleDefinitions.h"
#include "../Scripting/NativeDefinitions/InputDefinitions.h"
#include "../Scripting/NativeDefinitions/ColorDefinitions.h"
#include "../Scripting/NativeDefinitions/MathDefinitions.h"
#include "../Scripting/NativeDefinitions/RandomDefinitions.h"
#include "../Scripting/NativeDefinitions/UIDefinitions.h"
#include "../Scripting/NativeDefinitions/TextureDefinitions.h"
#include "../Scripting/NativeDefinitions/ModelImageGeneratorDefinitions.h"
#include "../Scripting/NativeDefinitions/LocalizationDefinitions.h"
#include "../Scripting/NativeDefinitions/BillboardDefinitions.h"
#include "../Scripting/NativeDefinitions/ModelDefinitions.h"
#include "../Scripting/NativeDefinitions/RM2Definitions.h"
#include "../Scripting/NativeDefinitions/CollisionDefinitions.h"
#include "../Scripting/NativeDefinitions/PickableDefinitions.h"
#include "../Scripting/NativeDefinitions/PlayerControllerDefinitions.h"
#include "../Scripting/NativeDefinitions/EventDefinition.h"
#include "../Scripting/NativeDefinitions/ReflectionDefinitions.h"

// Generally, world->scripting;

ScriptWorld::ScriptWorld(World* world, GraphicsResources* gfxRes, Camera* camera, KeyBinds* keyBinds, MouseData* mouseData, PGE::IO* io, LocalizationManager* lm, PickableManager* pm, UIMesh* um, Config* config, BillboardManager* bm, ModelImageGenerator* mig) {
    manager = new ScriptManager();
    gameWorld = world;

    refCounterManager = new RefCounterManager();

    nativeDefs.push_back(new WorldDefinitions(manager, world));
    nativeDefs.push_back(new RegexDefinitions(manager, refCounterManager));
    nativeDefs.push_back(new MementoDefinitions(manager));
    nativeDefs.push_back(new ColorDefinitions(manager));
    nativeDefs.push_back(new MathDefinitions(manager));
    nativeDefs.push_back(new RandomDefinitions(manager, refCounterManager));
    nativeDefs.push_back(new InputDefinitions(manager, keyBinds, mouseData, io));
    nativeDefs.push_back(new TextureDefinitions(manager, gfxRes));
    nativeDefs.push_back(new ModelImageGeneratorDefinitions(manager, mig));
    nativeDefs.push_back(new UIDefinitions(manager, um, config, world));
    nativeDefs.push_back(new LocalizationDefinitions(manager, lm));
    nativeDefs.push_back(new BillboardDefinitions(manager, bm));
    nativeDefs.push_back(new CollisionDefinitions(manager, refCounterManager));
    nativeDefs.push_back(new ModelDefinitions(manager, gfxRes));
    nativeDefs.push_back(new RM2Definitions(manager, gfxRes));
    nativeDefs.push_back(new PickableDefinitions(manager, refCounterManager, pm));
    nativeDefs.push_back(new PlayerControllerDefinitions(manager, refCounterManager, camera));
    nativeDefs.push_back(new ReflectionDefinitions(manager));
    ConsoleDefinitions* conDef = new ConsoleDefinitions(manager, keyBinds);
    nativeDefs.push_back(conDef);

    keyBinds->setConsoleDefinitions(conDef);


    perTickEventDefinition = new EventDefinition(manager, "PerTick", // Tick++;
        std::vector<ScriptFunction::Signature::Argument> { ScriptFunction::Signature::Argument(Type::UInt32, "tick"), ScriptFunction::Signature::Argument(Type::Float, "interpolation") });

    perEveryTickEventDefinition = new EventDefinition(manager, "PerEveryTick", // Some things need to always tick
        std::vector<ScriptFunction::Signature::Argument> { ScriptFunction::Signature::Argument(Type::UInt32, "tick"), ScriptFunction::Signature::Argument(Type::Float, "interpolation") });

    perFrameGameEventDefinition = new EventDefinition(manager, "PerFrame",
        std::vector<ScriptFunction::Signature::Argument> { ScriptFunction::Signature::Argument(Type::Float, "interpolation") });

    perFrameMenuEventDefinition = new EventDefinition(manager, "PerEveryFrame",
        std::vector<ScriptFunction::Signature::Argument> { ScriptFunction::Signature::Argument(Type::Float, "interpolation") });
    // perTickEventDefinition->setArgument("tick", tick); // maintained for reference

    const std::vector<PGE::String>& enabledMods = config->enabledMods->value;

    tinyxml2::XMLDocument doc;

    for (int i = 0; i < enabledMods.size(); i++) {
        PGE::FilePath directory = PGE::FilePath::fromStr(enabledMods[i] + "/");
        PGE::FilePath depsFile = PGE::FilePath(directory, "dependencies.cfg");
        if (depsFile.exists()) {
            std::vector<PGE::String> depNames; depsFile.readLines(depNames);
            int depsNotEnabled = (int)depNames.size();
            for (int j = 0; j < i; j++) {
                for (int k = 0; k < depNames.size(); k++) {
                    if (enabledMods[j].equals(depNames[k])) {
                        depsNotEnabled--;
                        break;
                    }
                }
            }
            PGE_ASSERT(depsNotEnabled == 0, enabledMods[i] + " has dependencies that are not enabled before it");
        }
        ScriptModule* scriptModule = new ScriptModule(manager, enabledMods[i]);
        std::vector<PGE::FilePath> files; directory.enumerateFiles(files);
        for (int j = 0; j < files.size(); j++) {
            if (files[j].getExtension().equals("as")) {
                Script* script = new Script(files[j]);
                scriptModule->addScript(files[j].str()
                    .replace("/", "")
                    .replace(".", ""), script);
            }
        }
        scriptModule->build();
        modules.push_back(scriptModule);
    }

    conDef->setUp(manager);

    for (int i=0;i<modules.size();i++) {
        ScriptModule* scriptModule = modules[i];

        ScriptFunction* mainFunction = scriptModule->getFunctionByName("main");
        if (mainFunction != nullptr) {
            mainFunction->prepare();
            mainFunction->execute();
        }

        //scriptModule->save(doc);
        //doc.LoadFile("juanIsntReal.xml");
        //scriptModule->load(doc.FirstChildElement());
        //scriptModule->save(doc);
    }

    doc.SaveFile("juanIsntReal.xml");
}

ScriptWorld::~ScriptWorld() {
    for (int i = 0; i < modules.size(); i++) {
        ScriptModule* scriptModule = modules[i];

        ScriptFunction* exitFunction = scriptModule->getFunctionByName("exit");
        if (exitFunction != nullptr) {
            exitFunction->prepare();
            exitFunction->execute();
        }
    }

    for (int i = (int)modules.size()-1; i >= 0; i--) {
        delete modules[i];
    }

    delete perTickEventDefinition;
    delete perFrameGameEventDefinition;
    delete perFrameMenuEventDefinition;

    for (NativeDefinition* nd : nativeDefs) {
        delete nd;
    }

    delete refCounterManager;

    delete manager;
}

void ScriptWorld::updateTick(uint32_t tick, float interp) {
    perTickEventDefinition->setArgument("tick", tick);
    perTickEventDefinition->setArgument("interpolation", interp);
    perTickEventDefinition->execute();
}

void ScriptWorld::updateEveryTick(uint32_t tick, float interp) {
    perEveryTickEventDefinition->setArgument("tick", tick);
    perEveryTickEventDefinition->setArgument("interpolation", interp);
    perEveryTickEventDefinition->execute();
}

void ScriptWorld::updateFrame(float interpolation) {
    perFrameGameEventDefinition->setArgument("interpolation", interpolation);
    perFrameGameEventDefinition->execute();
}

void ScriptWorld::updateEveryFrame(float interpolation) {
    perFrameMenuEventDefinition->setArgument("interpolation", interpolation);
    perFrameMenuEventDefinition->execute();
}
