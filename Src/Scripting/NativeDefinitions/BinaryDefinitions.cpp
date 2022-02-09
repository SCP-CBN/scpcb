#include "../NativeDefinitionRegistrar.h"
#include "../NativeUtils.h"

#include <PGE/File/BinaryReader.h>
#include <PGE/Math/Vector.h>
#include <PGE/Math/Matrix.h>
#include <PGE/Color/Color.h>

using namespace PGE;

static BinaryReader* createReader(const String& path) {
	// TODO: Validate!
	return new BinaryReader(FilePath::fromStr(path));
}

static asITypeInfo* byteArrayType;

static bool tryReadBytes(BinaryReader* reader, asUINT bytes, CScriptArray* arr) {
	arr->Resize(bytes);
	for (asUINT i : Range(bytes)) {
		if (!reader->tryRead<byte>(((byte*)arr->GetBuffer())[i])) {
			return false;
		}
	}
	return true;
}

static CScriptArray* readBytes(BinaryReader* reader, asUINT bytes) {
	CScriptArray* ret = CScriptArray::Create(byteArrayType, bytes);
	for (asUINT i : Range(bytes)) {
		((byte*)ret->GetBuffer())[i] = reader->read<byte>();
	}
	return ret;
}

static void readBytesInto(BinaryReader* reader, CScriptArray* arr, asUINT bytes) {
	arr->Resize(bytes);
	for (asUINT i : Range(bytes)) {
		((byte*)arr->GetBuffer())[i] = reader->read<byte>();
	}
}

static void registerBinaryDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager& refCtr, const NativeDefinitionsHelpers&) {
	PGE_REGISTER_REF_TYPE_FULL(BinaryReader, engine, refCtr);
	engine.PGE_REGISTER_REF_FACTORY(BinaryReader, createReader);

	byteArrayType = engine.GetTypeInfoByDecl("array<u8>");

	engine.PGE_REGISTER_METHOD(BinaryReader, endOfFile);

#define REGISTER_READ(name, type) \
	engine.PGE_REGISTER_METHOD_N(BinaryReader, "tryRead" name, tryRead<type>); \
	engine.PGE_REGISTER_METHOD_N(BinaryReader, "read" name, read<type>)
#define REGISTER_READ_T(type) REGISTER_READ(#type, type)

	REGISTER_READ("Int8", i8);
	REGISTER_READ("Int16", i16);
	REGISTER_READ("Int32", i32);
	REGISTER_READ("Int64", i64);
	REGISTER_READ("UInt8", u8);
	REGISTER_READ("UInt16", u16);
	REGISTER_READ("UInt32", u32);
	REGISTER_READ("UInt64", u64);
	REGISTER_READ("Float", float);
	REGISTER_READ("Double", double);
	REGISTER_READ_T(Vector2f);
	REGISTER_READ_T(Vector3f);
	REGISTER_READ_T(Vector4f);
	REGISTER_READ_T(Vector2i);
	REGISTER_READ_T(Matrix4x4f);

	REGISTER_READ_T(String);
	engine.PGE_REGISTER_METHOD(BinaryReader, readStringInto);

	engine.PGE_REGISTER_FUNCTION_AS_METHOD_REPLACE_RET(BinaryReader, ArrayHack<byte>*, readBytes);
	engine.PGE_REGISTER_FUNCTION_AS_METHOD_REPLACE_ARGS(BinaryReader, tryReadBytes, (BinaryReader*, asUINT, ArrayHack<byte>*));
	engine.PGE_REGISTER_FUNCTION_AS_METHOD_REPLACE_ARGS(BinaryReader, readBytesInto, (BinaryReader*, ArrayHack<byte>*, asUINT));

	engine.PGE_REGISTER_METHOD(BinaryReader, trySkip);
	engine.PGE_REGISTER_METHOD(BinaryReader, skip);
}

static NativeDefinitionRegistrar _{ &registerBinaryDefinitions,
	NativeDefinitionDependencyFlags::MATH | NativeDefinitionDependencyFlags::COLOR };
