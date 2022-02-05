#include "CBR.h"

#include <set>
#include <fstream>

#include <PGE/File/BinaryReader.h>
#include <PGE/Graphics/Material.h>

#include "../Graphics/GraphicsResources.h"
#include "../Utils/TextureUtil.h"

using namespace PGE;

const String TEXTURE_PATH = "SCPCB/GFX/Map/Textures/";

static const FilePath shaderPath = FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaque/");
static const FilePath shaderNormalPath = FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaqueNormalMap/");

enum class Lightmapped {
    No = 0,
    Fully = 1,
    Outdated = 2,
};

CBR::CBR(GraphicsResources* gr, const String& filename) {
    this->gr = gr;

    shader = gr->getShader(FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaque/"), true);
    shaderModelMatrixConstant = shader->getVertexShaderConstant("modelMatrix");

    shaderNormal = gr->getShader(FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaqueNormalMap/"), true);
    shaderNormalModelMatrixConstant = shaderNormal->getVertexShaderConstant("modelMatrix");

    BinaryReader reader = BinaryReader(FilePath::fromStr(filename));

    std::vector<byte> header = reader.readBytes(3);
    PGE_ASSERT(
        header[0] == 'C' &&
        header[1] == 'B' &&
        header[2] == 'R', "CBR file is corrupted/invalid!");
    uint32_t revision = reader.read<u32>();

    // Lightmaps
    PGE_ASSERT((Lightmapped)reader.read<PGE::byte>() != Lightmapped::No, "CBR file without lightmaps");
    lightmaps.resize(4);
    for (int i = 0; i < 4; i++) {
        int size = reader.read<i32>();
        std::vector<byte> bytes = reader.readBytes(size);
        lightmaps[i] = TextureHelper::load(gr->getGraphics(), bytes);
    }

    // Texture dictionary
    int32_t texSize = reader.read<u32>();
    std::vector<String> textureNames(texSize);
    allTextures = std::vector<Texture*>();
    materials = std::vector<Material*>(texSize);
    std::set<int> toolTextures;
    // TODO: only skip tooltextures that are not recognized for an ingame purpose
    // i.e. tooltextures/invisible_collision should be handled as a special case
    for (int i = 0; i < texSize; i++) {
        reader.readStringInto(textureNames[i]);
        if (textureNames[i].findFirst("tooltextures") == textureNames[i].end()) {
            ReferenceVector<Texture> textures;
            for (int j = 0; j < 3; j++) {
                textures.push_back(*lightmaps[j]);
            }
            Texture* tex = gr->getTexture(TEXTURE_PATH + textureNames[i]);
            textures.push_back(*tex);
            allTextures.push_back(tex);
            bool normalMapped = false;
            Texture* texNormal = gr->getTexture(TEXTURE_PATH + textureNames[i] + "_n");
            if (texNormal != nullptr) {
                normalMapped = true;
                textures.push_back(*texNormal);
                allTextures.push_back(texNormal);
            }
            materials[i] = Material::create(*gr->getGraphics(), normalMapped ? *shaderNormal : *shader, textures, Opaque::YES);
        } else {
            toolTextures.insert(i);
        }
    }

    // Solids
    struct Vertex {
        Vector4f position;
        Vector3f normal;
        Vector2f lmUv;
        Vector2f diffUv;
        Color color;
    };

    // 2D arrays
    std::vector<std::vector<Vertex>> vertices = std::vector<std::vector<Vertex>>(texSize);
    std::vector<std::vector<Mesh::Triangle>> primitives = std::vector<std::vector<Mesh::Triangle>>(texSize);
    int solidCount = reader.read<i32>();
    for (int i = 0; i < solidCount; i++) {
        int faceCount = reader.read<i32>();
        for (int j = 0; j < faceCount; j++) {
            int textureID = reader.read<i32>();
            // 2 * Coordinate (= 3 * float) + 5 * decimal
            reader.skip(2 * 3 * 4 + 5 * 16);
            int vertexCount = reader.read<i32>();
            int vertexOffset = (int)vertices[textureID].size();
            for (int k = 1; k < vertexCount - 1; k++) {
                primitives[textureID].push_back(Mesh::Triangle(
                    vertexOffset,
                    vertexOffset + k + 1,
                    vertexOffset + k
                ));
            }
            for (int k = 0; k < vertexCount; k++) {
                Vertex tempVertex;
                tempVertex.position = Vector4f(reader.read<Vector3f>(), 1.f);
                tempVertex.normal = Vector3fs::ONE;
                tempVertex.lmUv = reader.read<Vector2f>();
                tempVertex.diffUv = reader.read<Vector2f>();
                tempVertex.color = Colors::WHITE;
                vertices[textureID].push_back(tempVertex);
            }
        }
    }
    meshes.reserve(texSize);
    for (int i = 0; i < texSize; i++) {
        if (toolTextures.find(i) == toolTextures.end()) {
            Mesh* newMesh = Mesh::create(*gr->getGraphics());
            newMesh->setMaterial(materials[i]);

            StructuredData vertexData = StructuredData(materials[i]->getShader().getVertexLayout(), vertices[i].size());
            for (int j = 0; j < vertices[i].size(); j++) {
                vertexData.setValue(j, "position", vertices[i][j].position);
                vertexData.setValue(j, "normal", vertices[i][j].normal);
                vertexData.setValue(j, "lmUv", vertices[i][j].lmUv);
                vertexData.setValue(j, "diffUv", vertices[i][j].diffUv);
            }

            newMesh->setGeometry(std::move(vertexData), primitives[i]);
            meshes.push_back(newMesh);
        }
    }
}

CBR::~CBR() {
    for (Material* mat : materials) {
        delete mat;
    }
    gr->dropShader(shader);
    gr->dropShader(shaderNormal);
    for (int i = 0; i < 4; i++) {
        delete lightmaps[i];
    }
    for (PGE::Texture* texture : allTextures) {
        gr->dropTexture(texture);
    }
}

void CBR::render(const Matrix4x4f& modelMatrix) {
    shaderModelMatrixConstant->setValue(modelMatrix);
    shaderNormalModelMatrixConstant->setValue(modelMatrix);
    for (Mesh* m : meshes) {
        m->render();
    }
}
