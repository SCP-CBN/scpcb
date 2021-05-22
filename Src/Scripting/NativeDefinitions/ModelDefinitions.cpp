#include "ModelDefinitions.h"

#include "../ScriptManager.h"

#include "../../Graphics/GraphicsResources.h"
#include "../../Models/Model.h"

ModelDefinitions::ModelDefinitions(ScriptManager* mgr, GraphicsResources* gr) {
    engine = mgr->getAngelScriptEngine();

    engine->RegisterObjectType("CModel", sizeof(ModelInstance), asOBJ_REF | asOBJ_NOCOUNT);

    engine->RegisterObjectMethod("CModel", "void render() const", asMETHOD(ModelInstance, render), asCALL_THISCALL);

    engine->RegisterObjectMethod("CModel", "const Vector3f& get_position() property", asMETHOD(ModelInstance, getPosition), asCALL_THISCALL);
    engine->RegisterObjectMethod("CModel", "void set_position(const Vector3f&in pos) property", asMETHOD(ModelInstance, setPosition), asCALL_THISCALL);
    engine->RegisterObjectMethod("CModel", "const Vector3f& get_rotation() property", asMETHOD(ModelInstance, getRotation), asCALL_THISCALL);
    engine->RegisterObjectMethod("CModel", "void set_rotation(const Vector3f&in rot) property", asMETHOD(ModelInstance, setRotation), asCALL_THISCALL);
    engine->RegisterObjectMethod("CModel", "const Vector3f& get_scale() property", asMETHOD(ModelInstance, getScale), asCALL_THISCALL);
    engine->RegisterObjectMethod("CModel", "void set_scale(const Vector3f&in scl) property", asMETHOD(ModelInstance, setScale), asCALL_THISCALL);

    engine->RegisterObjectMethod("CModel", "void setMaterial(CMaterial@ mat)", asMETHOD(ModelInstance, setMaterial), asCALL_THISCALL);

    engine->SetDefaultNamespace("CModel");
    engine->RegisterGlobalFunction("CModel@ create(string modelName)", asMETHOD(GraphicsResources, getModelInstance), asCALL_THISCALL_ASGLOBAL, gr);
    engine->RegisterGlobalFunction("void destroy(CModel@ m)", asMETHOD(GraphicsResources, dropModelInstance), asCALL_THISCALL_ASGLOBAL, gr);
}
