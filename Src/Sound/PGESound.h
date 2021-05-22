#ifndef PGE_SOUND_H_INCLUDED
#define PGE_SOUND_H_INCLUDED

#include <String/String.h>
#include <Misc/Filepath.h>

#include "Sound.h"
#include "SoundStream.h"


namespace PGE {

class Sound {
    private:
        PGE::String soundname;
        PGE::FilePath filename;

    public:
        Sound();
        ~Sound();

};

}


#endif // PGE_SOUND_H_INCLUDED
