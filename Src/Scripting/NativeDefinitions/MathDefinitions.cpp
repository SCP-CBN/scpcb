#include "MathDefinitions.h"

#include "../NativeUtils.h"

#include <PGE/Math/Math.h>
#include <PGE/Math/Vector.h>
#include <PGE/Math/Matrix.h>
#include <PGE/Math/Line.h>
#include <PGE/Math/Plane.h>
#include <PGE/Math/AABBox.h>
#include <PGE/Math/Rectangle.h>

#include "../ScriptManager.h"

using namespace PGE;

static void vector3fConstructor(void* memory) {
    ::new(memory) PGE::Vector3f();
}

static void vector3fConstructorSingle(float s, void* memory) {
    ::new(memory) PGE::Vector3f(s);
}

static void vector3fConstructorParametrized(float x, float y, float z, void* memory) {
    ::new(memory) PGE::Vector3f(x, y, z);
}

static void vector3fDestructor(void* memory) {
    ((PGE::Vector3f*)memory)->~Vector3f();
}

static PGE::String vector3fToString(const PGE::Vector3f& vec) {
    return "Vector3f(" + PGE::String::from(vec.x) + ", " + PGE::String::from(vec.y) + ", " + PGE::String::from(vec.z) + ")";
}

static void matrixConstructor(void* memory) {
    ::new(memory) PGE::Matrix4x4f();
}

static void matrixConstructorParametrized(float aa, float ab, float ac, float ad,
                                   float ba, float bb, float bc, float bd,
                                   float ca, float cb, float cc, float cd,
                                   float da, float db, float dc, float dd, void* memory) {
    ::new(memory) PGE::Matrix4x4f(aa, ab, ac, ad,
                                ba, bb, bc, bd,
                                ca, cb, cc, cd,
                                da, db, dc, dd);
}

static void matrixDestructor(void* memory) {
    ((PGE::Matrix4x4f*)memory)->~Matrix4x4f();
}

static void rectangleConstructor(void* memory) {
    ::new(memory) PGE::Rectanglef();
}

static void rectangleConstructorVectors(const PGE::Vector2f& itl, const PGE::Vector2f& ibr, void* memory) {
    ::new(memory) PGE::Rectanglef(itl, ibr);
}

static void rectangleConstructorParameterized(float il, float it, float ir, float ib, void* memory) {
    ::new(memory) PGE::Rectanglef(il, it, ir, ib);
}

static void rectangleDestructor(void* memory) {
    ((PGE::Rectanglef*)memory)->~Rectanglef();
}

static int maxInt(int a, int b) {
    return std::max(a, b);
}

static int minInt(int a, int b) {
    return std::min(a, b);
}

static float maxFloat(float a, float b) {
    return std::max(a, b);
}

static float minFloat(float a, float b) {
    return std::min(a, b);
}

MathDefinitions::MathDefinitions(ScriptManager* mgr) {
    engine = mgr->getAngelScriptEngine();

    // Vector2f
    engine->PGE_REGISTER_TYPE(Vector2f, asOBJ_APP_CLASS_ALLFLOATS);
    engine->PGE_REGISTER_CONSTRUCTOR(Vector2f);
    engine->PGE_REGISTER_CONSTRUCTOR(Vector2f, (float));
    engine->PGE_REGISTER_CONSTRUCTOR(Vector2f, (float, float));
    engine->PGE_REGISTER_DESTRUCTOR(Vector2f);
    engine->PGE_REGISTER_PROPERTY(Vector2f, x);
    engine->PGE_REGISTER_PROPERTY(Vector2f, y);

    engine->PGE_REGISTER_METHOD(Vector2f, operator==);

    engine->PGE_REGISTER_METHOD_EX(Vector2f, Vector2f&, operator=, (const Vector2f&));
    engine->PGE_REGISTER_METHOD_EX(Vector2f, void, operator+=, (const Vector2f&));
    engine->PGE_REGISTER_METHOD_EX(Vector2f, void, operator-=, (const Vector2f&));
    engine->PGE_REGISTER_METHOD_EX(Vector2f, void, operator+=, (float));
    engine->PGE_REGISTER_METHOD_EX(Vector2f, void, operator-=, (float));
    engine->PGE_REGISTER_METHOD(Vector2f, operator*=);
    engine->PGE_REGISTER_METHOD(Vector2f, operator/=);
    engine->PGE_REGISTER_METHOD_EX(Vector2f, const Vector2f, operator-, ());

    engine->PGE_REGISTER_METHOD_EX(Vector2f, const Vector2f, operator+, (const Vector2f&));
    engine->PGE_REGISTER_METHOD_EX(Vector2f, const Vector2f, operator-, (const Vector2f&));
    engine->PGE_REGISTER_METHOD_EX(Vector2f, const Vector2f, operator+, (float));
    engine->PGE_REGISTER_METHOD_EX(Vector2f, const Vector2f, operator-, (float));
    engine->PGE_REGISTER_METHOD(Vector2f, operator*);
    engine->PGE_REGISTER_METHOD_R(Vector2f, operator*);
    engine->PGE_REGISTER_METHOD(Vector2f, operator/);
    
    engine->PGE_REGISTER_METHOD(Vector2f, lengthSquared);
    engine->PGE_REGISTER_METHOD(Vector2f, length);
    engine->PGE_REGISTER_METHOD(Vector2f, distanceSquared);
    engine->PGE_REGISTER_METHOD(Vector2f, distance);

    engine->PGE_REGISTER_METHOD(Vector2f, normalize);

    engine->PGE_REGISTER_METHOD(Vector2f, reflect);
    engine->PGE_REGISTER_METHOD(Vector2f, dotProduct);

    //engine->PGE_REGISTER_TO_STRING(Vector2f);

    engine->SetDefaultNamespace("Vector2f");
    engine->PGE_REGISTER_GLOBAL_PROPERTY_N("ONE", Vector2fs::ONE);
    engine->PGE_REGISTER_GLOBAL_PROPERTY_N("ZERO", Vector2fs::ZERO);
    engine->SetDefaultNamespace("");

    // Vector3f
    engine->PGE_REGISTER_TYPE(Vector3f, asOBJ_APP_CLASS_ALLFLOATS);
    engine->PGE_REGISTER_CONSTRUCTOR(Vector3f);
    engine->PGE_REGISTER_CONSTRUCTOR(Vector3f, (float));
    engine->PGE_REGISTER_CONSTRUCTOR(Vector3f, (float, float, float));
    engine->PGE_REGISTER_DESTRUCTOR(Vector3f);
    engine->PGE_REGISTER_PROPERTY(Vector3f, x);
    engine->PGE_REGISTER_PROPERTY(Vector3f, y);
    engine->PGE_REGISTER_PROPERTY(Vector3f, z);

    engine->PGE_REGISTER_METHOD(Vector3f, operator==);

    engine->RegisterObjectMethod("Vector3f", "void opAssign(const Vector3f &in other)", asMETHODPR(PGE::Vector3f, operator=, (const PGE::Vector3f&), PGE::Vector3f&), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opAddAssign(const Vector3f&in other)", asMETHODPR(PGE::Vector3f, operator+=, (const PGE::Vector3f&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opAddAssign(float f)", asMETHODPR(PGE::Vector3f, operator+=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opSubAssign(const Vector3f&in other)", asMETHODPR(PGE::Vector3f, operator-=, (const PGE::Vector3f&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opSubAssign(float f)", asMETHODPR(PGE::Vector3f, operator-=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opMulAssign(float f)", asMETHODPR(PGE::Vector3f, operator*=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opDivAssign(float f)", asMETHODPR(PGE::Vector3f, operator/=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opNeg()", asMETHODPR(PGE::Vector3f, operator-, () const, const PGE::Vector3f), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "Vector3f opAdd(const Vector3f&in other) const", asMETHODPR(PGE::Vector3f, operator+, (const PGE::Vector3f&) const, const PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opAdd(float f) const", asMETHODPR(PGE::Vector3f, operator+, (float) const, const PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opSub(const Vector3f&in other) const", asMETHODPR(PGE::Vector3f, operator-, (const PGE::Vector3f&) const, const PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opSub(float f) const", asMETHODPR(PGE::Vector3f, operator-, (float) const, const PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opMul(float f) const", asMETHODPR(PGE::Vector3f, operator*, (float) const, const PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opMul_r(float f) const", asMETHODPR(PGE::Vector3f, operator*, (float) const, const PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opDiv(float f) const", asMETHODPR(PGE::Vector3f, operator/, (float) const, const PGE::Vector3f), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "float lengthSquared() const", asMETHOD(PGE::Vector3f, lengthSquared), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "float length() const", asMETHOD(PGE::Vector3f, length), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "float distanceSquared(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, distanceSquared), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "float distance(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, distance), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "Vector3f normalize() const", asMETHOD(PGE::Vector3f, normalize), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "Vector3f reflect(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, reflect), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "float dotProduct(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, dotProduct), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f crossProduct(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, crossProduct), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "string toString() const", asFUNCTION(vector3fToString), asCALL_CDECL_OBJLAST);

    engine->SetDefaultNamespace("Vector3f");
    engine->RegisterGlobalProperty("const Vector3f one", (void*) &PGE::Vector3fs::ONE);
    engine->RegisterGlobalProperty("const Vector3f zero", (void*)&PGE::Vector3fs::ZERO);
    engine->SetDefaultNamespace("");

    // Matrix4x4f
    engine->RegisterObjectType("Matrix4x4f", sizeof(PGE::Matrix4x4f), asOBJ_VALUE | asOBJ_APP_CLASS_ALLFLOATS | asGetTypeTraits<PGE::Matrix4x4f>());
    engine->RegisterObjectBehaviour("Matrix4x4f", asBEHAVE_CONSTRUCT, "void f()", asFUNCTION(matrixConstructor), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Matrix4x4f", asBEHAVE_CONSTRUCT, "void f(float aa, float ab, float ac, float ad,"
                                                                             "float ba, float bb, float bc, float bd,"
                                                                             "float ca, float cb, float cc, float cd,"
                                                                             "float da, float db, float dc, float dd)",
        asFUNCTION(matrixConstructorParametrized), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Matrix4x4f", asBEHAVE_DESTRUCT, "void f()", asFUNCTION(matrixDestructor), asCALL_CDECL_OBJLAST);

    engine->RegisterObjectMethod("Matrix4x4f", "bool opEquals(const Matrix4x4f&in other) const", asMETHODPR(PGE::Matrix4x4f, operator==, (const PGE::Matrix4x4f&) const, bool), asCALL_THISCALL);

    engine->RegisterObjectMethod("Matrix4x4f", "void opAssign(const Matrix4x4f&in other)", asMETHODPR(PGE::Matrix4x4f, operator=, (const PGE::Matrix4x4f&), PGE::Matrix4x4f&), asCALL_THISCALL);
    engine->RegisterObjectMethod("Matrix4x4f", "void opMulAssign(const Matrix4x4f&in other)", asMETHODPR(PGE::Matrix4x4f, operator*=, (const PGE::Matrix4x4f&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Matrix4x4f", "Matrix4x4f opMul(float f) const", asMETHODPR(PGE::Matrix4x4f, operator*, (const PGE::Matrix4x4f&) const, const PGE::Matrix4x4f), asCALL_THISCALL);

    engine->RegisterObjectMethod("Matrix4x4f", "Matrix4x4f transpose() const", asMETHOD(PGE::Matrix4x4f, transpose), asCALL_THISCALL);
    engine->RegisterObjectMethod("Matrix4x4f", "Matrix4x4f product(const Matrix4x4f&in other) const", asMETHODPR(PGE::Matrix4x4f, operator*, (const PGE::Matrix4x4f& other) const, const PGE::Matrix4x4f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Matrix4x4f", "Vector3f transform(const Vector3f&in vec) const", asMETHODPR(PGE::Matrix4x4f, transform, (const PGE::Vector3f&) const, const PGE::Vector3f), asCALL_THISCALL);

    //engine->RegisterObjectMethod("Matrix4x4f", "string toString() const", asMETHOD(PGE::Matrix4x4f, toString), asCALL_THISCALL);

    engine->SetDefaultNamespace("Matrix4x4f");
    engine->RegisterGlobalFunction("Matrix4x4f translate(const Vector3f&in position)", asFUNCTION(PGE::Matrix4x4f::translate), asCALL_CDECL);
    engine->RegisterGlobalFunction("Matrix4x4f scale(const Vector3f&in scale)", asFUNCTION(PGE::Matrix4x4f::scale), asCALL_CDECL);
    engine->RegisterGlobalFunction("Matrix4x4f rotate(const Vector3f&in rotation)", asFUNCTION(PGE::Matrix4x4f::rotate), asCALL_CDECL);
    
    engine->RegisterGlobalFunction("Matrix4x4f constructWorldMat(const Vector3f&in position, const Vector3f&in rotation, const Vector3f&in scale)", asFUNCTION(PGE::Matrix4x4f::constructWorldMat), asCALL_CDECL);
    engine->RegisterGlobalFunction("Matrix4x4f constructViewMat(const Vector3f&in position, const Vector3f&in target, const Vector3f&in upVector)", asFUNCTION(PGE::Matrix4x4f::constructViewMat), asCALL_CDECL);
    engine->RegisterGlobalFunction("Matrix4x4f constructPerspectiveMat(float horizontalfov, float aspectRatio, float nearZ, float farZ)", asFUNCTION(PGE::Matrix4x4f::constructPerspectiveMat), asCALL_CDECL);
    engine->RegisterGlobalFunction("Matrix4x4f constructOrthographicMat(float width, float height, float nearZ, float farZ)", asFUNCTION(PGE::Matrix4x4f::constructOrthographicMat), asCALL_CDECL);
    engine->SetDefaultNamespace("");

    // Rectanglef
    engine->RegisterObjectType("Rectanglef", sizeof(PGE::Rectanglef), asOBJ_VALUE | asOBJ_APP_CLASS_ALLFLOATS | asGetTypeTraits<PGE::Rectanglef>());
    engine->RegisterObjectBehaviour("Rectanglef", asBEHAVE_CONSTRUCT, "void f()", asFUNCTION(rectangleConstructor), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Rectanglef", asBEHAVE_CONSTRUCT, "void f(const Vector2f&in tl, const Vector2f&in br)", asFUNCTION(rectangleConstructorVectors), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Rectanglef", asBEHAVE_CONSTRUCT, "void f(float il, float it, float ir, float ib)", asFUNCTION(rectangleConstructorParameterized), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Rectanglef", asBEHAVE_DESTRUCT, "void f()", asFUNCTION(rectangleDestructor), asCALL_CDECL_OBJLAST);

    engine->RegisterObjectMethod("Rectanglef", "bool opEquals(const Rectanglef&in other) const", asMETHODPR(PGE::Rectanglef, operator==, (const PGE::Rectanglef&) const, bool), asCALL_THISCALL);

    engine->RegisterObjectMethod("Rectanglef", "void opAssign(const Rectanglef &in other)", asMETHODPR(PGE::Rectanglef, operator=, (const PGE::Rectanglef&), PGE::Rectanglef&), asCALL_THISCALL);

    engine->RegisterObjectMethod("Rectanglef", "void addPoint(float x, float y)", asMETHODPR(PGE::Rectanglef, addPoint, (float, float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Rectanglef", "void addPoint(const Vector2f&in point)", asMETHODPR(PGE::Rectanglef, addPoint, (const PGE::Vector2f&), void), asCALL_THISCALL);
    
    engine->RegisterObjectMethod("Rectanglef", "float width() const", asMETHOD(PGE::Rectanglef, width), asCALL_THISCALL);
    engine->RegisterObjectMethod("Rectanglef", "float height() const", asMETHOD(PGE::Rectanglef, height), asCALL_THISCALL);
    engine->RegisterObjectMethod("Rectanglef", "float area() const", asMETHOD(PGE::Rectanglef, area), asCALL_THISCALL);

    engine->RegisterObjectMethod("Rectanglef", "Vector2f center() const", asMETHOD(PGE::Rectanglef, center), asCALL_THISCALL);
    engine->RegisterObjectMethod("Rectanglef", "Vector2f topLeftCorner() const", asMETHOD(PGE::Rectanglef, topLeftCorner), asCALL_THISCALL);
    engine->RegisterObjectMethod("Rectanglef", "Vector2f topRightCorner() const", asMETHOD(PGE::Rectanglef, topRightCorner), asCALL_THISCALL);
    engine->RegisterObjectMethod("Rectanglef", "Vector2f bottomLeftCorner() const", asMETHOD(PGE::Rectanglef, bottomLeftCorner), asCALL_THISCALL);
    engine->RegisterObjectMethod("Rectanglef", "Vector2f bottomRightCorner() const", asMETHOD(PGE::Rectanglef, bottomRightCorner), asCALL_THISCALL);

    engine->RegisterObjectMethod("Rectanglef", "bool isPointInside(const Vector2f&in p) const", asMETHOD(PGE::Rectanglef, isPointInside), asCALL_THISCALL);
    engine->RegisterObjectMethod("Rectanglef", "bool intersects(const Rectanglef&in other) const", asMETHOD(PGE::Rectanglef, intersects), asCALL_THISCALL);

    // Generic
    engine->SetDefaultNamespace("Math");
    engine->PGE_REGISTER_GLOBAL_FUNCTION(Math::degToRad);
    engine->PGE_REGISTER_GLOBAL_FUNCTION(Math::radToDeg);
    engine->PGE_REGISTER_GLOBAL_FUNCTION(Math::equalFloats);
    engine->RegisterGlobalFunction("int maxInt(int val, int other)", asFUNCTION(maxInt), asCALL_CDECL);
    engine->RegisterGlobalFunction("int minInt(int val, int other)", asFUNCTION(minInt), asCALL_CDECL);
    engine->RegisterGlobalFunction("float maxFloat(float val, float other)", asFUNCTION(maxFloat), asCALL_CDECL);
    engine->RegisterGlobalFunction("float minFloat(float val, float other)", asFUNCTION(minFloat), asCALL_CDECL);
    engine->RegisterGlobalFunction("int clampInt(int val, int min, int max)", asFUNCTION(std::clamp<int>), asCALL_CDECL);
    engine->RegisterGlobalFunction("float clampFloat(float val, float min, float max)", asFUNCTION(std::clamp<float>), asCALL_CDECL);
    engine->RegisterGlobalFunction("float absFloat(float val)", asFUNCTIONPR(std::abs, (float), float), asCALL_CDECL);
    engine->RegisterGlobalFunction("int floor(float val)", asFUNCTION(PGE::Math::floor), asCALL_CDECL);
    engine->RegisterGlobalFunction("int ceil(float val)", asFUNCTION(PGE::Math::ceil), asCALL_CDECL);
    engine->RegisterGlobalFunction("float sqrt(float val)", asFUNCTION(std::sqrtf), asCALL_CDECL);
    engine->RegisterGlobalFunction("float sin(float radians)", asFUNCTION(std::sinf), asCALL_CDECL);
    engine->RegisterGlobalFunction("float cos(float radians)", asFUNCTION(std::cosf), asCALL_CDECL);
    engine->PGE_REGISTER_GLOBAL_PROPERTY(Math::PI);
}
