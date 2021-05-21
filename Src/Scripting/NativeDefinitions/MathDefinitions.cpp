#include "MathDefinitions.h"

#include <Math/Math.h>
#include <Math/Vector.h>
#include <Math/Matrix.h>
#include <Math/Line.h>
#include <Math/Plane.h>
#include <Math/AABBox.h>
#include <Math/Rectangle.h>

#include "../ScriptManager.h"

static void vector2fConstructor(void* memory) {
    new(memory) PGE::Vector2f();
}

static void vector2fConstructorSingle(float s, void* memory) {
    new(memory) PGE::Vector2f(s);
}

static void vector2fConstructorParametrized(float x, float y, void* memory) {
    new(memory) PGE::Vector2f(x, y);
}

static void vector2fDestructor(void* memory) {
    ((PGE::Vector2f*)memory)->~Vector2f();
}

static void vector3fConstructor(void* memory) {
    new(memory) PGE::Vector3f();
}

static void vector3fConstructorSingle(float s, void* memory) {
    new(memory) PGE::Vector3f(s);
}

static void vector3fConstructorParametrized(float x, float y, float z, void* memory) {
    new(memory) PGE::Vector3f(x, y, z);
}

static void vector3fDestructor(void* memory) {
    ((PGE::Vector3f*)memory)->~Vector3f();
}

static void matrixConstructor(void* memory) {
    new(memory) PGE::Matrix4x4f();
}

static void matrixConstructorParametrized(float aa, float ab, float ac, float ad,
                                   float ba, float bb, float bc, float bd,
                                   float ca, float cb, float cc, float cd,
                                   float da, float db, float dc, float dd, void* memory) {
    new(memory) PGE::Matrix4x4f(aa, ab, ac, ad,
                                ba, bb, bc, bd,
                                ca, cb, cc, cd,
                                da, db, dc, dd);
}

static void matrixDestructor(void* memory) {
    ((PGE::Matrix4x4f*)memory)->~Matrix4x4f();
}

static void rectangleConstructor(void* memory) {
    new(memory) PGE::Rectanglef();
}

static void rectangleConstructorVectors(const PGE::Vector2f& itl, const PGE::Vector2f& ibr, void* memory) {
    new(memory) PGE::Rectanglef(itl, ibr);
}

static void rectangleConstructorParameterized(float il, float it, float ir, float ib, void* memory) {
    new(memory) PGE::Rectanglef(il, it, ir, ib);
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
    engine->RegisterObjectType("Vector2f", sizeof(PGE::Vector2f), asOBJ_VALUE | asOBJ_APP_CLASS_ALLFLOATS | asGetTypeTraits<PGE::Vector2f>());
    engine->RegisterObjectBehaviour("Vector2f", asBEHAVE_CONSTRUCT, "void f()", asFUNCTION(vector2fConstructor), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Vector2f", asBEHAVE_CONSTRUCT, "void f(float s)", asFUNCTION(vector2fConstructorSingle), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Vector2f", asBEHAVE_CONSTRUCT, "void f(float x, float y)", asFUNCTION(vector2fConstructorParametrized), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Vector2f", asBEHAVE_DESTRUCT, "void f()", asFUNCTION(vector2fDestructor), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectProperty("Vector2f", "float x", asOFFSET(PGE::Vector2f, x));
    engine->RegisterObjectProperty("Vector2f", "float y", asOFFSET(PGE::Vector2f, y));

    engine->RegisterObjectMethod("Vector2f", "bool opEquals(const Vector2f&in other) const", asMETHODPR(PGE::Vector2f, operator==, (const PGE::Vector2f&) const, bool), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector2f", "void opAssign(const Vector2f&in other)", asMETHODPR(PGE::Vector2f, operator=, (const PGE::Vector2f&), PGE::Vector2f&), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "void opAddAssign(const Vector2f&in other)", asMETHODPR(PGE::Vector2f, operator+=, (const PGE::Vector2f&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "void opAddAssign(float f)", asMETHODPR(PGE::Vector2f, operator+=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "void opSubAssign(const Vector2f&in other)", asMETHODPR(PGE::Vector2f, operator-=, (const PGE::Vector2f&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "void opSubAssign(float f)", asMETHODPR(PGE::Vector2f, operator-=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "void opMulAssign(float f)", asMETHODPR(PGE::Vector2f, operator*=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "void opDivAssign(float f)", asMETHODPR(PGE::Vector2f, operator/=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "Vector2f opNeg() const", asMETHODPR(PGE::Vector2f, operator-, () const, PGE::Vector2f), asCALL_THISCALL);
    
    engine->RegisterObjectMethod("Vector2f", "Vector2f opAdd(const Vector2f&in other) const", asMETHODPR(PGE::Vector2f, operator+, (const PGE::Vector2f&) const, PGE::Vector2f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "Vector2f opAdd(float f) const", asMETHODPR(PGE::Vector2f, operator+, (float) const, PGE::Vector2f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "Vector2f opSub(const Vector2f&in other) const", asMETHODPR(PGE::Vector2f, operator-, (const PGE::Vector2f&) const, PGE::Vector2f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "Vector2f opSub(float f) const", asMETHODPR(PGE::Vector2f, operator-, (float) const, PGE::Vector2f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "Vector2f opMul(float f) const", asMETHODPR(PGE::Vector2f, operator*, (float) const, PGE::Vector2f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "Vector2f opMul_r(float f) const", asMETHODPR(PGE::Vector2f, operator*, (float) const, PGE::Vector2f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "Vector2f opDiv(float f) const", asMETHODPR(PGE::Vector2f, operator/, (float) const, PGE::Vector2f), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector2f", "float lengthSquared() const", asMETHOD(PGE::Vector2f, lengthSquared), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "float length() const", asMETHOD(PGE::Vector2f, length), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "float distanceSquared(const Vector2f&in other) const", asMETHOD(PGE::Vector2f, distanceSquared), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "float distance(const Vector2f&in other) const", asMETHOD(PGE::Vector2f, distance), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector2f", "Vector2f normalize() const", asMETHOD(PGE::Vector2f, normalize), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector2f", "Vector2f reflect(const Vector2f&in other) const", asMETHOD(PGE::Vector2f, reflect), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector2f", "float dotProduct(const Vector2f&in other) const", asMETHOD(PGE::Vector2f, dotProduct), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector2f", "string toString() const", asMETHOD(PGE::Vector2f, toString), asCALL_THISCALL);

    engine->SetDefaultNamespace("Vector2f");
    engine->RegisterGlobalFunction("Vector2f lerp(const Vector2f&in oldValue, const Vector2f&in newValue, float interpolation)", asFUNCTION(PGE::Vector2f::lerp), asCALL_CDECL);
    engine->RegisterGlobalProperty("const Vector2f one", (void*)&PGE::Vector2f::ONE);
    engine->RegisterGlobalProperty("const Vector2f zero", (void*)&PGE::Vector2f::ZERO);
    engine->SetDefaultNamespace("");

    // Vector3f
    engine->RegisterObjectType("Vector3f", sizeof(PGE::Vector3f), asOBJ_VALUE | asOBJ_APP_CLASS_ALLFLOATS | asGetTypeTraits<PGE::Vector3f>());
    engine->RegisterObjectBehaviour("Vector3f", asBEHAVE_CONSTRUCT, "void f()", asFUNCTION(vector3fConstructor), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Vector3f", asBEHAVE_CONSTRUCT, "void f(float s)", asFUNCTION(vector3fConstructorSingle), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Vector3f", asBEHAVE_CONSTRUCT, "void f(float x, float y, float z)", asFUNCTION(vector3fConstructorParametrized), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("Vector3f", asBEHAVE_DESTRUCT, "void f()", asFUNCTION(vector3fDestructor), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectProperty("Vector3f", "float x", asOFFSET(PGE::Vector3f, x));
    engine->RegisterObjectProperty("Vector3f", "float y", asOFFSET(PGE::Vector3f, y));
    engine->RegisterObjectProperty("Vector3f", "float z", asOFFSET(PGE::Vector3f, z));

    engine->RegisterObjectMethod("Vector3f", "bool opEquals(const Vector3f&in other) const", asMETHODPR(PGE::Vector3f, operator==, (const PGE::Vector3f&) const, bool), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "Vector3f& opAssign(const Vector3f &in other)", asMETHODPR(PGE::Vector3f, operator=, (const PGE::Vector3f&), PGE::Vector3f&), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opAddAssign(const Vector3f&in other)", asMETHODPR(PGE::Vector3f, operator+=, (const PGE::Vector3f&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opAddAssign(float f)", asMETHODPR(PGE::Vector3f, operator+=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opSubAssign(const Vector3f&in other)", asMETHODPR(PGE::Vector3f, operator-=, (const PGE::Vector3f&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opSubAssign(float f)", asMETHODPR(PGE::Vector3f, operator-=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opMulAssign(float f)", asMETHODPR(PGE::Vector3f, operator*=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "void opDivAssign(float f)", asMETHODPR(PGE::Vector3f, operator/=, (float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opNeg()", asMETHODPR(PGE::Vector3f, operator-, () const, PGE::Vector3f), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "Vector3f opAdd(const Vector3f&in other) const", asMETHODPR(PGE::Vector3f, operator+, (const PGE::Vector3f&) const, PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opAdd(float f) const", asMETHODPR(PGE::Vector3f, operator+, (float) const, PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opSub(const Vector3f&in other) const", asMETHODPR(PGE::Vector3f, operator-, (const PGE::Vector3f&) const, PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opSub(float f) const", asMETHODPR(PGE::Vector3f, operator-, (float) const, PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opMul(float f) const", asMETHODPR(PGE::Vector3f, operator*, (float) const, PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opMul_r(float f) const", asMETHODPR(PGE::Vector3f, operator*, (float) const, PGE::Vector3f), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f opDiv(float f) const", asMETHODPR(PGE::Vector3f, operator/, (float) const, PGE::Vector3f), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "float lengthSquared() const", asMETHOD(PGE::Vector3f, lengthSquared), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "float length() const", asMETHOD(PGE::Vector3f, length), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "float distanceSquared(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, distanceSquared), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "float distance(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, distance), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "Vector3f normalize() const", asMETHOD(PGE::Vector3f, normalize), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "Vector3f reflect(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, reflect), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "float dotProduct(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, dotProduct), asCALL_THISCALL);
    engine->RegisterObjectMethod("Vector3f", "Vector3f crossProduct(const Vector3f&in other) const", asMETHOD(PGE::Vector3f, crossProduct), asCALL_THISCALL);

    engine->RegisterObjectMethod("Vector3f", "string toString() const", asMETHOD(PGE::Vector3f, toString), asCALL_THISCALL);

    engine->SetDefaultNamespace("Vector3f");
    engine->RegisterGlobalFunction("Vector3f lerp(const Vector3f&in oldValue, const Vector3f&in newValue, float interpolation)", asFUNCTION(PGE::Vector3f::lerp), asCALL_CDECL);
    engine->RegisterGlobalProperty("const Vector3f one", (void*) &PGE::Vector3f::ONE);
    engine->RegisterGlobalProperty("const Vector3f zero", (void*)&PGE::Vector3f::ZERO);
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

    engine->RegisterObjectMethod("Matrix4x4f", "Matrix4x4f& opAssign(const Matrix4x4f&in other)", asMETHODPR(PGE::Matrix4x4f, operator=, (const PGE::Matrix4x4f&), PGE::Matrix4x4f&), asCALL_THISCALL);
    engine->RegisterObjectMethod("Matrix4x4f", "void opMulAssign(const Matrix4x4f&in other)", asMETHODPR(PGE::Matrix4x4f, operator*=, (const PGE::Matrix4x4f&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Matrix4x4f", "Matrix4x4f opMul(float f) const", asMETHODPR(PGE::Matrix4x4f, operator*, (const PGE::Matrix4x4f&) const, PGE::Matrix4x4f), asCALL_THISCALL);

    engine->RegisterObjectMethod("Matrix4x4f", "Matrix4x4f transpose() const", asMETHOD(PGE::Matrix4x4f, transpose), asCALL_THISCALL);
    //engine->RegisterObjectMethod("Matrix4x4f", "Matrix4x4f product(const Matrix4x4f&in other) const", asMETHOD(PGE::Matrix4x4f, product), asCALL_THISCALL);
    engine->RegisterObjectMethod("Matrix4x4f", "Vector3f transform(const Vector3f&in vec) const", asMETHODPR(PGE::Matrix4x4f, transform, (const PGE::Vector3f&) const, PGE::Vector3f), asCALL_THISCALL);

    engine->RegisterObjectMethod("Matrix4x4f", "string toString() const", asMETHOD(PGE::Matrix4x4f, toString), asCALL_THISCALL);

    engine->SetDefaultNamespace("Matrix4x4f");
    engine->RegisterGlobalFunction("Matrix4x4f translate(const Vector3f&in position)", asFUNCTION(PGE::Matrix4x4f::translate), asCALL_CDECL);
    engine->RegisterGlobalFunction("Matrix4x4f scale(const Vector3f&in scale)", asFUNCTION(PGE::Matrix4x4f::scale), asCALL_CDECL);
    engine->RegisterGlobalFunction("Matrix4x4f rotate(const Vector3f&in rotation)", asFUNCTION(PGE::Matrix4x4f::rotate), asCALL_CDECL);
    
    engine->RegisterGlobalFunction("Matrix4x4f constructWorldMat(const Vector3f&in position, const Vector3f&in scale, const Vector3f&in rotation)", asFUNCTION(PGE::Matrix4x4f::constructWorldMat), asCALL_CDECL);
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

    engine->RegisterObjectMethod("Rectanglef", "Rectanglef& opAssign(const Rectanglef &in other)", asMETHODPR(PGE::Rectanglef, operator=, (const PGE::Rectanglef&), PGE::Rectanglef&), asCALL_THISCALL);

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
    engine->RegisterGlobalFunction("float degToRad(float degrees)", asFUNCTION(PGE::Math::degToRad), asCALL_CDECL);
    engine->RegisterGlobalFunction("float radToDeg(float radians)", asFUNCTION(PGE::Math::radToDeg), asCALL_CDECL);
    engine->RegisterGlobalFunction("bool equalFloats(float val, float other)", asFUNCTION(PGE::Math::equalFloats), asCALL_CDECL);
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
    engine->RegisterGlobalProperty("const float PI", (void*)&PGE::Math::PI);
}
