#ifndef CBR_H_INCLUDED
#define CBR_H_INCLUDED

#include <PGE/Graphics/Texture.h>
#include <PGE/Graphics/Shader.h>
#include <PGE/Graphics/Mesh.h>
#include <PGE/String/String.h>
#include <PGE/Math/Matrix.h>

class GraphicsResources;

class CBR {
    private:
        GraphicsResources* gr;

        std::vector<PGE::Texture*> lightmaps;
        std::vector<PGE::Texture*> allTextures;
        std::vector<PGE::Material*> materials;
        std::vector<PGE::Mesh*> meshes;

        PGE::Shader* shader;
        PGE::Shader::Constant* shaderModelMatrixConstant;
        PGE::Shader* shaderNormal;
        PGE::Shader::Constant* shaderNormalModelMatrixConstant;

    public:
        CBR(GraphicsResources* gr, const PGE::String& filename);
        ~CBR();

        void render(const PGE::Matrix4x4f& modelMatrix);
};

#endif // CBR_H_INCLUDED
