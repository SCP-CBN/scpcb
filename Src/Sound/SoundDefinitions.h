#ifndef SOUNDDEFINITIONS_H_INCLUDED
#define SOUNDDEFINITIONS_H_INCLUDED
#include "Sound.h"
#include "SoundResources.h"

#include "PGESound.h"
#include "SoundStream.h"

#include "../Scripting/NativeDefinition.h"

class ScriptManager;
class SoundResources;


class SoundDefinitions : public NativeDefinition {
    private:
        PGE::Sound* createSound(PGE::String snd);
        void destroySound(PGE::Sound* snd);
        SoundResources* sndRes;


    public:
        SoundDefinitions(ScriptManager* mgr, SoundResources* sndr);
};



#endif // SOUNDDEFINITIONS_H_INCLUDED
