#ifndef RM2_H_INCLUDED
#define RM2_H_INCLUDED

#include <vector>
#include <map>

#include <Math/Matrix.h>
#include <Mesh/Mesh.h>
#include <Shader/Shader.h>
#include <Texture/Texture.h>
#include <Misc/FilePath.h>
#include <Color/Color.h>

class CollisionMesh;
class GraphicsResources;
class Camera;

struct PointLight {
    PGE::Vector3f position;
    PGE::Vector2f range;
    PGE::Color color;
};

struct Spotlight {
    PGE::Vector3f position;
    PGE::Vector2f range;
    PGE::Vector3f direction;
    PGE::Vector2f cone;
    PGE::Color color;
};

struct Waypoint {
    PGE::Vector3f position;
    std::vector<int> connections;
};

enum class RM2Error {
    None = 0,
    InvalidHeader,
    UnexpectedChunk,
    ReadPastEof
};

class RM2 {
    private:
        std::map<unsigned short, PGE::Material*> materials;

        struct TextureEntry {
            PGE::Texture* texture;
            PGE::Texture* normalMap;
            PGE::Shader* shader;
        };

        std::vector<TextureEntry> textures;
        GraphicsResources* graphicsResources;

        PGE::Shader* opaqueShader;
        PGE::Shader::Constant* opaqueModelMatrixConstant;

        PGE::Shader* opaqueNormalMapShader;
        PGE::Shader::Constant* opaqueNormalMapModelMatrixConstant;

        PGE::Shader* alphaShader;
        PGE::Shader::Constant* alphaModelMatrixConstant;

        std::vector<PGE::Mesh*> opaqueMeshes;
        std::vector<PGE::Mesh*> alphaMeshes;

        std::vector<CollisionMesh*> collisionMeshes;
        std::vector<PointLight> pointLights;
        std::vector<Spotlight> spotlights;
        std::vector<Waypoint> waypoints;

        RM2Error error;

    public:
        RM2(GraphicsResources* gfxMgr, const PGE::String& filename);
        //~RM2();

        //RM2Error getError() const;

        void render(const PGE::Matrix4x4f& modelMatrix);

        const std::vector<CollisionMesh*>& getCollisionMeshes() const;
        CollisionMesh* getCollisionMesh(int index) const;
        int collisionMeshCount() const;
        //const std::vector<PointLight>& getPointLights() const;
        //const std::vector<Spotlight>& getSpotlights() const;
        //const std::vector<Waypoint>& getWaypoints() const;
};

#endif // RM2_H_INCLUDED
