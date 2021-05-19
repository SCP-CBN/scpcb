#include "ScriptManager.h"
#include "ScriptClass.h"
#include "ScriptModule.h"
#include "StringFactory.h"
#include <angelscript.h>
#include <String/String.h>
#include <map>
#include <stdlib.h>
#include <inttypes.h>
#include "AngelScriptAddons/scriptarray/scriptarray.h"

struct ContextPool {
    std::vector<asIScriptContext*> contexts;
};

std::map<asIScriptEngine*, ContextPool> contextPools;
asIScriptContext* requestContextCallback(asIScriptEngine* engine, void* param) {
    if (contextPools.find(engine) == contextPools.end()) {
        ContextPool newPool;
        contextPools.emplace(engine, newPool);
    }

    asIScriptContext* ctx = nullptr;
    if(contextPools[engine].contexts.size() > 0) {
        ctx = contextPools[engine].contexts[0];
        contextPools[engine].contexts.pop_back();
    } else {
        ctx = engine->CreateContext();
    }
    ctx->SetExceptionCallback(asMETHOD(ScriptManager, contextExceptionCallback), param, asCALL_THISCALL);

    return ctx;
}

void returnContextToPool(asIScriptEngine* engine, asIScriptContext* ctx, void* param) {
    if (contextPools.find(engine) == contextPools.end()) {
        ContextPool newPool;
        contextPools.emplace(engine, newPool);
    }

    contextPools[engine].contexts.push_back(ctx);

    ctx->Unprepare();
}

ScriptManager::ScriptManager() {
    engine = asCreateScriptEngine();

    ContextPool newPool;
    contextPools.emplace(engine, newPool);

    engine->SetContextCallbacks(requestContextCallback, returnContextToPool, this);

    engine->SetMessageCallback(asMETHOD(ScriptManager, messageCallback), this, asCALL_THISCALL);

    stringFactory = new StringFactory(engine);

    RegisterScriptArray(engine, true);
}

ScriptManager::~ScriptManager() {
    engine->ShutDownAndRelease();
    delete ((StringFactory*)stringFactory);
}

void ScriptManager::contextExceptionCallback(asIScriptContext* context) {
    asSMessageInfo info;
    info.message = context->GetExceptionString();
    info.row = context->GetExceptionLineNumber(&info.col, &info.section);
    info.type = asEMsgType::asMSGTYPE_ERROR;
    messageCallback(&info, nullptr);
}

void ScriptManager::messageCallback(const asSMessageInfo* msg, void* param) {
    LogEntry newLogEntry;
    switch (msg->type) {
        case asEMsgType::asMSGTYPE_ERROR: {            newLogEntry.type = LogEntry::Type::AngelScriptError;
        } break;
        case asEMsgType::asMSGTYPE_WARNING: {
            newLogEntry.type = LogEntry::Type::AngelScriptWarning;
        } break;
        case asEMsgType::asMSGTYPE_INFORMATION: {
            newLogEntry.type = LogEntry::Type::AngelScriptInfo;
        } break;
    }
    newLogEntry.message = msg->message;
    newLogEntry.section = msg->section;
    newLogEntry.row = msg->row;
    newLogEntry.col = msg->col;

    log.push_back(newLogEntry);
}

asIScriptEngine* ScriptManager::getAngelScriptEngine() const {
    engine->SetDefaultNamespace("");
    return engine;
}

ScriptClass* ScriptManager::getSharedClassByTypeId(int typeId) const {
    for (int i = 0; i < sharedClasses.size(); i++) {
        if (sharedClasses[i]->getTypeId() == typeId) { return sharedClasses[i]; }
    }
    return nullptr;
}

ScriptClass* ScriptManager::getClassByTypeId(int typeId) const {
    ScriptClass* scriptClass = getSharedClassByTypeId(typeId);

    if (scriptClass != nullptr) { return scriptClass; }

    for (int i=0;i<scriptModules.size();i++) {
        scriptClass = scriptModules[i]->getClassByTypeId(typeId);
        if (scriptClass != nullptr) { return scriptClass; }
    }

    return nullptr;
}

void ScriptManager::registerSharedClass(ScriptClass* clss) {
    sharedClasses.push_back(clss);
}

const std::vector<ScriptModule*>& ScriptManager::getScriptModules() const {
    return scriptModules;
}

void ScriptManager::registerScriptModule(ScriptModule* mdl) {
    scriptModules.push_back(mdl);
}

bool ScriptManager::isArrayTypeId(int typeId) const {
    return IsScriptArrayType(engine->GetTypeInfoById(typeId));
}
