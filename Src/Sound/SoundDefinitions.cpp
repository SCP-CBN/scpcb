#include "SoundDefinitions.h"

#include "../Scripting/ScriptManager.h"

//#include "../../Sound/SoundResources.h"
#include "SoundResources.h"
#include "SoundLayer.h"

#include "PGESound.h"
#include "SoundStream.h"

#include <String/String.h>


SoundDefinitions::SoundDefinitions(ScriptManager* mgr, SoundResources* sndr) {
    engine = mgr->getAngelScriptEngine();
    sndRes = sndr;
    printf("HELLO FROM SOUND DEFINITIONS");
}
/*
    engine->RegisterObjectType("CSound", sizeof(PGE::Sound), asOBJ_REF | asOBJ_NOCOUNT);
    engine->RegisterObjectType("CSoundLayer", sizeof(SoundLayer), asOBJ_REF | asOBJ_NOCOUNT);
    engine->RegisterObjectType("CSoundStream", sizeof(SoundStream), asOBJ_REF | asOBJ_NOCOUNT);
    engine->SetDefaultNamespace("CSound");

    // CSound@ object
    engine->RegisterGlobalFunction("CSound@ create(string&in filename)", asMETHOD(SoundDefinitions, createSound), asCALL_THISCALL_ASGLOBAL, this);
    engine->RegisterGlobalFunction("void destroy(CSound@ m)", asMETHOD(SoundDefinitions, destroySound), asCALL_THISCALL_ASGLOBAL, this);

    // CSoundLayer@ object
    //engine->RegisterGlobalFunction("CSoundLayer@ createLayer(string&in layerName)", asMETHOD(SoundDefinitions, createSoundLayer), asCALL_THISCALL_ASGLOBAL, this);
    //engine->RegisterGlobalFunction("void destroyLayer(CSoundLayer@ m)", asMETHOD(SoundDefinitions, destroySoundLayer), asCALL_THISCALL_ASGLOBAL, this);

    // CSoundStream@ object
    engine->RegisterGlobalFunction("CSoundStream@ createStream(string&in layerName)", asMETHOD(SoundDefinitions, createSoundStream), asCALL_THISCALL_ASGLOBAL, this);
    //engine->RegisterGlobalFunction("void destroyStream(CSoundStream@ m)", asMETHOD(SoundDefinitions, destroySoundStream), asCALL_THISCALL_ASGLOBAL, this);
    //engine->RegisterObjectMethod("CSoundStream", "float pushAudio() const", asMETHOD(SoundStream, pushAudio), asCALL_THISCALL);
    //engine->RegisterObjectMethod("CSoundStream", "float distanceSquared(const Vector2f&in other) const", asMETHOD(PGE::Vector2f, distanceSquared), asCALL_THISCALL);
    //engine->RegisterObjectMethod("CSoundStream", "float distance(const Vector2f&in other) const", asMETHOD(PGE::Vector2f, distance), asCALL_THISCALL);

}

PGE::Sound* SoundDefinitions::createSound(PGE::String filename) {
    PGE::Sound* newSnd = new PGE::Sound();
    return newSnd;
}
void SoundDefinitions::destroySound(PGE::Sound* snd) {
}

SoundStream* SoundDefinitions::createSoundStream() {
    return nullptr;
}
void SoundDefinitions::destroySoundStream(SoundStream* stream) {
}
*/

/*
Sound* SoundDefinitions::createSoundLayer(PGE::Sound* filename) {
    Sound* newSnd = new Sound(filename);
    return newSnd;
}
void SoundDefinitions::destroySound(PGE::Sound* snd) {
}

PGE::Sound* SoundDefinitions::createSoundStream(PGE::Sound* filename) {
    PGE::Sound* newSnd = new PGE::Sound(filename);
    return newSnd;
}
void SoundDefinitions::destroySound(PGE::Sound* snd) {
}*/