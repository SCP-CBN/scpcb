#include <Math/Rectangle.h>

#include "Camera.h"
#include "../Utils/MathUtil.h"
#include "GraphicsResources.h"
#include "../World/DataInterpolator.h"

Camera::Camera(GraphicsResources* gr, int w, int h, float fov, float nearZ, float farZ, bool orthographic) {
    gfxRes = gr;

    position = PGE::Vector3f(0.f, 0.f, 0.f);
    lookAt = PGE::Vector3f(0.f, 0.f, 1.f);
    upDir = PGE::Vector3f(0.f, 1.f, 0.f);

    viewMatrix = PGE::Matrix4x4f::constructViewMat(position, lookAt, upDir);

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

    rotation = PGE::Matrix4x4f::identity;
    dataInter = DataInterpolator(position, PGE::Vector3f(-pitchAngle, yawAngle, tilt), PGE::Vector3f::zero);

    needsProjUpdate = true;
    update();
}

Camera::Camera(GraphicsResources* gr, int w, int h) : Camera(gr, w, h, MathUtil::degToRad(70.0f)) { }

void Camera::update() {
    PGE::Vector3f rotate = PGE::Vector3f(-pitchAngle, yawAngle, tilt);
    dataInter.update(position, rotate, PGE::Vector3f::zero);
}

void Camera::updateDrawTransform(float interpolation) {
    rotation = PGE::Matrix4x4f::rotate(dataInter.getInterpolatedRotation(interpolation));

    viewMatrix = PGE::Matrix4x4f::constructViewMat(dataInter.getInterpolatedPosition(interpolation), rotation.transform(lookAt), rotation.transform(upDir));

    if (needsProjUpdate) {
        if (!orthographicProj) {
            projectionMatrix = PGE::Matrix4x4f::constructPerspectiveMat(fov, getAspectRatio(), nearPlaneZ, farPlaneZ);
        } else {
            projectionMatrix = PGE::Matrix4x4f::constructOrthographicMat(width, height, nearPlaneZ, farPlaneZ);
        }

        needsProjUpdate = false;
    }
}

float Camera::getAspectRatio() const {
    return (float)width / height;
}

void Camera::setPosition(const PGE::Vector3f pos) {
    position = pos;
}

void Camera::setTilt(float rad) {
    tilt = rad;
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

const PGE::Matrix4x4f& Camera::getRotationMatrix() const {
    return rotation;
}

float Camera::getYawAngle() const {
    return yawAngle;
}

float Camera::getPitchAngle() const {
    return pitchAngle;
}
