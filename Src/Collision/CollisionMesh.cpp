#include "CollisionMesh.h"
#include <Mesh/Mesh.h>
#include <Math/AABBox.h>
#include <Math/Plane.h>

using namespace PGE;

CollisionMesh::CollisionMesh(std::vector<Vector3f> verts,std::vector<int> inds) {
    vertices = verts; indices = inds;
    // Structure of verts:
    //  [Vertex*] all of them.;
    // Structure of indices:
    // x+0 = vertex[x][0]
    // x+1 = vertex[x][1]
    // x+2 = vertex[x][2]
    // To form triangles.
}

CollisionMesh::CollisionMesh(std::vector<Vector3f> verts, std::vector<Primitive> prims) {
    int vertCount = (int)verts.size();
    int primCount = (int)prims.size();

    for (int i = 0; i < vertCount; i++) {
        if (i >= (int)vertices.size()) {
            vertices.push_back(verts[i]);
        }
        else {
            vertices[i] = verts[i];
        }
    }

    indices = std::vector<int>(primCount * 3);
    for (int i = 0; i < primCount; i++) {
        indices[(i * 3) + 0] = prims[i].a;
        indices[(i * 3) + 1] = prims[i].b;
        indices[(i * 3) + 2] = prims[i].c;
    }

    // Structure of verts:
    //  [Vertex*] all of them.;
    // Structure of indices:
    // x+0 = vertex[x][0]
    // x+1 = vertex[x][1]
    // x+2 = vertex[x][2]
    // To form triangles.
}


Collision CollisionMesh::checkCollision(Matrix4x4f matrix, Line3f line,float height,float radius,int& outTriangleIndex) const {
    Collision retVal;
    retVal.hit = false;
    outTriangleIndex = -1;
    AABBox lineBox(line.pointA,line.pointB);
    lineBox.addPoint(lineBox.getMin() + Vector3f(-radius,-height*0.5f,-radius));
    lineBox.addPoint(lineBox.getMax() + Vector3f(radius,height*0.5f,radius));
    AABBox triBox(PGE::Vector3f::ZERO);
    for (size_t i=0;i<indices.size()/3;i++) {
        PGE::Vector3f vert0 = matrix.transform(vertices[indices[(i*3)+0]]);
        PGE::Vector3f vert1 = matrix.transform(vertices[indices[(i*3)+1]]);
        PGE::Vector3f vert2 = matrix.transform(vertices[indices[(i*3)+2]]);
        triBox.reset(vert0);
        triBox.addPoint(vert1);
        triBox.addPoint(vert2);
        triBox.addPoint(triBox.getMin() + Vector3f(-0.1f,-0.1f,-0.1f));
        triBox.addPoint(triBox.getMax() + Vector3f(0.1f,0.1f,0.1f));
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

Collision CollisionMesh::checkCollision(Matrix4x4f matrix, Line3f line, float height, float radius) const {
    int outTriangleIndex;
    return checkCollision(matrix, line, height, radius, outTriangleIndex);
}

const std::vector<Vector3f>& CollisionMesh::getVertices() const {
    return vertices;
}
