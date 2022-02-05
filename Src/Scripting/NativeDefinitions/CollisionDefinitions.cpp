#include "../NativeDefinitionRegistrar.h"

#include "../RefCounter.h"

#include "../ScriptManager.h"

#include "../../Collision/CollisionMesh.h"
#include "../../Collision/CollisionMeshCollection.h"
#include <scriptarray/scriptarray.h>

static std::unordered_map<CollisionMesh*, int> meshRefCount;
static std::unordered_map<CollisionMeshCollection*, int> collectionRefCount;
static class : public RefCounter {
    public:
        using RefCounter::refCounterManager;

        void addRef(void* ptr) {
            if (meshRefCount.find((CollisionMesh*)ptr) != meshRefCount.end()) {
                meshRefCount[(CollisionMesh*)ptr]++;
            }
            if (collectionRefCount.find((CollisionMeshCollection*)ptr) != collectionRefCount.end()) {
                collectionRefCount[(CollisionMeshCollection*)ptr]++;
            }
        }

        void release(void* ptr) {
            if (meshRefCount.find((CollisionMesh*)ptr) != meshRefCount.end()) {
                CollisionMesh* castPtr = (CollisionMesh*)ptr;
                meshRefCount[castPtr]--;

                if (meshRefCount[castPtr] <= 0) {
                    meshRefCount.erase(castPtr);
                    refCounterManager->unlinkPtr(castPtr);
                    delete castPtr;
                }
            }
            if (collectionRefCount.find((CollisionMeshCollection*)ptr) != collectionRefCount.end()) {
                CollisionMeshCollection* castPtr = (CollisionMeshCollection*)ptr;
                collectionRefCount[castPtr]--;

                if (collectionRefCount[castPtr] <= 0) {
                    collectionRefCount.erase(castPtr);
                    refCounterManager->unlinkPtr(castPtr);
                    delete castPtr;
                }
            }
        }
} counter;

static CollisionMesh* meshFactory(CScriptArray* verts, CScriptArray* inds) {
    std::vector<PGE::Vector3f> vecVerts;
    std::vector<int> vecInds;
    for (unsigned i=0; i < verts->GetSize(); i++) {
        vecVerts.push_back(*((PGE::Vector3f*)verts->At(i)));
    }
    for (unsigned i=0; i < inds->GetSize(); i++) {
        vecInds.push_back(*((int*)inds->At(i)));
    }
    CollisionMesh* newMesh = new CollisionMesh(vecVerts, vecInds);
    meshRefCount.emplace(newMesh, 1);
    counter.refCounterManager->linkPtrToCounter(newMesh, &counter);
    return newMesh;
}

static CollisionMeshCollection* collectionFactory() {
    CollisionMeshCollection* newMeshCollection = new CollisionMeshCollection();
    collectionRefCount.emplace(newMeshCollection, 1);
    counter.refCounterManager->linkPtrToCounter(newMeshCollection, &counter);
    return newMeshCollection;
}

static void registerCollisionDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager& rcMgr, const NativeDefinitionsHelpers&) {
    counter.refCounterManager = &rcMgr;

    engine.SetDefaultNamespace("Collision");

    engine.RegisterObjectType("Mesh", sizeof(CollisionMesh), asOBJ_REF);
    engine.RegisterObjectBehaviour("Mesh", asBEHAVE_FACTORY, "Mesh@ f(const array<Vector3f>&in verts, const array<int>&in inds)",
        asFUNCTION(meshFactory), asCALL_CDECL);
    engine.RegisterObjectBehaviour("Mesh", asBEHAVE_ADDREF, "void f()", asMETHOD(decltype(counter), addRef), asCALL_THISCALL_OBJLAST, &counter);
    engine.RegisterObjectBehaviour("Mesh", asBEHAVE_RELEASE, "void f()", asMETHOD(decltype(counter), release), asCALL_THISCALL_OBJLAST, &counter);

    engine.RegisterEnum("Instance");

    engine.RegisterObjectType("Collection", sizeof(CollisionMeshCollection), asOBJ_REF);
    engine.RegisterObjectBehaviour("Collection", asBEHAVE_FACTORY, "Collection@ f()", asFUNCTION(collectionFactory), asCALL_CDECL);
    engine.RegisterObjectBehaviour("Collection", asBEHAVE_ADDREF, "void f()", asMETHOD(decltype(counter), addRef), asCALL_THISCALL_OBJLAST, &counter);
    engine.RegisterObjectBehaviour("Collection", asBEHAVE_RELEASE, "void f()", asMETHOD(decltype(counter), release), asCALL_THISCALL_OBJLAST, &counter);
    engine.RegisterObjectMethod("Collection", "Instance addInstance(Mesh@ mesh, const Matrix4x4f&in matrix)", asMETHOD(CollisionMeshCollection, addInstance), asCALL_THISCALL);
    engine.RegisterObjectMethod("Collection", "void updateInstance(Instance instance, const Matrix4x4f&in matrix)", asMETHOD(CollisionMeshCollection, updateInstance), asCALL_THISCALL);
    engine.RegisterObjectMethod("Collection", "void removeInstance(Instance instance)", asMETHOD(CollisionMeshCollection, removeInstance), asCALL_THISCALL);
}

static NativeDefinitionRegistrar _ {
    &registerCollisionDefinitions,
    NativeDefinitionDependencyFlagBits::MATH,
    NativeDefinitionDependencyFlagBits::COLLISION,
};
