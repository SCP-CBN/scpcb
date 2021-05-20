#ifndef SOUNDRESOURCES_H_INCLUDED
#define SOUNDRESOURCES_H_INCLUDED

#include <unordered_map>
#include <assimp/Importer.hpp>
#include "../Utils/ResourcePackManager.h"
#include <String/Key.h>

#include <String/String.h>

#include "SoundLayer.h"
#include "Sound.h"
#include "PGESound.h"
#include "SoundStream.h"
#include "SoundHelper.h"


class ResourcePackManager;
class Config;

class DebugSound {

public:
    DebugSound();
    ~DebugSound();
};


class SoundResources {
private:
    struct SoundEntry {
        // This needs to stay a string for the Resource Packs to work.
        PGE::String name;
        PGE::Sound* sound;
        int refCount;
    };
    std::unordered_map<PGE::Texture*, TextureEntry*> soundToSounds;
    std::unordered_map<PGE::String::Key, TextureEntry*> pathToSounds;

    Assimp::Importer* soundImporter;

    DebugSound* debugSound;

public:
    SoundResources(Config* con);
    ~SoundResources();

    ResourcePackManager* rpm;
    DebugSound* getDebugSound() const;

    PGE::Sound* getSound(const PGE::String& filename);
    void dropSound(PGE::Sound* sound);
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
