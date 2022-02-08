#include "../NativeDefinitionRegistrar.h"
#include "../NativeDefinitionHelpers.h"

#include "../ScriptManager.h"

#include "../../Utils/LocalizationManager.h"

static void registerLocalizationDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers& helpers) {
    engine.SetDefaultNamespace("Local");
    engine.RegisterGlobalFunction("string getTxt(const string&in key)", asMETHOD(LocalizationManager, getLocalTxt), asCALL_THISCALL_ASGLOBAL, helpers.lm);
}

static NativeDefinitionRegistrar _ { &registerLocalizationDefinitions };
