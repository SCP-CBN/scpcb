#ifndef SOUND_H_INCLUDED
#define SOUND_H_INCLUDED

#include <String/String.h>
#include "PGESound.h"
#include "SoundStream.h"


class SoundResources;

class Sound {
    private:
        SoundResources* sndRes;

        
    public:
        Sound(SoundResources* sr);
        ~Sound();
};

class SoundInstance {
    private:
        Sound* Sound;

    public:
        SoundInstance();

        void render();
};

#endif // SoundMANAGER_H_INCLUDED
