#include "Font.h"

#include <Math/Matrix.h>

#include <inttypes.h>
#include <stdlib.h>
#include <stdio.h>

#include "../Graphics/GraphicsResources.h"
#include "../Save/Config.h"

Font::Font(FT_Library ftLibrary, GraphicsResources* gr, Config* con, const PGE::FilePath& fn, int h) {
    graphicsRes = gr;
    config = con;
    filename = fn;
    height = h;

    FT_New_Face(ftLibrary,
                filename.cstr(),
                0,
                &freeTypeFace);

    FT_Set_Pixel_Sizes(freeTypeFace,
                       0,
                       height);

    shader = gr->getShader(shaderPath, false);

    modelMatrixConstant = shader->getVertexShaderConstant("modelMatrix");
    colorConstant = shader->getFragmentShaderConstant("imageColor");

    shader->getVertexShaderConstant("projectionMatrix")->setValue(gr->getOrthoMat());

    renderAtlas(0);
}

Font::~Font() {
    for (int i=0;i<atlases.size();i++) {
        delete atlases[i].mesh;
        delete atlases[i].material;
        delete atlases[i].texture;
    }

    graphicsRes->dropShader(shader);

    FT_Done_Face(freeTypeFace);
}

void Font::renderAtlas(long chr) {
    bool needsNewAtlas = false;

    long startChr = chr-1024;
    if (startChr<0) { startChr = 0; }
    long endChr = startChr+2048;

    uint8_t* buffer = nullptr;
    int x = -1; int y = -1;
    int maxHeight = -1;
    for (long i=startChr;i<endChr;i++) {
        std::map<long,GlyphData>::iterator it = glyphData.find(i);
        if (it==glyphData.end()) {
            long glyphIndex = FT_Get_Char_Index(freeTypeFace,i);
            FT_Load_Glyph(freeTypeFace,
                          (FT_UInt)glyphIndex,
                          FT_LOAD_DEFAULT);
            if (glyphIndex != 0) {
                FT_Render_Glyph(freeTypeFace->glyph,
                                FT_RENDER_MODE_NORMAL);
                unsigned char* glyphBuffer = freeTypeFace->glyph->bitmap.buffer;
                int glyphWidth = freeTypeFace->glyph->bitmap.width;
                int glyphHeight = freeTypeFace->glyph->bitmap.rows;

                if (glyphWidth>0 && glyphHeight>0) {
                    if (buffer==nullptr) {
                        buffer = new uint8_t[atlasDims*atlasDims*4];
                        for (int j=0;j<atlasDims*atlasDims;j++) {
                            buffer[(j*4)+0]=255;
                            buffer[(j*4)+1]=255;
                            buffer[(j*4)+2]=255;
                            buffer[(j*4)+3]=0;
                        }
                        x=1; y=1; maxHeight=0;
                    }

                    if (x+glyphWidth+1>atlasDims-1) {
                        x=1; y+=maxHeight+1;
                        maxHeight = 0;
                    }
                    if (y+glyphHeight+1>atlasDims-1) {
                        needsNewAtlas = true;
                        break;
                    }
                    if (glyphHeight>maxHeight) { maxHeight = glyphHeight; }

                    for (int j=0;j<glyphWidth*glyphHeight;j++) {
                        int bufferPos = x+y*atlasDims;
                        bufferPos += (j%glyphWidth)+((j/glyphWidth)*atlasDims);
                        buffer[(bufferPos*4)+3]=glyphBuffer[j];
                    }

                    GlyphData gd;
                    gd.atlasIndex = (int)atlases.size();
                    gd.horizontalAdvance = (float)(freeTypeFace->glyph->metrics.horiAdvance>>6);
                    gd.drawOffset = PGE::Vector2f((float)-freeTypeFace->glyph->bitmap_left, (float)(freeTypeFace->glyph->bitmap_top-height*10/15));
                    gd.srcRect = PGE::Rectanglef((float)x/(float)atlasDims,(float)y/(float)atlasDims,(float)(x+glyphWidth)/(float)atlasDims,(float)(y+glyphHeight)/(float)atlasDims);

                    x+=glyphWidth+1;

                    glyphData.emplace(i,gd);
                } else {
                    GlyphData gd;
                    gd.atlasIndex = -1;
                    gd.horizontalAdvance = (float)(freeTypeFace->glyph->metrics.horiAdvance>>6);
                    glyphData.emplace(i,gd);
                }
            } else {
                GlyphData gd;
                gd.atlasIndex = -1;
                gd.horizontalAdvance = (float)(freeTypeFace->glyph->metrics.horiAdvance>>6);
                glyphData.emplace(i,gd);
            }
        }
    }

    if (buffer!=nullptr) {
        Atlas newAtlas;
        newAtlas.texture = PGE::Texture::load(graphicsRes->getGraphics(),atlasDims,atlasDims,buffer,PGE::Texture::FORMAT::RGBA32);
        newAtlas.material = new PGE::Material(shader,newAtlas.texture);
        newAtlas.mesh = PGE::Mesh::create(graphicsRes->getGraphics(),PGE::Primitive::TYPE::TRIANGLE);
        newAtlas.mesh->setMaterial(newAtlas.material);
        atlases.push_back(newAtlas);
        delete[] buffer;
    }

    if (needsNewAtlas) {
        renderAtlas(chr);
    }
}

void Font::draw(const PGE::String& text, const PGE::Vector2f& pos, float scale, float rotation, const PGE::Color& color) {
    draw(text, PGE::Vector3f(pos.x,pos.y,0.1f), PGE::Vector2f(scale), PGE::Vector3f(0.f, 0.f, rotation), color);
}

void Font::draw(const PGE::String& text, const PGE::Vector3f& pos, const PGE::Vector2f& scale, const PGE::Vector3f& rotation, const PGE::Color& color) {
    PGE::Matrix4x4f modelMatrix = PGE::Matrix4x4f::constructWorldMat(pos, PGE::Vector3f(scale.x, scale.y, 1.f), rotation);

    PGE::Vector3f currPos = PGE::Vector3f::zero;

    modelMatrixConstant->setValue(modelMatrix);
    colorConstant->setValue(color);

    for (int i=0;i<atlases.size();i++) {
        atlases[i].mesh->clearGeometry();

        atlases[i].vertices.clear();
        atlases[i].primitives.clear();
    }
    for (int i=0;i<text.length();i++) {
        long chr = (long)text.charAt(i);
        std::map<long,GlyphData>::iterator it = glyphData.find(chr);
        if (it==glyphData.end()) {
            renderAtlas(chr);
            it = glyphData.find(chr);
        }

        PGE::Vertex vertex;

        if (it!=glyphData.end()) {
            if (it->second.atlasIndex>=0) {
                const GlyphData& gd = it->second;
                PGE::Vector3f glyphPos = PGE::Vector3f(currPos.x-gd.drawOffset.x,
                                                       currPos.y-gd.drawOffset.y,
                                                       currPos.z);
                PGE::Vector3f glyphPos2 = glyphPos.add(PGE::Vector3f(gd.srcRect.width()*atlasDims,gd.srcRect.height()*atlasDims,0.f));
                PGE::Vector2f glyphUv = PGE::Vector2f(gd.srcRect.topLeftCorner().x,gd.srcRect.topLeftCorner().y);
                PGE::Vector2f glyphUv2 = PGE::Vector2f(gd.srcRect.bottomRightCorner().x,gd.srcRect.bottomRightCorner().y);

                int vertCount = (int)atlases[it->second.atlasIndex].vertices.size();

                vertex.setVector3f("position", glyphPos);
                vertex.setVector2f("uv", glyphUv);
                atlases[it->second.atlasIndex].vertices.push_back(vertex);

                vertex.setVector3f("position", PGE::Vector3f(glyphPos2.x, glyphPos.y, glyphPos.z));
                vertex.setVector2f("uv", PGE::Vector2f(glyphUv2.x, glyphUv.y));
                atlases[it->second.atlasIndex].vertices.push_back(vertex);

                vertex.setVector3f("position", PGE::Vector3f(glyphPos.x, glyphPos2.y, glyphPos.z));
                vertex.setVector2f("uv", PGE::Vector2f(glyphUv.x, glyphUv2.y));
                atlases[it->second.atlasIndex].vertices.push_back(vertex);

                vertex.setVector3f("position", glyphPos2);
                vertex.setVector2f("uv", glyphUv2);
                atlases[it->second.atlasIndex].vertices.push_back(vertex);

                atlases[it->second.atlasIndex].primitives.push_back(PGE::Primitive(vertCount + 0, vertCount + 2, vertCount + 1));
                atlases[it->second.atlasIndex].primitives.push_back(PGE::Primitive(vertCount + 1, vertCount + 2, vertCount + 3));
            }
            currPos = currPos.add(PGE::Vector3f(it->second.horizontalAdvance,0.f,0.f));
        }
    }
    for (int i=0;i<atlases.size();i++) {
        atlases[i].mesh->setGeometry((int)atlases[i].vertices.size(), atlases[i].vertices, (int)atlases[i].primitives.size(), atlases[i].primitives);

        if (atlases[i].vertices.size()>0) {
            atlases[i].mesh->render();
        }
    }
}

float Font::stringWidth(const PGE::String& text, float scale) {
    float width = 0.f;

    for (int i = 0; i < text.length(); i++) {
        long chr = (long)text.charAt(i);
        std::map<long, GlyphData>::iterator it = glyphData.find(chr);
        if (it == glyphData.end()) {
            renderAtlas(chr);
            it = glyphData.find(chr);
        }

        width += it->second.horizontalAdvance;
    }

    return width * scale;
}

float Font::getHeight(float scale) const {
    return (float)height * scale * 10.f / 15.f;
}
