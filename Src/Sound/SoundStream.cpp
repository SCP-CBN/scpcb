// A Sound Stream is the thing that actually plays audio data like PGE::Sound through the speakers.
#include "SoundStream.h"

#include <Math/Math.h>
#include <String/String.h>
#include <Misc/FilePath.h>

#include "PGESound.h"

#include <../../Engine/Libraries/SDL2/include/SDL_audio.h>
#include <../../Engine/Libraries/SDL2/include/SDL.h>

#include <fstream>
#include <map>
#include <ogg/ogg.h>
#include <vorbis/codec.h>
//#include <vorbis/vorbisenc.h>
#include <vorbis/vorbisfile.h>

class OggStream
{
    int mSerial;
    ogg_stream_state mState;
    int mPacketCount;
};
typedef std::vector<int, OggStream*> StreamMap;

SoundStream::SoundStream() {
    printf("HELLO FROM NEW SOUND STREAM\n");
}

SDL_AudioDeviceID dev;
SDL_AudioSpec baseChannel;


ogg_int16_t convbuffer[4096]; /* take 8k out of the data segment, not the stack */
int convsize = 4096;
void SoundStream::playTestTone() {
    printf("HELLO FROM TEST TONE\n");
    PGE::String filename = "C:/Users/Pyro/source/repos/scpcb/Content/SCPCB/SFX/SCP/914/Refining.ogg";
    PGE::FilePath fpath = PGE::FilePath::fromStr(filename);
    printf("Sound Path: %s\n", filename.cstr());

    SDL_Init(SDL_INIT_AUDIO);
    SDL_memset(&baseChannel, 0, sizeof(baseChannel));
    baseChannel.freq = 44100;
    baseChannel.format = AUDIO_S16SYS;
    baseChannel.samples = 1024;
    baseChannel.callback = NULL;


    printf("Loading file : %s\n", filename.cstr());
    OggVorbis_File vorbf;
    ov_fopen(filename.cstr(), &vorbf);
    int numSamples = ov_pcm_total(&vorbf, -1);
    int numStreams = ov_streams(&vorbf);
    int runtime = ov_time_total(&vorbf, -1);
    int bitRate = ov_info(&vorbf, 0)->rate;

    SDL_AudioSpec channel;
    channel.freq = 44100;
    channel.size = 1024;
    channel.format = AUDIO_S16SYS;
    channel.channels = 1;
    channel.samples = 1024;
    channel.callback = NULL;

    dev = SDL_OpenAudioDevice(NULL, 0, &channel, NULL, 0);

    int strm = 0; // new int(numStreams);
    ogg_int64_t pcmlength = ov_pcm_total(&vorbf, -1);
    char* buf;
    buf = new char[4096]; // malloc(pcmlength * 2);

    int iter = 0;
    while (1) {
        iter++; if (iter >= 1000000) { break; }
        int bytes_read = ov_read(&vorbf,buf, 4096, 0, 2, 1, &strm);
        if (bytes_read <= 0) { break; }
        for (int w = 0; w < bytes_read; w++) {
            SDL_QueueAudio(dev, &buf[w], 1);
        }
        buf = new char[4096];
    }


    SDL_PauseAudioDevice(dev, 0);
    ov_clear(&vorbf);

    /*
    * 
    *     for (int i = 0; i < channel.size; i++) {
        int16_t sample = 16; // data.at(i);
        const int sample_size = sizeof(sample);
        SDL_QueueAudio(dev, &sample, sample_size);
    }
    const char* defname = alcGetString(NULL, ALC_DEFAULT_DEVICE_SPECIFIER);
    printf("DEFAULT DEVICE: %s\n", defname);

    ALCdevice* device = alcOpenDevice(defname);
    ALCcontext* context = alcCreateContext(device, NULL);
    alcMakeContextCurrent(context);

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
        */
}

SoundStream::~SoundStream() {
   //alcCloseDevice(device);
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