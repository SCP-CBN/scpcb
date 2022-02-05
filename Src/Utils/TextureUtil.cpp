#include "TextureUtil.h"

#include <stb_image.h>

ImageData::ImageData(const PGE::FilePath& file, int& width, int& height) {
	resource = (PGE::byte*)stbi_load(file.str().cstr(), &width, &height, nullptr, 4);
	PGE::String failureReason = resource == nullptr ? stbi_failure_reason() : "";
	PGE_ASSERT(resource != nullptr, PGE::String("Texture loading failed (img: ") + file.str() + "; reason: " + failureReason + ")");
}

ImageData::ImageData(const std::vector<PGE::byte>& fileData, int& width, int& height) {
	resource = (PGE::byte*)stbi_load_from_memory(fileData.data(), fileData.size(), &width, &height, nullptr, 4);
	PGE::String failureReason = resource == nullptr ? stbi_failure_reason() : "";
	PGE_ASSERT(resource != nullptr, PGE::String("Texture loading failed from memory (reason: ") + failureReason + ")");
}

ImageData::~ImageData() {
	stbi_image_free(resource);
}

PGE::Texture* TextureHelper::load(PGE::Graphics* gfx, const PGE::FilePath& file) {
	int width; int height;
	ImageData data = ImageData(file, width, height);
	return PGE::Texture::load(*gfx, width, height, data, PGE::Texture::Format::RGBA32);
}

PGE::Texture* TextureHelper::load(PGE::Graphics* gfx, const std::vector<PGE::byte>& fileData) {
	int width; int height;
	ImageData data = ImageData(fileData, width, height);
	return PGE::Texture::load(*gfx, width, height, data, PGE::Texture::Format::RGBA32);
}
