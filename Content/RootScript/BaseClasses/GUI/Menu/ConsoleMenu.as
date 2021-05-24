namespace ConsoleMenu {
    shared ConsoleMenu@ instance = ConsoleMenu();
    shared const float lineHeight = Font::large.getHeight(GUIText::defaultScale) + 1.f;
}

namespace Console {
    shared void addMessage(const string&in msg, const Color&in color = Color::White) {
        ConsoleMenu::instance.addConsoleMessage(msg, color);
    }
}

shared class ConsoleMenu : Menu {
    private GUIFrame@ frame;
    private GUITextInput@ input;
    private GUIScrollbar@ scrollbar;

    private int commandHistoryIndex = -1;
    private array<string> commandHistory;
    private array<GUIText@> messageHistory;
    private float scrollOffset = 0.f;

    private float firstMessagePosition;

    ConsoleMenu() {
        super("console");
        float frameX = -GUIComponent::SCALE_MAGNITUDE * UI::getAspectRatio();
        float frameWidth = GUIComponent::SCALE_MAGNITUDE * 2.f * UI::getAspectRatio();

        @frame = GUIFrame(this, frameX, -GUIComponent::SCALE_MAGNITUDE, frameWidth, GUIComponent::SCALE_MAGNITUDE);
        @input = GUITextInput(this, frameX, 0, frameWidth, 5.f, true);
        @scrollbar = GUIScrollbar(this, GUIComponent::SCALE_MAGNITUDE * UI::getAspectRatio() - 5.f, -GUIComponent::SCALE_MAGNITUDE + GUIComponent::borderThickness, 5.f, GUIComponent::SCALE_MAGNITUDE - GUIComponent::borderThickness * 2);
        scrollbar.sourceDisplayedSize = GUIComponent::SCALE_MAGNITUDE - GUIComponent::borderThickness * 4.f;

        firstMessagePosition = -Font::large.getHeight(GUIText::defaultScale) - GUIComponent::borderThickness * 2;
    }

    private void updateCoordinates() {
        scrollOffset = Math::minFloat(0.f, scrollOffset + Input::getMouseWheelDelta().y); // TODO: Scale this with window size to prevent weird edge behavior?
        scrollbar.sourceTotalSize = messageHistory.length() * ConsoleMenu::lineHeight;
        scrollbar.position = -scrollOffset; // TODO: Replace with inout func?
        scrollOffset = -scrollbar.position;
        float currentHeight = firstMessagePosition - scrollOffset;
        float lowestPoint = -Font::large.getHeight(GUIText::defaultScale) - GUIComponent::borderThickness * 2;
        float highestPoint = -GUIComponent::SCALE_MAGNITUDE + GUIComponent::borderThickness * 2;
        for (int i = messageHistory.length() - 1; i >= 0; i--) {
            if (currentHeight <= lowestPoint && currentHeight >= highestPoint) {
                messageHistory[i].active = true;
                messageHistory[i].y = currentHeight;
            } else {
                messageHistory[i].active = false;
            }
            currentHeight -= ConsoleMenu::lineHeight;
        }
    }

    void addConsoleMessage(const string&in msg, const Color&in color) {
        GUIText@ newText = GUIText(this, -GUIComponent::SCALE_MAGNITUDE * UI::getAspectRatio() + GUIComponent::borderThickness * 2, 0, false, false, false);
        newText.text = msg;
        newText.color = color;
        messageHistory.insertLast(newText);
        if (@GUITextInput::subscriber == @input) {
            updateCoordinates();
        }
    }

    void clear() {
        components = array<GUIComponent@>(0);
        messageHistory = array<GUIText@>(0);
        components.insertLast(frame);
        components.insertLast(input);
        components.insertLast(scrollbar);
        // TODO: Reinitialize input properly.
    }

    void onActivate() override {
        input.select();
        updateCoordinates();
    }

    void onDeactivate() override {
        input.deselect();
    }

    bool onEscapeHit() override {
        return true;
    }

    bool update() override {
        if (Input::Enter::isHit() && input.txt != "") {
            addConsoleMessage("> " + input.txt, Color::Yellow);

            Console::execute(input.txt);
            commandHistory.insertLast(input.txt);
            commandHistoryIndex = -1;

            input.clearTextAndMementos();
        }
        if (Input::UpArrow::isHit() || Input::DownArrow::isHit()) {
            commandHistoryIndex += Input::UpArrow::isHit() ? -1 : 1;
            if (commandHistoryIndex < -1) {
                commandHistoryIndex = commandHistory.length() - 1;
            } else if (commandHistoryIndex >= commandHistory.length()) {
                commandHistoryIndex = -1;
            }
            if (commandHistoryIndex >= 0) {
                input.txt = commandHistory[commandHistoryIndex];
            } else {
                input.txt = "";
            }
        }
        if (Input::getMouseWheelDelta().y != 0.0) {
            updateCoordinates();
        }
        return Input::getHit() & Input::ToggleConsole != 0;
    }
}
