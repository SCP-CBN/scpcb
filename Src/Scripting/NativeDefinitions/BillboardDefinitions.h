#ifndef BILLBOARDDEFINITIONS_H_INCLUDED
#define BILLBOARDDEFINITIONS_H_INCLUDED

#include <PGE/Math/Vector.h>
#include <PGE/Color/Color.h>

#include "../NativeDefinition.h"

class ScriptManager;
class BillboardManager;
class Billboard;

class BillboardDefinitions : public NativeDefinition {
    private:
        BillboardManager* bm;

        Billboard* createBillboardFacingCamera(const PGE::String& textureName, const PGE::Vector3f& pos, float rotation, const PGE::Vector2f& scale, const PGE::Color& color);
        Billboard* createBillboardArbitraryRotation(const PGE::String& textureName, const PGE::Vector3f& pos, const PGE::Vector3f& rotation, const PGE::Vector2f& scale, const PGE::Color& color);
        void destroyBillboard(Billboard* billboard);

    public:
        BillboardDefinitions(ScriptManager* mgr, BillboardManager* bm);
};

#endif // BILLBOARDDEFINITIONS_H_INCLUDED
