// the Sound Resources object is similar to GraphicsResources and handles sound layers.

#include "SoundResources.h"
#include "SoundLayer.h"
#include "Sound.h"


#include "../Utils/ResourcePackManager.h"
#include "../Save/Config.h"

#include <String/String.h>
#include <String/Key.h>


#include "PGESound.h"
#include "SoundStream.h"


SoundResources::SoundResources(Config* con) {
    printf("HELLO FROM SOUNDRESOURCES CONSTRUCTOR\n");
    PGE::SoundStream* x = new PGE::SoundStream();
    x->playTestTone();

}
SoundResources::~SoundResources() {
    printf("HELLO FROM SOUNDRESOURCES DECONSTRUCTOR");
}
DebugSound::DebugSound() {
}
DebugSound::~DebugSound() {}
DebugSound* SoundResources::getDebugSound() const { return debugSound; }

/*

void SoundResources::audioCallback(void* userdata, Uint8* stream, int len) {
}

/*
    int numAudioDevices = SDL_GetNumAudioDevices(0);
    for (int i = 0; i < numAudioDevices; i++) {
        auto audioDevice = SDL_GetAudioDeviceName(i, 0);
        printf("Found audio device: %s\n", audioDevice);
    }*/
/*

SoundResources::SoundResources(Config* con) {
    //con->setSoundResources(this);
    //rpm = new ResourcePackManager(con->resourcePackLocations, con->enabledResourcePacks);
    //debugSound = new DebugSound(sfx);
    SDL_Init(SDL_INIT_AUDIO);
    Mix_Init(MIX_INIT_OGG);
    SDL_memset(&baseChannel, 0, sizeof(baseChannel));
    baseChannel.freq = 44100;
    baseChannel.format = AUDIO_S16SYS;
    baseChannel.samples = 1024;
    baseChannel.callback = NULL;

    SoundStream* test = this->createStream();
    test->playTestTone();
    test->playFile(PGE::String("Content/SCPCB/SFX/SCP/914/Refining.ogg"));
    printf("Hello from SoundResources ----\n");

}
SoundResources::~SoundResources() {
    delete debugSound;
}

SoundStream* SoundResources::createStream() {
    SDL_AudioSpec want;
    SDL_memcpy(&want, &baseChannel, sizeof(want));
    SoundStream* stream = new SoundStream(this,want);
    return stream;
}
*/

/*

SoundInstance* SoundResources::getSoundInstance(const PGE::String& filename) {
    auto find = pathToModels.find(filename);
    if (find != pathToModels.end()) {
        find->second->refCount++;
        return new SoundInstance(find->second->model);
    }
    return new SoundInstance(filename);
}
*/

/*
void SoundResources::dropSoundInstance(SoundInstance* mi) {
    auto find = modelToModels.find(mi->getModel());
    if (find != modelToModels.end()) {
        ModelEntry* model = find->second;
        model->refCount--;
        if (model->refCount <= 0) {
            delete model->model;
            pathToModels.erase(model->filename);
            modelToModels.erase(find);
            delete model;
        }
    }
}



*/
