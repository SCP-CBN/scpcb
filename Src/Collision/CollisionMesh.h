#ifndef COLLISIONMESH_H_INCLUDED
#define COLLISIONMESH_H_INCLUDED

#include <vector>
#include <Math/Vector.h>
#include <Math/Matrix.h>
#include <Mesh/Mesh.h>

#include "Collision.h"


class CollisionMesh {
    public:
        CollisionMesh(std::vector<PGE::Vector3f> verts, std::vector<int> inds);
        CollisionMesh(std::vector<PGE::Vector3f> verts, std::vector<PGE::Primitive> prims);
        Collision checkCollision(PGE::Matrix4x4f matrix, PGE::Line3f line,float height,float radius,int& outTriangleIndex) const;
        Collision checkCollision(PGE::Matrix4x4f matrix, PGE::Line3f line,float height,float radius) const;
        const std::vector<PGE::Vector3f>& getVertices() const;

    private:
        std::vector<PGE::Vector3f> vertices;
        std::vector<int> indices;
};

#endif // COLLISIONMESH_H_INCLUDED
