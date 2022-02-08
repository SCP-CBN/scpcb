#include "../NativeDefinitionRegistrar.h"
#include "../NativeDefinitionHelpers.h"

#include "../NativeUtils.h"

#include "../ScriptManager.h"

#include "../../Graphics/Billboard.h"

static BillboardManager* bm;

static Billboard* createBillboardFacingCamera(const PGE::String& textureName, const PGE::Vector3f& pos, float rotation, const PGE::Vector2f& scale, const PGE::Color& color) {
    return new Billboard(bm, textureName, pos, rotation, scale, color);
}

static Billboard* createBillboardArbitraryRotation(const PGE::String& textureName, const PGE::Vector3f& pos, const PGE::Vector3f& rotation, const PGE::Vector2f& scale, const PGE::Color& color) {
    return new Billboard(bm, textureName, pos, rotation, scale, color);
}

static void registerBillboardDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers& helpers) {
    bm = helpers.bm;
    
    engine.RegisterObjectType("Billboard", sizeof(Billboard), asOBJ_REF | asOBJ_NOCOUNT);

    engine.RegisterObjectMethod("Billboard", "void set_visible(bool vis) property", asMETHOD(Billboard, setVisible), asCALL_THISCALL);
    engine.RegisterObjectMethod("Billboard", "bool get_visible() property", asMETHOD(Billboard, getVisible), asCALL_THISCALL);

    engine.SetDefaultNamespace("Billboard");
    engine.RegisterGlobalFunction("Billboard@ create(string textureName, const Vector3f&in pos, float rotation, const Vector2f&in scale=Vector2f(1.0, 1.0), const Color&in color=Color(1.0, 1.0, 1.0))", asFUNCTION(createBillboardFacingCamera), asCALL_CDECL);
    engine.RegisterGlobalFunction("Billboard@ create(string textureName, const Vector3f&in pos, const Vector3f&in rotation, const Vector2f&in scale=Vector2f(1.0, 1.0), const Color&in color=Color(1.0, 1.0, 1.0))", asFUNCTION(createBillboardArbitraryRotation), asCALL_CDECL);
    engine.RegisterGlobalFunction("void destroy(Billboard@ b)", asFUNCTION(destructGen<Billboard>), asCALL_CDECL);

    engine.RegisterGlobalFunction("void renderAll()", asMETHOD(BillboardManager, render), asCALL_THISCALL_ASGLOBAL, helpers.bm);
}

static NativeDefinitionRegistrar _{ &registerBillboardDefinitions,
    NativeDefinitionDependencyFlags::COLOR | NativeDefinitionDependencyFlags::MATH };
