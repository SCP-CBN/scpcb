#ifndef CBR_H_INCLUDED
#define CBR_H_INCLUDED

#include <Mesh/Mesh.h>
#include <String/String.h>
#include <Math/Matrix.h>
#include <Shader/Shader.h>

class CollisionMesh;
class GraphicsResources;


class CBR {
    private:
        GraphicsResources* gr;

        PGE::Texture** lightmaps;
        std::vector<PGE::Texture*> allTextures;
        std::vector<PGE::Material*> materials;
        std::vector<PGE::Mesh*> meshes;

        PGE::Shader* shader;
        PGE::Shader::Constant* shaderModelMatrixConstant;
        PGE::Shader* shaderNormal;
        PGE::Shader::Constant* shaderNormalModelMatrixConstant;

        std::vector<CollisionMesh*> collisionMeshes;

    public:
        CBR(GraphicsResources* gr, const PGE::String& filename);
        ~CBR();

        void render(const PGE::Matrix4x4f& modelMatrix);

        const std::vector<CollisionMesh*>& getCollisionMeshes() const;
        CollisionMesh* getCollisionMesh(int index) const;
        int collisionMeshCount() const;
};

#endif // CBR_H_INCLUDED
