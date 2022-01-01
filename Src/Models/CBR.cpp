#include "CBR.h"

#include <set>
#include <fstream>

#include <PGE/File/BinaryReader.h>
#include <PGE/Graphics/Material.h>

#include "../Graphics/GraphicsResources.h"
#include "../Utils/TextureUtil.h"

const PGE::String TEXTURE_PATH = "SCPCB/GFX/Map/Textures/";

PGE::FilePath CBR::shaderPath;
PGE::FilePath CBR::shaderNormalPath;

enum class Lightmapped {
    No = 0,
    Fully = 1,
    Outdated = 2,
};

CBR::CBR(GraphicsResources* gr, const PGE::String& filename) {
    if (!shaderPath.isValid()) {
        shaderPath = PGE::FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaque/");
        shaderNormalPath = PGE::FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaqueNormalMap/");
    }

    this->gr = gr;

    shader = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaque/"), true);
    shaderModelMatrixConstant = shader->getVertexShaderConstant("modelMatrix");

    shaderNormal = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaqueNormalMap/"), true);
    shaderNormalModelMatrixConstant = shaderNormal->getVertexShaderConstant("modelMatrix");

    PGE::BinaryReader reader = PGE::BinaryReader(PGE::FilePath::fromStr(filename));

    std::vector<PGE::byte> header = reader.readBytes(3);
    PGE::asrt(
        header[0] == 'C' &&
        header[1] == 'B' &&
        header[2] == 'R', "CBR file is corrupted/invalid!");
    uint32_t revision = reader.read<PGE::u32>();

    // Lightmaps
    PGE::asrt((Lightmapped)reader.read<PGE::byte>() != Lightmapped::No, "CBR file without lightmaps");
    lightmaps = new PGE::Texture*[4];
    for (int i = 0; i < 4; i++) {
        int size = reader.read<PGE::i32>();
        std::vector<PGE::byte> bytes = reader.readBytes(size);
        lightmaps[i] = TextureHelper::load(gr->getGraphics(), bytes);
    }

    // Texture dictionary
    int32_t texSize = reader.read<PGE::u32>();
    std::vector<PGE::String> textureNames(texSize);
    allTextures = std::vector<PGE::Texture*>();
    materials = std::vector<PGE::Material*>(texSize);
    std::set<int> toolTextures;
    // TODO: only skip tooltextures that are not recognized for an ingame purpose
    // i.e. tooltextures/invisible_collision should be handled as a special case
    for (int i = 0; i < texSize; i++) {
        reader.readStringInto(textureNames[i]);
        if (textureNames[i].findFirst("tooltextures") == textureNames[i].end()) {
            PGE::ReferenceVector<PGE::Texture> textures;
            for (int j = 0; j < 3; j++) {
                textures.push_back(*lightmaps[j]);
            }
            PGE::Texture* tex = gr->getTexture(TEXTURE_PATH + textureNames[i]);
            textures.push_back(*tex);
            allTextures.push_back(tex);
            bool normalMapped = false;
            PGE::Texture* texNormal = gr->getTexture(TEXTURE_PATH + textureNames[i] + "_n");
            if (texNormal != nullptr) {
                normalMapped = true;
                textures.push_back(*texNormal);
                allTextures.push_back(texNormal);
            }
            materials[i] = PGE::Material::create(*gr->getGraphics(), normalMapped ? *shaderNormal : *shader, textures, PGE::Opaque::YES);
        } else {
            toolTextures.insert(i);
        }
    }

    // Solids
    struct Vertex {
        PGE::Vector4f position;
        PGE::Vector3f normal;
        PGE::Vector2f lmUv;
        PGE::Vector2f diffUv;
        PGE::Color color;
    };

    // 2D arrays
    std::vector<std::vector<Vertex>> vertices = std::vector<std::vector<Vertex>>(texSize);
    std::vector<std::vector<PGE::Mesh::Triangle>> primitives = std::vector<std::vector<PGE::Mesh::Triangle>>(texSize);
    int solidCount = reader.read<PGE::i32>();
    for (int i = 0; i < solidCount; i++) {
        int faceCount = reader.read<PGE::i32>();
        for (int j = 0; j < faceCount; j++) {
            int textureID = reader.read<PGE::i32>();
            // 2 * Coordinate (= 3 * float) + 5 * decimal
            reader.skip(2 * 3 * 4 + 5 * 16);
            int vertexCount = reader.read<PGE::i32>();
            int vertexOffset = (int)vertices[textureID].size();
            for (int k = 1; k < vertexCount - 1; k++) {
                primitives[textureID].push_back(PGE::Mesh::Triangle(
                    vertexOffset,
                    vertexOffset + k + 1,
                    vertexOffset + k
                ));
            }
            for (int k = 0; k < vertexCount; k++) {
                Vertex tempVertex;
                tempVertex.position = PGE::Vector4f(reader.read<PGE::Vector3f>(), 1.f);
                tempVertex.normal = PGE::Vector3fs::ONE;
                tempVertex.lmUv = reader.read<PGE::Vector2f>();
                tempVertex.diffUv = reader.read<PGE::Vector2f>();
                tempVertex.color = PGE::Colors::WHITE;
                vertices[textureID].push_back(tempVertex);
            }
        }
    }
    meshes.reserve(texSize);
    for (int i = 0; i < texSize; i++) {
        if (toolTextures.find(i) == toolTextures.end()) {
            PGE::Mesh* newMesh = PGE::Mesh::create(*gr->getGraphics());
            newMesh->setMaterial(materials[i]);

            PGE::StructuredData vertexData = PGE::StructuredData(materials[i]->getShader().getVertexLayout(), vertices[i].size());
            for (int j = 0; j < vertices[i].size(); j++) {
                vertexData.setValue(j, "position", vertices[i][j].position);
                vertexData.setValue(j, "normal", vertices[i][j].normal);
                vertexData.setValue(j, "lmUv", vertices[i][j].lmUv);
                vertexData.setValue(j, "diffUv", vertices[i][j].diffUv);
                vertexData.setValue(j, "color", vertices[i][j].color);
            }

            newMesh->setGeometry(std::move(vertexData), primitives[i]);
            meshes.push_back(newMesh);
        }
    }
}

CBR::~CBR() {
    for (PGE::Material* mat : materials) {
        delete mat;
    }
    gr->dropShader(shader);
    gr->dropShader(shaderNormal);
    for (int i = 0; i < 4; i++) {
        delete lightmaps[i];
    }
    delete[] lightmaps;
    for (PGE::Texture* texture : allTextures) {
        gr->dropTexture(texture);
    }
}

void CBR::render(const PGE::Matrix4x4f& modelMatrix) {
    shaderModelMatrixConstant->setValue(modelMatrix);
    shaderNormalModelMatrixConstant->setValue(modelMatrix);
    for (PGE::Mesh* m : meshes) {
        m->render();
    }
}
