#ifndef CAMERA_H_INCLUDED
#define CAMERA_H_INCLUDED

#include <Math/Matrix.h>
#include <Graphics/Graphics.h>
#include <Shader/Shader.h>

#include "../World/DataInterpolator.h"

class GraphicsResources;

class Camera {
    private:
        GraphicsResources* gfxRes;

        float yawAngle;
        float pitchAngle;
        // The range of the the pitchAngle field before it is clamped.
        float pitchAngleLimit;
        float tilt;

        float nearPlaneZ;
        float farPlaneZ;
        int width;
        int height;
        float fov;
        // Perspective or Orthographic matrix.
        bool orthographicProj;

        bool needsProjUpdate;
        
        static const PGE::Vector3f FORWARD;
        static const PGE::Vector3f UP;
        
        PGE::Matrix4x4f rotation;

    protected:
        DataInterpolator dataInter;
        PGE::Matrix4x4f viewMatrix;
        PGE::Matrix4x4f projectionMatrix;

    public:
        Camera(GraphicsResources* gr, int w, int h, float fov, float nearZ = 0.01f, float farZ = 30.f, bool orthographic = false);
        Camera(GraphicsResources* gr, int w, int h);

        PGE::Vector3f position;

        void update();
        virtual void updateDrawTransform(float interpolation);
        
        void addAngle(float yawAngle, float pitchAngle);

        const PGE::Matrix4x4f& getViewMatrix() const;
        const PGE::Matrix4x4f& getProjectionMatrix() const;
        virtual PGE::Matrix4x4f getRotationMatrix() const;

        float getYawAngle() const;
        float getPitchAngle() const;
};

#endif // CAMERA_H_INCLUDED
