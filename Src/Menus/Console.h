#ifndef CONSOLE_H_INCLUDED
#define CONSOLE_H_INCLUDED

#include <IO/IO.h>
#include <Color/Color.h>
#include <stack>

#include "Menu.h"
#include "GUI/GUIText.h"
#include <angelscript.h>

class UIMesh;
class Font;
class KeyBinds;
class Config;
class TxtManager;
class GUIFrame;
class GUITextInput;

class Console;

class Command {
public:
    virtual PGE::String getName() const = 0;
    virtual PGE::String getHelpText() const = 0;
    virtual void execute(Console* console, const std::vector<PGE::String>& params) const = 0;
};

class Console : public Menu {
private:
    GUIFrame* frame;
    GUITextInput* input;

    class Message {
    private:
        float linePositionFromBottom;

    public:
        Message(UIMesh* um, KeyBinds* kb, Config* con, TxtManager* txtmng, Font* fnt, const PGE::String& resp, const PGE::Color& color);

        GUIText* text;

        void setLinePositionFromBottom(float line);

        static float lineHeight;
        static float bottomOfConsoleWindow;
    };

    std::vector<Message> messageHistory;
    void updateMessageWindow();

    int commandHistoryIndex;
    std::deque<PGE::String> commandHistory;

    int windowMaxLineCount;
    float windowScrollOffset;
    
    UIMesh* uiMesh;
    Font* font;
    KeyBinds* keyBinds;
    Config* config;
    TxtManager* txtMngt;

    std::vector<Command*> commands;
    void registerInternalCommands();

    void executeCommand(const PGE::String& in);

public:
    Console(World* wrld, UIMesh* um, Font* font, KeyBinds* kb, Config* con, TxtManager* tm, PGE::IO* io);
    ~Console();

    void update(const PGE::Vector2f& mousePosition, const PGE::Vector2i& mouseWheelDelta) override;
    void render() const override;

    void addConsoleMessage(const PGE::String& resp, const PGE::Color& color = PGE::Color::White);
    void logWarning(const PGE::String& resp);
    void logError(const PGE::String& resp);
    
    void showHelp(const PGE::String& com);
    void listCommands();
    void clear();

    void registerExternalCommand(const PGE::String& name, const PGE::String& helpText, asIScriptFunction* f, asIScriptContext* context);
};

#endif // CONSOLE_H_INCLUDED
