#include "../NativeDefinitionRegistrar.h"
#include "../NativeDefinitionHelpers.h"

#include "../../Models/RM2.h"
#include "../ScriptManager.h"

#include <iostream>

static GraphicsResources* gfxRes;

static RM2* loadRM2(const PGE::String& filename) {
    try {
        return new RM2(gfxRes, filename);
    } catch (const std::exception& e) {
        std::cout << e.what() << std::endl;
    }
}

static void deleteRM2(RM2* rm2) {
    delete rm2;
}

static void registerRM2Definitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers& helpers) {
    gfxRes = helpers.gfxRes;

    engine.RegisterObjectType("RM2", sizeof(RM2), asOBJ_REF | asOBJ_NOCOUNT);

    engine.RegisterObjectMethod("RM2", "Collision::Mesh@ getCollisionMesh(int index)", asMETHOD(RM2, getCollisionMesh), asCALL_THISCALL);
    engine.RegisterObjectMethod("RM2", "int collisionMeshCount()", asMETHOD(RM2, collisionMeshCount), asCALL_THISCALL);

    engine.RegisterObjectMethod("RM2", "void render(const Matrix4x4f&in matrix)", asMETHOD(RM2, render), asCALL_THISCALL);

    engine.SetDefaultNamespace("RM2");
    engine.RegisterGlobalFunction("RM2@ load(const string&in filename)", asFUNCTION(loadRM2), asCALL_CDECL);
    engine.RegisterGlobalFunction("void delete(RM2@ rm2)", asFUNCTION(deleteRM2), asCALL_CDECL);
}

static NativeDefinitionRegistrar _ { &registerRM2Definitions, NativeDefinitionDependencyFlags::COLLISION };
