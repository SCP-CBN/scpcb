#include "DebugGraphics.h"

#include <math.h>

DebugGraphics::DebugGraphics(PGE::Graphics* gfx) {
    mesh = PGE::Mesh::create(gfx, PGE::Primitive::Type::TRIANGLE);
    shader = PGE::Shader::load(gfx, PGE::FilePath::fromStr("SCPCB/GFX/Shaders/Debug/"));
    material = new PGE::Material(shader, true);
    mesh->setMaterial(material);

    colorConstant = shader->getFragmentShaderConstant("inColor");
    viewMatrixConstant = shader->getVertexShaderConstant("viewMatrix");
    projectionMatrixConstant = shader->getVertexShaderConstant("projectionMatrix");
}

DebugGraphics::~DebugGraphics() {
    delete mesh;
    delete material;
    delete shader;
}

void DebugGraphics::setViewMatrix(const PGE::Matrix4x4f& viewMatrix) {
    viewMatrixConstant->setValue(viewMatrix);
}

void DebugGraphics::setProjectionMatrix(const PGE::Matrix4x4f& projectionMatrix) {
    projectionMatrixConstant->setValue(projectionMatrix);
}

void DebugGraphics::draw3DLine(const PGE::Line3f& line, const PGE::Color& color, float thickness) {
    colorConstant->setValue(color);

    std::vector<PGE::Vertex> vertices;
    std::vector<PGE::Primitive> triangles;

    PGE::Vector3f v1 = line.pointB.subtract(line.pointA).normalize();
    PGE::Vector3f v2 = fabs(v1.dotProduct(PGE::Vector3f(0, 1, 0))) < 0.8f ? PGE::Vector3f(0, 1, 0) : PGE::Vector3f(0, 0, 1);
    PGE::Vector3f v3 = v1.crossProduct(v2).normalize();
    v2 = v1.crossProduct(v3).normalize();

    PGE::Vertex vertex;
    PGE::Vector3f tempPos;

    vertex.setVector3f("normal", v3);

    tempPos = line.pointA.add(v2.multiply(thickness));
    vertex.setVector4f("position", PGE::Vector4f(tempPos, 1.f));
    vertices.push_back(vertex);
    tempPos = line.pointA.add(v2.multiply(-thickness));
    vertex.setVector4f("position", PGE::Vector4f(tempPos, 1.f));
    vertices.push_back(vertex);
    tempPos = line.pointB.add(v2.multiply(thickness));
    vertex.setVector4f("position", PGE::Vector4f(tempPos, 1.f));
    vertices.push_back(vertex);
    tempPos = line.pointB.add(v2.multiply(-thickness));
    vertex.setVector4f("position", PGE::Vector4f(tempPos, 1.f));
    vertices.push_back(vertex);
    triangles.push_back(PGE::Primitive(0,1,2));
    triangles.push_back(PGE::Primitive(1,2,3));
    triangles.push_back(PGE::Primitive(0,2,1));
    triangles.push_back(PGE::Primitive(2,1,3));

    vertex.setVector3f("normal", v2);

    tempPos = line.pointA.add(v3.multiply(thickness));
    vertex.setVector4f("position", PGE::Vector4f(tempPos, 1.f));
    vertices.push_back(vertex);
    tempPos = line.pointA.add(v3.multiply(-thickness));
    vertex.setVector4f("position", PGE::Vector4f(tempPos, 1.f));
    vertices.push_back(vertex);
    tempPos = line.pointB.add(v3.multiply(thickness));
    vertex.setVector4f("position", PGE::Vector4f(tempPos, 1.f));
    vertices.push_back(vertex);
    tempPos = line.pointB.add(v3.multiply(-thickness));
    vertex.setVector4f("position", PGE::Vector4f(tempPos, 1.f));
    vertices.push_back(vertex);
    triangles.push_back(PGE::Primitive(4,5,6));
    triangles.push_back(PGE::Primitive(5,6,7));
    triangles.push_back(PGE::Primitive(4,6,5));
    triangles.push_back(PGE::Primitive(6,5,7));

    mesh->setGeometry(8, vertices, 8, triangles);
    mesh->render();
}
