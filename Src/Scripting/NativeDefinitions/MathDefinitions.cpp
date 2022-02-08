#include "../NativeDefinitionRegistrar.h"
#include "../NativeUtils.h"

#include <PGE/Math/Math.h>
#include <PGE/Math/Vector.h>
#include <PGE/Math/Matrix.h>
#include <PGE/Math/Line.h>
#include <PGE/Math/Plane.h>
#include <PGE/Math/AABBox.h>
#include <PGE/Math/Rectangle.h>

using namespace PGE;

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

#define REGISTER_VECTOR_COMMON_GEN(vector, type, trait) \
    engine.PGE_REGISTER_TYPE(vector, trait | asOBJ_POD); \
    engine.PGE_REGISTER_CONSTRUCTOR(vector); \
    engine.PGE_REGISTER_CONSTRUCTOR(vector, (type)); \
 \
    engine.PGE_REGISTER_METHOD(vector, operator==); \
 \
    engine.PGE_REGISTER_METHOD_EX(vector, void, operator+=, (const vector&)); \
    engine.PGE_REGISTER_METHOD_EX(vector, void, operator-=, (const vector&)); \
    engine.PGE_REGISTER_METHOD_EX(vector, void, operator+=, (type)); \
    engine.PGE_REGISTER_METHOD_EX(vector, void, operator-=, (type)); \
    engine.PGE_REGISTER_METHOD(vector, operator*=); \
    engine.PGE_REGISTER_METHOD_EX(vector, vector, operator-, ()); \
 \
    engine.PGE_REGISTER_METHOD_EX(vector, vector, operator+, (const vector&)); \
    engine.PGE_REGISTER_METHOD_EX(vector, vector, operator-, (const vector&)); \
    engine.PGE_REGISTER_METHOD_EX(vector, vector, operator+, (type)); \
    engine.PGE_REGISTER_METHOD_EX(vector, vector, operator-, (type)); \
    engine.PGE_REGISTER_METHOD(vector, operator*); \
 \
    engine.PGE_REGISTER_METHOD(vector, lengthSquared); \
    engine.PGE_REGISTER_METHOD(vector, length); \
    engine.PGE_REGISTER_METHOD(vector, distanceSquared); \
    engine.PGE_REGISTER_METHOD(vector, distance); \
 \
    engine.PGE_REGISTER_METHOD(vector, dotProduct); \
    engine.PGE_REGISTER_METHOD(vector, entrywiseProduct); \
 \
    engine.SetDefaultNamespace(#vector); \
    engine.PGE_REGISTER_GLOBAL_PROPERTY(vector ## s::ONE); \
    engine.PGE_REGISTER_GLOBAL_PROPERTY(vector ## s::ZERO); \
    engine.SetDefaultNamespace(""); \
 \
    engine.PGE_REGISTER_TO_STRING(vector)


#define REGISTER_VECTOR_COMMON(vector) \
    REGISTER_VECTOR_COMMON_GEN(vector, float, asOBJ_APP_CLASS_ALLFLOATS); \
    engine.PGE_REGISTER_METHOD(vector, equals, "Math::EPSILON_DEFAULT"); \
    engine.PGE_REGISTER_METHOD(vector, operator/=); \
    engine.PGE_REGISTER_METHOD(vector, operator/); \
    engine.PGE_REGISTER_METHOD(vector, normalize); \
    engine.PGE_REGISTER_METHOD(vector, reflect)

constexpr float& matrixAccessorMut(Matrix4x4f& mat, int x, int y) {
    PGE_ASSERT(x >= 0 && x < 4, "x out of range [0, 4)! (" + String::from(x) + ")");
    PGE_ASSERT(y >= 0 && y < 4, "y out of range [0, 4)! (" + String::from(y) + ")");
    return mat[x][y];
}

constexpr float matrixAccessor(const Matrix4x4f& mat, int x, int y) {
    return matrixAccessorMut((Matrix4x4f&)mat, x, y);
}

static void registerMathDefinitions(class ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers&) {
    // Generic
    engine.SetDefaultNamespace("Math");
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Math::degToRad);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Math::radToDeg);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Math::equalFloats);

#define REGISTER_COMMON(type) \
    engine.PGE_REGISTER_GLOBAL_FUNCTION_EX(const type&, std::max<type>, (const type&, const type&)); \
    engine.PGE_REGISTER_GLOBAL_FUNCTION_EX(const type&, std::min<type>, (const type&, const type&)); \
    engine.PGE_REGISTER_GLOBAL_FUNCTION_EX(type, std::abs, (type)); \
    engine.PGE_REGISTER_GLOBAL_FUNCTION(std::clamp<type>);

    REGISTER_COMMON(int);
    REGISTER_COMMON(float);

    engine.PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::floor, (float));
    engine.PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::ceil, (float));
    engine.PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::sqrt, (float));
    engine.PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::sin, (float));
    engine.PGE_REGISTER_GLOBAL_FUNCTION_EX(float, std::cos, (float));
    engine.PGE_REGISTER_GLOBAL_PROPERTY(Math::PI);
    engine.PGE_REGISTER_GLOBAL_PROPERTY(Math::E);
    engine.PGE_REGISTER_GLOBAL_PROPERTY(Math::EPSILON_DEFAULT);
    engine.SetDefaultNamespace("");

    REGISTER_VECTOR_COMMON(Vector2f);
    engine.PGE_REGISTER_CONSTRUCTOR(Vector2f, (float, float));
    engine.PGE_REGISTER_PROPERTY(Vector2f, x);
    engine.PGE_REGISTER_PROPERTY(Vector2f, y);

    REGISTER_VECTOR_COMMON(Vector3f);
    engine.PGE_REGISTER_CONSTRUCTOR(Vector3f, (float, float, float));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector3f, (Vector2f, float));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector3f, (float, Vector2f));
    engine.PGE_REGISTER_PROPERTY(Vector3f, x);
    engine.PGE_REGISTER_PROPERTY(Vector3f, y);
    engine.PGE_REGISTER_PROPERTY(Vector3f, z);
    engine.PGE_REGISTER_METHOD(Vector3f, crossProduct);

    REGISTER_VECTOR_COMMON(Vector4f);
    engine.PGE_REGISTER_CONSTRUCTOR(Vector4f, (float, float, float, float));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector4f, (Vector3f, float));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector4f, (float, Vector3f));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector4f, (Vector2f, Vector2f));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector4f, (Vector2f, float, float));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector4f, (float, float, Vector2f));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector4f, (float, Vector2f, float));
    engine.PGE_REGISTER_PROPERTY(Vector4f, x);
    engine.PGE_REGISTER_PROPERTY(Vector4f, y);
    engine.PGE_REGISTER_PROPERTY(Vector4f, z);
    engine.PGE_REGISTER_PROPERTY(Vector4f, w);

    REGISTER_VECTOR_COMMON_GEN(Vector2i, i32, asOBJ_APP_CLASS_ALLINTS);
    engine.PGE_REGISTER_CONSTRUCTOR(Vector2i, (i32, i32));
    engine.PGE_REGISTER_CONSTRUCTOR(Vector2i, (Vector2f));
    engine.PGE_REGISTER_PROPERTY(Vector2i, x);
    engine.PGE_REGISTER_PROPERTY(Vector2i, y);
    engine.PGE_REGISTER_CAST_AS_CTOR(Vector2i, Vector2f);

    // Matrix4x4f
    engine.PGE_REGISTER_TYPE(Matrix4x4f, asOBJ_APP_CLASS_ALLFLOATS | asOBJ_POD);
    engine.PGE_REGISTER_CONSTRUCTOR(Matrix4x4f);
    engine.PGE_REGISTER_CONSTRUCTOR(Matrix4x4f, (float, float, float, float,
                                                 float, float, float, float,
                                                 float, float, float, float,
                                                 float, float, float, float));
    engine.PGE_REGISTER_CONSTRUCTOR(Matrix4x4f, (Vector4f, Vector4f, Vector4f, Vector4f));

    engine.SetDefaultNamespace("Matrix4x4f");
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::translate);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::rotatePitch);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::rotateYaw);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::rotateRoll);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::rotate);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::scale);

    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::lookAt);

    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::constructWorldMat);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::constructViewMat);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::constructPerspectiveMat);
    engine.PGE_REGISTER_GLOBAL_FUNCTION(Matrix4x4f::constructOrthographicMat);
    engine.SetDefaultNamespace("");

    engine.PGE_REGISTER_FUNCTION_AS_METHOD(Matrix4x4f, "opIndex", matrixAccessor);
    engine.PGE_REGISTER_FUNCTION_AS_METHOD(Matrix4x4f, "opIndex", matrixAccessorMut);

    engine.PGE_REGISTER_METHOD(Matrix4x4f, operator==);
    engine.PGE_REGISTER_METHOD(Matrix4x4f, equals, "Math::EPSILON_DEFAULT");

    engine.PGE_REGISTER_METHOD(Matrix4x4f, operator+=);
    engine.PGE_REGISTER_METHOD(Matrix4x4f, operator+);

    engine.PGE_REGISTER_METHOD_EX(Matrix4x4f, void, operator*=, (float));
    engine.PGE_REGISTER_METHOD_EX(Matrix4x4f, void, operator*=, (const Matrix4x4f&));
    engine.PGE_REGISTER_METHOD_EX(Matrix4x4f, Matrix4x4f, operator*, (float));
    engine.PGE_REGISTER_METHOD_EX(Matrix4x4f, Matrix4x4f, operator*, (const Matrix4x4f&));

    engine.PGE_REGISTER_METHOD_EX(Matrix4x4f, Vector4f, operator*, (const Vector4f&));

    engine.PGE_REGISTER_METHOD_EX(Matrix4x4f, Vector3f, transform, (const Vector3f&));
    engine.PGE_REGISTER_METHOD_EX(Matrix4x4f, Vector4f, transform, (const Vector4f&));

    engine.PGE_REGISTER_METHOD(Matrix4x4f, transpose);

    engine.PGE_REGISTER_METHOD(Matrix4x4f, extractViewTarget);
    engine.PGE_REGISTER_METHOD(Matrix4x4f, extractViewUp);
    engine.PGE_REGISTER_METHOD(Matrix4x4f, extractViewPosition);

    engine.SetDefaultNamespace("Matrix4x4f");
    engine.PGE_REGISTER_GLOBAL_PROPERTY(Matrices::ZERO);
    engine.PGE_REGISTER_GLOBAL_PROPERTY(Matrices::IDENTITY);
    engine.SetDefaultNamespace("");

    engine.PGE_REGISTER_TO_STRING(Matrix4x4f);

    // Rectanglef
    engine.RegisterObjectType("Rectanglef", sizeof(PGE::Rectanglef), asOBJ_VALUE | asOBJ_APP_CLASS_ALLFLOATS | asGetTypeTraits<PGE::Rectanglef>());
    engine.RegisterObjectBehaviour("Rectanglef", asBEHAVE_CONSTRUCT, "void f()", asFUNCTION(rectangleConstructor), asCALL_CDECL_OBJLAST);
    engine.RegisterObjectBehaviour("Rectanglef", asBEHAVE_CONSTRUCT, "void f(const Vector2f&in tl, const Vector2f&in br)", asFUNCTION(rectangleConstructorVectors), asCALL_CDECL_OBJLAST);
    engine.RegisterObjectBehaviour("Rectanglef", asBEHAVE_CONSTRUCT, "void f(float il, float it, float ir, float ib)", asFUNCTION(rectangleConstructorParameterized), asCALL_CDECL_OBJLAST);
    engine.RegisterObjectBehaviour("Rectanglef", asBEHAVE_DESTRUCT, "void f()", asFUNCTION(rectangleDestructor), asCALL_CDECL_OBJLAST);

    engine.RegisterObjectMethod("Rectanglef", "bool opEquals(const Rectanglef&in other) const", asMETHODPR(PGE::Rectanglef, operator==, (const PGE::Rectanglef&) const, bool), asCALL_THISCALL);

    engine.RegisterObjectMethod("Rectanglef", "void opAssign(const Rectanglef &in other)", asMETHODPR(PGE::Rectanglef, operator=, (const PGE::Rectanglef&), PGE::Rectanglef&), asCALL_THISCALL);

    engine.RegisterObjectMethod("Rectanglef", "void addPoint(float x, float y)", asMETHODPR(PGE::Rectanglef, addPoint, (float, float), void), asCALL_THISCALL);
    engine.RegisterObjectMethod("Rectanglef", "void addPoint(const Vector2f&in point)", asMETHODPR(PGE::Rectanglef, addPoint, (const PGE::Vector2f&), void), asCALL_THISCALL);
    
    engine.RegisterObjectMethod("Rectanglef", "float width() const", asMETHOD(PGE::Rectanglef, width), asCALL_THISCALL);
    engine.RegisterObjectMethod("Rectanglef", "float height() const", asMETHOD(PGE::Rectanglef, height), asCALL_THISCALL);
    engine.RegisterObjectMethod("Rectanglef", "float area() const", asMETHOD(PGE::Rectanglef, area), asCALL_THISCALL);

    engine.RegisterObjectMethod("Rectanglef", "Vector2f center() const", asMETHOD(PGE::Rectanglef, center), asCALL_THISCALL);
    engine.RegisterObjectMethod("Rectanglef", "Vector2f topLeftCorner() const", asMETHOD(PGE::Rectanglef, topLeftCorner), asCALL_THISCALL);
    engine.RegisterObjectMethod("Rectanglef", "Vector2f topRightCorner() const", asMETHOD(PGE::Rectanglef, topRightCorner), asCALL_THISCALL);
    engine.RegisterObjectMethod("Rectanglef", "Vector2f bottomLeftCorner() const", asMETHOD(PGE::Rectanglef, bottomLeftCorner), asCALL_THISCALL);
    engine.RegisterObjectMethod("Rectanglef", "Vector2f bottomRightCorner() const", asMETHOD(PGE::Rectanglef, bottomRightCorner), asCALL_THISCALL);

    engine.RegisterObjectMethod("Rectanglef", "bool isPointInside(const Vector2f&in p) const", asMETHOD(PGE::Rectanglef, isPointInside), asCALL_THISCALL);
    engine.RegisterObjectMethod("Rectanglef", "bool intersects(const Rectanglef&in other) const", asMETHOD(PGE::Rectanglef, intersects), asCALL_THISCALL);
}

static NativeDefinitionRegistrar _ {
    &registerMathDefinitions,
    NativeDefinitionDependencyFlags::NONE,
    NativeDefinitionDependencyFlags::MATH
};
