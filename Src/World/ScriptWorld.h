#ifndef SCRIPTWORLD_H_INCLUDED
#define SCRIPTWORLD_H_INCLUDED

#include <IO/IO.h>

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
        EventDefinition* perEveryTickEventDefinition;
        EventDefinition* perTickMenuEventDefinition;
        EventDefinition* perLoadTickEventDefinition;

        EventDefinition* perFrameGameEventDefinition;
        EventDefinition* perMenuFrameEventDefinition;
        EventDefinition* perEveryFrameEventDefinition;
        EventDefinition* perLoadFrameEventDefinition;

        EventDefinition* resolutionChangedEventDefinition;

        std::vector<ScriptModule*> modules;
        World* gameWorld;

    public:
        ScriptWorld(World* world, GraphicsResources* gfxRes, Camera* camera, KeyBinds* keyBinds, MouseData* mouseData, PGE::IO* io, LocalizationManager* lm, PickableManager* pm, UIMesh* um,  Config* config, BillboardManager* bm, ModelImageGenerator* mig);
        ~ScriptWorld();

        void updateTick(uint32_t tick,float interp);
        void updateEveryTick(uint32_t tick, float interp);
        void updateLoadTick(float interp);

        void updateFrame(float interp);
        void updateMenuFrame(float interp);
        void updateLoadFrame(float interp);
        void updateEveryFrame(float interp);
        void updateResolution(int newWidth, int newHeight);
};

#endif // SCRIPTWORLD_H_INCLUDED
