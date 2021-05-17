#include "Collider.h"

#include <Math/Plane.h>

#include "../Collision/CollisionMeshCollection.h"

constexpr float GRAVITY = 0.6f;

Collider::Collider(float radius, float height) {
    this->cmc = nullptr;
    this->radius = radius;
    this->height = height;
}

void Collider::setCollisionMeshCollection(CollisionMeshCollection* cmc) {
    this->cmc = cmc;
}

// TODO: Scale this fully.
PGE::Vector3f Collider::applyGravity(PGE::Vector3f position, float horizontalSpeed, float timeStep) {
    int iterations = 0;
    fallSpeed += GRAVITY * timeStep;
    PGE::Line3f line = PGE::Line3f(position, position + PGE::Vector3f(0.f, -fallSpeed - (horizontalSpeed * 2.f), 0.f));
    while (true) {
        Collision coll = cmc->checkCollision(line, height, radius);
        if (coll.hit) {
            PGE::Vector3f resultPos = line.pointA + (line.pointB - line.pointA) * coll.coveredAmount * 0.995f;
            if (iterations == 0) {
                line = PGE::Line3f(position, position + PGE::Vector3f(0.f, -fallSpeed, 0.f));
            }
            if (resultPos.distanceSquared(position) < 0.0001f) {
                resultPos = position;
                coll.coveredAmount = 0.f;
            }
            position = resultPos;
            if (abs(coll.normal.y) > 0.71f && abs(coll.normal.y - coll.surfaceNormal.y) < 0.05f) {
                //hit a floor: stand still
                fallSpeed = 0.f < fallSpeed ? 0.f : fallSpeed;
                break;
            } else {
                if (iterations >= 5) { break; }
                iterations++;
                //hit a steep surface: slide down
                float remainingDist = (line.pointB - position).length() * 0.995f;
                PGE::Vector3f reflectedDir = (line.pointB - line.pointA).reflect(coll.normal) * -remainingDist;
                PGE::Plane p = PGE::Plane(coll.normal, position);
                PGE::Vector3f tempPos = position;
                tempPos += reflectedDir - p.normal * ((tempPos - position).dotProduct(p.normal) * 0.995f);
                if (tempPos.y - position.y >= 0.f) { break; } //don't allow movement in the opposite direction
                if (position.distanceSquared(tempPos) < 0.0001f) { break; }
                line = PGE::Line3f(position, tempPos);
            }
        } else {
            //didn't hit anything: keep falling
            if (iterations == 0) {
                line = PGE::Line3f(position, position + PGE::Vector3f(0.f, -fallSpeed, 0.f));
            }
            position = line.pointB;
            break;
        }
    }
    return position;
}

void Collider::resetGravity() {
    fallSpeed = 0.f;
}

PGE::Vector3f Collider::tryMove(PGE::Vector3f position, const PGE::Vector3f& goal) const {
    int iterations = 0;
    PGE::Line3f line = PGE::Line3f(position, goal);
    PGE::Vector3f targetDir = (line.pointB - line.pointA).normalize();
    PGE::Vector3f currDir = targetDir;
    while (true) {
        Collision coll = cmc->checkCollision(line, height, radius);
        if (coll.hit) {
            PGE::Vector3f resultPos = line.pointA + (line.pointB - line.pointA) * (coll.coveredAmount * 0.995f);
            if (resultPos.distanceSquared(position) < 0.0001f) {
                resultPos = position;
                coll.coveredAmount = 0.f;
            }
            position = resultPos;
            if (iterations >= 5) { break; }
            iterations++;
            float remainingDist = (line.pointB - position).length();
            if (coll.normal.y <= 0.71f) {
                //surface is too steep to climb up or pushes you down
                coll.normal.y = 0.f;
                coll.normal = coll.normal.normalize();
            }
            PGE::Vector3f reflectedDir = currDir.reflect(coll.normal) * -remainingDist;
            PGE::Plane p = PGE::Plane(coll.normal, position);
            PGE::Vector3f tempPos = position;
            tempPos = tempPos + reflectedDir;
            tempPos = tempPos - p.normal * ((tempPos - position).dotProduct(p.normal) * 0.995f);
            currDir = (tempPos - position).normalize();
            if (currDir.dotProduct(targetDir) < 0.f && iterations > 1) { break; }
            line = PGE::Line3f(position, tempPos);
        } else {
            position = line.pointB;
            break;
        }
    }
    return position;
}
