#ifndef INPUT_H_INCLUDED
#define INPUT_H_INCLUDED

#include <String/String.h>

enum class Input {
    NONE = 0x0,
    FORWARD = 0x1,
    BACKWARD = 0x2,
    LEFT = 0x4,
    RIGHT = 0x8,
    SPRINT = 0x10,
    CROUCH = 0x20,
    BLINK = 0x40,
    INTERACT = 0x80,

    // Inventory Hotkeys.
    INVENTORY = 0x100,
    TOGGLE_SITE_NAVIGATOR = 0x200,
    TOGGLE_RADIO = 0x400,

    TOGGLE_CONSOLE = 0x800
};

PGE::String getBindingName(const Input& input);
bool inputWasFired(const Input& input, const Input& firedInput);

const Input operator&(const Input& a, const Input& b);
const Input operator|(const Input& a, const Input& b);

#endif // INPUT_H_INCLUDED
