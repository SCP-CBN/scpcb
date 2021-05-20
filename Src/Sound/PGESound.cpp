// I couldn't get OpenAL to link to both the engine and SCPCB at the same time.
// You're welcome to try and fix that.

// The PGE objects are simple data containers for their referenced material
#include "PGESound.h"

#include <String/String.h>
#include <Misc/FilePath.h>

#include "Sound.h"
#include "SoundStream.h"



namespace PGE {
//class SoundStream;

//const Vector2f Vector2f::ZERO = Vector2f(0.f,0.f);
//const Vector2f Vector2f::ONE = Vector2f(1.f,1.f);


Sound::Sound() {


}

Sound::~Sound() {

}

}