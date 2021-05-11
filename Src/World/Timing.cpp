#include "Timing.h"
#include "../Utils/MathUtil.h"

// The maximum amount of time the accumulator can store.
static constexpr double MAX_ACCUMULATED_SECONDS = 3.0;

Timing::Timing(int tickrate) {
    timeStep = 1.0 / tickrate;
    accumulatedSeconds = 0.0;
    secondToLastFixedTime = 1.0;
    lastFixedTime = 1.0;

    initialTime = std::chrono::high_resolution_clock::now();
    prevTime = initialTime;
}

double Timing::getTimeStep() const {
    return timeStep;
}

void Timing::addSecondsToAccumulator(double seconds) {
    if (seconds <= 0.0) { return; }
    accumulatedSeconds += seconds;

    if (accumulatedSeconds > MAX_ACCUMULATED_SECONDS) {
        accumulatedSeconds = MAX_ACCUMULATED_SECONDS;
    }
}

bool Timing::tickReady() const {
    return accumulatedSeconds >= timeStep;
}

void Timing::subtractTick() {
    if (accumulatedSeconds <= 0.0) { return; }

    accumulatedSeconds -= timeStep;
}

void Timing::updateInterpolationFactor() {
    secondToLastFixedTime = lastFixedTime;
    lastFixedTime = getTotalElapsedTime();
}

double Timing::getInterpolationFactor() const {
    if (MathUtil::absDouble(secondToLastFixedTime - lastFixedTime) > MathUtil::MARGIN_ERROR) {
        return (getTotalElapsedTime() - lastFixedTime) / (lastFixedTime - secondToLastFixedTime);
    } else {
        return 1.0;
    }
}


double Timing::getElapsedSeconds() {
    std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> timeSpan = std::chrono::duration_cast<std::chrono::duration<double>>(now - prevTime);

    prevTime = now;
    return timeSpan.count();
}


double Timing::getTotalElapsedTime() const {
    std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> timeSpan = std::chrono::duration_cast<std::chrono::duration<double>>(now - initialTime);

    return timeSpan.count();
}
