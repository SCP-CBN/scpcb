#ifndef MATHUTIL_H_INCLUDED
#define MATHUTIL_H_INCLUDED

namespace MathUtil {
    constexpr float MARGIN_ERROR = 0.001f;

    constexpr float PI = 3.1415926535897932f;

    float degToRad(float degrees);
    float radToDeg(float radians);
    
    bool equalFloats(float val, float other);

    int maxInt(int val, int other);
    int minInt(int val, int other);
    float maxFloat(float val, float other);
    float minFloat(float val, float other);
    int clampInt(int val, int min, int max);
    float clampFloat(float val, float min, float max);

    float absFloat(float val);
    double absDouble(double val);

    int floor(float val);
    int ceil(float val);
};

#endif // MATHUTIL_H_INCLUDED
