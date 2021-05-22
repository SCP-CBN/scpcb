#ifndef CBRDEFINITIONS_H_INCLUDED
#define CBRDEFINITIONS_H_INCLUDED

#include <String/String.h>

#include "../NativeDefinition.h"

class ScriptManager;
class GraphicsResources;
class CBR;

class CBRDefinitions : public NativeDefinition {
    private:
        GraphicsResources* graphicsResources;
        
        CBR* loadCBR(PGE::String filename);
        void deleteCBR(CBR* rm2);

    public:
        CBRDefinitions(ScriptManager* mgr, GraphicsResources* gfxRes);
};

#endif // CBRDEFINITIONS_H_INCLUDED
