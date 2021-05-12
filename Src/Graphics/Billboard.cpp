#include "Billboard.h"

#include <math.h>

#include "GraphicsResources.h"
#include "Camera.h"

BillboardManager::BillboardManager(PGE::Graphics* gfx, GraphicsResources* gr, Camera* cam) {
    gfxRes = gr;
    camera = cam;
    shader = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/Billboard/"), true);
}

BillboardManager::~BillboardManager() {
    std::unordered_map<PGE::String::Key, BillboardMesh> meshesCopy = meshes;
    for (std::unordered_map<PGE::String::Key, BillboardMesh>::iterator it=meshesCopy.begin();it!=meshesCopy.end();it++) {
        BillboardMesh& mesh = it->second;
        for (int i = (int)mesh.billboards.size()-1; i >= 0; i--) {
            delete mesh.billboards[i];
        }
    }
    gfxRes->dropShader(shader);
}

void BillboardManager::addBillboard(Billboard* billboard) {
    billboard->markAsDirty();
    PGE::String texName = billboard->getTexture();
    auto it = meshes.find(texName);
    if (it == meshes.end()) {
        BillboardMesh newMesh;
        newMesh.texture = gfxRes->getTexture(texName);
        newMesh.material = new PGE::Material(shader, newMesh.texture, false);
        newMesh.mesh = PGE::Mesh::create(gfxRes->getGraphics(), PGE::Primitive::Type::TRIANGLE);
        newMesh.mesh->setMaterial(newMesh.material);
        meshes.emplace(texName, newMesh);
        it = meshes.find(texName);
    }
    it->second.geomChanged = true;
    it->second.billboards.push_back(billboard);
}

void BillboardManager::removeBillboard(Billboard* billboard) {
    PGE::String texName = billboard->getTexture();
    auto it = meshes.find(texName);
    if (it != meshes.end()) {
        std::vector<Billboard*>& billboards = it->second.billboards;
        for (int i=0;i<billboards.size();i++) {
            if (billboards[i] == billboard) {
                it->second.geomChanged = true;
                billboards.erase(billboards.begin()+i);
                break;
            }
        }
        if (billboards.size() <= 0) {
            delete it->second.mesh;
            delete it->second.material;
            gfxRes->dropTexture(it->second.texture);
            meshes.erase(texName);
        }
    }
}

void BillboardManager::render() {
    for (auto it=meshes.begin();it!=meshes.end();it++) {
        BillboardMesh& mesh = it->second;
        // Insertion sort.
        bool& geomChanged = mesh.geomChanged;
        for (int i = 0; i < mesh.billboards.size(); i++) {
            mesh.billboards[i]->camDistance = mesh.billboards[i]->getPosition().distanceSquared(camera->position);
            Billboard* b = mesh.billboards[i];
            int j;
            for (j=i-1;j>=0;j--) {
                if (b->camDistance > mesh.billboards[j]->camDistance) {
                    mesh.billboards[j+1] = mesh.billboards[j];
                    geomChanged = true;
                } else {
                    break;
                }
            }
            mesh.billboards[j+1] = b;
        }
        if (mesh.vertices.size() < mesh.billboards.size()*4) {
            geomChanged = true;
            mesh.vertices.resize(mesh.billboards.size()*4);
            int prevSize = (int)primitives.size();
            for (int i=prevSize;i<(mesh.vertices.size() / 2);i+=2) {
                primitives.push_back(PGE::Primitive((i*2)+2, (i*2)+1, (i*2)+0));
                primitives.push_back(PGE::Primitive((i*2)+1, (i*2)+2, (i*2)+3));
            }
        }
        for (int i=0;i<mesh.billboards.size();i++) {
            geomChanged |= mesh.billboards[i]->updateVertices(mesh.vertices, i*4);
        }
        if (geomChanged) {
            mesh.mesh->setGeometry((int)mesh.billboards.size() * 4, mesh.vertices, (int)mesh.billboards.size() * 2, primitives);
            geomChanged = false;
        }
        mesh.mesh->render();
    }
}

Billboard::Billboard(BillboardManager* bm, const PGE::String& textureName, const PGE::Vector3f& pos, float rotation, const PGE::Vector2f& scale, const PGE::Color& color) {
    this->bm = bm;
    
    this->position = pos;
    this->scale = scale;
    this->color = color;

    this->rotation.x = rotation; alwaysFacingCamera = true;

    this->vertexStartIndex = -1;

    this->textureName = textureName;

    this->visible = true;

    bm->addBillboard(this);
}

Billboard::Billboard(BillboardManager* bm, const PGE::String& textureName, const PGE::Vector3f& pos, const PGE::Vector3f& rotation, const PGE::Vector2f& scale, const PGE::Color& color) {
    this->bm = bm;
    
    this->position = pos;
    this->scale = scale;
    this->color = color;

    this->rotation = rotation; alwaysFacingCamera = false;

    this->vertexStartIndex = -1;

    this->textureName = textureName;

    this->visible = true;

    bm->addBillboard(this);
}

Billboard::~Billboard() {
    bm->removeBillboard(this);
}

void Billboard::setTexture(const PGE::String& textureName) {
    bm->removeBillboard(this);
    this->textureName = textureName;
    markAsDirty();
    bm->addBillboard(this);
}

PGE::String Billboard::getTexture() const {
    return textureName;
}

void Billboard::setPosition(const PGE::Vector3f& position) {
    this->position = position;
    markAsDirty();
}

const PGE::Vector3f& Billboard::getPosition() const {
    return position;
}

void Billboard::setRotation(const PGE::Vector3f& rotation) {
    this->rotation = rotation; alwaysFacingCamera = false;
    markAsDirty();
}

void Billboard::setRotation(float rotation) {
    this->rotation.x = rotation; alwaysFacingCamera = true;
    markAsDirty();
}

void Billboard::setScale(const PGE::Vector2f& scale) {
    this->scale = scale;
    markAsDirty();
}

void Billboard::setColor(const PGE::Color& color) {
    this->color = color;
    markAsDirty();
}

void Billboard::setVisible(bool vis) {
    if (visible != vis) {
        visible = vis;
        if (visible) {
            bm->addBillboard(this);
        } else {
            bm->removeBillboard(this);
        }
    }
}

bool Billboard::getVisible() {
    return visible;
}

void Billboard::markAsDirty() {
    vertexStartIndex = -1;
}

bool Billboard::updateVertices(std::vector<PGE::Vertex>& vertices, int startIndex) {
    if (startIndex == vertexStartIndex) { return false; }

    vertexStartIndex = startIndex;
    if (alwaysFacingCamera) {
        float sinRotation = sin(rotation.x);
        float cosRotation = cos(rotation.x);

        PGE::Vector2f offset0 = PGE::Vector2f((scale.x * 0.5f * cosRotation) + (scale.y * 0.5f * sinRotation), (-scale.x * 0.5f * sinRotation) + (scale.y * 0.5f* cosRotation));
        PGE::Vector2f offset1 = PGE::Vector2f((-scale.x * 0.5f * cosRotation) + (scale.y * 0.5f * sinRotation), (scale.x * 0.5f * sinRotation) + (scale.y * 0.5f* cosRotation));
        PGE::Vector2f offset2 = PGE::Vector2f((scale.x * 0.5f * cosRotation) + (-scale.y * 0.5f * sinRotation), (-scale.x * 0.5f * sinRotation) + (-scale.y * 0.5f* cosRotation));
        PGE::Vector2f offset3 = PGE::Vector2f((-scale.x * 0.5f * cosRotation) + (-scale.y * 0.5f * sinRotation), (scale.x * 0.5f * sinRotation) + (-scale.y * 0.5f* cosRotation));

        vertices[startIndex + 0].setVector4f("position", PGE::Vector4f(position,1.f));
        vertices[startIndex + 0].setVector2f("offset", offset0);
        vertices[startIndex + 1].setVector4f("position", PGE::Vector4f(position,1.f));
        vertices[startIndex + 1].setVector2f("offset", offset1);
        vertices[startIndex + 2].setVector4f("position", PGE::Vector4f(position,1.f));
        vertices[startIndex + 2].setVector2f("offset", offset2);
        vertices[startIndex + 3].setVector4f("position", PGE::Vector4f(position,1.f));
        vertices[startIndex + 3].setVector2f("offset", offset3);
    } else {
        PGE::Matrix4x4f rotationMatrix = PGE::Matrix4x4f::rotate(rotation);
        PGE::Vector3f offset0 = rotationMatrix.transform(PGE::Vector3f(scale.x * 0.5f, scale.y * 0.5f, 0.f));
        PGE::Vector3f offset1 = rotationMatrix.transform(PGE::Vector3f(-scale.x * 0.5f, scale.y * 0.5f, 0.f));
        PGE::Vector3f offset2 = rotationMatrix.transform(PGE::Vector3f(scale.x * 0.5f, -scale.y * 0.5f, 0.f));
        PGE::Vector3f offset3 = rotationMatrix.transform(PGE::Vector3f(-scale.x * 0.5f, -scale.y * 0.5f, 0.f));

        vertices[startIndex + 0].setVector4f("position", PGE::Vector4f(position.add(offset0),1.f));
        vertices[startIndex + 0].setVector2f("offset", PGE::Vector2f::ZERO);
        vertices[startIndex + 1].setVector4f("position", PGE::Vector4f(position.add(offset1),1.f));
        vertices[startIndex + 1].setVector2f("offset", PGE::Vector2f::ZERO);
        vertices[startIndex + 2].setVector4f("position", PGE::Vector4f(position.add(offset2),1.f));
        vertices[startIndex + 2].setVector2f("offset", PGE::Vector2f::ZERO);
        vertices[startIndex + 3].setVector4f("position", PGE::Vector4f(position.add(offset3),1.f));
        vertices[startIndex + 3].setVector2f("offset", PGE::Vector2f::ZERO);
    }

    vertices[startIndex + 0].setVector2f("texCoords", PGE::Vector2f(0.f,0.f));
    vertices[startIndex + 1].setVector2f("texCoords", PGE::Vector2f(1.f,0.f));
    vertices[startIndex + 2].setVector2f("texCoords", PGE::Vector2f(0.f,1.f));
    vertices[startIndex + 3].setVector2f("texCoords", PGE::Vector2f(1.f,1.f));
    vertices[startIndex + 0].setColor("color", color);
    vertices[startIndex + 1].setColor("color", color);
    vertices[startIndex + 2].setColor("color", color);
    vertices[startIndex + 3].setColor("color", color);

    return true;
}
