#include "MouseData.h"

#include "../Save/Config.h"

MouseData::MouseData(PGE::InputManager* inputManager, Config* config) {
    this->inputManager = inputManager;
    this->config = config;
}

void MouseData::update() {
    // Get mouse position and convert it to screen coordinates.

    // Convert it to [0, 100].
    PGE::Vector2f scale = PGE::Vector2f(100.f / config->getWidth(), 100.f / config->getHeight());
    mousePosition = PGE::Vector2f(inputManager->getMousePosition().x * scale.x, inputManager->getMousePosition().y * scale.y);
    mousePosition.x *= config->getAspectRatio();

    // Subtract 50 to bring it inline with the [-50, 50] screen coordinates.
    mousePosition.x -= 50.f * config->getAspectRatio();
    mousePosition.y -= 50.f;

    mouseWheelDelta = inputManager->consumeMouseWheelDelta(); // Casting to 2f for AngelScript.

    mouseDelta = inputManager->consumeMouseDelta();
}

const PGE::Vector2f& MouseData::getPosition() const {
    return mousePosition;
}

const PGE::Vector2f& MouseData::getDelta() const {
    return mouseDelta;
}

const PGE::Vector2i& MouseData::getWheelDelta() const {
    return mouseWheelDelta;
}
