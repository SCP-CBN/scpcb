#ifndef SOUNDSTREAM_H_INCLUDED
#define SOUNDSTREAM_H_INCLUDED

#include <String/String.h>

#include "PGESound.h"

#include <al.h>
#include <alc.h>

namespace PGE {
class SoundStream {
private:

public:
    SoundStream();
    ~SoundStream();

    void playTestTone();
    void playFile(PGE::String filename);

};
}

#endif // SOUNDSTREAM_H_INCLUDED
