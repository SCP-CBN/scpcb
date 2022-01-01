#include "DataInterpolator.h"

#include <PGE/Math/Math.h>
#include <PGE/Math/Interpolator.h>

DataInterpolator::TransformData::TransformData(const PGE::Vector3f& pos, const PGE::Vector3f& rot, const PGE::Vector3f& scal) {
    position = pos;
    rotation = rot;
    scale = scal;
}

DataInterpolator::DataInterpolator()
: currTransform(TransformData(PGE::Vector3fs::ZERO,PGE::Vector3fs::ZERO,PGE::Vector3fs::ZERO)),
  prevTransform(TransformData(PGE::Vector3fs::ZERO,PGE::Vector3fs::ZERO,PGE::Vector3fs::ZERO)) { }

DataInterpolator::DataInterpolator(const PGE::Vector3f& position, const PGE::Vector3f& rotation, const PGE::Vector3f& scale) 
: currTransform(TransformData(position, rotation, scale)), prevTransform(TransformData(position, rotation, scale)) { }

void DataInterpolator::update(const PGE::Vector3f& position, const PGE::Vector3f& rotation, const PGE::Vector3f& scale) {
    prevTransform = currTransform;
    currTransform = TransformData(position, rotation, scale);
}

PGE::Vector3f DataInterpolator::getInterpolatedPosition(float interpolation) const {
    return PGE::Interpolator::lerp(prevTransform.position, currTransform.position, interpolation);
}

PGE::Vector3f DataInterpolator::getInterpolatedRotation(float interpolation) const {
    PGE::Vector3f diff = currTransform.rotation - prevTransform.rotation;
    while (diff.x < -PGE::Math::PI) { diff.x += PGE::Math::PI*2.f; }
    while (diff.x > PGE::Math::PI) { diff.x -= PGE::Math::PI*2.f; }
    while (diff.y < -PGE::Math::PI) { diff.y += PGE::Math::PI*2.f; }
    while (diff.y > PGE::Math::PI) { diff.y -= PGE::Math::PI*2.f; }
    while (diff.z < -PGE::Math::PI) { diff.z += PGE::Math::PI*2.f; }
    while (diff.z > PGE::Math::PI) { diff.z -= PGE::Math::PI*2.f; }
    return (prevTransform.rotation + diff) * interpolation;
}

PGE::Vector3f DataInterpolator::getInterpolatedScale(float interpolation) const {
    return PGE::Interpolator::lerp(prevTransform.scale, currTransform.scale, interpolation);
}
