#include <Math/Vector.h>

class CollisionMeshCollection;

class Collider {
    public:
        Collider(float radius, float height);

        void setCollisionMeshCollection(CollisionMeshCollection* cmc);

        PGE::Vector3f applyGravity(PGE::Vector3f position, float horizontalSpeed, float timeStep);
        void resetGravity();
        PGE::Vector3f tryMove(PGE::Vector3f origin, const PGE::Vector3f& goal) const;

    private:
        CollisionMeshCollection* cmc;
        float fallSpeed = 0.f;
        float height;
        float radius;
};
