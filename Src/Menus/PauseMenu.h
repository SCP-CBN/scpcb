#ifndef PAUSEMENU_H_INCLUDED
#define PAUSEMENU_H_INCLUDED

#include "Menu.h"
#include "GUI/GUIButton.h"
#include "GUI/GUIFrame.h"
#include "GUI/GUITextInput.h"
#include "GUI/GUIText.h"
#include "../Graphics/Font.h"

class TxtManager;
class World;

class PauseMenu : public Menu {
    private:
        enum class SubState {
            Main,
            NewGame,
            LoadGame,
            Options,
            Quitting
        };

        // Whether the pause menu is being shown on startup as oppose to in the middle of a game.
        bool mainMenu;

        enum class OptionsTab {
            Graphics,
            Audio,
            Controls,
            Gameplay
        };

        SubState currState;
        OptionsTab currOptionsTab;

        void setState(SubState state);
        void setOptionsTab(OptionsTab tab);

        // --Buttons.

        // Main state.
        GUIButton* newgame;
        GUIButton* loadgame;
        GUIButton* options;
        GUIButton* quit;

        // Quitting state.
        GUIFrame* quitFrame;
        GUIButton* quitYes;
        GUIButton* quitNo;
        GUIText* quitText;

        UIMesh* uiMesh;
        Font* largeFont;
        KeyBinds* keyBinds;

    public:
        PauseMenu(World* wrld, UIMesh* um, Font* largeFnt, KeyBinds* kb, Config* con, TxtManager* tm, PGE::IO* io);

        void onEscapeHit() override;

        void update(const PGE::Vector2f& mousePosition, const PGE::Vector2i& mouseWheelDelta) override;
        void render() const override;

        GUITextInput* inputTest; //TODO: remove
};

#endif // PAUSEMENU_H_INCLUDED
