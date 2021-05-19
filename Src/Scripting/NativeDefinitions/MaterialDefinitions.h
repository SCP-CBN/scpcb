#ifndef MATERIALDEFINITIONS_H_INCLUDED
#define MATERIALDEFINITIONS_H_INCLUDED
#include <Mesh/Mesh.h>

#include <Shader/Shader.h>
#include <Texture/Texture.h>

#include "../NativeDefinition.h"

class ScriptManager;
class GraphicsResources;

class MaterialDefinitions : public NativeDefinition {
    private:
        PGE::Material* createMaterial(PGE::Texture* texture);
        void destroyMaterial(PGE::Material mat);
        GraphicsResources* gfxRes;

        PGE::Shader* shader;
        PGE::Shader::Constant* modelMatrix;

    public:
        MaterialDefinitions(ScriptManager* mgr, GraphicsResources* gr);
};

#endif // MATERIALDEFINITIONS_H_INCLUDED
