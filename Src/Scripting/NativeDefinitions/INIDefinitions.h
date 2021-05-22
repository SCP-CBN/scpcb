#ifndef INIDEFINITIONS_H_INCLUDED
#define INIDEFINITIONS_H_INCLUDED

#include <vector>
#include <map>
#include <Misc/FilePath.h>
#include "../../Utils/INI.h"
#include "../NativeDefinition.h"


class ScriptManager;

class INIDefinitions : public NativeDefinition {
public:
    INIDefinitions(ScriptManager* mgr, INIFile* ini);
};

#endif // INIDEFINITIONS_H_INCLUDED