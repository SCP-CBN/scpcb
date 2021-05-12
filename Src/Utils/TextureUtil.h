#ifndef TEXTURE_UTIL_H_DEFINED
#define TEXTURE_UTIL_H_DEFINED

#include <ResourceManagement/Resource.h>
#include <Misc/FilePath.h>
#include <Texture/Texture.h>

class ImageData : public PGE::Resource<PGE::byte*> {
	public:
		ImageData(const PGE::FilePath& file, int& width, int& height);
		ImageData(PGE::byte* fileData, int size, int& width, int& height);
		~ImageData();
};

namespace TextureHelper {
	PGE::Texture* load(PGE::Graphics* gfx, const PGE::FilePath& file);
	PGE::Texture* load(PGE::Graphics* gfx, PGE::byte* fileData, int size);
};

#endif // TEXTURE_UTIL_H_DEFINED
