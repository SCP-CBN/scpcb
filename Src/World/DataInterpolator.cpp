#include "DataInterpolator.h"
#include "../Utils/MathUtil.h"

DataInterpolator::TransformData::TransformData(const PGE::Vector3f& pos, const PGE::Vector3f& rot, const PGE::Vector3f& scal) {
    position = pos;
    rotation = rot;
    scale = scal;
}

DataInterpolator::DataInterpolator()
: currTransform(TransformData(PGE::Vector3f::ZERO,PGE::Vector3f::ZERO,PGE::Vector3f::ZERO)),
  prevTransform(TransformData(PGE::Vector3f::ZERO,PGE::Vector3f::ZERO,PGE::Vector3f::ZERO)) { /* default */ }

DataInterpolator::DataInterpolator(const PGE::Vector3f& position, const PGE::Vector3f& rotation, const PGE::Vector3f& scale) 
: currTransform(TransformData(position, rotation, scale)), prevTransform(TransformData(position, rotation, scale)) { /* default */ }

void DataInterpolator::update(const PGE::Vector3f& position, const PGE::Vector3f& rotation, const PGE::Vector3f& scale) {
    prevTransform = currTransform;
    currTransform = TransformData(position, rotation, scale);
}

PGE::Vector3f DataInterpolator::getInterpolatedPosition(float interpolation) const {
    return PGE::Vector3f::lerp(prevTransform.position, currTransform.position, interpolation);
}

PGE::Vector3f DataInterpolator::getInterpolatedRotation(float interpolation) const {
    PGE::Vector3f diff = currTransform.rotation.subtract(prevTransform.rotation);
    while (diff.x < -MathUtil::PI) { diff.x += MathUtil::PI*2.f; }
    while (diff.x > MathUtil::PI) { diff.x -= MathUtil::PI*2.f; }
    while (diff.y < -MathUtil::PI) { diff.y += MathUtil::PI*2.f; }
    while (diff.y > MathUtil::PI) { diff.y -= MathUtil::PI*2.f; }
    while (diff.z < -MathUtil::PI) { diff.z += MathUtil::PI*2.f; }
    while (diff.z > MathUtil::PI) { diff.z -= MathUtil::PI*2.f; }
    return prevTransform.rotation.add(diff.multiply(interpolation));
}

PGE::Vector3f DataInterpolator::getInterpolatedScale(float interpolation) const {
    return PGE::Vector3f::lerp(prevTransform.scale, currTransform.scale, interpolation);
}