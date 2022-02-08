#ifndef GRAPHICSRESOURCES_H_INCLUDED
#define GRAPHICSRESOURCES_H_INCLUDED

#include <unordered_map>

#include <assimp/Importer.hpp>

#include <PGE/String/Key.h>

#include <PGE/Graphics/Graphics.h>
#include <PGE/Graphics/Shader.h>
#include <PGE/Graphics/Texture.h>

class Model;
class ModelInstance;
class ResourcePackManager;
class Config;
class Camera;
class DebugGraphics;

class GraphicsResources {
    private:
        struct ShaderEntry {
            PGE::FilePath filename;
            PGE::Shader* shader;
            int refCount;
            bool needsViewProjection;
        };
        std::unordered_map<PGE::Shader*, ShaderEntry*> shaderToShaders;
        std::unordered_map<PGE::String::Key, ShaderEntry*> pathToShaders;

        struct ModelEntry {
            // Having this as a string makes the loading of textures easier.
            PGE::String filename;
            Model* model;
            int refCount;
        };
        std::unordered_map<Model*, ModelEntry*> modelToModels;
        std::unordered_map<PGE::String::Key, ModelEntry*> pathToModels;

        // TEX
        struct Content {
            PGE::String str;
            PGE::Texture* ptr;
            int count;
        };
        std::unordered_map<PGE::String::Key, Content*> refCountStr;
        std::unordered_map<PGE::Texture*, Content*> refCountPtr;
        // TEX

        PGE::Matrix4x4f orthoMat;

        PGE::Graphics* graphics;

        DebugGraphics* debugGraphics;

        Assimp::Importer* modelImporter;

    public:
        ResourcePackManager* rpm;
        
        GraphicsResources(PGE::Graphics* gfx, Config* con);
        ~GraphicsResources();

        PGE::Shader* getShader(const PGE::FilePath& filename, bool needsViewProjection);
        void dropShader(PGE::Shader* shader);

        PGE::Texture* getTexture(const PGE::String& filename, bool& isNew);
        PGE::Texture* getTexture(const PGE::String& filename);
        bool dropTexture(PGE::Texture* texture);
        void addTextureRef(PGE::Texture* ptr);
        void registerTexture(const PGE::String& name, PGE::Texture* ptr);

        ModelInstance* getModelInstance(const PGE::String& filename);
        void dropModelInstance(ModelInstance* mi);
    
        void updateOrthoMat(float aspectRatio);
        PGE::Matrix4x4f getOrthoMat() const;
        void setCameraUniforms(const Camera* cam) const;

        PGE::Graphics* getGraphics() const;
        DebugGraphics* getDebugGraphics() const;
};

#endif // GRAPHICSRESOURCES_H_INCLUDED
