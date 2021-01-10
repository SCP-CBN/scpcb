#include "PlayerController.h"

#include <Math/Plane.h>

#include "../Collision/Collider.h"
#include "../World/Pickable.h"
#include "../Utils/MathUtil.h"

PlayerController::PlayerController(float r, float camHeight) {
    collider = new Collider(r, camHeight);

    position = PGE::Vector3f::zero;
    camAnimState = 0.f;
    currWalkSpeed = 0.f;
    stamina = 1.f;
    
    noclip = false;
}

PlayerController::~PlayerController() {
    delete collider;
}

void PlayerController::setCollisionMeshCollection(CollisionMeshCollection* collection) {
    PickableManager::cmc = collection;
    collider->setCollisionMeshCollection(collection);
}

void PlayerController::update(float yaw, float pitch, Input input, float timeStep) {
    if ((input & (Input::Forward | Input::Backward | Input::Left | Input::Right)) == Input::None) {
        stand(timeStep); //not pressing any movement keys: we're standing still
    } else {
        float sinAngle = std::sin(yaw);
        float cosAngle = std::cos(yaw);
        float targetSpeed = WALK_SPEED_MAX;
        if ((input & Input::Sprint) != Input::None) {
            targetSpeed = SPRINT_SPEED_MAX * getClampedStamina() + WALK_SPEED_MAX * (1.f - getClampedStamina());
        }
        // TODO: Scale this.
        currWalkSpeed = currWalkSpeed * WALK_SPEED_SMOOTHING_FACTOR + targetSpeed * (1.f - WALK_SPEED_SMOOTHING_FACTOR);

        PGE::Vector2f targetDir = PGE::Vector2f::zero;
        if ((input & Input::Forward) != Input::None) {
            targetDir = targetDir.add(PGE::Vector2f(sinAngle, cosAngle));
        }
        if ((input & Input::Backward) != Input::None) {
            targetDir = targetDir.add(PGE::Vector2f(-sinAngle, -cosAngle));
        }
        if ((input & Input::Left) != Input::None) {
            targetDir = targetDir.add(PGE::Vector2f(-cosAngle, sinAngle));
        }
        if ((input & Input::Right) != Input::None) {
            targetDir = targetDir.add(PGE::Vector2f(cosAngle, -sinAngle));
        }
        if (targetDir.lengthSquared() < 0.01f) {
            //TODO: remove
            position = position.add(PGE::Vector3f(0.f, 60.f, 0.f) * timeStep);
            noclip = true;
            // -------

            stand(timeStep); //inputs cancel each other out: we're standing still
        } else {
            noclip = false; // Also remove
            targetDir = targetDir.normalize();
            walk(targetDir, timeStep);
            camAnimState += sqrt(currWalkSpeed / WALK_SPEED_MAX) * timeStep;
            while (camAnimState >= 2.f * MathUtil::PI / 0.08f) {
                camAnimState -= 2.f * MathUtil::PI / 0.08f;
            }
        }
    }
    if (!noclip) {
        position = collider->applyGravity(position, currWalkSpeed, timeStep);
    } else {
        collider->resetGravity();
    }
}

float PlayerController::getCamAnimState() const {
    return camAnimState;
}

float PlayerController::getClampedStamina() const {
    if (stamina < 0.f) { return 0.f; }
    if (stamina > 1.f) { return 1.f; }
    return stamina;
}

void PlayerController::stand(float timeStep) {
    currWalkSpeed = 0.f;
    stamina += STAMINA_RECOVERY_RATE * timeStep;
    if (stamina > 1.f) { stamina = 1.f; }
}

void PlayerController::walk(PGE::Vector2f dir, float timeStep) {
    position = collider->tryMove(position, position.add(PGE::Vector3f(dir.x * currWalkSpeed, 0.f, dir.y * currWalkSpeed) * timeStep));
}
