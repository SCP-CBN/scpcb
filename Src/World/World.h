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

class World {
    private:
        bool oldPaused;

        enum class RenderType {
            All,
            NoUI,
            UIOnly
        };

        PGE::Graphics* graphics;
        PGE::IO* io;

        Camera* camera;

        KeyBinds* keyBinds;
        MouseData* mouseData;
        Config* config;
        Timing* timing;

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

        UIMesh* uiMesh;

        GraphicsResources* gfxRes;
        ModelImageGenerator* miGen;

        LocalizationManager* locMng;
        PickableManager* pickMng;
        BillboardManager* billMng;

        ScriptWorld* scripting;

        bool shutdownRequested;

        void applyConfig(const Config* config);

        //-- Update/Draw code.

        // Goes through the update phase of a single tick.
        void runTick(float timeStep);

        // Update code for GameState::Playing game state.
        void updatePlaying(float timeStep);
        // Draw code for GameState::Playing game state.
        void drawPlaying(float interpolation);

        // Goes through the draw phase.
        void draw(float interpolation, RenderType r);

    public:
        bool paused;

        World();
        ~World();

        // Goes through the update/draw phrase of a single frame.
        bool run();

        // Prompts the world object to kill itself.
        void quit();

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
