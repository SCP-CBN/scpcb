#ifndef SOUNDRESOURCES_H_INCLUDED
#define SOUNDRESOURCES_H_INCLUDED

#include <unordered_map>
#include "../Utils/ResourcePackManager.h"

#include <String/String.h>
#include <String/Key.h>

#include "SoundLayer.h"
#include "Sound.h"

#include "PGESound.h"
#include "SoundStream.h"

class ResourcePackManager;
class Config;

class DebugSound {

public:
    DebugSound();
    ~DebugSound();
};


class SoundResources {
private:
    DebugSound* debugSound;

public:
    SoundResources(Config* con);
    ~SoundResources();

    ResourcePackManager* rpm;
    DebugSound* getDebugSound() const;
};



/*

class SoundInstance;
class Sound;

class SoundStream;



class SoundResources {
    private:
        enum AudioFormats {
        };
        DebugSound* debugSound;
        SDL_AudioSpec baseChannel;


    public:



        void audioCallback(void* userdata, Uint8* stream, int len);


        SoundInstance* getSoundInstance(const PGE::String& filename);
        void dropSoundInstance(SoundInstance* mi);
        PGE::Sound* getSound() const;
        SoundStream* createStream();

};
*/


#endif // SOUNDRESOURCES_H_INCLUDED
