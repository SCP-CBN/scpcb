#include "MaterialDefinitions.h"
#include <Mesh/Mesh.h>
#include <Texture/Texture.h>
#include <assimp/postprocess.h>

#include "../ScriptManager.h"
#include "../../Graphics/GraphicsResources.h"

MaterialDefinitions::MaterialDefinitions(ScriptManager* mgr, GraphicsResources* gr) {
    engine = mgr->getAngelScriptEngine();
    gfxRes = gr;
    shader = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/Model/"), true);
    modelMatrix = shader->getVertexShaderConstant("modelMatrix");
    PGE::Shader::Constant* colorConstant = shader->getFragmentShaderConstant("inColor");
    colorConstant->setValue(PGE::Color::WHITE);

    engine->RegisterObjectType("CMaterial", sizeof(PGE::Material), asOBJ_REF | asOBJ_NOCOUNT);
    engine->SetDefaultNamespace("CMaterial");
    engine->RegisterGlobalFunction("CMaterial@ create(Texture@ texture)", asMETHOD(MaterialDefinitions, createMaterial), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("void destroy(CMaterial@ m)", asMETHOD(MaterialDefinitions, destroyMaterial), asCALL_THISCALL_ASGLOBAL, this);
}

PGE::Material* MaterialDefinitions::createMaterial(PGE::Texture* texture) {
    PGE::Material* newMat = new PGE::Material(shader, texture);
    return newMat;
}
void MaterialDefinitions::destroyMaterial(PGE::Material mat) {
}