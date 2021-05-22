#include "WorldDefinitions.h"

#include "../ScriptManager.h"

#include "../../World/World.h"

WorldDefinitions::WorldDefinitions(ScriptManager* mgr, World* w) :
#ifdef _WIN32
    platform(0)
#elif defined __APPLE__
    platform(1)
#elif defined LINUX
    platform(2)
#endif
    {
    engine = mgr->getAngelScriptEngine();

    engine->SetDefaultNamespace("Environment");
    engine->RegisterGlobalProperty("bool paused", &w->paused);
    engine->RegisterGlobalProperty("bool loading", &w->loading);
    engine->RegisterGlobalProperty("int loadState", &w->loadState);
    engine->RegisterGlobalProperty("int loadDone", &w->loadDone);
    engine->RegisterGlobalProperty("int loadMax", &w->loadMax);

    engine->RegisterGlobalProperty("uint32 tick", &w->tick);
    
    engine->RegisterGlobalFunction("int get_tickRate() property", asMETHOD(World, getTickRate), asCALL_THISCALL_ASGLOBAL, w);
    engine->RegisterGlobalFunction("void set_tickRate(int rate) property", asMETHOD(World, setTickRate), asCALL_THISCALL_ASGLOBAL, w);
    engine->RegisterGlobalFunction("int get_frameRate() property", asMETHOD(World, getFrameRate), asCALL_THISCALL_ASGLOBAL, w);
    engine->RegisterGlobalFunction("void set_frameRate(int rate) property", asMETHOD(World, setFrameRate), asCALL_THISCALL_ASGLOBAL, w);

    engine->RegisterGlobalFunction("int get_avgTickRate() property", asMETHOD(World, getAvgTickRate), asCALL_THISCALL_ASGLOBAL, w);
    engine->RegisterGlobalFunction("int get_avgFrameRate() property", asMETHOD(World, getAvgFrameRate), asCALL_THISCALL_ASGLOBAL, w);

    engine->RegisterGlobalFunction("void quit()", asMETHOD(World, quit), asCALL_THISCALL_ASGLOBAL, w);

    engine->RegisterEnum("Platform");
    engine->RegisterEnumValue("Platform", "Windows", 0);
    engine->RegisterEnumValue("Platform", "Apple", 1);
    engine->RegisterEnumValue("Platform", "Linux", 2);

    engine->SetDefaultNamespace("Environment::Platform");
    engine->RegisterGlobalProperty("const Platform active", (void*)&platform);
}
