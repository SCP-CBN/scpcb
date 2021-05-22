#ifndef WORLD_H_INCLUDED
#define WORLD_H_INCLUDED

#include <vector>
#include <ft2build.h>
#include FT_FREETYPE_H
#include <Graphics/Graphics.h>
#include <IO/IO.h>
#include <String/String.h>

class Camera;
class Config;
class Timing;
class GraphicsResources;
class ModelImageGenerator;
class Font;
class MessageManager;
class LocalizationManager;
class MouseData;
class KeyBinds;
class BillboardManager;
class PickableManager;
class ScriptWorld;
class UIMesh;
class SoundResources;

class World {
    private:

        // Private System interface
        PGE::Graphics* graphics;
        PGE::IO* io;
        Camera* camera;
        KeyBinds* keyBinds;
        MouseData* mouseData;
        Config* config;
        Timing* timing;
        UIMesh* uiMesh;

        // Private Fonts - There aren't many fonts, this can stay for the time being.
        FT_Library ftLibrary;
        Font* largeFont;
        Font* fontAppleLarge;
        Font* fontAppleSmall;
        Font* fontInconsolataLarge;
        Font* fontInconsolataSmall;
        Font* fontCrystalLarge;
        Font* fontCrystalSmall;
        Font* fontSubotypeLarge;
        Font* fontSubotypeSmall;
        Font* fontBoldLarge;
        Font* fontBoldSmall;

        // Private ScriptWorld resources
        GraphicsResources* gfxRes;
        ModelImageGenerator* miGen;
        LocalizationManager* locMng;
        PickableManager* pickMng;
        BillboardManager* billMng;
        SoundResources* sndRes;

        // Private ScriptWorld
        ScriptWorld* scripting;
        bool shutdownRequested;

        void applyConfig(const Config* config);


        // Ticking

        void startFrame(float sinceLast);
        void runEveryFrame(float sinceLast);
        void runMenuFrame(float sinceLast);
        void runLoadFrame(float sinceLast);
        void runFrame(float sinceLast);

        void startTick(float sinceLast);
        void runTick(uint32_t tick, float sinceLast);
        void runLoadTick(float sinceLast);
        void runEveryTick(uint32_t tick, float sinceLast);

        //const char** loadMessage;
        //const char** loadPart;

        PGE::Vector2f gameMousePos;
        PGE::Vector2f menuMousePos;
        void applyCameraMouseMovement(PGE::Vector2f mousePos);
        float camInterp = 0.f;


    public:
        // ScriptWorld :: Environment global properties
        bool paused;
        bool loading;
        int loadState;
        int loadMax;
        int loadDone;

        //const char** getLoadMessage();
        //const char** getLoadPart();
        //void setLoadMessage(PGE::String* msg);
        //void setLoadPart(PGE::String* msg);

        uint32_t tick;

        World();
        ~World();

        // Main infinite loop
        bool run();

        // Queue exit program to desktop
        void quit();

        // Tick timing and frame timing environment
        int getTickRate() const;
        int getFrameRate() const;
        float getAvgTickRate() const;
        float getAvgFrameRate() const;
        void setTickRate(int rate);
        void setFrameRate(int rate);



        // Fonts
        Font* getFont() const;
        Font* getFontAppleLarge() const;
        Font* getFontAppleSmall() const;
        Font* getFontInconsolataLarge() const;
        Font* getFontInconsolataSmall() const;
        Font* getFontCrystalLarge() const;
        Font* getFontCrystalSmall() const;
        Font* getFontSubotypeLarge() const;
        Font* getFontSubotypeSmall() const;
        Font* getFontBoldLarge() const;
        Font* getFontBoldSmall() const;
};

#endif // WORLD_H_INCLUDED
