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

#define REGISTER_VECTOR_COMMON(vector) \
    engine->PGE_REGISTER_TYPE(vector, asOBJ_APP_CLASS_ALLFLOATS); \
    engine->PGE_REGISTER_CONSTRUCTOR(vector); \
    engine->PGE_REGISTER_CONSTRUCTOR(vector, (float)); \
    engine->PGE_REGISTER_DESTRUCTOR(vector); \
 \
    engine->PGE_REGISTER_METHOD(vector, operator==); \
 \
    engine->PGE_REGISTER_METHOD_EX(vector, vector&, operator=, (const vector&)); \
    engine->PGE_REGISTER_METHOD_EX(vector, void, operator+=, (const vector&)); \
    engine->PGE_REGISTER_METHOD_EX(vector, void, operator-=, (const vector&)); \
    engine->PGE_REGISTER_METHOD_EX(vector, void, operator+=, (float)); \
    engine->PGE_REGISTER_METHOD_EX(vector, void, operator-=, (float)); \
    engine->PGE_REGISTER_METHOD(vector, operator*=); \
    engine->PGE_REGISTER_METHOD(vector, operator/=); \
    engine->PGE_REGISTER_METHOD_EX(vector, const vector, operator-, ()); \
 \
    engine->PGE_REGISTER_METHOD(vector, lengthSquared); \
    engine->PGE_REGISTER_METHOD(vector, length); \
    engine->PGE_REGISTER_METHOD(vector, distanceSquared); \
    engine->PGE_REGISTER_METHOD(vector, distance); \
 \
    engine->PGE_REGISTER_METHOD(vector, normalize); \
 \
    engine->PGE_REGISTER_METHOD(vector, reflect); \
    engine->PGE_REGISTER_METHOD(vector, dotProduct); \
 \
    engine->SetDefaultNamespace(#vector); \
    engine->PGE_REGISTER_GLOBAL_PROPERTY(vector ## s::ONE); \
    engine->PGE_REGISTER_GLOBAL_PROPERTY(vector ## s::ZERO); \
    engine->SetDefaultNamespace("")


MathDefinitions::MathDefinitions(ScriptManager* mgr) {
    engine = mgr->getAngelScriptEngine();

    // Vector2f
    REGISTER_VECTOR_COMMON(Vector2f);
    engine->PGE_REGISTER_CONSTRUCTOR(Vector2f, (float, float));
    engine->PGE_REGISTER_PROPERTY(Vector2f, x);
    engine->PGE_REGISTER_PROPERTY(Vector2f, y);

    //engine->PGE_REGISTER_TO_STRING(Vector2f);

    // Vector3f
    REGISTER_VECTOR_COMMON(Vector3f);
    engine->PGE_REGISTER_CONSTRUCTOR(Vector3f, (float, float, float));
    engine->PGE_REGISTER_PROPERTY(Vector3f, x);
    engine->PGE_REGISTER_PROPERTY(Vector3f, y);
    engine->PGE_REGISTER_PROPERTY(Vector3f, z);

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

#define REGISTER_COMMON(type) \
    engine->PGE_REGISTER_GLOBAL_FUNCTION_EX(const type&, std::max<type>, (const type&, const type&)); \
    engine->PGE_REGISTER_GLOBAL_FUNCTION_EX(const type&, std::min<type>, (const type&, const type&)); \
    engine->PGE_REGISTER_GLOBAL_FUNCTION_EX(type, std::abs, (type)); \
    engine->PGE_REGISTER_GLOBAL_FUNCTION(std::clamp<type>);

    REGISTER_COMMON(int);
    REGISTER_COMMON(float);
    
    engine->PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::floor, (float));
    engine->PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::ceil, (float));
    engine->PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::sqrt, (float));
    engine->PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::sin, (float));
    engine->PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::cos, (float));
    engine->PGE_REGISTER_GLOBAL_PROPERTY(Math::PI);
}
