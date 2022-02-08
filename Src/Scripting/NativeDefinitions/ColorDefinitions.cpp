#include "../NativeDefinitionRegistrar.h"

#include <PGE/Color/Color.h>

#include "../ScriptManager.h"

static void colorConstructor(void* memory) {
    ::new(memory) PGE::Color();
}

static void colorConstructorParametrized(float r, float g, float b, float a, void* memory) {
    ::new(memory) PGE::Color(r, g, b, a);
}

static void colorConstructorParametrizedInt(PGE::byte r, PGE::byte g, PGE::byte b, PGE::byte a, void* memory) {
    ::new(memory) PGE::Color(r, g, b, a);
}

static void colorDestructor(void* memory) {
    ((PGE::Color*)memory)->~Color();
}

static void registerColorDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers&) {
    engine.RegisterObjectType("Color", sizeof(PGE::Color), asOBJ_VALUE | asOBJ_APP_CLASS_ALLFLOATS | asGetTypeTraits<PGE::Color>());
    engine.RegisterObjectBehaviour("Color", asBEHAVE_CONSTRUCT, "void f()", asFUNCTION(colorConstructor), asCALL_CDECL_OBJLAST);
    engine.RegisterObjectBehaviour("Color", asBEHAVE_CONSTRUCT, "void f(float r, float g, float b, float a=1.0)", asFUNCTION(colorConstructorParametrized), asCALL_CDECL_OBJLAST);
    engine.RegisterObjectBehaviour("Color", asBEHAVE_CONSTRUCT, "void f(uint8 r, uint8 g, uint8 b, uint8 a=1.0)", asFUNCTION(colorConstructorParametrizedInt), asCALL_CDECL_OBJLAST);
    engine.RegisterObjectBehaviour("Color", asBEHAVE_DESTRUCT, "void f()", asFUNCTION(colorDestructor), asCALL_CDECL_OBJLAST);

    engine.RegisterObjectMethod("Color", "bool opEquals(const Color&in other) const", asMETHODPR(PGE::Color, operator==, (const PGE::Color&) const, bool), asCALL_THISCALL);

    engine.RegisterObjectProperty("Color", "float red", asOFFSET(PGE::Color, red));
    engine.RegisterObjectProperty("Color", "float green", asOFFSET(PGE::Color, green));
    engine.RegisterObjectProperty("Color", "float blue", asOFFSET(PGE::Color, blue));
    engine.RegisterObjectProperty("Color", "float alpha", asOFFSET(PGE::Color, alpha));

    engine.RegisterObjectMethod("Color", "uint8 get_redByte() property", asMETHOD(PGE::Color, getRed), asCALL_THISCALL);
    engine.RegisterObjectMethod("Color", "uint8 get_greenByte() property", asMETHOD(PGE::Color, getGreen), asCALL_THISCALL);
    engine.RegisterObjectMethod("Color", "uint8 get_blueByte() property", asMETHOD(PGE::Color, getBlue), asCALL_THISCALL);
    engine.RegisterObjectMethod("Color", "uint8 get_alphaByte() property", asMETHOD(PGE::Color, getAlpha), asCALL_THISCALL);
    engine.RegisterObjectMethod("Color", "void set_redInt(uint8 r) property", asMETHOD(PGE::Color, setRed), asCALL_THISCALL);
    engine.RegisterObjectMethod("Color", "void set_greenInt(uint8 g) property", asMETHOD(PGE::Color, setGreen), asCALL_THISCALL);
    engine.RegisterObjectMethod("Color", "void set_blueInt(uint8 b) property", asMETHOD(PGE::Color, setBlue), asCALL_THISCALL);
    engine.RegisterObjectMethod("Color", "void set_alphaInt(uint8 a) property", asMETHOD(PGE::Color, setAlpha), asCALL_THISCALL);

    engine.RegisterObjectMethod("Color", "Color& opAssign(const Color &in other)", asMETHODPR(PGE::Color, operator=, (const PGE::Color&), PGE::Color&), asCALL_THISCALL);

    engine.SetDefaultNamespace("Color");
    engine.RegisterGlobalProperty("const Color Red", (void*)&PGE::Colors::RED);
    engine.RegisterGlobalProperty("const Color Green", (void*)&PGE::Colors::GREEN);
    engine.RegisterGlobalProperty("const Color Blue", (void*)&PGE::Colors::BLUE);
    engine.RegisterGlobalProperty("const Color Orange", (void*)&PGE::Colors::ORANGE);
    engine.RegisterGlobalProperty("const Color Yellow", (void*)&PGE::Colors::YELLOW);
    engine.RegisterGlobalProperty("const Color Cyan", (void*)&PGE::Colors::CYAN);
    engine.RegisterGlobalProperty("const Color Magenta", (void*)&PGE::Colors::MAGENTA);
    engine.RegisterGlobalProperty("const Color White", (void*)&PGE::Colors::WHITE);
    engine.RegisterGlobalProperty("const Color Gray", (void*)&PGE::Colors::GRAY);
    engine.RegisterGlobalProperty("const Color Black", (void*)&PGE::Colors::BLACK);
}

static NativeDefinitionRegistrar _ {
    &registerColorDefinitions,
    NativeDefinitionDependencyFlags::NONE,
    NativeDefinitionDependencyFlags::COLOR
};
