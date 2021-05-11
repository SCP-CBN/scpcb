#ifndef MODELMANAGER_H_INCLUDED
#define MODELMANAGER_H_INCLUDED

#include <assimp/Importer.hpp>

#include <Misc/FilePath.h>
#include <Math/Matrix.h>
#include <Mesh/Mesh.h>
#include <Shader/Shader.h>

class GraphicsResources;

class Model {
    private:
        GraphicsResources* gfxRes;

        PGE::Mesh** meshes;
        unsigned int meshCount;

        PGE::Material** materials;
        unsigned int materialCount;

        PGE::Shader* shader;

        PGE::Shader::Constant* modelMatrix;

        Model(); // We don't want this.
        
    public:
        Model(Assimp::Importer* importer, GraphicsResources* gr, const PGE::String& filename);
        ~Model();
        
        void render(const PGE::Matrix4x4f& modelMatrix) const;
};

class ModelInstance {
    private:
        Model* model;

        bool modelMatrixNeedsRecalculation;
        PGE::Matrix4x4f modelMatrix;

        PGE::Vector3f position = PGE::Vector3f::ZERO;
        PGE::Vector3f rotation = PGE::Vector3f::ZERO;
        PGE::Vector3f scale = PGE::Vector3f::ONE;

    public:
        ModelInstance(Model* model);

        void setPosition(const PGE::Vector3f& pos);
        void setRotation(const PGE::Vector3f& rot);
        void setScale(const PGE::Vector3f& scl);

        const PGE::Vector3f& getPosition() const;
        const PGE::Vector3f& getRotation() const;
        const PGE::Vector3f& getScale() const;

        Model* getModel() const;

        void render();
};

#endif // MODELMANAGER_H_INCLUDED
