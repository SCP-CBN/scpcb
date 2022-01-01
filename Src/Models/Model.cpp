#include "Model.h"

#include <assimp/postprocess.h>
#include <assimp/scene.h>
#include <assimp/mesh.h>
#include <assimp/vector3.h>

#include <PGE/Graphics/Material.h>

#include "../Graphics/GraphicsResources.h"

Model::Model(Assimp::Importer* importer, GraphicsResources* gr, const PGE::String& filename) {
    gfxRes = gr;
    shader = gr->getShader(PGE::FilePath::fromStr("SCPCB/GFX/Shaders/Model/"), true);
    modelMatrix = shader->getVertexShaderConstant("modelMatrix");
    PGE::Shader::Constant* colorConstant = shader->getFragmentShaderConstant("inColor");
    colorConstant->setValue(PGE::Colors::WHITE);
    
    PGE::String path = filename.substr(filename.begin(), filename.findLast("/") - 1);

    const aiScene* scene = importer->ReadFile(PGE::FilePath::fromStr(filename).str().cstr(),
        aiProcess_MakeLeftHanded |
        aiProcess_FlipUVs |
        aiProcess_FlipWindingOrder |
        aiProcess_CalcTangentSpace |
        aiProcess_PreTransformVertices |
        aiProcess_JoinIdenticalVertices |
        aiProcess_ImproveCacheLocality |
        aiProcess_GenSmoothNormals |
        aiProcess_SplitLargeMeshes |
        aiProcess_Triangulate |
        aiProcess_RemoveComponent |
        aiProcess_RemoveRedundantMaterials |
        aiProcess_FindInvalidData |
        aiProcess_GenUVCoords |
        aiProcess_TransformUVCoords |
        aiProcess_OptimizeMeshes |
        aiProcess_Debone |
        aiProcess_SortByPType |
        aiProcess_FindDegenerates
    );

    PGE::String err = importer->GetErrorString();
    PGE::asrt(err.isEmpty(), "Failed to load model (err: " + err + ")");

    materialCount = scene->mNumMaterials;
    materials = new PGE::Material*[materialCount];
    for (unsigned i = 0; i < materialCount; i++) {
        aiString texturePath;
        PGE::asrt(scene->mMaterials[i]->GetTexture(aiTextureType_DIFFUSE, 0, &texturePath) == aiReturn_SUCCESS, "Texture for model " + filename + " failed to load.");
        PGE::String textureName = PGE::String(texturePath.C_Str()).replace("\\", "/");
        int lastSlash = textureName.findLast("/").getPosition();
        textureName = textureName.substr(lastSlash + 1, textureName.length() - lastSlash - 5);
        materials[i] = PGE::Material::create(*gfxRes->getGraphics(), *shader, *gr->getTexture(path + textureName), PGE::Opaque::YES);
    }

    meshCount = scene->mNumMeshes;
    meshes = new PGE::Mesh*[meshCount];
    for (unsigned i = 0; i < meshCount; i++) {
        aiMesh* mesh = scene->mMeshes[i];

        PGE::Material& material = *materials[mesh->mMaterialIndex];

        PGE::StructuredData vertices = PGE::StructuredData(material.getShader().getVertexLayout(), mesh->mNumVertices);
        for (unsigned j = 0; j < mesh->mNumVertices; j++) {
            vertices.setValue(j, "position", PGE::Vector4f((float)mesh->mVertices[j].x, (float)mesh->mVertices[j].y, (float)mesh->mVertices[j].z, 1.f));
            vertices.setValue(j, "normal", PGE::Vector3fs::ONE);
            vertices.setValue(j, "uv", PGE::Vector2f((float)mesh->mTextureCoords[0][j].x, (float)mesh->mTextureCoords[0][j].y));
        }

        std::vector<PGE::Mesh::Triangle> primitives;
        for (unsigned i = 0; i < mesh->mNumFaces; i++) {
            primitives.push_back(PGE::Mesh::Triangle(mesh->mFaces[i].mIndices[2], mesh->mFaces[i].mIndices[1], mesh->mFaces[i].mIndices[0]));
        }

        meshes[i] = PGE::Mesh::create(*gr->getGraphics());
        meshes[i]->setGeometry(vertices.copy(), primitives);
        meshes[i]->setMaterial(&material);
    }

    importer->FreeScene();
}

Model::~Model() {
    for (unsigned i = 0; i < meshCount; i++) {
        delete meshes[i];
    }
    delete[] meshes;

    for (unsigned i = 0; i < materialCount; i++) {
        for (int j = 0; j < materials[i]->getTextureCount(); j++) {
            gfxRes->dropTexture((PGE::Texture*)&materials[i]->getTexture(j));
        }
        delete materials[i];
    }
    delete[] materials;

    gfxRes->dropShader(shader);
}

void Model::render(const PGE::Matrix4x4f& modelMatrix) const {
    this->modelMatrix->setValue(modelMatrix);
    for (unsigned i = 0; i < meshCount; i++) {
        meshes[i]->render();
    }
}

ModelInstance::ModelInstance(Model* model) {
    this->model = model;
    modelMatrixNeedsRecalculation = false;
}

void ModelInstance::setPosition(const PGE::Vector3f& pos) {
    if (position != pos) {
        position = pos;
        modelMatrixNeedsRecalculation = true;
    }
}

void ModelInstance::setRotation(const PGE::Vector3f& rot) {
    if (rotation != rot) {
        rotation = rot;
        modelMatrixNeedsRecalculation = true;
    }
}

void ModelInstance::setScale(const PGE::Vector3f& scl) {
    if (scale != scl) {
        scale = scl;
        modelMatrixNeedsRecalculation = true;
    }
}

const PGE::Vector3f& ModelInstance::getPosition() const {
    return position;
}

const PGE::Vector3f& ModelInstance::getRotation() const {
    return rotation;
}

const PGE::Vector3f& ModelInstance::getScale() const {
    return scale;
}

Model* ModelInstance::getModel() const {
    return model;
}

void ModelInstance::render() {
    if (modelMatrixNeedsRecalculation) {
        modelMatrix = PGE::Matrix4x4f::constructWorldMat(position, rotation, scale);
        modelMatrixNeedsRecalculation = false;
    }
    model->render(modelMatrix);
}
