#include "Script.h"

#include <Exception/Exception.h>

#include "ScriptManager.h"
#include "ScriptClass.h"
#include "ScriptFunction.h"
#include "ScriptModule.h"

#include <fstream>

Script::Script(const PGE::FilePath& fn) {
    fileName = fn;

    scriptContents = "";

    char* readBuf = new char[1024];

    std::ifstream inFile;
    inFile.open(fileName.cstr());

    PGE_ASSERT(inFile.is_open(), "Could not find script: \"" + fileName.str() + "\"");

    bool reachedEndOfFile = inFile.eof();
    while (!reachedEndOfFile) {
        inFile.read(readBuf,1023);
        readBuf[inFile.gcount()]='\0';
        scriptContents += readBuf;

        reachedEndOfFile = inFile.eof();
    }

    inFile.close();

    delete[] readBuf;
}

PGE::FilePath Script::getFileName() const {
    return fileName;
}

PGE::String Script::getScriptContents() const {
    return scriptContents;
}

Script::~Script() {
    //do nothing
}

