#ifndef SOUND_UTIL_H_DEFINED
#define SOUND_UTIL_H_DEFINED

#include <ResourceManagement/Resource.h>
#include <Misc/FilePath.h>
#include "PGESound.h"

#include <fstream>


class SoundData : public PGE::Resource<PGE::byte*> {
	public:
		SoundData(const PGE::FilePath& file);
		~SoundData();
};

namespace SoundHelper {
	//PGE::Sound* load(const PGE::FilePath& file);
}

#endif // SOUND_UTIL_H_DEFINED
