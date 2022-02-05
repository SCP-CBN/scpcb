#ifndef SCRIPTWORLD_H_INCLUDED
#define SCRIPTWORLD_H_INCLUDED

#include <PGE/Input/InputManager.h>

#include "../Scripting/NativeDefinitionHelpers.h"

class ScriptManager;

class EventDefinition;
class NativeDefinition;

class ScriptModule;
class World;
class GraphicsResources;
class KeyBinds;
class MouseData;
class Config;
class Camera;
class UIMesh;
class LocalizationManager;
class PickableManager;
class BillboardManager;
class ModelImageGenerator;
class RefCounterManager;

class ScriptWorld {
    private:
        ScriptManager* manager;

        RefCounterManager* refCounterManager;

        std::vector<NativeDefinition*> nativeDefs;

        EventDefinition* perTickEventDefinition;
        EventDefinition* perFrameGameEventDefinition;
        EventDefinition* perFrameMenuEventDefinition;

        std::vector<ScriptModule*> modules;

    public:
        ScriptWorld(const NativeDefinitionsHelpers& helpers);
        ~ScriptWorld();

        void update(float timeStep);
        void drawGame(float interpolation);
        void drawMenu(float interpolation);
};

#endif // SCRIPTWORLD_H_INCLUDED
