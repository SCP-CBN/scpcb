#ifndef NATIVE_DEFINITION_HELPERS_H_INCLUDED
#define NATIVE_DEFINITION_HELPERS_H_INCLUDED

#include <PGE/Input/InputManager.h>

struct NativeDefinitionsHelpers {
    class World* world;
    class GraphicsResources* gfxRes;
    class Camera* camera;
    class KeyBinds* keyBinds;
    class MouseData* mouseData;
    PGE::InputManager* inputManager;
    class LocalizationManager* lm;
    class PickableManager* pm;
    class UIMesh* um;
    class Config* config;
    float timestep;
    class BillboardManager* bm;
    class ModelImageGenerator* mig;
};

#endif // NATIVE_DEFINITION_HELPERS_H_INCLUDED
