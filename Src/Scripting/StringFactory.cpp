#include "StringFactory.h"

const void* StringFactory::GetStringConstant(const char* data, asUINT length) {
    asAcquireExclusiveLock();

    char* tempBuf = new char[(uint64_t)length + 1];
    memcpy(tempBuf, data, sizeof(char) * length);
    tempBuf[length] = '\0';

    PGE::String tempStr = tempBuf;
    delete[] tempBuf;

    auto poolEntry = strPool.find(tempStr);
    if (poolEntry != strPool.end()) {
        poolEntry->second.refCount++;
    } else {
        StringPoolEntry newEntry = StringPoolEntry(tempStr);
        newEntry.refCount = 1;
        strPool.emplace(tempStr, newEntry);
        poolEntry = strPool.find(tempStr);
    }

    asReleaseExclusiveLock();

    return &(poolEntry->second.str);
}

int StringFactory::ReleaseStringConstant(const void* str) {
    int retVal = asSUCCESS;

    asAcquireExclusiveLock();

    PGE::String* deref = ((PGE::String*)str);
    auto poolEntry = strPool.find(*deref);
    if (poolEntry != strPool.end()) {
        poolEntry->second.refCount--;
        if (poolEntry->second.refCount <= 0) {
            strPool.erase(*deref);
        }
    }

    asReleaseExclusiveLock();

    return retVal;
}

int StringFactory::GetRawStringData(const void* str, char* data, asUINT* length) const {
    if (str == nullptr) { return asERROR; }

    PGE::String deref = *((PGE::String*)str);
    if (length != nullptr) {
        asUINT& lengthRef = *length;
        lengthRef = deref.byteLength();
    }
    if (data != nullptr) {
        memcpy(data, deref.cstr(), sizeof(char)*deref.byteLength());
    }

    return asSUCCESS;
}

static void constructString(PGE::String* thisPointer) {
    new(thisPointer) PGE::String();
}

static void copyConstructString(const PGE::String& other, PGE::String* thisPointer) {
    new(thisPointer) PGE::String(other);
}

static void constructStringFromChar(char chr, PGE::String* thisPointer) {
    new(thisPointer) PGE::String(chr);
}

static void destructString(PGE::String* thisPointer) {
    thisPointer->~String();
}

static PGE::String& assignString(const PGE::String& str, PGE::String& dest) {
    dest = str;
    return dest;
}

static PGE::String& addAssignString(const PGE::String& str, PGE::String& dest) {
    dest += str;
    return dest;
}

static bool stringEquals(const PGE::String& lhs, const PGE::String& rhs) {
    return lhs.equals(rhs);
}

static PGE::String stringAdd(const PGE::String& rhs, const PGE::String& lhs) {
    return lhs + rhs;
}

static int stringLength(const PGE::String& str) {
    return str.length();
}

static PGE::String stringSubstrStart(int start, const PGE::String& str) {
    return str.substr(start);
}

static PGE::String stringSubstrStartLen(int start, int count, const PGE::String& str) {
    return str.substr(start, count);
}

static PGE::wchar stringCharAt(int index, const PGE::String& str) {
    return *str.charAt(index);
}

static int stringToInt(const PGE::String& str) {
    return str.toInt();
}

static int stringToIntWithCheck(const PGE::String& str, bool& success) {
    return str.toInt(success);
}

static float stringToFloat(const PGE::String& str) {
    return str.toFloat();
}

static float stringToFloatWithCheck(const PGE::String& str, bool& success) {
    return str.toFloat(success);
}

static PGE::String intToString(int i) {
    return PGE::String::fromInt(i);
}

static PGE::String floatToString(float f) {
    return PGE::String::fromFloat(f);
}

StringFactory::StringFactory(asIScriptEngine* engine) {
    engine->RegisterObjectType("string", sizeof(PGE::String), asOBJ_VALUE | asOBJ_APP_CLASS_CDAK);

    engine->RegisterObjectBehaviour("string", asBEHAVE_CONSTRUCT,"void f()",asFUNCTION(constructString), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("string", asBEHAVE_CONSTRUCT,"void f(const string& in)",asFUNCTION(copyConstructString), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("string", asBEHAVE_CONSTRUCT,"void f(uint8)",asFUNCTION(constructStringFromChar), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectBehaviour("string", asBEHAVE_DESTRUCT,"void f()",asFUNCTION(destructString), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectMethod("string", "string& opAssign(const string& in)",asFUNCTION(assignString), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectMethod("string", "string& opAddAssign(const string& in)",asFUNCTION(addAssignString), asCALL_CDECL_OBJLAST);

    engine->RegisterObjectMethod("string", "bool opEquals(const string& in) const",asFUNCTION(stringEquals), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectMethod("string", "string opAdd(const string& in) const",asFUNCTION(stringAdd), asCALL_CDECL_OBJLAST);

    engine->RegisterObjectMethod("string", "uint length() const", asFUNCTION(stringLength), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectMethod("string", "string substr(int start) const", asFUNCTION(stringSubstrStart), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectMethod("string", "string substr(int start, int end) const",asFUNCTION(stringSubstrStartLen), asCALL_CDECL_OBJLAST);

    engine->RegisterObjectMethod("string", "uint16 opIndex(uint) const",asFUNCTION(stringCharAt), asCALL_CDECL_OBJLAST);

    engine->RegisterObjectMethod("string", "int toInt(bool&out success) const", asFUNCTION(stringToIntWithCheck), asCALL_CDECL_OBJFIRST);
    engine->RegisterObjectMethod("string", "int toInt() const", asFUNCTION(stringToInt), asCALL_CDECL_OBJLAST);
    engine->RegisterObjectMethod("string", "float toFloat(bool&out success) const", asFUNCTION(stringToFloatWithCheck), asCALL_CDECL_OBJFIRST);
    engine->RegisterObjectMethod("string", "float toFloat() const", asFUNCTION(stringToFloat), asCALL_CDECL_OBJFIRST);

    engine->RegisterStringFactory("string", this);

    engine->RegisterGlobalFunction("string toString(int i)", asFUNCTION(intToString), asCALL_CDECL);
    engine->RegisterGlobalFunction("string toString(float f)", asFUNCTION(floatToString), asCALL_CDECL);
}
