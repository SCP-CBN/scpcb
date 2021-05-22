#include "CBR.h"

#include <set>
#include <fstream>

#include <Misc/BinaryReader.h>

#include "../Collision/CollisionMesh.h"
#include "../Graphics/GraphicsResources.h"
#include "../Utils/TextureUtil.h"

const PGE::FilePath shaderPath = PGE::FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaque/");
const PGE::FilePath shaderNormalPath = PGE::FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaqueNormalMap/");
const PGE::String texturePath = "SCPCB/GFX/Map/Textures/";


enum Lightmapped {
    No = 0,
    Fully = 1,
    Outdated = 2,
};

inline bool fileExists(PGE::String filename) {
    struct stat buffer;
    return (stat(filename.cstr(), &buffer) == 0);
}

CBR::CBR(GraphicsResources* gr, const PGE::String& filename) {
    this->gr = gr;

    shader = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaque/"), true);
    shaderModelMatrixConstant = shader->getVertexShaderConstant("modelMatrix");

    shaderNormal = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/RoomOpaqueNormalMap/"), true);
    shaderNormalModelMatrixConstant = shaderNormal->getVertexShaderConstant("modelMatrix");

    PGE::BinaryReader reader = PGE::BinaryReader(PGE::FilePath::fromStr(filename));

    PGE_ASSERT(reader.readFixedLengthString(3) == "CBR", "CBR file is corrupted/invalid!");
    uint32_t revision = reader.readUInt();

    // Lightmaps
    PGE_ASSERT(reader.readByte() > No, "CBR file without lightmaps");
    lightmaps = new PGE::Texture*[4];
    for (int i = 0; i < 4; i++) {
        int size = reader.readInt();
        PGE::byte* bytes = reader.readBytes(size);
        lightmaps[i] = TextureHelper::load(gr->getGraphics(), bytes, size);
        delete[] bytes;
    }

    // Texture dictionary
    int32_t texSize = reader.readInt();
    PGE::String* textureNames = new PGE::String[texSize];
    allTextures = std::vector<PGE::Texture*>();
    materials = std::vector<PGE::Material*>(texSize);
    std::set<int> toolTextures;
    // TODO: only skip tooltextures that are not recognized for an ingame purpose
    // i.e. tooltextures/invisible_collision should be handled as a special case
    for (int i = 0; i < texSize; i++) {
        textureNames[i] = reader.readNullTerminatedString();
        //printf("Tried to grab CBR texture: %s.\n", (texturePath + textureNames[i]).cstr());

        if (textureNames[i].findFirst("tooltextures") == textureNames[i].end()) {
            //printf("Making CBR texture %s.\n", (texturePath + textureNames[i]).cstr());
            std::vector<PGE::Texture*> textures;
            for (int j = 0; j < 3; j++) {
                textures.push_back(lightmaps[j]);
            }

            PGE::String texPath = texturePath + textureNames[i];
            PGE::FilePath truePath = PGE::FilePath::fromStr(texPath);
            if (!fileExists(truePath.str() + ".jpg") && !fileExists(truePath.str() + ".png")) {
                PGE::String filenameFolder = filename.substr(filename.begin(), filename.findLast("/"));
                texPath = filenameFolder + "/" + textureNames[i];
                truePath = PGE::FilePath::fromStr(texPath);
                //printf("Trying path: %s --- ", truePath.cstr());
                if (!fileExists(truePath.str() + ".jpg") && !fileExists(truePath.str() + ".png")) {
                    texPath = filenameFolder + filename.substr(filename.findLast("/"), filename.findLast(".")) + "/" + textureNames[i];
                    truePath = PGE::FilePath::fromStr(texPath);
                    //printf("Trying path: %s --- ", truePath.cstr());
                    bool validTexture = (fileExists(truePath.str() + ".jpg") || fileExists(truePath.str() + ".png"));
                    PGE_ASSERT(validTexture, "Tried to load CBR with missing texture: " + textureNames[i]);
                }
            }
            PGE::Texture* tex = gr->getTexture(texPath);

            textures.push_back(tex);
            allTextures.push_back(tex);
            bool normalMapped = false;
            PGE::Texture* texNormal = gr->getTexture(texturePath.cstr() + textureNames[i] + "_n");
            if (texNormal != nullptr) {
                normalMapped = true;
                textures.push_back(texNormal);
                allTextures.push_back(texNormal);
            }
            materials[i] = new PGE::Material(normalMapped ? shaderNormal : shader, textures);
        } else {
            toolTextures.insert(i);
        }
    }

    // Solids
    // 2D arrays
    std::vector<PGE::Vector3f>* vertexPositions = new std::vector<PGE::Vector3f>[texSize];
    std::vector<PGE::Vertex>* vertices = new std::vector<PGE::Vertex>[texSize];
    std::vector<PGE::Primitive>* primitives = new std::vector<PGE::Primitive>[texSize];
    int solidCount = reader.readInt();
    for (int i = 0; i < solidCount; i++) {
        int faceCount = reader.readInt();
        for (int j = 0; j < faceCount; j++) {
            int textureID = reader.readInt();
            // 2 * Coordinate (= 3 * float) + 5 * decimal
            reader.skip(2 * 3 * 4 + 5 * 16);
            int vertexCount = reader.readInt();
            int vertexOffset = vertices[textureID].size();

            std::vector<int> indices;

            for (int k = 1; k < vertexCount - 1; k++) {
                primitives[textureID].push_back(PGE::Primitive(
                    vertexOffset,
                    vertexOffset + k + 1,
                    vertexOffset + k
                ));
            }
            for (int k = 0; k < vertexCount; k++) {
                PGE::Vertex tempVertex;
                PGE::Vector3f position = reader.readVector3f();
                tempVertex.setVector4f("position", PGE::Vector4f(position, 1.f));
                tempVertex.setVector3f("normal", PGE::Vector3f::ONE);
                tempVertex.setVector2f("lmUv", reader.readVector2f());
                tempVertex.setVector2f("diffUv", reader.readVector2f());
                tempVertex.setColor("color", PGE::Color::WHITE);
                vertices[textureID].push_back(tempVertex);

                vertexPositions[textureID].push_back(position);
            }
        }
    }


    meshes.reserve(texSize);
    for (int i = 0; i < texSize; i++) {
        if (toolTextures.find(i) == toolTextures.end()) {
            PGE::Mesh* newMesh = PGE::Mesh::create(gr->getGraphics(), PGE::Primitive::Type::TRIANGLE);
            newMesh->setMaterial(materials[i]);
            newMesh->setGeometry(vertices[i].size(), vertices[i], primitives[i].size(), primitives[i]);
            meshes.push_back(newMesh);

            collisionMeshes.push_back(new CollisionMesh(vertexPositions[i], primitives[i]));
        }
    }



    //delete[] indices;
    delete[] vertices;
    delete[] primitives;
    delete[] textureNames;
}

CBR::~CBR() {
    gr->dropShader(shader);
    gr->dropShader(shaderNormal);
    for (int i = 0; i < 4; i++) {
        delete lightmaps[i];
    }
    delete[] lightmaps;
    for (PGE::Texture* texture : allTextures) {
        gr->dropTexture(texture);
    }
    for (PGE::Material* material : materials) {
        delete material;
    }
}

void CBR::render(const PGE::Matrix4x4f& modelMatrix) {
    shaderModelMatrixConstant->setValue(modelMatrix);
    shaderNormalModelMatrixConstant->setValue(modelMatrix);
    for (PGE::Mesh* m : meshes) {
        m->render();
    }
}

const std::vector<CollisionMesh*>& CBR::getCollisionMeshes() const {
    return collisionMeshes;
}

CollisionMesh* CBR::getCollisionMesh(int index) const {
    return collisionMeshes[index];
}

int CBR::collisionMeshCount() const {
    return (int)collisionMeshes.size();
}
