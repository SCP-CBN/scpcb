#include "SoundUtil.h"


#include <al.h>
#include <alc.h>

SoundData::SoundData(const PGE::FilePath& file, ALuint* data) {

}

SoundData::~SoundData() {
	
}

PGE::Sound* SoundHelper::load(const PGE::FilePath& file) {
	std::ifstream stream(file.cstr(), std::ifstream::binary | std::ifstream::in);
	int startPos = stream.tellg();
	ALuint* data;
	char c;
	while (stream.get(c)) {
		data[(int)stream.tellg() - 1] = c;
	}

	SoundData data = SoundData(file, data);
	return PGE::Sound::load(file, data);
}