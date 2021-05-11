#include "RM2Definitions.h"

#include <fstream>
#include <stdio.h>

#include "../../Models/RM2.h"
#include "../ScriptManager.h"

RM2Definitions::RM2Definitions(ScriptManager* mgr, GraphicsResources* gfxRes) {
    graphicsResources = gfxRes;

    engine = mgr->getAngelScriptEngine();

    engine->RegisterObjectType("RM2", sizeof(RM2), asOBJ_REF | asOBJ_NOCOUNT);

    engine->RegisterObjectMethod("RM2", "Collision::Mesh@ getCollisionMesh(int index)", asMETHOD(RM2, getCollisionMesh), asCALL_THISCALL);
    engine->RegisterObjectMethod("RM2", "int collisionMeshCount()", asMETHOD(RM2, collisionMeshCount), asCALL_THISCALL);

    engine->RegisterObjectMethod("RM2", "void render(const Matrix4x4f&in matrix)", asMETHOD(RM2, render), asCALL_THISCALL);

    engine->SetDefaultNamespace("RM2");
    engine->RegisterGlobalFunction("RM2@ load(string filename)", asMETHOD(RM2Definitions, loadRM2), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("void delete(RM2@ rm2)", asMETHOD(RM2Definitions, deleteRM2), asCALL_THISCALL_ASGLOBAL, this);
}

#include <iostream>

RM2* RM2Definitions::loadRM2(PGE::String filename) {
    try {
        return new RM2(graphicsResources, filename);
    } catch (const std::exception& e) {
        std::cout << e.what() << std::endl;
    }
}

void RM2Definitions::deleteRM2(RM2* rm2) {
    delete rm2;
}
