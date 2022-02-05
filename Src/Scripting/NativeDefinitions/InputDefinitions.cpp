#include "../NativeDefinitionRegistrar.h"

#include "../NativeDefinitionHelpers.h"

#include "../ScriptManager.h"

#include "../../Input/KeyBinds.h"
#include "../../Input/MouseData.h"

static void registerKey(asIScriptEngine& engine, const PGE::String& name, PGE::KeyboardInput* input) {
    engine.SetDefaultNamespace(("Input::" + name).cstr());
    engine.RegisterGlobalFunction("bool isDown()", asMETHOD(PGE::KeyboardInput, isDown), asCALL_THISCALL_ASGLOBAL, input);
    engine.RegisterGlobalFunction("bool isHit()", asMETHOD(PGE::KeyboardInput, isHit), asCALL_THISCALL_ASGLOBAL, input);
}

static void registerInputDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers& helpers) {
    engine.RegisterEnum("Input");

    engine.RegisterEnumValue("Input", "None", (int)Input::NONE);
    engine.RegisterEnumValue("Input", "Forward", (int)Input::FORWARD);
    engine.RegisterEnumValue("Input", "Backward", (int)Input::BACKWARD);
    engine.RegisterEnumValue("Input", "Left", (int)Input::LEFT);
    engine.RegisterEnumValue("Input", "Right", (int)Input::LEFT);
    engine.RegisterEnumValue("Input", "Crouch", (int)Input::CROUCH);
    engine.RegisterEnumValue("Input", "Blink", (int)Input::BLINK);
    engine.RegisterEnumValue("Input", "Interact", (int)Input::INTERACT);

    engine.RegisterEnumValue("Input", "Inventory", (int)Input::INVENTORY);
    engine.RegisterEnumValue("Input", "ToggleSiteNavigator", (int)Input::TOGGLE_SITE_NAVIGATOR);
    engine.RegisterEnumValue("Input", "ToggleRadio", (int)Input::TOGGLE_RADIO);

    engine.RegisterEnumValue("Input", "ToggleConsole", (int)Input::TOGGLE_CONSOLE);

    engine.SetDefaultNamespace("Input::Mouse1");
    engine.RegisterGlobalFunction("int getClickCount()", asMETHOD(PGE::MouseInput, getClickCount), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds->mouse1);
    engine.RegisterGlobalFunction("bool isHit()", asMETHOD(PGE::MouseInput, isHit), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds->mouse1);
    engine.RegisterGlobalFunction("bool isDown()", asMETHOD(PGE::MouseInput, isDown), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds->mouse1);

    engine.SetDefaultNamespace("Input");
    engine.RegisterGlobalFunction("Input getDown()", asMETHOD(KeyBinds, getDownInputs), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);
    engine.RegisterGlobalFunction("Input getHit()", asMETHOD(KeyBinds, getHitInputs), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);

    engine.RegisterGlobalFunction("bool anyShiftDown()", asMETHOD(KeyBinds, anyShiftDown), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);
    engine.RegisterGlobalFunction("bool anyShortcutDown()", asMETHOD(KeyBinds, anyShortcutDown), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);

    engine.RegisterGlobalFunction("bool selectAllIsHit()", asMETHOD(KeyBinds, selectAllIsHit), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);

    engine.RegisterGlobalFunction("bool copyIsHit()", asMETHOD(KeyBinds, copyIsHit), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);
    engine.RegisterGlobalFunction("bool pasteIsHit()", asMETHOD(KeyBinds, pasteIsHit), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);
    engine.RegisterGlobalFunction("bool cutIsHit()", asMETHOD(KeyBinds, cutIsHit), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);

    engine.RegisterGlobalFunction("bool undoIsHit()", asMETHOD(KeyBinds, undoIsHit), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);
    engine.RegisterGlobalFunction("bool redoIsHit()", asMETHOD(KeyBinds, redoIsHit), asCALL_THISCALL_ASGLOBAL, helpers.keyBinds);

    engine.RegisterGlobalFunction("void startTextInputCapture()", asMETHOD(PGE::InputManager, startTextInputCapture), asCALL_THISCALL_ASGLOBAL, helpers.inputManager);
    engine.RegisterGlobalFunction("void stopTextInputCapture()", asMETHOD(PGE::InputManager, stopTextInputCapture), asCALL_THISCALL_ASGLOBAL, helpers.inputManager);
    engine.RegisterGlobalFunction("const string& getTextInput()", asMETHOD(PGE::InputManager, getTextInput), asCALL_THISCALL_ASGLOBAL, helpers.inputManager);

    engine.RegisterGlobalFunction("void setClipboardText(string str)", asMETHOD(PGE::InputManager, setClipboardText), asCALL_THISCALL_ASGLOBAL, helpers.inputManager);
    engine.RegisterGlobalFunction("string getClipboardText()", asMETHOD(PGE::InputManager, getClipboardText), asCALL_THISCALL_ASGLOBAL, helpers.inputManager);

    engine.RegisterGlobalFunction("const Vector2f& getMousePosition()", asMETHOD(MouseData , getPosition), asCALL_THISCALL_ASGLOBAL, helpers.mouseData);
    engine.RegisterGlobalFunction("const Vector2f& getMouseDelta()", asMETHOD(MouseData, getDelta), asCALL_THISCALL_ASGLOBAL, helpers.mouseData);
    engine.RegisterGlobalFunction("const Vector2f& getMouseWheelDelta()", asMETHOD(MouseData, getWheelDelta), asCALL_THISCALL_ASGLOBAL, helpers.mouseData);

    registerKey(engine, "Escape", helpers.keyBinds->escape);
    registerKey(engine, "Backspace", helpers.keyBinds->backspace);
    registerKey(engine, "Delete", helpers.keyBinds->del);
    registerKey(engine, "UpArrow", helpers.keyBinds->upArrow);
    registerKey(engine, "DownArrow", helpers.keyBinds->downArrow);
    registerKey(engine, "LeftArrow", helpers.keyBinds->leftArrow);
    registerKey(engine, "RightArrow", helpers.keyBinds->rightArrow);
    registerKey(engine, "Enter", helpers.keyBinds->enter);
}

static NativeDefinitionRegistrar _ { &registerInputDefinitions, NativeDefinitionDependencyFlagBits::MATH };
