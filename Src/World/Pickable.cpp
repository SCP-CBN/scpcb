#include "Pickable.h"

#include "../Collision/CollisionMeshCollection.h"
#include "../Input/KeyBinds.h"
#include "../Graphics/UIMesh.h"
#include "../Graphics/Camera.h"
#include "../Utils/MathUtil.h"

CollisionMeshCollection* PickableManager::cmc;

Pickable::Pickable() {
    position = PGE::Vector3f::ZERO;
    picked = false;
}

bool Pickable::getPicked() {
    if (picked) {
        picked = false;
        return true;
    }
    return false;
}

PickableManager::PickableManager(Camera* cam, UIMesh* um, KeyBinds* kb) {
    camera = cam;
    keyBinds = kb;
    uiMesh = um;

    currentPickable = nullptr;
}

void PickableManager::activatePickable(Pickable* p) {
    for (const auto& it : activePickables) {
        if (it == p) {
            return; // Already active.
        }
    }
    activePickables.push_back(p);
    validPickables.reserve(activePickables.size());
}

void PickableManager::deactivatePickable(Pickable* p) {
    for (auto it = activePickables.begin(); it != activePickables.end(); it++) {
        if (*it == p) {
            activePickables.erase(it);
            validPickables.resize(activePickables.size());
            validPickables.shrink_to_fit();
            return;
        }
    }
}

void PickableManager::update() {
    currentPickable = nullptr;
    validPickables.clear();
    for (const auto& p : activePickables) {
        p->cachedDistance = camera->position.distanceSquared(p->position);
        // We only want to have to sort the Pickables in a valid range.
        if (p->cachedDistance < 20 * 20) {
            validPickables.push_back(p);
        }
    }
    std::sort(validPickables.begin(), validPickables.end(), [](Pickable* a, Pickable* b) {
        return a->cachedDistance < b->cachedDistance;
    });
    for (const auto& p : validPickables) {
        if (!cmc->checkCollision(PGE::Line3f(camera->position, p->position + PGE::Vector3f(0.f, 1.f, 0.f)), 0.f, 0.f).hit) { // TODO: Remove artificial raising of height.
            currentPickable = p;
            if (keyBinds->mouse1->isHit()) {
                p->picked = true;
            }
            return;
        }
    }
}

void PickableManager::render() {
    if (currentPickable != nullptr) {
        uiMesh->setTextureless();
        PGE::Vector3f lookAt = -(camera->position - currentPickable->position).normalize();
        PGE::Vector3f forward = camera->getViewMatrix().extractViewTarget().normalize();
        PGE::Vector2f lookAtTwo = PGE::Vector2f(lookAt.x, lookAt.z).normalize();
        float f = -camera->getYawAngle() + std::atan2(lookAtTwo.x, lookAtTwo.y);
        float f2 = -(lookAt.y - forward.y) * 50;
        if (f < -MathUtil::PI) {
            f += MathUtil::PI * 2;
        }
        if (f > MathUtil::PI) {
            f -= MathUtil::PI * 2;
        }
        f *= 50;
        uiMesh->addRect(PGE::Rectanglef(f - 5, f2 - 5, f + 5, f2 + 5));
        uiMesh->endRender();
    }
}
