#include "PlayerControllerDefinitions.h"

#include "../ScriptManager.h"

#include "../../PlayerController/PlayerController.h"
#include "../../Graphics/Camera.h"
#include "../../World/Pickable.h"

PlayerController* PlayerControllerDefinitions::playerControllerFactory(float radius, float height) {
    PlayerController* newController = new PlayerController(radius, height);
    refCount.emplace(newController, 1);
    refCounterManager->linkPtrToCounter(newController, this);
    this->height = height;
    return newController;
}

void PlayerControllerDefinitions::addRef(void* ptr) {
    PlayerController* controller = (PlayerController*)ptr;
    if (refCount.find(controller) == refCount.end()) { return; }
    refCount[controller]++;
}

void PlayerControllerDefinitions::release(void* ptr) {
    PlayerController* controller = (PlayerController*)ptr;
    if (refCount.find(controller) == refCount.end()) { return; }
    refCount[controller]--;

    if (refCount[controller] <= 0) {
        refCount.erase(controller);
        refCounterManager->unlinkPtr(controller);
        if (PickableManager::cmc != nullptr) {
            refCounterManager->release(PickableManager::cmc);
        }
        delete controller;
    }
}


void PlayerControllerDefinitions::setCollisionCollection(PlayerController* controller, CollisionMeshCollection* collection) {
    PlayerControllerDefinitions* e = this;
    if (PickableManager::cmc != nullptr) {
        refCounterManager->release(PickableManager::cmc);
    }
    controller->setCollisionMeshCollection(collection);
}

void PlayerControllerDefinitions::__UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(PlayerController* controller, Input input, float timeStep) {
    controller->update(tempCamera->getYawAngle(), tempCamera->getPitchAngle(), input, timeStep);
    tempCamera->position = controller->position.add(PGE::Vector3f(0.f, height, 0.f));
    // Fixes interpolation bug, hella ugly but we'll get rid of this altogether soon anyways.
    // if (timeStep == 0.f) { // This does not appear to do anything
        tempCamera->update();
    //}

    release(controller);
}

PlayerControllerDefinitions::PlayerControllerDefinitions(ScriptManager* mgr, RefCounterManager* rcMgr, Camera* cam) {
    tempCamera = cam;

    engine = mgr->getAngelScriptEngine();

    refCounterManager = rcMgr;

    engine->RegisterObjectType("PlayerController", sizeof(PlayerController), asOBJ_REF);
    engine->RegisterObjectBehaviour("PlayerController", asBEHAVE_FACTORY, "PlayerController@ f(float radius, float height)", asMETHOD(PlayerControllerDefinitions, playerControllerFactory), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterObjectBehaviour("PlayerController", asBEHAVE_ADDREF, "void f()", asMETHOD(PlayerControllerDefinitions,addRef), asCALL_THISCALL_OBJLAST, this);
    engine->RegisterObjectBehaviour("PlayerController", asBEHAVE_RELEASE, "void f()", asMETHOD(PlayerControllerDefinitions,release), asCALL_THISCALL_OBJLAST, this);

    engine->RegisterObjectMethod("PlayerController", "void setCollisionCollection(Collision::Collection@ coll)", asMETHOD(PlayerControllerDefinitions,setCollisionCollection), asCALL_THISCALL_OBJFIRST, this);
    engine->RegisterObjectMethod("PlayerController", "void update(float yaw, float pitch, Input inputs)", asMETHOD(PlayerController,update), asCALL_THISCALL);

    engine->RegisterGlobalFunction("void __UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE(PlayerController@ controller, int input, float timeStep)", asMETHOD(PlayerControllerDefinitions, __UPDATE_PLAYERCONTROLLER_TEST_TODO_REMOVE), asCALL_THISCALL_ASGLOBAL, this);

    engine->RegisterObjectProperty("PlayerController", "Vector3f position", asOFFSET(PlayerController, position));
    engine->RegisterObjectProperty("PlayerController", "bool noclip", asOFFSET(PlayerController, vNoclip));
}
