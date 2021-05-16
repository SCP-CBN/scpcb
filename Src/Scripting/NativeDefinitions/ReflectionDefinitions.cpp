#include "ReflectionDefinitions.h"

#include "../ScriptManager.h"

#include "../ScriptFunction.h"
#include "../ScriptObject.h"
#include "../ScriptClass.h"
#include "../ScriptModule.h"
#include "../CachedArgument.h"
#include "../AngelScriptAddons/scriptarray/scriptarray.h"

class Reflection {
    private:
        bool initialized;
        ScriptClass* scriptClass;
        ScriptManager* scriptManager;
        asITypeInfo* typeInfo;

        std::vector<PGE::String> requiredInterfaces;

        int selectedDerivedIndex;
        std::vector<CachedArgument> arguments;

        void allocArguments(int index) {
            arguments.resize(index+1);
            if (arguments[index].type != nullptr && arguments[index].type->isClassType()) {
                asIScriptObject* angelScriptObject = (asIScriptObject*)arguments[index].value.ptr;
                angelScriptObject->Release();
            }
        }

        std::vector<ScriptClass*> getMatchingDerivedClasses() {
            std::vector<ScriptClass*> derivedClasses = scriptClass->getDerivedClasses();

            if (requiredInterfaces.size() > 0) {
                for (int i = (int)derivedClasses.size()-1; i >= 0; i--) {
                    int interfaceCount = 0;
                    asITypeInfo* ti = derivedClasses[i]->getAngelScriptTypeInfo();
                    for (unsigned int j=0; j < ti->GetInterfaceCount(); j++) {
                        asITypeInfo* itf = ti->GetInterface(j);
                        for (int k=0; k < requiredInterfaces.size(); k++) {
                            if (requiredInterfaces[k].equalsIgnoreCase(itf->GetName())) {
                                interfaceCount++;
                                break;
                            }
                        }
                    }

                    if (interfaceCount < requiredInterfaces.size()) {
                        derivedClasses.erase(derivedClasses.begin()+i);
                    }
                }
            }

            return derivedClasses;
        }
    public:
        Reflection(asITypeInfo* ti, ScriptManager* mgr) {
            typeInfo = ti->GetSubType();
            PGE::String typeName = typeInfo->GetName();
            initialized = false;
            scriptClass = nullptr;
            scriptManager = nullptr;
            selectedDerivedIndex = 0;
            initialize(mgr);
        }

        ~Reflection() {
            clearArguments();
        }

        void initialize(ScriptManager* mgr) {
            if (initialized) { return; }

            initialized = true;

            scriptManager = mgr;

            int typeId = typeInfo->GetTypeId();

            scriptClass = mgr->getClassByTypeId(typeId);
        }

        void requireInterface(const PGE::String& interfaceName) {
            requiredInterfaces.push_back(interfaceName);
        }

        void clearRequiredInterfaces() {
            requiredInterfaces.clear();
        }

        CScriptArray* getDerivedNames() {
            std::vector<ScriptClass*> derivedClasses = getMatchingDerivedClasses();

            asITypeInfo* arrayTypeInfo = scriptManager->getAngelScriptEngine()->GetTypeInfoByDecl("array<string>");

            CScriptArray* newArray = CScriptArray::Create(arrayTypeInfo, (asUINT)derivedClasses.size());
            for (int i=0;i<derivedClasses.size();i++) {
                PGE::String nm = derivedClasses[i]->getName();
                newArray->SetValue(i, &nm);
            }

            return newArray;
        }

        void clearArguments() {
            for (int i=0;i<arguments.size();i++) {
                if (arguments[i].type != nullptr && arguments[i].type->isClassType()) {
                    asIScriptObject* angelScriptObject = (asIScriptObject*)arguments[i].value.ptr;
                    angelScriptObject->Release();
                }
            }
            arguments.clear();
        }

        void setConstructorArgument(int index, bool val) {
            allocArguments(index);
            arguments[index].type = Type::Bool;
            arguments[index].value.truthy = val;
        }

        void setConstructorArgument(int index, int val) {
            allocArguments(index);
            arguments[index].type = Type::Int32;
            arguments[index].value.i32 = val;
        }

        void setConstructorArgument(int index, unsigned int val) {
            allocArguments(index);
            arguments[index].type = Type::Int32;
            arguments[index].value.u32 = val;
        }

        void setConstructorArgument(int index, float val) {
            allocArguments(index);
            arguments[index].type = Type::Float;
            arguments[index].value.f = val;
        }

        void setConstructorArgument(int index, double val) {
            allocArguments(index);
            arguments[index].type = Type::Double;
            arguments[index].value.d = val;
        }

        void setConstructorArgument(int index, const PGE::String& val) {
            allocArguments(index);
            arguments[index].type = Type::String;
            arguments[index].strValue = val;
        }

        void setConstructorArgument(int index, void* val, int typeId) {
            //TODO: account for native types
            bool isRef = (typeId & asTYPEID_OBJHANDLE) != 0;
            Type* type = scriptManager->getClassByTypeId(typeId & (~asTYPEID_OBJHANDLE));
            
            asIScriptObject* angelScriptObject = (asIScriptObject*)val;
            angelScriptObject->AddRef();

            allocArguments(index);
            arguments[index].type = type;
            arguments[index].value.ptr = val;
        }

        void* callConstructor(const PGE::String& derivedClassName) {
            std::vector<ScriptClass*> derivedClasses = getMatchingDerivedClasses();
            for (int i=0;i<derivedClasses.size();i++) {
                if (derivedClasses[i]->getName().equals(derivedClassName)) {
                    const std::vector<ScriptFunction*>& constructors = derivedClasses[i]->getConstructors();

                    for (int j=0;j<constructors.size();j++) {
                        const ScriptFunction::Signature& signature = constructors[j]->getSignature();
                        if (signature.arguments.size() != arguments.size()) { continue; }
                        bool signatureMatches = true;
                        for (int k=0;k<arguments.size();k++) {
                            if (signature.arguments[k].type != arguments[k].type && signature.arguments[k].type != arguments[k].type->asRef()) {
                                signatureMatches = false;
                                break;
                            }
                        }
                        if (!signatureMatches) { continue; }

                        constructors[j]->prepare();
                        for (int k=0;k<arguments.size();k++) {
                            if (arguments[k].type == Type::Bool) {
                                constructors[j]->setArgument(signature.arguments[k].name, arguments[k].value.truthy);
                            } else if (arguments[k].type == Type::Int32) {
                                constructors[j]->setArgument(signature.arguments[k].name, arguments[k].value.i32);
                            } else if (arguments[k].type == Type::UInt32) {
                                constructors[j]->setArgument(signature.arguments[k].name, arguments[k].value.u32);
                            } else if (arguments[k].type == Type::Float) {
                                constructors[j]->setArgument(signature.arguments[k].name, arguments[k].value.f);
                            } else if (arguments[k].type == Type::Double) {
                                constructors[j]->setArgument(signature.arguments[k].name, arguments[k].value.d);
                            } else if (arguments[k].type == Type::String) {
                                constructors[j]->setArgument(signature.arguments[k].name, arguments[k].strValue);
                            } else {
                                constructors[j]->setArgumentNative(signature.arguments[k].name, arguments[k].value.ptr);
                            }
                        }
                        constructors[j]->execute();
                        asIScriptObject* result = constructors[j]->getReturnObject()->getAngelScriptObject();
                        result->AddRef();
                        return result;
                    }

                    break;
                }
            }

            return nullptr;
        }
};


void ReflectionDefinitions::reflectionConstructor(asITypeInfo* typeInfo, void* memory) {
    new(memory) Reflection(typeInfo, scriptManager);
}

void ReflectionDefinitions::reflectionDestructor(void* memory) {
    ((Reflection*)memory)->~Reflection();
}

ReflectionDefinitions::ReflectionDefinitions(ScriptManager* mgr) {
    engine = mgr->getAngelScriptEngine();
    scriptManager = mgr;

    engine->RegisterObjectType("Reflection<class T>", sizeof(Reflection), asOBJ_VALUE | asOBJ_APP_CLASS_ALLINTS | asOBJ_TEMPLATE | asGetTypeTraits<Reflection>());
    engine->RegisterObjectBehaviour("Reflection<T>", asBEHAVE_CONSTRUCT, "void f(int&in)", asMETHOD(ReflectionDefinitions, reflectionConstructor), asCALL_THISCALL_OBJLAST, this);
    engine->RegisterObjectBehaviour("Reflection<T>", asBEHAVE_DESTRUCT, "void f()", asMETHOD(ReflectionDefinitions, reflectionDestructor), asCALL_THISCALL_OBJLAST, this);
    engine->RegisterObjectMethod("Reflection<T>", "void requireInterface(const string&in interfaceName)", asMETHOD(Reflection, requireInterface), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "void clearRequiredInterfaces()", asMETHOD(Reflection, clearRequiredInterfaces), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "array<string>@ getDerivedNames()", asMETHOD(Reflection, getDerivedNames), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "void setConstructorArgument(int index, bool val)", asMETHODPR(Reflection, setConstructorArgument, (int, bool), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "void setConstructorArgument(int index, int val)", asMETHODPR(Reflection, setConstructorArgument, (int, int), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "void setConstructorArgument(int index, uint val)", asMETHODPR(Reflection, setConstructorArgument, (int, unsigned int), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "void setConstructorArgument(int index, float val)", asMETHODPR(Reflection, setConstructorArgument, (int, float), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "void setConstructorArgument(int index, double val)", asMETHODPR(Reflection, setConstructorArgument, (int, double), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "void setConstructorArgument(int index, const string&in val)", asMETHODPR(Reflection, setConstructorArgument, (int, const PGE::String&), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "void setConstructorArgument(int index, ?&in val)", asMETHODPR(Reflection, setConstructorArgument, (int, void*, int), void), asCALL_THISCALL);
    engine->RegisterObjectMethod("Reflection<T>", "T@ callConstructor(const string&in derivedClassName)", asMETHOD(Reflection, callConstructor), asCALL_THISCALL);
}
