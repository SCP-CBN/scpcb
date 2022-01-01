#ifndef FONT_H_INCLUDED
#define FONT_H_INCLUDED

#include <vector>
#include <map>

#include <ft2build.h>
#include FT_FREETYPE_H

#include <PGE/Graphics/Texture.h>
#include <PGE/Graphics/Shader.h>
#include <PGE/Graphics/Mesh.h>
#include <PGE/File/FilePath.h>
#include <PGE/String/String.h>
#include <PGE/Math/Vector.h>
#include <PGE/Math/Rectangle.h>

class GraphicsResources;
class Config;

class Font {
    public:
        Font(FT_Library ftLibrary, GraphicsResources* gr, Config* con, const PGE::FilePath& fn, int h);
        ~Font();

        // Simplified input parameters.
        void draw(const PGE::String& text, const PGE::Vector2f& pos, float scale, float rotation = 0.f, const PGE::Color& color = PGE::Color(1.f, 1.f, 1.f));
        void draw(const PGE::String& text, const PGE::Vector3f& pos, const PGE::Vector2f& scale, const PGE::Vector3f& rotation = PGE::Vector3fs::ZERO, const PGE::Color& color = PGE::Color(1.f,1.f,1.f));

        float stringWidth(const PGE::String& text, float scale);
        float getHeight(float scale) const;

    private:
        Font();

        struct GlyphData {
            int atlasIndex;
            PGE::Vector2f drawOffset;
            float horizontalAdvance;
            PGE::Rectanglef srcRect;
        };

        struct Atlas {
            PGE::Texture* texture;
            PGE::Material* material;
            PGE::Mesh* mesh;

            struct Vertex {
                PGE::Vector3f position;
                PGE::Vector2f uv;
            };

            std::vector<Vertex> vertices;
            std::vector<PGE::Mesh::Triangle> primitives;

            PGE::StructuredData generateVertexData() const;
        };

        std::vector<Atlas> atlases;

        PGE::FilePath shaderPath = PGE::FilePath::fromStr("SCPCB/GFX/Shaders/Text/");
        PGE::Shader* shader;
        PGE::Shader::Constant* modelMatrixConstant;
        PGE::Shader::Constant* colorConstant;

        void renderAtlas(long chr);

        int height;
        FT_Face freeTypeFace;

        std::map<long,GlyphData> glyphData;

        GraphicsResources* graphicsRes;
        Config* config;

        PGE::FilePath filename;
};

#endif // FONT_H_INCLUDED
