#include "../NativeDefinitionRegistrar.h"

#include "../NativeDefinitionHelpers.h"

#include "../NativeUtils.h"

#include "../../Graphics/GraphicsResources.h"

static void registerTextureDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers& helpers) {
    engine.RegisterObjectType("Texture", sizeof(PGE::Texture), asOBJ_REF | asOBJ_NOCOUNT);

    engine.SetDefaultNamespace("Texture");
    engine.RegisterGlobalFunction("Texture@ get(const string&in filename)", asMETHOD(GraphicsResources, getTexture), asCALL_THISCALL_ASGLOBAL, helpers.gfxRes);
    engine.RegisterGlobalFunction("void drop(Texture@ texture)", asMETHOD(GraphicsResources, dropTexture), asCALL_THISCALL_ASGLOBAL, helpers.gfxRes);
}

static NativeDefinitionRegistrar _ { &registerTextureDefinitions };
