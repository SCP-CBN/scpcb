
#ifndef BBBLITZ3D_H
#define BBBLITZ3D_H

#include "bbsys.h"
#include "../blitz3d/blitz3d.h"
#include "../blitz3d/world.h"
#include "../blitz3d/texture.h"
#include "../blitz3d/brush.h"
#include "../blitz3d/camera.h"
#include "../blitz3d/sprite.h"
#include "../blitz3d/meshmodel.h"
#include "../blitz3d/loader_3ds.h"
#include "../blitz3d/loader_b3d.h"
#include "../blitz3d/md2model.h"
#include "../blitz3d/q3bspmodel.h"
#include "../blitz3d/meshutil.h"
#include "../blitz3d/pivot.h"
#include "../blitz3d/planemodel.h"
#include "../blitz3d/terrain.h"
#include "../blitz3d/listener.h"
#include "../blitz3d/cachedtexture.h"

extern gxScene *gx_scene;

void bbHWMultiTex(int enable);
int bbHWTexUnits();
int bbGfxDriverCaps3D();
void bbWBuffer(int enable);
void bbDither(int enable);
void bbAntiAlias(int enable);
void bbWireFrame(int enable);
void bbAmbientLight(float r, float g, float b);
void bbClearCollisions();
void bbUpdateWorld (float eslapsed=1.f);
void bbCaptureWorld ();
void bbRenderWorld(float tween=1.f);
void bbClearWorld(int e=1, int b=1, int t=1);
int bbActiveTextures();
int bbTrisRendered();
float bbStats3D(int n);
class Texture* bbCreateTexture(int w, int h, int flags=1, int frames=1);
class Texture* bbLoadTexture(String file, int flags=1);
class Texture* bbLoadAnimTexture(String file, int flags, int w, int h, int first, int cnt);
void bbFreeTexture(class Texture* t);
void bbTextureBlend(class Texture* t, int blend);
void bbTextureCoords(class Texture* t, int flags);
void bbRotateTexture(class Texture* t, float angle);
int bbTextureWidth(class Texture* t);
int bbTextureHeight(class Texture* t);
String bbTextureName(class Texture* t);
void bbSetCubeFace(class Texture* t, int face);
void bbSetCubeMode(class Texture* t, int mode);
class gxCanvas* bbTextureBuffer(class Texture* t, int frame=0);
void bbClearTextureFilters();
class Brush* bbCreateBrush(float r=255.f, float g=255.f, float b=255.f);
void bbFreeBrush(class Brush* b);
void bbBrushColor(class Brush* br, float r, float g, float b);
void bbBrushAlpha(class Brush* b, float alpha);
void bbBrushShininess(class Brush* b, float n);
void bbBrushTexture(class Brush* b, Texture* t, int frame, int index);
class Texture* bbGetBrushTexture(class Brush* b, int index);
void bbBrushBlend(class Brush* b, int blend);
void bbBrushFX(class Brush* b, int fx);
class MeshModel* bbLoadMesh(String f, class Object* p=nullptr);
class MeshModel* bbLoadAnimMesh(String f, class Object* p=nullptr);
int bbLoadAnimSeq(class Object* o, String f);
class MeshModel* bbCreateMesh(class Object* p=nullptr);
class MeshModel* bbCreateCube(class Object* p=nullptr);
class MeshModel* bbCreateSphere(int segs, class Object* p=nullptr);
class MeshModel* bbCreateCylinder(int segs, int solid, class Object* p=nullptr);
class MeshModel* bbCreateCone(int segs, int solid, class Object* p=nullptr);
class MeshModel* bbDeepCopyMesh(class MeshModel* m, class Object* p=nullptr);
void bbRotateMesh(class MeshModel* m, float x, float y, float z);
void bbPositionMesh(class MeshModel* m, float x, float y, float z);
void bbFitMesh(class MeshModel* m, float x, float y, float z, float w, float h, float d, int uniform);
void bbFlipMesh(class MeshModel* m);
void bbPaintMesh(class MeshModel* m, Brush* b);
void bbUpdateNormals(class MeshModel* m);
void bbLightMesh(class MeshModel* m, float r, float g, float b, float range = 0.f, float x = 0.f, float y = 0.f, float z = 0.f);
float bbMeshWidth(class MeshModel* m);
float bbMeshHeight(class MeshModel* m);
float bbMeshDepth(class MeshModel* m);
int bbCountSurfaces(class MeshModel* m);
void bbMeshCullBox(class MeshModel* m, float x, float y, float z, float width, float height, float depth);
class Surface* bbCreateSurface(class MeshModel* m, Brush* b);
class Brush* bbGetSurfaceBrush(class Surface* s);
class Brush* bbGetEntityBrush(class Model* m);
class Surface* bbFindSurface(class MeshModel* m, Brush* b);
void bbPaintSurface(class Surface* s, Brush* b);
int bbAddVertex(class Surface* s, float x, float y, float z, float tu, float tv, float tw=1.f);
int bbAddTriangle(class Surface* s, int v0, int v1, int v2);
void bbVertexCoords(class Surface* s, int n, float x, float y, float z);
void bbVertexNormal(class Surface* s, int n, float x, float y, float z);
void bbVertexColor(class Surface* s, int n, float r, float g, float b, float a=1.f);
int bbCountVertices(class Surface* s);
int bbCountTriangles(class Surface* s);
float bbVertexX(class Surface* s, int n);
float bbVertexY(class Surface* s, int n);
float bbVertexZ(class Surface* s, int n);
float bbVertexNX(class Surface* s, int n);
float bbVertexNY(class Surface* s, int n);
float bbVertexNZ(class Surface* s, int n);
float bbVertexRed(class Surface* s, int n);
float bbVertexGreen(class Surface* s, int n);
float bbVertexBlue(class Surface* s, int n);
float bbVertexAlpha(class Surface* s, int n);
int bbTriangleVertex(class Surface* s, int n, int v);
class Camera* bbCreateCamera(class Object* p = nullptr);
void bbCameraZoom(class Camera* c, float zoom);
void bbCameraRange(class Camera* c, float nr, float fr);
void bbCameraClsColor(class Camera* c, float r, float g, float b);
void bbCameraProjMode(class Camera* c, int mode);
void bbCameraViewport(class Camera* c, int x, int y, int w, int h);
void bbCameraFogColor(class Camera* c, float r, float g, float b);
void bbCameraFogRange(class Camera* c, float nr, float fr);
void bbCameraFogMode(class Camera* c, int mode);
int bbCameraProject(class Camera* c, float x, float y, float z);
float bbProjectedX();
float bbProjectedY();
float bbProjectedZ();
int bbEntityInView(class Object* e, Camera* c);
class Object* bbEntityPick(class Object* src, float range);
void bbEntityType(Object *o, int type, int recurs=0);
void bbEntityPickMode(class Object* o, int mode, int obs);
class Object* bbLinePick(float x, float y, float z, float dx, float dy, float dz, float radius);
float bbPickedX();
float bbPickedY();
float bbPickedZ();
float bbPickedNX();
float bbPickedNY();
float bbPickedNZ();
float bbPickedTime();
class Object* bbPickedEntity();
void* bbPickedSurface();
int bbPickedTriangle();
class Light* bbCreateLight(int type, class Object* p);
void bbLightColor(class Light* light, float r, float g, float b);
void bbLightRange(class Light* light, float range);
class Object* bbCreatePivot(class Object* p=nullptr);
class Object* bbCreateSprite(class Object* p);
void bbRotateSprite(class Sprite* s, float angle);
class Object* bbLoadMD2(String file, class Object* p);
float bbMD2AnimTime(class MD2Model* m);
int bbMD2AnimLength(class MD2Model* m);
int bbMD2Animating(class MD2Model* m);
void bbBSPAmbientLight(class Q3BSPModel* t, float r, float g, float b);
void bbScaleSprite(class Sprite *s, float x, float y);
class Object* bbCreateMirror(class Object* p);
class Object* bbCreatePlane(int segs, class Object* p);
void bbTerrainShading(class Terrain* t, int enable);
int bbTerrainSize(class Terrain* t);
class gxChannel* bbEmitSound(class gxSound* sound, class Object* o);
class Model* bbCopyModelEntity(class Model* e, class Object* p = nullptr);
class MeshModel* bbCopyMeshModelEntity(class MeshModel* e, class Object* p = nullptr);
class Pivot* bbCopyPivot(class Pivot* e, class Object* p = nullptr);
float bbEntityX(class Object* e, int global=1);
float bbEntityY(class Object* e, int global=1);
float bbEntityZ(class Object* e, int global=1);
float bbEntityPitch(class Object* e, int global=1);
float bbEntityYaw(class Object* e, int global=1);
float bbEntityRoll(class Object* e, int global=1);
float bbGetMatElement(class Object* e, int row, int col);
float bbTFormedX();
float bbTFormedY();
float bbTFormedZ();
float bbVectorYaw(float x, float y, float z);
float bbVectorPitch(float x, float y, float z);
void bbResetEntity(class Object* o);
class Object* bbGetParent(class Object* e);
int bbGetEntityType(class Object* o);
void bbEntityBox(class Object* o, float x, float y, float z, float w, float h, float d);
class Object* bbEntityCollided(class Object* o, int type);
int bbCountCollisions(class Object* o);
void bbMoveEntity(class Object* e, float x, float y, float z);
void bbTurnEntity(class Object* e, float p, float y, float r, int global=0);
void bbTranslateEntity(class Object* e, float x, float y, float z, int global=0);
void bbPositionEntity(class Object* e, float x, float y, float z, int global=0);
void bbRotateEntity(class Object* e, float p, float y, float r, int global=0);
void bbPointEntity(class Object* e, class Object* t, float roll=0.f);
void bbAnimateMD2(class MD2Model* m, int mode, float speed, int first, int last, float trans);
void bbAnimate(class Object* o, int mode, float speed, int seq, float trans);
int bbAddAnimSeq(class Object* o, int length);
int bbAnimSeq(class Object* o);
float bbAnimTime(class Object* o);
int bbAnimLength(class Object* o);
int bbAnimating(class Object* o);
void bbEntityParent(class Object* e, class Object* p, int global=1);
int bbCountChildren(class Object* e);
class Object* bbGetChild(class Object* e, int index);
class Object* bbFindChild(class Object* e, String t);
void bbPaintEntity(class Model* m, Brush* b);
void bbEntityColor(class Model* m, float r, float g, float b);
void bbEntityAlpha(class Model* m, float alpha);
void bbEntityShininess(class Model* m, float shininess);
void bbEntityTexture(class Model* m, Texture* t, int frame, int index);
void bbEntityBlend(class Model* m, int blend);
void bbEntityFX(class Model* m, int fx);
void bbEntityAutoFade(class Model* m, float nr, float fr);
void bbEntityOrder(class Object* o, int n);
void bbHideEntity(class Object* e);
void bbShowEntity(class Object* e);
void bbFreeEntity(class Object* e);
void bbNameEntity(class Object* e, String t);
String bbEntityName(class Object* e);
String bbEntityClass(class Object* e);

#endif
