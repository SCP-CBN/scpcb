#include "GraphicsResources.h"

#include <assimp/mesh.h>

#include "../Models/Model.h"
#include "../Utils/ResourcePackManager.h"
#include "../Utils/TextureUtil.h"
#include "../Save/Config.h"
#include "Camera.h"
#include "DebugGraphics.h"

GraphicsResources::GraphicsResources(PGE::Graphics* gfx, Config* con) {
    con->setGraphicsResources(this);
    updateOrthoMat(con->getAspectRatio());
    graphics = gfx;
    rpm = new ResourcePackManager(con->resourcePackLocations, con->enabledResourcePacks);
    debugGraphics = new DebugGraphics(gfx);

    modelImporter = new Assimp::Importer();
    modelImporter->SetPropertyInteger(AI_CONFIG_PP_RVC_FLAGS,
        aiComponent_CAMERAS |
        aiComponent_LIGHTS |
        aiComponent_COLORS |
        aiComponent_ANIMATIONS |
        aiComponent_BONEWEIGHTS
    );
    modelImporter->SetPropertyInteger(AI_CONFIG_PP_SLM_VERTEX_LIMIT, 65535);
    modelImporter->SetPropertyInteger(AI_CONFIG_PP_SLM_TRIANGLE_LIMIT, 65535);
    modelImporter->SetPropertyInteger(AI_CONFIG_PP_SBP_REMOVE, aiPrimitiveType_POINT | aiPrimitiveType_LINE);
}

GraphicsResources::~GraphicsResources() {
    delete rpm;
    delete debugGraphics;
    delete modelImporter;
}

PGE::Shader* GraphicsResources::getShader(const PGE::FilePath& filename, bool needsViewProjection) {
    auto find = pathToShaders.find(filename.str());
    if (find != pathToShaders.end()) {
        find->second->refCount++;
        return find->second->shader;
    }

    ShaderEntry* newShader = new ShaderEntry();
    newShader->refCount = 1;
    newShader->shader = PGE::Shader::load(*graphics, filename);
    newShader->filename = filename;
    newShader->needsViewProjection = needsViewProjection;
    pathToShaders.emplace(filename.str(), newShader);
    shaderToShaders.emplace(newShader->shader, newShader);
    return newShader->shader;
}

void GraphicsResources::dropShader(PGE::Shader* shader) {
    auto find = shaderToShaders.find(shader);
    if (find != shaderToShaders.end()) {
        ShaderEntry* shaderEntry = find->second;
        shaderEntry->refCount--;
        if (shaderEntry->refCount <= 0) {
            delete shaderEntry->shader;
            pathToShaders.erase(shaderEntry->filename.str());
            shaderToShaders.erase(find);
            delete shaderEntry;
        }
    }
}

PGE::Texture* GraphicsResources::getTexture(const PGE::String& filename) {
    bool b;
    return getTexture(filename, b);
}

PGE::Texture* GraphicsResources::getTexture(const PGE::String& filename, bool& isNew) {
    auto it = refCountStr.find(filename);
    if (it != refCountStr.end()) {
        it->second->count++;
        isNew = false;
        return it->second->ptr;
    }
    isNew = true;
    PGE::FilePath path = rpm->getHighestModPath(filename);
    if (!path.exists()) { return nullptr; }
    Content* ret = new Content{
        filename,
        TextureHelper::load(graphics, path),
        1,
    };
    refCountStr.emplace(filename, ret);
    refCountPtr.emplace(ret->ptr, ret);
    return ret->ptr;
}

bool GraphicsResources::dropTexture(PGE::Texture* texture) {
    auto it = refCountPtr.find(texture);
    PGE_ASSERT(it != refCountPtr.end(), "ptr was not registered");
    it->second->count--;
    if (it->second->count == 0) {
        refCountStr.erase(refCountStr.find(it->second->str));
        delete it->second;
        refCountPtr.erase(it);
        delete texture;
        return true;
    }
    return false;
}

void GraphicsResources::addTextureRef(PGE::Texture* ptr) {
    auto it = refCountPtr.find(ptr);
    PGE_ASSERT(it != refCountPtr.end(), "ptr was not registered");
    it->second->count++;
}

void GraphicsResources::registerTexture(const PGE::String& name, PGE::Texture* ptr) {
    Content* ret = new Content{
        name,
        TextureHelper::load(graphics, rpm->getHighestModPath(name)),
        0,
    };
    refCountStr.emplace(name, ret);
    refCountPtr.emplace(ret->ptr, ret);
}

ModelInstance* GraphicsResources::getModelInstance(const PGE::String& filename) {
    auto find = pathToModels.find(filename);
    if (find != pathToModels.end()) {
        find->second->refCount++;
        return new ModelInstance(find->second->model);
    }

    ModelEntry* newModel = new ModelEntry();
    newModel->refCount = 1;
    newModel->model = new Model(modelImporter, this, filename);
    newModel->filename = filename;
    pathToModels.emplace(filename, newModel);
    modelToModels.emplace(newModel->model, newModel);
    return new ModelInstance(newModel->model);
}

void GraphicsResources::dropModelInstance(ModelInstance* mi) {
    auto find = modelToModels.find(mi->getModel());
    if (find != modelToModels.end()) {
        ModelEntry* model = find->second;
        model->refCount--;
        if (model->refCount <= 0) {
            delete model->model;
            pathToModels.erase(model->filename);
            modelToModels.erase(find);
            delete model;
        }
    }
}

void GraphicsResources::updateOrthoMat(float aspectRatio) {
    // Define our screen space for UI elements.
    // Top Left     - [-50, -50]
    // Bottom Right - [50, 50]
    // Horizontal plane is scaled with the aspect ratio.
    float w = 100.f * aspectRatio;
    float h = 100.f;
    float nearZ = 0.01f;
    float farZ = 1.f;
    // TODO: I really don't fucking know.
    orthoMat = PGE::Matrix4x4f::constructOrthographicMat(-w, -h, nearZ, -farZ);
}

PGE::Matrix4x4f GraphicsResources::getOrthoMat() const {
    return orthoMat;
}

void GraphicsResources::setCameraUniforms(const Camera* cam) const {
    for (const auto& entry : shaderToShaders) {
        if (entry.second->needsViewProjection) {
            entry.first->getVertexShaderConstant("viewMatrix")->setValue(cam->getViewMatrix());
            entry.first->getVertexShaderConstant("projectionMatrix")->setValue(cam->getProjectionMatrix());
        }
    }

    debugGraphics->setViewMatrix(cam->getViewMatrix());
    debugGraphics->setProjectionMatrix(cam->getProjectionMatrix());
}

PGE::Graphics* GraphicsResources::getGraphics() const {
    return graphics;
}

DebugGraphics* GraphicsResources::getDebugGraphics() const {
    return debugGraphics;
}
