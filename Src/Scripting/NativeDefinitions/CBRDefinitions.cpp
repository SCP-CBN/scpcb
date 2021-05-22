#include "CBRDefinitions.h"

#include <fstream>
#include <stdio.h>

#include "../../Models/CBR.h"
#include "../ScriptManager.h"

CBRDefinitions::CBRDefinitions(ScriptManager* mgr, GraphicsResources* gfxRes) {
    graphicsResources = gfxRes;

    engine = mgr->getAngelScriptEngine();

    engine->RegisterObjectType("CBR", sizeof(CBR), asOBJ_REF | asOBJ_NOCOUNT);

    engine->RegisterObjectMethod("CBR", "Collision::Mesh@ getCollisionMesh(int index)", asMETHOD(CBR, getCollisionMesh), asCALL_THISCALL);
    engine->RegisterObjectMethod("CBR", "int collisionMeshCount()", asMETHOD(CBR, collisionMeshCount), asCALL_THISCALL);

    engine->RegisterObjectMethod("CBR", "void render(const Matrix4x4f&in matrix)", asMETHOD(CBR, render), asCALL_THISCALL);

    engine->SetDefaultNamespace("CBR");
    engine->RegisterGlobalFunction("CBR@ load(string filename)", asMETHOD(CBRDefinitions, loadCBR), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("void delete(CBR@ rm2)", asMETHOD(CBRDefinitions, deleteCBR), asCALL_THISCALL_ASGLOBAL, this);
}

#include <iostream>

CBR* CBRDefinitions::loadCBR(PGE::String filename) {
    try {
        return new CBR(graphicsResources, filename);
    } catch (const std::exception& e) {
        std::cout << e.what() << std::endl;
    }
}

void CBRDefinitions::deleteCBR(CBR* rm2) {
    delete rm2;
}
