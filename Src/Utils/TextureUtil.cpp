#include "TextureUtil.h"

#include <stb_image.h>

ImageData::ImageData(const PGE::FilePath& file, int& width, int& height) {
	resource = (PGE::byte*)stbi_load(file.cstr(), &width, &height, nullptr, 4);
	PGE_ASSERT(resource != nullptr, PGE::String("Texture loading failed (img: ") + file.str() + "; reason: " + stbi_failure_reason() + ")");
}

ImageData::ImageData(PGE::byte* fileData, int size, int& width, int& height) {
	resource = (PGE::byte*)stbi_load_from_memory(fileData, size, &width, &height, nullptr, 4);
	PGE_ASSERT(resource != nullptr, PGE::String("Texture loading failed from memory (reason: ") + stbi_failure_reason() + ")");
}

ImageData::~ImageData() {
	stbi_image_free(resource);
}

PGE::Texture* TextureHelper::load(PGE::Graphics* gfx, const PGE::FilePath& file) {
	int width; int height;
	ImageData data = ImageData(file, width, height);
	return PGE::Texture::load(gfx, width, height, data, PGE::Texture::Format::RGBA32);
}

PGE::Texture* TextureHelper::load(PGE::Graphics* gfx, PGE::byte* fileData, int size) {
	int width; int height;
	ImageData data = ImageData(fileData, size, width, height);
	return PGE::Texture::load(gfx, width, height, data, PGE::Texture::Format::RGBA32);
}
