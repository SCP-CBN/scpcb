namespace PauseMenu {
    shared PauseMenu@ instance = PauseMenu();
    shared enum State {
        Main,
        Options,
        Quit
    }
}

shared class PauseMenu : Menu {
    private PauseMenu::State currState = PauseMenu::State::Main;

    GUIButton@ newGame;
    GUIButton@ loadGame;
    GUIButton@ options;
    GUIButton@ quit;
    GUITextInput@ testInput;

    GUIFrame@ quitFrame;
    GUIText@ quitText;
    GUIButton@ quitYes;
    GUIButton@ quitNo;

    PauseMenu() {
        super("pausemenu");

        const float btnWidth = 40.f;
        const float btnHeight = 7.f;

        const float btnSpacing = 10.f;
        const float btnX = -btnWidth / 2.f;
        float btnY = -40.f;

        @newGame = GUIButton(this, btnX, btnY, btnWidth, btnHeight, "MainMenu.NewGame");
        btnY += btnSpacing;
        @loadGame = GUIButton(this, btnX, btnY, btnWidth, btnHeight, "MainMenu.LoadGame");
        btnY += btnSpacing;
        @options = GUIButton(this, btnX, btnY, btnWidth, btnHeight, "MainMenu.Options");
        btnY += btnSpacing;
        @quit = GUIButton(this, btnX, btnY, btnWidth, btnHeight, "MainMenu.Quit");
        btnY += btnSpacing;
        @testInput = GUITextInput(this, btnX, btnY, btnWidth, btnHeight, false, 1000, "POGGERS");

        const float quitFrameWidth = 60.f;
        const float quitFrameHeight = 30.f;
        @quitFrame = GUIFrame(this, -quitFrameWidth / 2.f, -quitFrameHeight / 2.f, quitFrameWidth, quitFrameHeight);
        @quitText = GUIText(this, 0.f, -5.f, true, true, true);
        quitText.text = "MainMenu.Quit.Prompt";
        @quitYes = GUIButton(this, -25.f, 5.f, 12.f, 4.f, "MainMenu.Quit.Yes");
        @quitNo = GUIButton(this, 13.f, 5.f, 12.f, 4.f, "MainMenu.Quit.No");

        setState(PauseMenu::State::Main);
    }

    void setState(PauseMenu::State state) {
        newGame.locked = state != PauseMenu::State::Main;
        loadGame.locked = state != PauseMenu::State::Main;
        options.locked = state != PauseMenu::State::Main;
        quit.locked = state != PauseMenu::State::Main;

        quitFrame.active = state == PauseMenu::State::Quit;
        quitText.active = state == PauseMenu::State::Quit;
        quitYes.active = state == PauseMenu::State::Quit;
        quitNo.active = state == PauseMenu::State::Quit;

        currState = state;
    }

    bool onEscapeHit() override {
        switch (currState) {
            case PauseMenu::State::Main:
                return true;
            default:
                setState(PauseMenu::State::Main);
                return false;
        }
    }

    bool update() override {
        switch (currState) {
            case PauseMenu::State::Main:
                if (quit.getHit()) {
                    setState(PauseMenu::State::Quit);
                }
                break;
            case PauseMenu::State::Quit:
                if (quitNo.getHit()) {
                    setState(PauseMenu::State::Main);
                } else if (quitYes.getHit()) {
                    World::quit();
                }
                break;
        }
        return false;
    }
}
