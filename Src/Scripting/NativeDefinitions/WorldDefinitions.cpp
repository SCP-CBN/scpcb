#include "../NativeDefinitionRegistrar.h"
#include "../NativeDefinitionHelpers.h"

#include "../ScriptManager.h"

#include "../../World/World.h"

static void registerWorldDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers& helpers) {
    constexpr int PLATFORM =
#ifdef _WIN32
        0
#elif defined __APPLE__
        1
#elif defined LINUX
        2
#endif
    ;

    engine.SetDefaultNamespace("World");
    engine.RegisterGlobalProperty("bool paused", &helpers.world->paused);
    engine.RegisterGlobalFunction("void quit()", asMETHOD(World, quit), asCALL_THISCALL_ASGLOBAL, helpers.world);

    engine.RegisterEnum("Platform");
    engine.RegisterEnumValue("Platform", "Windows", 0);
    engine.RegisterEnumValue("Platform", "Apple", 1);
    engine.RegisterEnumValue("Platform", "Linux", 2);

    engine.SetDefaultNamespace("World::Platform");
    engine.RegisterGlobalProperty("const Platform active", (void*)&PLATFORM);
}

static NativeDefinitionRegistrar _ { &registerWorldDefinitions };
