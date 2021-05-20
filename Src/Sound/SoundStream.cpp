// A Sound Stream is the thing that actually plays audio data like PGE::Sound through the speakers.
#include "SoundStream.h"

#include <Math/Math.h>
#include <String/String.h>
#include <Misc/FilePath.h>

#include "PGESound.h"

#include <al.h>
#include <alc.h>


using namespace PGE;

ALCdevice* device;

SoundStream::SoundStream() {
    printf("HELLO FROM NEW SOUND STREAM\n");
}

void loadWAVfile(PGE::String fpath, ALenum &format, ALvoid* &data, ALsizei &size, ALsizei &freq, ALboolean &loop) {

}

ALuint* sound_load_ogg(const char* path) {
    ALuint* sound;
    Ogg
}

void SoundStream::playTestTone() {
    printf("HELLO FROM TEST TONE\n");
    PGE::String filename = "SCBCP/Content/SFX/SCPs/914/Refining.ogg";
    PGE::FilePath fpath = PGE::FilePath::fromStr(filename);
    printf("Sound Path: %s\n", fpath.cstr());

    const char* defname = alcGetString(NULL, ALC_DEFAULT_DEVICE_SPECIFIER);
    printf("DEFAULT DEVICE: %s\n", defname);

    ALCdevice* device = alcOpenDevice(defname);
    ALCcontext* context = alcCreateContext(device, NULL);
    alcMakeContextCurrent(context);

    /*
    struct stat statbuf;

    //PGE_ASSERT(openALDevice != nullptr, "Failed to start device");
    ALfloat listenerOri[] = { 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f };
    alListener3f(AL_POSITION, 0, 0, 1.0f);
    alListener3f(AL_VELOCITY, 0, 0, 0);
    alListenerfv(AL_ORIENTATION, listenerOri);


    alSourcef(source, AL_PITCH, 1);
    alSourcef(source, AL_GAIN, 1);
    alSource3f(source, AL_POSITION, 0, 0, 0);
    alSource3f(source, AL_VELOCITY, 0, 0, 0);
    alSourcei(source, AL_LOOPING, AL_FALSE);

    ALvoid* data;
    */


    ALuint source;
    alGenSources((ALuint)1, &source);

    int seconds = 5;
    ALsizei freq = 440.f;
    unsigned sample_rate = 22050;
    ALsizei size = sample_rate * seconds;

    ALuint buffer;
    alGenBuffers((ALuint)1, &buffer);

    short* samples = new short[size];
    for (int i = 0; i < size; i++) {
        samples[i] = 32760 * sin((2.f * float(Math::PI) * freq) / sample_rate * i);
    }

    alBufferData(buffer, AL_FORMAT_MONO16, samples,size,sample_rate);

    alSourcei(source, AL_BUFFER, buffer);

    alSourcePlay(source);
    printf("PLAYED SOUND\n");

}

SoundStream::~SoundStream() {
    alcCloseDevice(device);
}

/*
SoundStream::SoundStream(SoundResources* sndr, SDL_AudioSpec chan) {
    sndRes = sndr;
    channel = chan;
    dev = SDL_OpenAudioDevice(NULL, 0, &chan, NULL, 0);
}


//SDL_LoadFile("Content/SCPCB/SFX/Radio/Chatter1.ogg");
void SoundStream::playTestTone() {
    float x = 0;
    for (int i = 0; i < channel.freq * 3; i++) {
        x += .010f;
        // SDL_QueueAudio expects a signed 16-bit value
        // note: "5000" here is just gain so that we will hear something
        int16_t sample = sin(x * 4) * 5000;
        const int sample_size = sizeof(int16_t) * 1;
        SDL_QueueAudio(dev, &sample, sample_size);
    }
    SDL_PauseAudioDevice(dev, 0);
}

void SoundStream::playFile(PGE::String filename) {
    PGE::FilePath f = PGE::FilePath::fromStr(filename);

    Uint32 wav_length;
    Uint8* wav_buffer;
    Mix_Music* v = Mix_LoadMUS(f.cstr());
    printf("Loading file : %s\n", f.cstr());
    if (v == NULL) {
        printf("WAV error");
    }
    else {
        //Uint8* mixData = new Uint8[wav_length];
        //SDL_MixAudio(mixData, wav_buffer, wav_length, 1);
        Mix_PlayMusic(v, 0);
        //SDL_QueueAudio(dev, &v, wav_length);
        //SDL_FreeWAV(wav_buffer);
    }


    float x = 0;
    for (int i = 0; i < channel.freq * 3; i++) {
        x += 0.010f;
        // SDL_QueueAudio expects a signed 16-bit value
        // note: "5000" here is just gain so that we will hear something
        int16_t sample = sin(x * 4) * 5000;
        const int sample_size = sizeof(int16_t) * 1;
        SDL_QueueAudio(dev, &sample, sample_size);
    }
    SDL_PauseAudioDevice(dev, 0);
}
*/