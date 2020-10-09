#ifndef RM2DEFINITIONS_H_INCLUDED
#define RM2DEFINITIONS_H_INCLUDED

#include <Misc/String.h>

#include "../NativeDefinition.h"

class ScriptManager;
class GraphicsResources;
class RM2;

class RM2Definitions : public NativeDefinition {
    private:
        RM2* loadRM2(PGE::String filename);
        void deleteRM2(RM2* rm2);

        GraphicsResources* graphicsResources;
    public:
        RM2Definitions(ScriptManager* mgr, GraphicsResources* gfxRes);
};

#endif // RM2DEFINITIONS_H_INCLUDED
