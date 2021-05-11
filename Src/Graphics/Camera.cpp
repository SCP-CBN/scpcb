#include <Math/Rectangle.h>

#include "Camera.h"
#include "../Utils/MathUtil.h"
#include "GraphicsResources.h"
#include "../World/DataInterpolator.h"

const PGE::Vector3f Camera::FORWARD = PGE::Vector3f(0.f, 0.f, 1.f);
const PGE::Vector3f Camera::UP = PGE::Vector3f(0.f, 1.f, 0.f);

Camera::Camera(GraphicsResources* gr, int w, int h, float fov, float nearZ, float farZ, bool orthographic) {
    gfxRes = gr;

    position = PGE::Vector3f(0.f, 0.f, 0.f);

    viewMatrix = PGE::Matrix4x4f::constructViewMat(position, FORWARD, UP);

    yawAngle = 0.f;
    pitchAngle = 0.f;
    pitchAngleLimit = MathUtil::PI / 2.f;
    tilt = 0.f;

    this->nearPlaneZ = nearZ;
    this->farPlaneZ = farZ;
    this->fov = fov;
    this->width = w;
    this->height = h;
    this->orthographicProj = orthographic;

    rotation = PGE::Matrix4x4f::IDENTITY;
    dataInter = DataInterpolator(position, PGE::Vector3f(-pitchAngle, yawAngle, tilt), PGE::Vector3f::ZERO);

    needsProjUpdate = true;
    update();
}

Camera::Camera(GraphicsResources* gr, int w, int h) : Camera(gr, w, h, MathUtil::degToRad(70.0f)) { /* default */ }

void Camera::update() {
    dataInter.update(position, PGE::Vector3f(-pitchAngle, yawAngle, tilt), PGE::Vector3f::ZERO);
}

void Camera::updateDrawTransform(float interpolation) {
    rotation = PGE::Matrix4x4f::rotate(dataInter.getInterpolatedRotation(interpolation));

    viewMatrix = PGE::Matrix4x4f::constructViewMat(dataInter.getInterpolatedPosition(interpolation), rotation.transform(FORWARD), rotation.transform(UP));

    if (needsProjUpdate) {
        if (!orthographicProj) {
            projectionMatrix = PGE::Matrix4x4f::constructPerspectiveMat(fov, (float)width / height, nearPlaneZ, farPlaneZ);
        } else {
            projectionMatrix = PGE::Matrix4x4f::constructOrthographicMat((float)width, (float)height, nearPlaneZ, farPlaneZ);
        }

        needsProjUpdate = false;
    }
}

void Camera::addAngle(float x, float y) {
    if (MathUtil::equalFloats(x, 0.f) && MathUtil::equalFloats(y, 0.f)) {
        return;
    }

    yawAngle += x;
    pitchAngle -= y;

    if (pitchAngle < -pitchAngleLimit) {
        pitchAngle = -pitchAngleLimit;
    } else if (pitchAngle > pitchAngleLimit) {
        pitchAngle = pitchAngleLimit;
    }

    float PI_MUL_2 = MathUtil::PI * 2.f;

    if (yawAngle > PI_MUL_2) {
        yawAngle -= PI_MUL_2;
    } else if (yawAngle < -PI_MUL_2) {
        yawAngle += PI_MUL_2;
    }
}

const PGE::Matrix4x4f& Camera::getViewMatrix() const {
    return viewMatrix;
}

const PGE::Matrix4x4f& Camera::getProjectionMatrix() const {
    return projectionMatrix;
}

PGE::Matrix4x4f Camera::getRotationMatrix() const {
    return rotation;
}

float Camera::getYawAngle() const {
    return yawAngle;
}

float Camera::getPitchAngle() const {
    return pitchAngle;
}
