#include "Console.h"
#include "../Save/Config.h"
#include "GUI/GUIComponent.h"
#include "GUI/GUIFrame.h"
#include "GUI/GUITextInput.h"
#include "../Utils/MathUtil.h"
#include "../Scripting/NativeDefinitions/ConsoleDefinitions.h"

float Console::Message::lineHeight;
float Console::Message::bottomOfConsoleWindow;

Console::Console(World* wrld, UIMesh* um, Font* font, KeyBinds* kb, Config* con, TxtManager* tm, PGE::IO* io) : Menu(wrld, "console") {
    //TODO: Figure out alignment issues and simplify this.
    float frameX = -GUIComponent::SCALE_MAGNITUDE * con->getAspectRatio();
    float frameY = -GUIComponent::SCALE_MAGNITUDE + 2.f;
    float frameWidth = GUIComponent::SCALE_MAGNITUDE * 2.f * con->getAspectRatio();
    float frameHeight = GUIComponent::SCALE_MAGNITUDE;
    frame = new GUIFrame(um, kb, con, frameX, frameY, frameWidth, frameHeight);

    float inputY = frameY + frameHeight;
    input = new GUITextInput(um, font, kb, con, io, frameX, inputY, frameWidth, 5.f, true);

    windowMaxLineCount = (int) ((frameHeight - 3.f) / (font->getHeight() / con->getHeight() * GUIComponent::SCALE_MAGNITUDE + 2.f));

    Message::lineHeight = (font->getHeight() / con->getHeight() * frameHeight + 2.f);
    Message::bottomOfConsoleWindow = windowMaxLineCount * Message::lineHeight + 1.f;
    commandHistoryIndex = -1;

    windowScrollOffset = 0.f;
    txtMngt = tm;

    this->uiMesh = um;
    this->font = font;
    this->keyBinds = kb;
    this->config = con;

    registerInternalCommands();
}

Console::~Console() {
    for (int i = 0; i < (int)commands.size(); i++) {
        delete commands[i];
    }
}

void Console::update(const PGE::Vector2f& mousePosition, const PGE::Vector2i& mouseWheelDelta) {
    input->update(mousePosition);

    bool windowChanged = false;
    if (keyBinds->enter->isHit() && !input->getText().equals("")) {
        executeCommand(input->getText());
        input->clearTextAndMementos();

        windowChanged = true;
    }

    if (keyBinds->upArrow->isHit() || keyBinds->downArrow->isHit()) {
        int newIndex = keyBinds->upArrow->isHit() ? commandHistoryIndex + 1 : commandHistoryIndex - 1;
        if (newIndex < -1) {
            commandHistoryIndex = (int)commandHistory.size() - 1;
        } else if (newIndex >= commandHistory.size()) {
            commandHistoryIndex = -1;
        } else {
            commandHistoryIndex = newIndex;
        }

        if (commandHistoryIndex > -1) {
            input->setText(commandHistory[commandHistoryIndex]);
        } else {
            input->setText("");
        }
        windowChanged = true;
    }

    if (mouseWheelDelta.y != 0) {
        //Scroll only in the area of existing messages available.
        windowScrollOffset = MathUtil::clampFloat(
                windowScrollOffset + (mouseWheelDelta.y * 0.3f),
                (float)-MathUtil::maxInt(0, (int)messageHistory.size() - windowMaxLineCount),
                0.f);
        windowChanged = true;
    }

    if (windowChanged) {
        updateMessageWindow();
    }
}

void Console::render() const {
    uiMesh->startRender();

    frame->render();
    input->render();

    int lowestDrawn = (int)messageHistory.size() - MathUtil::floor(MathUtil::absFloat(windowScrollOffset));
    for (int i = MathUtil::maxInt(0, lowestDrawn - windowMaxLineCount); i < lowestDrawn; i++) {
        messageHistory[i].text->render();
    }

    uiMesh->endRender();
}

void Console::executeCommand(const PGE::String& in) {
    commandHistoryIndex = -1;
    addConsoleMessage("> " + in, PGE::Color::Yellow);
    commandHistory.push_front(in);

    std::vector<PGE::String> vect = in.split(" ", true);
    PGE::String command = vect[0];
    vect.erase(vect.begin());
    for (int i = 0; i < (int)commands.size(); i++) {
        if (command.equalsIgnoreCase(commands[i]->getName())) {
            commands[i]->execute(this, vect);
            return;
        }
    }
    addConsoleMessage("No command found", PGE::Color::Red);
}

Console::Message::Message(UIMesh* um, KeyBinds* kb, Config* con, TxtManager* txtmng, Font* fnt, const PGE::String& resp, const PGE::Color& color) {
    text = new GUIText(um, kb, con, txtmng, fnt, 3.f / con->getAspectRatio(), 0.f, Alignment::Left | Alignment::Top);
    text->rt = { resp, color };
}

void Console::Message::setLinePositionFromBottom(float line) {
    linePositionFromBottom = line;
    text->setY(bottomOfConsoleWindow - line * lineHeight);
}

void Console::addConsoleMessage(const PGE::String& resp, const PGE::Color& color) {
    messageHistory.push_back(Message(uiMesh, keyBinds, config, txtMngt, font, resp, color));
    updateMessageWindow();
    windowScrollOffset = 0;
}

void Console::logWarning(const PGE::String& resp) {
    addConsoleMessage(resp, PGE::Color::Yellow);
}

void Console::logError(const PGE::String& resp) {
    addConsoleMessage(resp, PGE::Color::Red);
}

void Console::updateMessageWindow() {
    for (int i = 0; i < messageHistory.size(); i++) {
        messageHistory[i].setLinePositionFromBottom(windowScrollOffset + messageHistory.size()-1-i);
    }
}

void Console::showHelp(const PGE::String& com) {
    for (int i = 0; i < (int)commands.size(); i++) {
        if (com.equals(commands[i]->getName())) {
            addConsoleMessage(commands[i]->getHelpText());
        }
    }
}

void Console::listCommands() {
    for (int i = 0; i < (int)commands.size(); i++) {
        addConsoleMessage(commands[i]->getName());
    }
}

void Console::clear() {
    messageHistory.clear();
    commandHistory.clear();
    commandHistoryIndex = 0;
    updateMessageWindow();
}

class HelpCommand : public Command {
public:
    PGE::String getName() const override {
        return "help";
    }

    PGE::String getHelpText() const override {
        return "Provides a description of a specified command. Use it with no parameters to list all commands.";
    }

    void execute(Console* console, const std::vector<PGE::String>& params) const override {
        if (params.size() > 0) {
            console->showHelp(params.front());
        }
        else {
            console->listCommands();
        }
    }
};

class ClearCommand : public Command {
public:
    PGE::String getName() const override {
        return "clear";
    }

    PGE::String getHelpText() const override {
        return "Clears the console.";
    }

    void execute(Console* console, const std::vector<PGE::String>& params) const override {
        console->clear();
    }
};

class JorgeCommand : public Command {
public:
    PGE::String getName() const override {
        return "jorge";
    }

    PGE::String getHelpText() const override {
        return "There is no help available for that command.";
    }

    void execute(Console* console, const std::vector<PGE::String>& params) const override {
        const char j[] = { 74, 111, 114, 103, 101, 32, 104, 97, 115, 32, 98, 101, 101, 110, 32, 101, 120, 112, 101, 99, 116, 105, 110, 103, 32, 121, 111, 117, 46, 0 };
        console->addConsoleMessage(j, PGE::Color::Orange);
    }
};

void Console::registerInternalCommands() {
    commands.push_back(new HelpCommand());
    commands.push_back(new ClearCommand());
    commands.push_back(new JorgeCommand());
}

class ScriptCommand : public Command {
private:
    asIScriptFunction* func;
    asIScriptContext* scriptContext;

    const PGE::String name;
    const PGE::String helpText;

public:
    bool duplicateName = false;

    ScriptCommand(const PGE::String& nm, const PGE::String& ht, asIScriptFunction* f, asIScriptContext* context) : name(nm), helpText(ht) {
        func = f;
        scriptContext = context;
    }

    PGE::String getName() const override {
        if (duplicateName) {
            return PGE::String(func->GetModuleName()) + ":" + name;
        } else {
            return name;
        }
    }

    PGE::String getHelpText() const override {
        return helpText.isEmpty() ? "No help available for this command." : helpText;
    }

    void execute(Console* console, const std::vector<PGE::String>& params) const override {
        if (func->GetParamCount() != params.size()) {
            console->addConsoleMessage("ARGUMENT SIZE MISMATCH", PGE::Color::Red);
            return;
        }
        if (scriptContext->Prepare(func) < 0) { throw std::runtime_error("ptooey! 2"); }
        PGE::String errMsg;
        for (unsigned int i = 0; i < func->GetParamCount(); i++) {
            int paramTypeId;
            if (func->GetParam(i, &paramTypeId) >= 0) {
                if (paramTypeId == asTYPEID_BOOL) {
                    if (params[i].toLower().equals("true") || params[i].equals("1")) {
                        scriptContext->SetArgByte(i, 1);
                    } else if (params[i].toLower().equals("false") || params[i].equals("0")) {
                        scriptContext->SetArgByte(i, 0);
                    } else {
                        errMsg = "NOT BOOL";
                        break;
                    }
                } else if (paramTypeId == asTYPEID_INT32) {
                    bool success;
                    int arg = params[i].toInt(success);
                    if (!success) {
                        errMsg = "NOT INT";
                        break;
                    }

                    // If the user enters a float.
                    if (!MathUtil::equalFloats((float)arg, params[i].toFloat())) {
                        console->addConsoleMessage("Loss of data!", PGE::Color::Yellow);
                    }

                    scriptContext->SetArgDWord(i, arg);
                } else if (paramTypeId == asTYPEID_FLOAT) {
                    bool success;
                    float arg = params[i].toFloat(success);
                    if (!success) {
                        errMsg = "NOT FLOAT";
                        break;
                    }

                    scriptContext->SetArgFloat(i, arg);
                } else if (paramTypeId == scriptContext->GetEngine()->GetStringFactoryReturnTypeId()) {
                    scriptContext->SetArgObject(i, (void*) &(params[i]));
                }
            } else {
                throw std::runtime_error("ptooey! 3");
            }
        }

        if (errMsg.isEmpty()) {
            scriptContext->Execute();
        } else {
            console->addConsoleMessage(errMsg, PGE::Color::Red);
        }
        scriptContext->Unprepare();
    }
};

void Console::registerExternalCommand(const PGE::String& name, const PGE::String& helpText, asIScriptFunction* f, asIScriptContext* context) {
    for (unsigned int i = 0; i < f->GetParamCount(); i++) {
        int paramTypeId;
        if (f->GetParam(i, &paramTypeId) < 0) {
            throw std::runtime_error("ptooey?");
        } else {
            if (paramTypeId != asTYPEID_BOOL && paramTypeId != asTYPEID_INT32 && paramTypeId != asTYPEID_FLOAT && paramTypeId != context->GetEngine()->GetStringFactoryReturnTypeId()) {
                throw std::runtime_error("STINKY INVALID TYPE");
            }
        }
    }
    ScriptCommand* newCommand = new ScriptCommand(name, helpText, f, context);
    ScriptCommand* otherCommand;
    for (int i = 0; i < commands.size(); i++) {
        otherCommand = dynamic_cast<ScriptCommand*>(commands[i]);
        if (otherCommand != nullptr) {
            // This will also catch a command that already has had its name changed.
            if (otherCommand->getName().equalsIgnoreCase(otherCommand->duplicateName ? PGE::String(f->GetModuleName()) + ":" + name : name)) {
                otherCommand->duplicateName = true;
                newCommand->duplicateName = true;
                if (otherCommand->getName().equalsIgnoreCase(newCommand->getName())) { throw std::runtime_error("lol double command"); }
                break;
            }
        } else if (commands[i]->getName().equalsIgnoreCase(name)) { //Check if name is occupied by a vanilla command.
            newCommand->duplicateName = true;
        }
    }
    commands.push_back(newCommand);
}
