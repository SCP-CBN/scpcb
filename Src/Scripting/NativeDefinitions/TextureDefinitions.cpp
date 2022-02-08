#include "../NativeDefinitionRegistrar.h"
#include "../NativeDefinitionHelpers.h"

#include "../../Utils/TextureUtil.h"

#include "../NativeUtils.h"

#include "../../Graphics/GraphicsResources.h"

using namespace PGE;

static void registerTextureDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager& refCtr, const NativeDefinitionsHelpers& helpers) {
    static class _ : public RefCounter {
		private:
			RefCounterManager& refCounterManager;
			GraphicsResources& gfxRes;

        public:
			_(RefCounterManager& mgr, GraphicsResources& gr) : refCounterManager(mgr), gfxRes(gr) { }

			Texture* loadTexture(const String& file) {
				bool isNew;
				Texture* tex = gfxRes.getTexture(file, isNew);
				if (isNew) {
					refCounterManager.linkPtrToCounter(tex, this);
				}
				return tex;
			}

			void addRef(void* ptr) override {
				gfxRes.addTextureRef((Texture*)ptr);
			}

			void release(void* ptr) override {
				if (gfxRes.dropTexture((Texture*)ptr)) {
					refCounterManager.unlinkPtr(ptr);
				}
			}
    } factory(refCtr, *helpers.gfxRes);

    PGE_REGISTER_REF_TYPE_CUSTOM(Texture, engine, factory);
	engine.PGE_REGISTER_REF_CONSTRUCTOR_CUSTOM(Texture, loadTexture, factory);
}

static NativeDefinitionRegistrar _ {
    &registerTextureDefinitions,
    NativeDefinitionDependencyFlags::NONE,
    NativeDefinitionDependencyFlags::TEXTURE
};
