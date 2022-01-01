#include "ConsoleDefinitions.h"
#ifdef DEBUG
    #include <iostream>
#endif

#include <PGE/Exception/Exception.h>
#include <PGE/Math/Math.h>
#include <PGE/Color/ConsoleColor.h>

#include "../../Input/KeyBinds.h"
#include "../ScriptManager.h"
#include "../ScriptModule.h"
#include "../ScriptObject.h"
#include "../ScriptGlobal.h"

void ConsoleDefinitions::helpInternal(std::vector<PGE::String> params) {
    if (params.size() == 2) {
        auto find = commands.find(params[1]);
        if (find == commands.end()) {
            addConsoleMessage("That command doesn't exist", PGE::Colors::YELLOW);
        } else {
            if (find->second.helpText.isEmpty()) {
                addConsoleMessage("There is no help available for that command.", PGE::Colors::YELLOW);
            } else {
                addConsoleMessage(find->second.helpText, PGE::Colors::BLUE);
            }
        }
    } else if (params.size() == 1) {
        for (const auto& comSet : commands) {
            Command command = comSet.second;
            addConsoleMessage(command.name, PGE::Colors::CYAN);
        }
    } else {
        addConsoleMessage("ARGUMENT SIZE MISMATCH", PGE::Colors::RED);
    }
}

void ConsoleDefinitions::bindInternal(std::vector<PGE::String> params) {
    params.erase(params.begin());
    PGE::Input* key = keyBinds->stringToInput(params.back());
    if (key == nullptr) {
        addConsoleMessage("That key doesn't exist.", PGE::Colors::RED);
    } else {
        params.pop_back();
        keyBinds->bindCommand(PGE::String::join(params, " "), key);
    }
}

void ConsoleDefinitions::unbindInternal(std::vector<PGE::String> params) {
    params.erase(params.begin());
    PGE::Input* key = keyBinds->stringToInput(params.back());
    if (key == nullptr) {
        addConsoleMessage("That key doesn't exist.", PGE::Colors::RED);
    } else {
        params.pop_back();
        keyBinds->unbindCommand(PGE::String::join(params, " "), key);
    }
}

ConsoleDefinitions::ConsoleDefinitions(ScriptManager* mgr, KeyBinds* kb) {
    keyBinds = kb;

    engine = mgr->getAngelScriptEngine();
    scriptContext = engine->CreateContext();
    msgContext = engine->CreateContext();

    engine->SetDefaultNamespace("Console");
    engine->RegisterGlobalFunction("void register(const string&in name, const string&in helpText, function&in command)", asMETHOD(ConsoleDefinitions, registerCommand), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("void register(const string&in name, function&in command)", asMETHOD(ConsoleDefinitions, registerCommandNoHelp), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("void execute(const string&in)", asMETHOD(ConsoleDefinitions, executeCommand), asCALL_THISCALL_ASGLOBAL, this);

    engine->SetDefaultNamespace("Debug");
    engine->RegisterGlobalFunction("void log(?&in content)", asMETHOD(ConsoleDefinitions, log<LogType::Log>), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("void warning(?&in content)", asMETHOD(ConsoleDefinitions, log<LogType::Warning>), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("void error(?&in content)", asMETHOD(ConsoleDefinitions, log<LogType::Error>), asCALL_THISCALL_ASGLOBAL, this);

    registerCommandInternal("help", "Provides a description of a specified command. Use it with no parameters to list all commands.", &ConsoleDefinitions::helpInternal);
    registerCommandInternal("bind", "Binds a command to a key.", &ConsoleDefinitions::bindInternal);
    registerCommandInternal("unbind", "Unbinds the given command from the key.", &ConsoleDefinitions::unbindInternal);
}

ConsoleDefinitions::~ConsoleDefinitions() {
    scriptContext->Release();
    msgContext->Release();
}

void ConsoleDefinitions::setUp(ScriptManager* mgr) {
    std::vector<ScriptModule*> modules = mgr->getScriptModules();
    for (const auto& mod : modules) {
        if (PGE::String(mod->getAngelScriptModule()->GetName()) == "RootScript") {
            consoleInstance = mod->getGlobalByName("instance", "ConsoleMenu")->getObject()->getAngelScriptObject();
            addConsoleMsgFunc = engine->GetModule("RootScript")->GetTypeInfoByName("ConsoleMenu")->GetMethodByName("addConsoleMessage");
            break;
        }
    }
}

void ConsoleDefinitions::registerCommandInternal(const PGE::String& name, const PGE::String& helpText, void(ConsoleDefinitions::*nativFunc)(std::vector<PGE::String>)) {
    Command c = { nullptr, nativFunc, name, helpText };
    commands.emplace(name, c);
}

void ConsoleDefinitions::registerCommand(const PGE::String& name, const PGE::String& helpText, void* f, int typeId) {
    asIScriptFunction* func = (asIScriptFunction*)(((typeId & asTYPEID_OBJHANDLE) != 0) ? *((void**)f) : f);
    for (unsigned i = 0; i < func->GetParamCount(); i++) {
        int paramTypeId;
        PGE::asrt(func->GetParam(i, &paramTypeId) == 0, "ptooey?");
        PGE::asrt(paramTypeId == asTYPEID_BOOL || paramTypeId == asTYPEID_INT32 || paramTypeId == asTYPEID_FLOAT || paramTypeId == engine->GetStringFactoryReturnTypeId(), "STINKY INVALID TYPE");
    }
    Command newCommand = { func, nullptr, name, helpText };
    commands.emplace(name, newCommand);
#ifdef DEBUG
    std::cout << "Command: " << name << std::endl;
#endif
}

void ConsoleDefinitions::registerCommandNoHelp(const PGE::String& name, void* f, int typeId) {
    registerCommand(name, "", f, typeId);
}

void ConsoleDefinitions::executeCommand(const PGE::String& in) {
    std::vector<PGE::String> params = in.split(" ", true);
    auto find = commands.find(params[0]);
    if (find != commands.end()) {
        if (find->second.func == nullptr) {
            (this->*find->second.nativFunc)(params);
        } else {
            asIScriptFunction* func = find->second.func;
            params.erase(params.begin());
            // TODO: Do we need to check all AS funcs or none?
            PGE::asrt(scriptContext->Prepare(func) == 0, "ptooey! 2");
            if (func->GetParamCount() != params.size()) {
                const char* defaultParam;
                func->GetParam((asUINT)params.size(), nullptr, nullptr, nullptr, &defaultParam);
                if (defaultParam == nullptr) {
                    scriptContext->Unprepare();
                    addConsoleMessage("ARGUMENT SIZE MISMATCH", PGE::Colors::RED);
                    return;
                }
            }
            PGE::String errMsg;
            for (unsigned i = 0; i < params.size(); i++) {
                int paramTypeId;
                PGE::asrt(func->GetParam(i, &paramTypeId) == 0, "ptooey! 3");
                if (paramTypeId == asTYPEID_BOOL) {
                    if (params[i].toLower().equals("true") || params[i].equals("1")) {
                        scriptContext->SetArgByte(i, 1);
                    } else if (params[i].toLower().equals("false") || params[i].equals("0")) {
                        scriptContext->SetArgByte(i, 0);
                    } else {
                        errMsg = "NOT BOOL";
                        break;
                    }
                } else if (paramTypeId == asTYPEID_INT32) {
                    bool success;
                    PGE::i32 arg = params[i].to<PGE::i32>(success);
                    if (!success) {
                        errMsg = "NOT INT";
                        break;
                    }

                    // If the user enters a float.
                    if (!PGE::Math::equalFloats((float)arg, params[i].to<float>())) {
                        addConsoleMessage("Loss of data!", PGE::Colors::YELLOW);
                    }

                    scriptContext->SetArgDWord(i, arg);
                } else if (paramTypeId == asTYPEID_FLOAT) {
                    bool success;
                    float arg = params[i].to<float>(success);
                    if (!success) {
                        errMsg = "NOT FLOAT";
                        break;
                    }

                    scriptContext->SetArgFloat(i, arg);
                } else if (paramTypeId == scriptContext->GetEngine()->GetStringFactoryReturnTypeId()) {
                    scriptContext->SetArgObject(i, (void*)&(params[i]));
                }
            }

            if (errMsg.isEmpty()) {
                scriptContext->Execute();
            } else {
                addConsoleMessage(errMsg, PGE::Colors::RED);
            }
            scriptContext->Unprepare();
        }
    } else {
        addConsoleMessage("No command found", PGE::Colors::RED);
    }
}

void ConsoleDefinitions::addConsoleMessage(const PGE::String& msg, const PGE::Color& color) {
    PGE::asrt(msgContext->Prepare(addConsoleMsgFunc) == 0, "prepare fail");
    PGE::asrt(msgContext->SetObject(consoleInstance) == 0, "setobj fail");
    PGE::asrt(msgContext->SetArgObject(0, (void*)&msg) == 0, "setarg0 fail");
    PGE::asrt(msgContext->SetArgObject(1, (void*)&color) == 0, "setarg1 fail");
    PGE::asrt(msgContext->Execute() == 0, "epic execute fail");
    PGE::asrt(msgContext->Unprepare() == 0, "unprepare fail");
}

void ConsoleDefinitions::internalLog(void* ref, int typeId, LogType type) {
    PGE::String typeString;
    PGE::Console::ForegroundColor color;
    switch (type) {
        case LogType::Log: {
            color = { PGE::Colors::CYAN };
            typeString = "Log";
        } break;
        case LogType::Warning: {
            color = { PGE::Colors::YELLOW };
            typeString = "Warn";
        } break;
        case LogType::Error: {
            color = { PGE::Colors::RED };
            typeString = "Err";
        } break;
    }
    PGE::String content;
    if (typeId == engine->GetStringFactoryReturnTypeId()) {
        content = *(PGE::String*)ref;
    } else {
        switch (typeId) {
            case asTYPEID_VOID: { // This should never happen.
                PGE::asrt(false, "VOID PARAMETER");
            } break;
            case asTYPEID_BOOL: {
                content = (*(bool*)ref) ? "True" : "False";
            } break;
            case asTYPEID_INT8: {
                content = PGE::String::from(*(PGE::byte*)ref);
            } break;
            case asTYPEID_INT16: {
                content = PGE::String::from(*(int16_t*)ref);
            } break;
            case asTYPEID_INT32: {
                content = PGE::String::from(*(int32_t*)ref);
            } break;
            case asTYPEID_INT64: {
                content = PGE::String::from(*(int64_t*)ref);
            } break;
            case asTYPEID_UINT8: {
                content = PGE::String::from(*(uint8_t*)ref);
            } break;
            case asTYPEID_UINT16: {
                content = PGE::String::from(*(uint16_t*)ref);
            } break;
            case asTYPEID_UINT32: {
                content = PGE::String::from(*(uint32_t*)ref);
            } break;
            case asTYPEID_UINT64: {
                content = PGE::String::from(*(uint64_t*)ref);
            } break;
            case asTYPEID_FLOAT: {
                content = PGE::String::from(*(float*)ref);
            } break;
            case asTYPEID_DOUBLE: {
                content = PGE::String::from(*(double*)ref);
            } break;
            default: { // Object.
                asITypeInfo* typeInfo = engine->GetTypeInfoById(typeId);
                asIScriptFunction* toString = typeInfo->GetMethodByName("toString");
                if (toString != nullptr) {
                    asIScriptContext* context = engine->RequestContext();
                    context->Prepare(toString);
                    context->SetObject(ref);
                    context->Execute();
                    void* ret = context->GetAddressOfReturnValue();
                    if (ret != nullptr) {
                        content = *(PGE::String*)ret;
                        engine->ReturnContext(context);
                        break;
                    }
                }
                content = PGE::String(typeInfo->GetName()) + "@" + PGE::String::hexFromInt((uintmax_t)ref);
            } break;
        }
    }
#ifdef DEBUG
    std::ostream& out = (type == LogType::Error ? std::cerr : std::cout);
    out << color << "Debug::" << typeString << ": " << content << PGE::Console::ResetAll() << std::endl;
#endif
    PGE::asrt(type != LogType::Error, "ERROR! " + content);
}
