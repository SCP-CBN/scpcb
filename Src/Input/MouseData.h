#ifndef MOUSEDATA_H_INCLUDED
#define MOUSEDATA_H_INCLUDED

#include <PGE/Input/InputManager.h>

class Config;

class MouseData {
    private:
        PGE::InputManager* inputManager;
        Config* config;

        PGE::Vector2f mouseDelta; // Per frame.
        PGE::Vector2f mousePosition;
        PGE::Vector2i mouseWheelDelta;

    public:
        MouseData(PGE::InputManager* inputManager, Config* config);

        const PGE::Vector2f& getPosition() const;
        const PGE::Vector2f& getDelta() const;
        const PGE::Vector2i& getWheelDelta() const;

        void update();
};

#endif // MOUSEDATA_H_INCLUDED
