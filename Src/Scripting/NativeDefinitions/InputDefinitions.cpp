#include "InputDefinitions.h"

#include "../ScriptManager.h"

#include "../../Input/KeyBinds.h"
#include "../../Input/MouseData.h"

InputDefinitions::InputDefinitions(ScriptManager* mgr, KeyBinds* kb, MouseData* md, PGE::IO* io) {
    engine = mgr->getAngelScriptEngine();

    keyBinds = kb;

    engine->RegisterEnum("Input");

    engine->RegisterEnumValue("Input", "None", (int)Input::NONE);
    engine->RegisterEnumValue("Input", "Forward", (int)Input::FORWARD);
    engine->RegisterEnumValue("Input", "Backward", (int)Input::BACKWARD);
    engine->RegisterEnumValue("Input", "Left", (int)Input::LEFT);
    engine->RegisterEnumValue("Input", "Right", (int)Input::LEFT);
    engine->RegisterEnumValue("Input", "Crouch", (int)Input::CROUCH);
    engine->RegisterEnumValue("Input", "Blink", (int)Input::BLINK);
    engine->RegisterEnumValue("Input", "Interact", (int)Input::INTERACT);

    engine->RegisterEnumValue("Input", "Inventory", (int)Input::INVENTORY);
    engine->RegisterEnumValue("Input", "ToggleSiteNavigator", (int)Input::TOGGLE_SITE_NAVIGATOR);
    engine->RegisterEnumValue("Input", "ToggleRadio", (int)Input::TOGGLE_RADIO);

    engine->RegisterEnumValue("Input", "ToggleConsole", (int)Input::TOGGLE_CONSOLE);

    engine->SetDefaultNamespace("Input::Mouse1");
    engine->RegisterGlobalFunction("int getClickCount()", asMETHOD(InputDefinitions, getClickCount), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("bool isHit()", asMETHOD(InputDefinitions, isHit), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("bool isDown()", asMETHOD(InputDefinitions, isDown), asCALL_THISCALL_ASGLOBAL, this);

    engine->SetDefaultNamespace("Input");
    engine->RegisterGlobalFunction("Input getDown()", asMETHOD(KeyBinds, getDownInputs), asCALL_THISCALL_ASGLOBAL, kb);
    engine->RegisterGlobalFunction("Input getHit()", asMETHOD(KeyBinds, getHitInputs), asCALL_THISCALL_ASGLOBAL, kb);

    engine->RegisterGlobalFunction("bool anyShiftDown()", asMETHOD(KeyBinds, anyShiftDown), asCALL_THISCALL_ASGLOBAL, kb);
    engine->RegisterGlobalFunction("bool anyShortcutDown()", asMETHOD(KeyBinds, anyShortcutDown), asCALL_THISCALL_ASGLOBAL, kb);

    engine->RegisterGlobalFunction("bool selectAllIsHit()", asMETHOD(KeyBinds, selectAllIsHit), asCALL_THISCALL_ASGLOBAL, kb);

    engine->RegisterGlobalFunction("bool copyIsHit()", asMETHOD(KeyBinds, copyIsHit), asCALL_THISCALL_ASGLOBAL, kb);
    engine->RegisterGlobalFunction("bool pasteIsHit()", asMETHOD(KeyBinds, pasteIsHit), asCALL_THISCALL_ASGLOBAL, kb);
    engine->RegisterGlobalFunction("bool cutIsHit()", asMETHOD(KeyBinds, cutIsHit), asCALL_THISCALL_ASGLOBAL, kb);

    engine->RegisterGlobalFunction("bool undoIsHit()", asMETHOD(KeyBinds, undoIsHit), asCALL_THISCALL_ASGLOBAL, kb);
    engine->RegisterGlobalFunction("bool redoIsHit()", asMETHOD(KeyBinds, redoIsHit), asCALL_THISCALL_ASGLOBAL, kb);

    engine->RegisterGlobalFunction("void startTextInputCapture()", asMETHOD(PGE::IO, startTextInputCapture), asCALL_THISCALL_ASGLOBAL, io);
    engine->RegisterGlobalFunction("void stopTextInputCapture()", asMETHOD(PGE::IO, stopTextInputCapture), asCALL_THISCALL_ASGLOBAL, io);
    engine->RegisterGlobalFunction("const string& getTextInput()", asMETHOD(PGE::IO, getTextInput), asCALL_THISCALL_ASGLOBAL, io);

    engine->RegisterGlobalFunction("void setClipboardText(string str)", asMETHOD(PGE::IO, setClipboardText), asCALL_THISCALL_ASGLOBAL, io);
    engine->RegisterGlobalFunction("string getClipboardText()", asMETHOD(PGE::IO, getClipboardText), asCALL_THISCALL_ASGLOBAL, io);

    engine->RegisterGlobalFunction("const Vector2f& getMousePosition()", asMETHOD(MouseData , getPosition), asCALL_THISCALL_ASGLOBAL, md);
    engine->RegisterGlobalFunction("const Vector2f& getMouseWheelDelta()", asMETHOD(MouseData, getWheelDelta), asCALL_THISCALL_ASGLOBAL, md);

    registerKey("Escape", kb->escape);
    registerKey("Backspace", kb->backspace);
    registerKey("Delete", kb->del);
    registerKey("UpArrow", kb->upArrow);
    registerKey("DownArrow", kb->downArrow);
    registerKey("LeftArrow", kb->leftArrow);
    registerKey("RightArrow", kb->rightArrow);
    registerKey("Enter", kb->enter);
}

void InputDefinitions::registerKey(const PGE::String& name, PGE::KeyboardInput* input) {
    engine->SetDefaultNamespace(("Input::" + name).cstr());
    engine->RegisterGlobalFunction("bool isDown()", asMETHOD(PGE::KeyboardInput, isDown), asCALL_THISCALL_ASGLOBAL, input);
    engine->RegisterGlobalFunction("bool isHit()", asMETHOD(PGE::KeyboardInput, isHit), asCALL_THISCALL_ASGLOBAL, input);
}

int InputDefinitions::getClickCount() const {
    return keyBinds->mouse1->getClickCount();
}

bool InputDefinitions::isHit() const {
    return keyBinds->mouse1->isHit();
}

bool InputDefinitions::isDown() const {
    return keyBinds->mouse1->isDown();
}
