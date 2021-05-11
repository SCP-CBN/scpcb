#ifndef KEYBINDS_H_INCLUDED
#define KEYBINDS_H_INCLUDED

#include <unordered_map>

#include <IO/IO.h>
#include <UserInput/UserInput.h>
#include <String/Key.h>

#include "Input.h"

class ConsoleDefinitions;

class KeyBinds {
    private:
        // Inputs that are down for this tick.
        Input downInputs;

        // Inputs that are in the hit state for this tick.
        Input hitInputs;

        PGE::IO* io;
        ConsoleDefinitions* conDef;

        typedef std::unordered_multimap<Input, PGE::UserInput*> UserInputMap;
        UserInputMap bindings;

        typedef std::unordered_multimap<PGE::String::RedundantKey, PGE::UserInput*> ConsoleBindingsMap;
        ConsoleBindingsMap consoleBindings;

        void bindInput(Input input, PGE::UserInput* key);
        void unbindInput(Input input, PGE::UserInput::Device device, int key);

        std::unordered_map<PGE::String::Key, PGE::UserInput*> inputStrings;
        void registerInputString(const PGE::String& string, PGE::KeyboardInput::Keycode key);
        void registerInputString(const PGE::String& string, PGE::MouseInput::Button key);
        void registerInputString(const PGE::String& string, PGE::ControllerInput::Button key);

    public:
        KeyBinds(PGE::IO* inIo);
        ~KeyBinds();

        void setConsoleDefinitions(ConsoleDefinitions* inConDef);

        PGE::MouseInput* mouse1;
        PGE::MouseInput* mouse2;
        PGE::KeyboardInput* escape;

        // Text input keys.
        PGE::KeyboardInput* leftArrow;
        PGE::KeyboardInput* rightArrow;
        PGE::KeyboardInput* upArrow;
        PGE::KeyboardInput* downArrow;
        PGE::KeyboardInput* leftShift;
        PGE::KeyboardInput* rightShift;
        // Checks if any of the shift keys are held down.
        bool anyShiftDown() const;
        PGE::KeyboardInput* backspace;
        PGE::KeyboardInput* del;
        PGE::KeyboardInput* enter;

        // Shortcuts.
        PGE::KeyboardInput* leftShortcutKey;
        PGE::KeyboardInput* rightShortcutKey;
        // Checks if any of the shortcut keys are held down.
        bool anyShortcutDown() const;
        PGE::KeyboardInput* keyA;
        PGE::KeyboardInput* keyC;
        PGE::KeyboardInput* keyX;
        PGE::KeyboardInput* keyV;
        PGE::KeyboardInput* keyZ;
#ifndef __APPLE__
        PGE::KeyboardInput* keyY;
#endif

        bool copyIsHit() const;
        bool cutIsHit() const;
        bool pasteIsHit() const;
        bool undoIsHit() const;
        bool redoIsHit() const;
        bool selectAllIsHit() const;

        void bindInput(Input input, PGE::MouseInput::Button key);
        void bindInput(Input input, PGE::KeyboardInput::Keycode key);
        void bindInput(Input input, PGE::ControllerInput::Button key);
        void unbindInput(Input input, PGE::MouseInput::Button key);
        void unbindInput(Input input, PGE::KeyboardInput::Keycode key);
        void unbindInput(Input input, PGE::ControllerInput::Button key);

        void bindCommand(PGE::String command, PGE::UserInput* key);
        void unbindCommand(PGE::String command, PGE::UserInput* key);

        // Iterate through the keybinds and find out which ones fired this tick.
        void update();
        Input getDownInputs() const;
        Input getHitInputs() const;

        PGE::UserInput* stringToInput(const PGE::String& key) const;
};

#endif // KEYBINDS_H_INCLUDED
