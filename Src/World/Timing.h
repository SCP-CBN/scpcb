#ifndef TIMING_H_INCLUDED
#define TIMING_H_INCLUDED

#include <chrono>

class Timing {
    private:
        double timeStep;
        double accumulatedSeconds;

        double secondToLastFixedTime;
        double lastFixedTime;

        // Total time since the object's initialization.
        std::chrono::high_resolution_clock::time_point initialTime;
        // Previous time when the last call to getElapsedSeconds() was made.
        std::chrono::high_resolution_clock::time_point prevTime;

    public:
        Timing(int tickrate);

        double getTimeStep() const;
        void addSecondsToAccumulator(double secondsPassed);

        // Returns whether enough time is left on the accumulator for another tick.
        bool tickReady() const;

        // Subtracts one tick from the accumlator.
        void subtractTick();

        void updateInterpolationFactor();

        double getInterpolationFactor() const;

        // Returns the total elapsed time since the object's creation.
        double getTotalElapsedTime() const;

        // Returns the elapsed seconds since the last call to this function.
        double getElapsedSeconds();
};

#endif // TIMING_H_INCLUDED
