#include "DataInterpolator.h"

#include <Math/Math.h>

DataInterpolator::TransformData::TransformData(const PGE::Vector3f& pos, const PGE::Vector3f& rot, const PGE::Vector3f& scal) {
    position = pos;
    rotation = rot;
    scale = scal;
}

DataInterpolator::DataInterpolator()
: currTransform(TransformData(PGE::Vector3f::ZERO,PGE::Vector3f::ZERO,PGE::Vector3f::ZERO)),
  prevTransform(TransformData(PGE::Vector3f::ZERO,PGE::Vector3f::ZERO,PGE::Vector3f::ZERO)) { }

DataInterpolator::DataInterpolator(const PGE::Vector3f& position, const PGE::Vector3f& rotation, const PGE::Vector3f& scale) 
: currTransform(TransformData(position, rotation, scale)), prevTransform(TransformData(position, rotation, scale)) { }

void DataInterpolator::update(const PGE::Vector3f& position, const PGE::Vector3f& rotation, const PGE::Vector3f& scale) {
    prevTransform = currTransform;
    currTransform = TransformData(position, rotation, scale);
}

PGE::Vector3f DataInterpolator::getInterpolatedPosition(float interpolation) const {
    return PGE::Vector3f::lerp(prevTransform.position, currTransform.position, interpolation);
}

PGE::Vector3f DataInterpolator::getInterpolatedRotation(float interpolation) const {
    PGE::Vector3f diff = currTransform.rotation - prevTransform.rotation;
    float pi = PGE::Math::PI;

    // This resolves onto a position between -pi~pi:
    //      while(diff.x < -PGE::Math::PI) { diff.x += pi*2.f; }
    //      while(diff.x > PGE::Math::PI) { diff.x -= pi*2.f; }
    //      while(diff.y < -PGE::Math::PI) { diff.y += pi*2.f; }
    //      while(diff.y > PGE::Math::PI) { diff.y -= pi*2.f; }
    //      while(diff.z < -PGE::Math::PI) { diff.z += pi*2.f; }
    //      while(diff.z > PGE::Math::PI) { diff.z -= pi*2.f; }
    // This can be calculated directly instead of while looping.
    // // -PI-0.inf + 2pi = pi-0.inf -> x=x+floor(x/PI)*-PI
    // // PI+0.inf - 2pi = -pi+0.inf; -> x=x-ceil(x/PI)*PI
    if (diff.x < -pi) { diff.x += floor(diff.x/pi)*-pi; }
    else if (diff.x > pi) { diff.x -= ceil(diff.x/pi)*pi; }
    if (diff.y < -pi) { diff.y += floor(diff.y / pi) * -pi; }
    else if (diff.y > pi) { diff.y -= ceil(diff.y / pi) * pi; }
    if (diff.z < -pi) { diff.z += floor(diff.z / pi) * -pi; }
    else if (diff.z > pi) { diff.z -= ceil(diff.z / pi) * pi; }

    return (prevTransform.rotation + diff) * interpolation;
}

PGE::Vector3f DataInterpolator::getInterpolatedScale(float interpolation) const {
    return PGE::Vector3f::lerp(prevTransform.scale, currTransform.scale, interpolation);
}