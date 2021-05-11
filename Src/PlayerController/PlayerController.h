#ifndef PLAYERCONTROLLER_H_INCLUDED
#define PLAYERCONTROLLER_H_INCLUDED

#include <Math/Vector.h>

#include "../Input/Input.h"

class CollisionMeshCollection;
class Collider;

class PlayerController {
    public:
        PlayerController(float r, float camHeight);
        ~PlayerController();
        
        PGE::Vector3f position;
        bool noclip;
    
        void setCollisionMeshCollection(CollisionMeshCollection* collection);
        void update(float angle, float angleY, Input input, float timeStep);

        float getCamAnimState() const;

    private:
        Collider* collider;

        float camAnimState;
        float currWalkSpeed;
        float stamina;

        float getClampedStamina() const;

        void stand(float timeStep);
        void walk(PGE::Vector2f dir, float timeStep);
};

#endif // PLAYERCONTROLLER_H_INCLUDED
