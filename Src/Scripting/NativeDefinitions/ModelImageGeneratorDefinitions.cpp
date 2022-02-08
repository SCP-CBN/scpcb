#include "../NativeDefinitionRegistrar.h"
#include "../NativeDefinitionHelpers.h"

#include "../ScriptManager.h"

#include "../../Graphics/ModelImageGenerator.h"

static void registerModelImageGeneratorDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers& helpers) {
    engine.SetDefaultNamespace("ModelImageGenerator");
    engine.RegisterGlobalFunction("void initialize(int texSize)", asMETHOD(ModelImageGenerator, initialize), asCALL_THISCALL_ASGLOBAL, helpers.mig);
    engine.RegisterGlobalFunction("void deinitialize()", asMETHOD(ModelImageGenerator, deinitialize), asCALL_THISCALL_ASGLOBAL, helpers.mig);
    engine.RegisterGlobalFunction("bool getInitialized()", asMETHOD(ModelImageGenerator, getInitialized), asCALL_THISCALL_ASGLOBAL, helpers.mig);
    engine.RegisterGlobalFunction("Texture@ generate(const string&in model, float scale, const Vector3f&in rotation, Vector2f position)", asMETHOD(ModelImageGenerator, generate), asCALL_THISCALL_ASGLOBAL, helpers.mig);
}

static NativeDefinitionRegistrar _ { &registerModelImageGeneratorDefinitions, NativeDefinitionDependencyFlags::TEXTURE };
