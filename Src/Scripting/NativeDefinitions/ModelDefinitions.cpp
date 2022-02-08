#include "../NativeDefinitionRegistrar.h"
#include "../NativeDefinitionHelpers.h"

#include "../ScriptManager.h"

#include "../../Graphics/GraphicsResources.h"
#include "../../Models/Model.h"

static void registerModelDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers& helpers) {
    engine.RegisterObjectType("Model", sizeof(ModelInstance), asOBJ_REF | asOBJ_NOCOUNT);

    engine.RegisterObjectMethod("Model", "void render() const", asMETHOD(ModelInstance, render), asCALL_THISCALL);

    engine.RegisterObjectMethod("Model", "const Vector3f& get_position() property", asMETHOD(ModelInstance, getPosition), asCALL_THISCALL);
    engine.RegisterObjectMethod("Model", "void set_position(const Vector3f&in pos) property", asMETHOD(ModelInstance, setPosition), asCALL_THISCALL);
    engine.RegisterObjectMethod("Model", "const Vector3f& get_rotation() property", asMETHOD(ModelInstance, getRotation), asCALL_THISCALL);
    engine.RegisterObjectMethod("Model", "void set_rotation(const Vector3f&in rot) property", asMETHOD(ModelInstance, setRotation), asCALL_THISCALL);
    engine.RegisterObjectMethod("Model", "const Vector3f& get_scale() property", asMETHOD(ModelInstance, getScale), asCALL_THISCALL);
    engine.RegisterObjectMethod("Model", "void set_scale(const Vector3f&in scl) property", asMETHOD(ModelInstance, setScale), asCALL_THISCALL);

    engine.SetDefaultNamespace("Model");
    engine.RegisterGlobalFunction("Model@ create(string modelName)", asMETHOD(GraphicsResources, getModelInstance), asCALL_THISCALL_ASGLOBAL, helpers.gfxRes);
    engine.RegisterGlobalFunction("void destroy(Model@ m)", asMETHOD(GraphicsResources, dropModelInstance), asCALL_THISCALL_ASGLOBAL, helpers.gfxRes);
}

static NativeDefinitionRegistrar _ { &registerModelDefinitions, NativeDefinitionDependencyFlags::MATH };
