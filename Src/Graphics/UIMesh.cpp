#include "UIMesh.h"

#include "../Graphics/GraphicsResources.h"
#include "../Utils/ResourcePackManager.h"
#include "../Utils/TextureUtil.h"

UIMesh::UIMesh(GraphicsResources* gr) {
    gfxRes = gr;

    shaderTextured = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/UI/"), false);
    shaderTextureless = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/UITextureless/"), false);

    mesh = PGE::Mesh::create(gfxRes->getGraphics(), PGE::Primitive::TYPE::TRIANGLE);
    material = nullptr;

    shaderTexturedColorConstant = shaderTextured->getFragmentShaderConstant("imageColor");
    shaderTexturelessColorConstant = shaderTextureless->getFragmentShaderConstant("imageColor");
    
    color = PGE::Color::WHITE;
    shaderTexturedColorConstant->setValue(color);
    shaderTexturelessColorConstant->setValue(color);
    
    textureless = false;
    tiled = false;

    borderThickness = 0.5f;

    shaderTextured->getVertexShaderConstant("projectionMatrix")->setValue(gr->getOrthoMat());
    shaderTextureless->getVertexShaderConstant("projectionMatrix")->setValue(gr->getOrthoMat());
}

UIMesh::~UIMesh() {
    delete mesh;
    gfxRes->dropShader(shaderTextured);
    gfxRes->dropShader(shaderTextureless);
}

void UIMesh::startRender() {
    mesh->clearGeometry();
    vertices.clear(); primitives.clear();
}

void UIMesh::endRender() {
    if (vertices.size() > 0 && primitives.size() > 0) {
        mesh->setGeometry((int)vertices.size(), vertices, (int)primitives.size(), primitives);
        mesh->render();
    }

    mesh->clearGeometry();
    vertices.clear(); primitives.clear();
}

void UIMesh::setTextured(PGE::Texture* texture, bool tile) {
    if (textureless || tiled != tile || material == nullptr || texture != material->getTexture(0)) {
        endRender();

        tiled = tile;
        textureless = false;

        PGE::Material* prevMaterial = material;
        material = new PGE::Material(shaderTextured, texture);
        mesh->setMaterial(material);
        delete prevMaterial;

        startRender();
    }
}

void UIMesh::setTextured(const PGE::String& textureName, bool tile) {
    loadTexture(textureName);
    PGE::Texture* texture = nullptr;
    for (int i = 0; i < textures.size(); i++) {
        if (textures[i].name.equals(textureName)) {
            texture = textures[i].pgeTexture;
            break;
        }
    }

    setTextured(texture, tile);
}

void UIMesh::setTextureless() {
    if (!textureless) {
        endRender();

        textureless = true;

        PGE::Material* prevMaterial = material;
        material = new PGE::Material(shaderTextureless);
        mesh->setMaterial(material);
        delete prevMaterial;

        startRender();
    }
}

void UIMesh::setColor(PGE::Color col) {
    endRender();
    
    color = col;
    shaderTexturedColorConstant->setValue(color);
    shaderTexturelessColorConstant->setValue(color);
    
    startRender();
}

void UIMesh::addRect(const PGE::Rectanglef& rect) {
    PGE::Rectanglef uvRect;
    if (!textureless) {
        if (tiled) {
            // Lower the scale from [-50, 50] to [-2, 2] so there's less frequent tiling.
            float tileScale = 0.04f; // 2.f / 50.f;
            
            uvRect = PGE::Rectanglef(rect.topLeftCorner().multiply(tileScale), rect.bottomRightCorner().multiply(tileScale));
        } else {
            uvRect = PGE::Rectanglef(PGE::Vector2f(0.f, 0.f), PGE::Vector2f(1.f, 1.f));
        }
    }

    PGE::Vertex vertex;

    int index0 = (int)vertices.size();
    vertex.setVector2f("position", rect.topLeftCorner());
    if (!textureless) { vertex.setVector2f("uv", uvRect.topLeftCorner()); }
    vertices.push_back(vertex);

    int index1 = (int)vertices.size();
    vertex.setVector2f("position", rect.topRightCorner());
    if (!textureless) { vertex.setVector2f("uv", uvRect.topRightCorner()); }
    vertices.push_back(vertex);

    int index2 = (int)vertices.size();
    vertex.setVector2f("position", rect.bottomLeftCorner());
    if (!textureless) { vertex.setVector2f("uv", uvRect.bottomLeftCorner()); }
    vertices.push_back(vertex);

    int index3 = (int)vertices.size();
    vertex.setVector2f("position", rect.bottomRightCorner());
    if (!textureless) { vertex.setVector2f("uv", uvRect.bottomRightCorner()); }
    vertices.push_back(vertex);

    primitives.push_back(PGE::Primitive(index2, index1, index0));
    primitives.push_back(PGE::Primitive(index3, index1, index2));
}

void UIMesh::loadTexture(const PGE::String& textureName) {
    PGE::Texture* texture = nullptr;
    for (int i = 0; i < textures.size(); i++) {
        if (textures[i].name.equals(textureName)) {
            return;
        }
    }

    if (texture == nullptr) {
        texture = TextureHelper::load(gfxRes->getGraphics(), gfxRes->rpm->getHighestModPath(textureName));
        Texture cacheEntry;
        cacheEntry.name = textureName; cacheEntry.pgeTexture = texture;
        textures.push_back(cacheEntry);
    }
}
