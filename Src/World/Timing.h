#ifndef TIMING_H_INCLUDED
#define TIMING_H_INCLUDED

#include <chrono>

class Timing {
    private:
        std::chrono::high_resolution_clock::time_point initialTime;
        std::chrono::high_resolution_clock::time_point prevTime;

        // Tick timers (Milliseconds)
        int tickRate;
        int tickStep;
        float sinceLastTick;
        std::chrono::high_resolution_clock::duration tickStepDuration;
        std::chrono::high_resolution_clock::time_point compareTick;
        std::chrono::high_resolution_clock::time_point lastTick;

        // Frame timers (Milliseconds)
        int frameRate;
        int frameStep;
        float sinceLastFrame;
        std::chrono::high_resolution_clock::duration frameStepDuration;
        std::chrono::high_resolution_clock::time_point compareFrame;
        std::chrono::high_resolution_clock::time_point lastFrame;

    public:
        Timing(int tickrate, int framerate);

        // Tick rates
        int getTickRate() const;
        float getSinceTick() const;
        void setTickRate(int rate);
        bool tickReady();
        void tickFinished();

        // Frame rates
        int getFrameRate() const;
        float getSinceFrame() const;
        void setFrameRate(int rate);
        bool frameReady();
        void frameFinished();

};

#endif // TIMING_H_INCLUDED
