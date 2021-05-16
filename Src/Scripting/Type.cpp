#include <Math/Vector.h>
#include <Math/Matrix.h>
#include <Color/Color.h>

#include "Type.h"

Type Type::boolPrivate = Type("bool", 1);
Type Type::int32Private = Type("int32", 4);
Type Type::uint32Private = Type("uint32", 4);
Type Type::floatPrivate = Type("float", 4);
Type Type::doublePrivate = Type("double", 8);
Type Type::stringPrivate = Type("string", sizeof(PGE::String));
Type Type::vector3fPrivate = Type("Vector3f", sizeof(PGE::Vector3f));
Type Type::matrix4x4fPrivate = Type("Matrix4x4f", sizeof(PGE::Matrix4x4f));
Type Type::colorPrivate = Type("Color", sizeof(PGE::Color));
Type Type::voidPrivate = Type("void");
Type Type::unsupportedPrivate = Type("!!unsupported!!");

Type* const Type::Bool = &Type::boolPrivate;
Type* const Type::Int32 = &Type::int32Private;
Type* const Type::UInt32 = &Type::uint32Private;
Type* const Type::Float = &Type::floatPrivate;
Type* const Type::Double = &Type::doublePrivate;
Type* const Type::String = &Type::stringPrivate;
Type* const Type::Vector3f = &Type::vector3fPrivate;
Type* const Type::Matrix4x4f = &Type::matrix4x4fPrivate;
Type* const Type::Color = &Type::colorPrivate;
Type* const Type::Void = &Type::voidPrivate;
Type* const Type::Unsupported = &Type::unsupportedPrivate;

Type::Type() {
    typeName = "<unknown>";
    refType = nullptr;
    arrayType = nullptr;
}

Type::Type(const PGE::String& name, int size) {
    typeName = name;
    this->size = size;
    refType = new RefType(this);
    arrayType = nullptr;
}

PGE::String Type::getName() const {
    return typeName;
}

bool Type::isClassType() const {
    return false;
}

bool Type::isRefType() const {
    return false;
}

ArrayType* Type::getArrayType() {
    if (arrayType == nullptr) {
        arrayType = new ArrayType(this);
    }
    return arrayType;
}

bool Type::isArrayType() const {
    return false;
}

RefType* Type::asRef() const {
    return refType;
}

int Type::getSize() const {
    return size;
}

ArrayType::ArrayType(Type* type) {
    elementType = type;
    refType = new RefType(this);
}

PGE::String ArrayType::getName() const {
    return "array<" + elementType->getName() + ">";
}

bool ArrayType::isArrayType() const {
    return true;
}

Type* ArrayType::getElementType() const {
    return elementType;
}

RefType::RefType(Type* type) {
    baseType = type;
    typeName = baseType->getName() + '@';
    refType = nullptr;
    arrayType = nullptr;
}

PGE::String RefType::getName() const {
    return baseType->getName() + '@';
}

bool RefType::isClassType() const {
    return baseType->isClassType();
}

bool RefType::isRefType() const {
    return true;
}

Type* RefType::getBaseType() const {
    return baseType;
}
