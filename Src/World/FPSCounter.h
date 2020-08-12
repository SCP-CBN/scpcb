#ifndef FPSCOUNTER_H_INCLUDED
#define FPSCOUNTER_H_INCLUDED

#include <queue>

class UIMesh;
class KeyBinds;
class Config;
class Font;
class GUIText;
class TxtManager;

class FPSCounter {
    private:
        std::deque<double> sampleBuffer;
        const int SAMPLE_COUNT = 20;

        double avgFPS;
        double currFPS;

        Config* config;

        GUIText* display;
        TxtManager* txtMng;

    public:
        bool visible;

        FPSCounter(UIMesh* um, KeyBinds* kb, Config* con, TxtManager* tm, Font* font);

        void update(double elapsedSeconds);
        void draw();
};

#endif // FPSCOUNTER_H_INCLUDED