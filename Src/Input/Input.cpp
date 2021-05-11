#include "Input.h"

PGE::String getBindingName(const Input& input) {
    switch (input) {
        case Input::FORWARD: {
            return PGE::String("Forward");
        } break;
        case Input::BACKWARD: {
            return PGE::String("Backward");
        } break;
        case Input::LEFT: {
            return PGE::String("Left");
        } break;
        case Input::RIGHT: {
            return PGE::String("Right");
        } break;
        case Input::SPRINT: {
            return PGE::String("Sprint");
        } break;
        case Input::CROUCH: {
            return PGE::String("Crouch");
        } break;
        case Input::BLINK: {
            return PGE::String("Blink");
        } break;
        case Input::INTERACT: {
            return PGE::String("Interact");
        } break;
        case Input::INVENTORY: {
            return PGE::String("Inventory");
        } break;
        case Input::TOGGLE_CONSOLE: {
            return PGE::String("ToggleConsole");
        } break;
        default: {
            return PGE::String("None");
        } break;
    }
}

bool inputWasFired(const Input& input, const Input& firedInput) {
    return (input & firedInput) == firedInput;
}

const Input operator&(const Input& a, const Input& b) {
    return (Input)((int)a & (int)b);
}

const Input operator|(const Input& a, const Input& b) {
    return (Input)((int)a | (int)b);
}
