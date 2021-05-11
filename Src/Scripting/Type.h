#ifndef TYPE_H_INCLUDED
#define TYPE_H_INCLUDED

#include <String/String.h>

class ArrayType;
class RefType;

class Type {
    private:
        // By initializing the Types this way the destructor gets called when the program exits.
        static Type int32Private;
        static Type uint32Private;
        static Type floatPrivate;
        static Type doublePrivate;
        static Type stringPrivate;
        static Type vector3fPrivate;
        static Type matrix4x4fPrivate;
        static Type colorPrivate;
        static Type voidPrivate;
        static Type unsupportedPrivate;

    protected:
        PGE::String typeName;
        int size;
        RefType* refType = nullptr;
        ArrayType* arrayType = nullptr;

    public:
        Type();
        Type(const PGE::String& name, int size = 0);
        ~Type() = default;

        virtual PGE::String getName() const;
        virtual bool isClassType() const;
        virtual ArrayType* getArrayType();
        virtual bool isArrayType() const;
        virtual RefType* asRef() const;
        virtual bool isRefType() const;

        int getSize() const;

        static Type* const Int32;
        static Type* const UInt32;
        static Type* const Float;
        static Type* const Double;
        static Type* const String;
        static Type* const Vector3f;
        static Type* const Matrix4x4f;
        static Type* const Color;
        static Type* const Void;
        static Type* const Unsupported;
};

class ArrayType : public Type {
    private:
        Type* elementType;

    public:
        ArrayType(Type* type);

        PGE::String getName() const override;
        bool isArrayType() const override;
        Type* getElementType() const;
};

class RefType : public Type {
    private:
        Type* baseType;

    public:
        RefType(Type* type);

        PGE::String getName() const override;
        bool isClassType() const override;
        bool isRefType() const override;
        Type* getBaseType() const;
};

#endif // TYPE_H_INCLUDED
