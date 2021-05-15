#include <iostream>
#include <fstream>
#include <String/String.h>

#include "INI.h"

INIFile* INIFile::iniFileFactory(const PGE::FilePath& filename) {
    INIFile* newINI = new INIFile(filename);
    return newINI;
}
	

INIFile::INIFile(const PGE::FilePath& filename) {
    name = filename;

    unsavedChanges = false;

    Section* currSection = nullptr;

    std::ifstream file(name.cstr());

    if (file.good()) {
        PGE::String currLine;
        while (!file.eof()) {
            std::string cppStr;
            getline(file, cppStr);
            currLine = PGE::String(cppStr);

            if (*currLine.charAt(0) == '[') {
                if (currSection != nullptr) {
                    sections.push_back(currSection);
                }
                currSection = new Section();
                currLine = currLine.substr(1,currLine.length()-2).trim();
                currSection->names = currLine.split('|', true);
            } else if (*currLine.charAt(0) != ';') {
                if (currSection != nullptr) {
                    std::vector<PGE::String> split = currLine.split('=', false);
                    if (split.size() >= 2) {
                        currSection->keys.push_back(split[0].trim());

                        // If the value itself had a '=' in it then recover those.
                        split.erase(split.begin());
                        PGE::String value = PGE::String::join(split, '=');
                        currSection->values.push_back(value.trim());
                    }
                }
            }
        }
        if (currSection != nullptr) {
            sections.push_back(currSection);
        }
    }
    file.close();
}


PlayerController* PlayerControllerDefinitions::playerControllerFactory(float radius, float height) {
  
  PlayerController* newController = new PlayerController(radius, height);
    refCount.emplace(newController, 1);
   
 refCounterManager->linkPtrToCounter(newController, this);
    return newController;
}


void PlayerControllerDefinitions::release(void* ptr) {
    PlayerController* controller = (PlayerController*)ptr;
 
   if (refCount.find(controller) == refCount.end()) { return; }
    refCount[controller]--;

    if (refCount[controller] <= 0) {
     
   refCount.erase(controller);
        refCounterManager->unlinkPtr(controller);
        if (PickableManager::cmc != nullptr) {
      
      refCounterManager->release(PickableManager::cmc);
        }
        delete controller;
    }
}



INIFile::~INIFile() {
    save();
    for (int i = 0; i < (int)sections.size(); i++) {
        delete sections[i];
    }
}

INIFile::release(void* ptr) {
    INIFile* iniF = (INIFile*)ptr;
    delete iniF;
}

PGE::String INIFile::getValue(const PGE::String& section, const PGE::String& key, const PGE::String& defaultValue) {
    for (int i = 0; i < (int)sections.size(); i++) {
        for (int j = 0; j < (int)sections[i]->names.size(); j++) {
            if (section.equalsIgnoreCase(sections[i]->names[j])) {
                for (int k = 0; k < (int)sections[i]->keys.size(); k++) {
                    if (sections[i]->keys[k].equalsIgnoreCase(key)) {
                        return sections[i]->values[k];
                    }
                }
                return defaultValue;
            }
        }
    }
    return defaultValue;
}

void INIFile::setValue(const PGE::String& section, const PGE::String& key, const PGE::String& value) {
    for (int i = 0; i < (int)sections.size(); i++) {
        for (int j = 0; j < (int)sections[i]->names.size(); j++) {
            if (section.equalsIgnoreCase(sections[i]->names[j])) {
                for (int k = 0; k < (int)sections[i]->keys.size(); k++) {
                    if (sections[i]->keys[k].equalsIgnoreCase(key)) {
                        if (!sections[i]->values[k].equals(value)) {
                            sections[i]->values[k] = value;
                            unsavedChanges = true;
                        }
                        return;
                    }
                }

                // Key doesn't exist, make it.
                sections[i]->keys.push_back(key.toLower());
                sections[i]->values.push_back(value);
                unsavedChanges = true;
                return;
            }
        }
    }

    // Section doesn't exist, make one.
    Section* sec = new Section();
    sec->names.push_back(section);
    sec->keys.push_back(key.toLower());
    sec->values.push_back(value);

    sections.push_back(sec);
    unsavedChanges = true;
}

std::vector<INIFile::Section*> INIFile::getAllSections() {
    return sections;
}

void INIFile::save() {
    if (!unsavedChanges) {
        return;
    }

    std::ofstream f(name.cstr());

    for (int i = 0; i < (int)sections.size(); i++) {
        PGE::String secName = sections[i]->names[0];
        for (int j = 1; j < (int)sections[i]->names.size(); j++) {
            secName = secName + "|" + sections[i]->names[j];
        }
        f << "[" << secName << "]" << std::endl;
        for (int j = 0; j < (int)sections[i]->keys.size(); j++) {
            f << sections[i]->keys[j] << " = " << sections[i]->values[j] << std::endl;
        }
        f << std::endl;
    }

    f.close();
    unsavedChanges = false;
}

PGE::String INIFile::getString(const PGE::String& section, const PGE::String& key, const PGE::String& defaultValue) {
    return getValue(section, key, defaultValue);
}

bool INIFile::getBool(const PGE::String& section, const PGE::String& key, bool defaultValue) {
    PGE::String val = getValue(section, key, "");
    if (val == "true" || val == "false") {
        return val == "true";
    } else {
        return defaultValue;
    }
}

int INIFile::getInt(const PGE::String& section, const PGE::String& key, int defaultValue) {
    return getValue(section, key, PGE::String::fromInt(defaultValue)).toInt();
}

float INIFile::getFloat(const PGE::String& section, const PGE::String& key, float defaultValue) {
    return getValue(section, key, PGE::String::fromFloat(defaultValue)).toFloat();
}

void INIFile::setString(const PGE::String& section, const PGE::String& key, const PGE::String& value) {
    setValue(section, key, value);
}

void INIFile::setBool(const PGE::String& section, const PGE::String& key, bool value) {
    setValue(section, key, value ? "true" : "false");
}

void INIFile::setInt(const PGE::String& section, const PGE::String& key, int value) {
    setValue(section, key, PGE::String::fromInt(value));
}

void INIFile::setFloat(const PGE::String& section, const PGE::String& key, float value) {
    setValue(section, key, PGE::String::fromFloat(value));
}
