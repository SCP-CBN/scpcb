#include "INIDefinitions.h"
#include <String/String.h>

#include "../ScriptManager.h"
#include "../../Utils/INI.h"


INIDefinitions::INIDefinitions(ScriptManager* mgr, INIFile* ini) {
    engine = mgr->getAngelScriptEngine();

    engine->RegisterObjectType("INIFile", sizeof(INIFile), asOBJ_REF | asOBJ_NOCOUNT);

    engine->RegisterObjectMethod("INIFile", "const int getInt(const string&in section, const string&in key, int defaultValue)", asMETHOD(INIFile, getInt), asCALL_THISCALL, ini);
    engine->RegisterObjectMethod("INIFile", "void setInt(const string&in section, const string&in key, int value)", asMETHOD(INIFile, setInt), asCALL_THISCALL, ini);

    engine->RegisterObjectMethod("INIFile", "const float getFloat(const string&in section, const string&in key, float defaultValue)", asMETHOD(INIFile, getFloat), asCALL_THISCALL, ini);
    engine->RegisterObjectMethod("INIFile", "void setFloat(const string&in section, const string&in key, float value)", asMETHOD(INIFile, setFloat), asCALL_THISCALL, ini);

    engine->RegisterObjectMethod("INIFile", "const string getString(const string&in section, const string&in key, string defaultValue)", asMETHOD(INIFile, getString), asCALL_THISCALL, ini);
    engine->RegisterObjectMethod("INIFile", "void setString(const string&in section, const string&in key, string value)", asMETHOD(INIFile, setString), asCALL_THISCALL, ini);

    engine->RegisterObjectMethod("INIFile", "const bool getBool(const string&in section, const string&in key, bool defaultValue)", asMETHOD(INIFile, getBool), asCALL_THISCALL, ini);
    engine->RegisterObjectMethod("INIFile", "void setBool(const string&in section, const string&in key, bool value)", asMETHOD(INIFile, setBool), asCALL_THISCALL, ini);


    engine->SetDefaultNamespace("INIFile");
    engine->RegisterGlobalFunction("INIFile@ open(string fileName)", asMETHOD(INIFile,iniFileFactory), asCALL_THISCALL_ASGLOBAL, ini);
}
