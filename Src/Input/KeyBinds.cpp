#include "KeyBinds.h"

#include "../Scripting/NativeDefinitions/ConsoleDefinitions.h"

KeyBinds::KeyBinds(PGE::IO* inIo) {
    downInputs = Input::NONE;
    hitInputs = Input::NONE;

    io = inIo;

    mouse1 = new PGE::MouseInput(PGE::MouseInput::Button::LEFT);
    mouse2 = new PGE::MouseInput(PGE::MouseInput::Button::RIGHT);

    escape = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::ESCAPE);
    leftArrow = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::LEFT);
    rightArrow = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::RIGHT);
    upArrow = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::UP);
    downArrow = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::DOWN);
    leftShift = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::LSHIFT);
    rightShift = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::RSHIFT);
    backspace = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::BACKSPACE);
    del = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::DELETE);
    enter = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::RETURN);

#ifdef __APPLE__
    leftShortcutKey = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::LGUI);
    rightShortcutKey = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::RGUI);
#else
    leftShortcutKey = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::LCTRL);
    rightShortcutKey = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::RCTRL);
#endif
    keyA = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::A);
    keyC = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::C);
    keyX = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::X);
    keyV = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::V);
    keyZ = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::Z);
#ifndef __APPLE__
    keyY = new PGE::KeyboardInput(PGE::KeyboardInput::Keycode::Y);
#endif

    io->trackInput(mouse1);
    io->trackInput(mouse2);
    io->trackInput(escape);
    io->trackInput(leftArrow);
    io->trackInput(rightArrow);
    io->trackInput(upArrow);
    io->trackInput(downArrow);
    io->trackInput(leftShift);
    io->trackInput(rightShift);
    io->trackInput(backspace);
    io->trackInput(del);
    io->trackInput(enter);
    io->trackInput(leftShortcutKey);
    io->trackInput(rightShortcutKey);
    io->trackInput(keyA);
    io->trackInput(keyC);
    io->trackInput(keyX);
    io->trackInput(keyV);
    io->trackInput(keyZ);
#ifndef __APPLE__
    io->trackInput(keyY);
#endif

    // TODO: Add more | change style?
    registerInputString("key_q", PGE::KeyboardInput::Keycode::Q);
    registerInputString("key_w", PGE::KeyboardInput::Keycode::W);
    registerInputString("key_e", PGE::KeyboardInput::Keycode::E);
    registerInputString("key_r", PGE::KeyboardInput::Keycode::R);
    registerInputString("key_t", PGE::KeyboardInput::Keycode::T);
    registerInputString("key_z", PGE::KeyboardInput::Keycode::Z);
    registerInputString("key_u", PGE::KeyboardInput::Keycode::U);
    registerInputString("key_i", PGE::KeyboardInput::Keycode::I);
    registerInputString("key_o", PGE::KeyboardInput::Keycode::O);
    registerInputString("key_p", PGE::KeyboardInput::Keycode::P);
    registerInputString("key_a", PGE::KeyboardInput::Keycode::A);
    registerInputString("key_s", PGE::KeyboardInput::Keycode::S);
    registerInputString("key_d", PGE::KeyboardInput::Keycode::D);
    registerInputString("key_f", PGE::KeyboardInput::Keycode::F);
    registerInputString("key_g", PGE::KeyboardInput::Keycode::G);
    registerInputString("key_h", PGE::KeyboardInput::Keycode::H);
    registerInputString("key_j", PGE::KeyboardInput::Keycode::J);
    registerInputString("key_k", PGE::KeyboardInput::Keycode::K);
    registerInputString("key_l", PGE::KeyboardInput::Keycode::L);
    registerInputString("key_y", PGE::KeyboardInput::Keycode::Y);
    registerInputString("key_x", PGE::KeyboardInput::Keycode::X);
    registerInputString("key_c", PGE::KeyboardInput::Keycode::C);
    registerInputString("key_v", PGE::KeyboardInput::Keycode::V);
    registerInputString("key_b", PGE::KeyboardInput::Keycode::B);
    registerInputString("key_n", PGE::KeyboardInput::Keycode::N);
    registerInputString("key_m", PGE::KeyboardInput::Keycode::M);
}

KeyBinds::~KeyBinds() {
    io->untrackInput(mouse1);
    io->untrackInput(mouse2);
    io->untrackInput(escape);
    io->untrackInput(leftArrow);
    io->untrackInput(rightArrow);
    io->untrackInput(upArrow);
    io->untrackInput(downArrow);
    io->untrackInput(leftShift);
    io->untrackInput(rightShift);
    io->untrackInput(backspace);
    io->untrackInput(del);
    io->untrackInput(enter);
    io->untrackInput(leftShortcutKey);
    io->untrackInput(rightShortcutKey);
    io->untrackInput(keyA);
    io->untrackInput(keyC);
    io->untrackInput(keyX);
    io->untrackInput(keyV);
    io->untrackInput(keyZ);
#ifndef __APPLE__
    io->untrackInput(keyY);
#endif

    delete mouse1; delete mouse2; delete escape;
    delete leftArrow; delete rightArrow; delete upArrow; delete downArrow; delete leftShift; delete rightShift;
    delete backspace; delete del;
    delete leftShortcutKey; delete rightShortcutKey;
    delete keyA; delete keyC; delete keyX; delete keyV; delete keyZ;
#ifndef __APPLE__
    delete keyY;
#endif

    // Untrack and delete bindings map.
    UserInputMap::iterator it;
    for (it = bindings.begin(); it != bindings.end(); it++) {
        io->untrackInput(it->second);
        delete it->second;
    }

    for (const auto& it : inputStrings) {
        delete it.second;
    }
}

void KeyBinds::setConsoleDefinitions(ConsoleDefinitions* inConDef) {
    conDef = inConDef;
}

void KeyBinds::registerInputString(const PGE::String& string, PGE::KeyboardInput::Keycode key) {
    inputStrings.emplace(string, new PGE::KeyboardInput(key));
}

void KeyBinds::registerInputString(const PGE::String& string, PGE::MouseInput::Button key) {
    inputStrings.emplace(string, new PGE::MouseInput(key));
}

void KeyBinds::registerInputString(const PGE::String& string, PGE::ControllerInput::Button key) {
    inputStrings.emplace(string, new PGE::ControllerInput(io->getController(0), key));
}

bool KeyBinds::anyShiftDown() const {
    return leftShift->isDown() || rightShift->isDown();
}

bool KeyBinds::anyShortcutDown() const {
    return leftShortcutKey->isDown() || rightShortcutKey->isDown();
}

bool KeyBinds::copyIsHit() const {
    return keyC->isHit() && anyShortcutDown();
}
bool KeyBinds::cutIsHit() const {
    return keyX->isHit() && anyShortcutDown();
}
bool KeyBinds::pasteIsHit() const {
    return keyV->isHit() && anyShortcutDown();
}
bool KeyBinds::undoIsHit() const {
#ifdef __APPLE__
    return keyZ->isHit() && anyShortcutDown() && !anyShiftDown();
#else
    return keyZ->isHit() && anyShortcutDown();
#endif
}
bool KeyBinds::redoIsHit() const {
#ifdef __APPLE__
    return keyZ->isHit() && anyShortcutDown() && anyShiftDown();
#else
    return keyY->isHit() && anyShortcutDown();
#endif
}
bool KeyBinds::selectAllIsHit() const {
    return keyA->isHit() && anyShortcutDown();
}

void KeyBinds::update() {
    downInputs = Input::NONE;
    hitInputs = Input::NONE;

    // TODO: This could be faster when the map is switched.
    for (auto it = bindings.begin(); it != bindings.end(); it++) {
        // Check if any of the assigned inputs are down.
        // If one of them is down/hit then the input is active.
        if (it->second->isDown()) {
            downInputs = downInputs | it->first;
        }
            
        if (it->second->isHit()) {
            hitInputs = hitInputs | it->first;
        }
    }

    // TODO: Disable when key capture is enabled.
    for (ConsoleBindingsMap::const_iterator it = consoleBindings.begin(); it != consoleBindings.end(); it++) {
        if (it->second->isHit()) {
            conDef->executeCommand(it->first.getStr());
        }
    }
}

Input KeyBinds::getDownInputs() const {
    return downInputs;
}

Input KeyBinds::getHitInputs() const {
    return hitInputs;
}

void KeyBinds::bindInput(Input input, PGE::UserInput* key) {
    io->trackInput(key);
    bindings.emplace(input, key);
}

void KeyBinds::bindInput(Input input, PGE::MouseInput::Button key) {
    bindInput(input, new PGE::MouseInput(key));
}

void KeyBinds::bindInput(Input input, PGE::KeyboardInput::Keycode key) {
    bindInput(input, new PGE::KeyboardInput(key));
}

void KeyBinds::bindInput(Input input, PGE::ControllerInput::Button key) {
    bindInput(input, new PGE::ControllerInput(io->getController(0), key));
}

void KeyBinds::unbindInput(Input input, PGE::UserInput::Device Device, int key) {
    // Iterate over all values of the given key
    std::pair<UserInputMap::iterator, UserInputMap::iterator> bindingsRange = bindings.equal_range(input);
    for (UserInputMap::iterator it = bindingsRange.first; it != bindingsRange.second; it++) {
        if (it->second->getDevice() == Device && it->second->getKey() == key) {
            io->untrackInput(it->second);
            delete it->second;
            bindings.erase(it);
            return;
        }
    }
}

void KeyBinds::unbindInput(Input input, PGE::MouseInput::Button key) {
    unbindInput(input, PGE::UserInput::Device::MOUSE, (int)key);
}

void KeyBinds::unbindInput(Input input, PGE::KeyboardInput::Keycode key) {
    unbindInput(input, PGE::UserInput::Device::KEYBOARD, (int)key);
}

void KeyBinds::unbindInput(Input input, PGE::ControllerInput::Button key) {
    unbindInput(input, PGE::UserInput::Device::CONTROLLER, (int)key);
}

void KeyBinds::bindCommand(PGE::String command, PGE::UserInput* key) {
    io->trackInput(key);
    consoleBindings.emplace(command, key);
}

void KeyBinds::unbindCommand(PGE::String command, PGE::UserInput* key) {
    // Iterate over all values of the given key
    std::pair<ConsoleBindingsMap::iterator, ConsoleBindingsMap::iterator> bindingsRange = consoleBindings.equal_range(command);
    for (ConsoleBindingsMap::iterator it = bindingsRange.first; it != bindingsRange.second; it++) {
        if (it->second->getDevice() == key->getDevice() && it->second->getKey() == key->getKey()) {
            io->untrackInput(it->second);
            consoleBindings.erase(it);
            return;
        }
    }
}

PGE::UserInput* KeyBinds::stringToInput(const PGE::String& key) const {
    auto find = inputStrings.find(key.toLower());
    if (find == inputStrings.end()) {
        return nullptr;
    }
    return find->second;
}
