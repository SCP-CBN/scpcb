#include "MaterialDefinitions.h"

#include "../ScriptManager.h"
#include "../../Graphics/GraphicsResources.h"

MaterialDefinitions::MaterialDefinitions(ScriptManager* mgr, GraphicsResources* gr) {
    engine = mgr->getAngelScriptEngine();
    gfxRes = gr;

    engine->RegisterObjectType("CMaterial", sizeof(PGE::Material), asOBJ_REF | asOBJ_NOCOUNT);
    engine->SetDefaultNamespace("CMaterial");
    engine->RegisterGlobalFunction("CMaterial@ create(string fileName)", asMETHOD(MaterialDefinitions, createMaterial), asCALL_CDECL);
    engine->RegisterGlobalFunction("void destroy(CMaterial@ m)", asMETHOD(MaterialDefinitions, destroyMaterial), asCALL_CDECL);
}

PGE::Material MaterialDefinitions::createMaterial(PGE::String fileName) {
    auto* shader = gfxRes->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/Model/"), true);
    PGE::Material newMat = PGE::Material(shader, gfxRes->getTexture(fileName),true);
    return newMat;
}
void MaterialDefinitions::destroyMaterial(PGE::Material mat) {
}