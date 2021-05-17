#ifndef MATERIALDEFINITIONS_H_INCLUDED
#define MATERIALDEFINITIONS_H_INCLUDED
#include <Mesh/Mesh.h>
#include "../NativeDefinition.h"

class ScriptManager;
class GraphicsResources;

class MaterialDefinitions : public NativeDefinition {
    private:
        PGE::Material createMaterial(PGE::String fileName);
        void destroyMaterial(PGE::Material mat);
        GraphicsResources* gfxRes;

    public:
        MaterialDefinitions(ScriptManager* mgr, GraphicsResources* gr);
};

#endif // MATERIALDEFINITIONS_H_INCLUDED
