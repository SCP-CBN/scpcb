#include "CollisionMesh.h"
#include <PGE/Math/AABBox.h>
#include <PGE/Math/Plane.h>

CollisionMesh::CollisionMesh(const std::vector<PGE::Vector3f>& verts, const std::vector<int>& inds) {
    vertices = verts; indices = inds;
}

Collision CollisionMesh::checkCollision(const PGE::Matrix4x4f& matrix, const PGE::Line3f& line,float height,float radius,int& outTriangleIndex) const {
    Collision retVal;
    retVal.hit = false;
    outTriangleIndex = -1;
    PGE::AABBox lineBox(line.pointA);
    lineBox.addPoint(line.pointB);
    lineBox.addPoint(lineBox.getMin() + PGE::Vector3f(-radius,-height*0.5f,-radius));
    lineBox.addPoint(lineBox.getMax() + PGE::Vector3f(radius,height*0.5f,radius));
    PGE::AABBox triBox(PGE::Vector3fs::ZERO);
    for (size_t i=0;i<indices.size()/3;i++) {
        PGE::Vector3f vert0 = matrix.transform(vertices[indices[(i*3)+0]]);
        PGE::Vector3f vert1 = matrix.transform(vertices[indices[(i*3)+1]]);
        PGE::Vector3f vert2 = matrix.transform(vertices[indices[(i*3)+2]]);
        triBox = PGE::AABBox(vert0);
        triBox.addPoint(vert1);
        triBox.addPoint(vert2);
        triBox.addPoint(triBox.getMin() + PGE::Vector3f(-0.1f,-0.1f,-0.1f));
        triBox.addPoint(triBox.getMax() + PGE::Vector3f(0.1f,0.1f,0.1f));
        if (!triBox.intersects(lineBox)) { continue; }
        Collision coll; coll.hit = false;
        coll = Collision::triangleCollide(line,height,radius,vert0,vert1,vert2);
        if (coll.hit) {
            if (!retVal.hit || retVal.coveredAmount>coll.coveredAmount) {
                retVal = coll;
                outTriangleIndex = (int)i;
            }
        }
    }
    return retVal;
}

Collision CollisionMesh::checkCollision(const PGE::Matrix4x4f& matrix, const PGE::Line3f& line, float height, float radius) const {
    int outTriangleIndex;
    return checkCollision(matrix, line, height, radius, outTriangleIndex);
}

const std::vector<PGE::Vector3f>& CollisionMesh::getVertices() const {
    return vertices;
}
