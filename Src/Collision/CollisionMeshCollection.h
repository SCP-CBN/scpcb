#ifndef COLLISIONMESHCOLLECTION_H_INCLUDED
#define COLLISIONMESHCOLLECTION_H_INCLUDED

#include <map>

#include <Math/Line.h>
#include <Math/Matrix.h>
#include <Math/AABBox.h>

#include "Collision.h"

class CollisionMesh;

class CollisionMeshCollection {
    public:
        class Instance {
            public:
                Instance(CollisionMeshCollection* coll,CollisionMesh* msh, PGE::Matrix4x4f mtrx, int id);
                Collision checkCollision(const PGE::Line3f& line,float height,float radius) const;
                CollisionMeshCollection* getCollection() const;
                CollisionMesh* getMesh() const;
                PGE::AABBox getBBox() const;
                int getId() const;

                PGE::Matrix4x4f matrix;
                void recalculateBBox();

                Instance() = default;
            private:
                CollisionMeshCollection* collection;
                CollisionMesh* mesh;
                PGE::AABBox bbox;
                int identifier;
        };

        int addInstance(CollisionMesh* mesh, const PGE::Matrix4x4f& matrix);
        void updateInstance(int instance, const PGE::Matrix4x4f& matrix);
        void removeInstance(int instance);

        Collision checkCollision(const PGE::Line3f& line,float height,float radius) const;

    private:
        std::map<int, Instance> instances;
        int lastInstanceId = 0;
};

#endif // COLLISIONMESHCOLLECTION_H_INCLUDED
