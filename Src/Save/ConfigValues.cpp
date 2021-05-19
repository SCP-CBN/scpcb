#include "ConfigValues.h"

#include "../Utils/INI.h"

ConfigValue::ConfigValue(INIFile* file, const PGE::String& section, const PGE::String& name) :
    file(file), section(section), name(name) { }

IntConfigValue::IntConfigValue(INIFile* file, const PGE::String& section, const PGE::String& name, int defaultValue)
    : ConfigValue(file, section, name) {
    value = defaultValue;
}

void IntConfigValue::saveValue() const {
    file->setInt(section, name, value);
}

void IntConfigValue::loadValue() {
    value = file->getInt(section, name, value);
}

BoolConfigValue::BoolConfigValue(INIFile* file, const PGE::String& section, const PGE::String& name, bool defaultValue)
    : ConfigValue(file, section, name) {
    value = defaultValue;
}

void BoolConfigValue::saveValue() const {
    file->setBool(section, name, value);
}

void BoolConfigValue::loadValue() {
    value = file->getBool(section, name, value);
}

StringConfigValue::StringConfigValue(INIFile* file, const PGE::String& section, const PGE::String& name, const PGE::String& defaultValue)
    : ConfigValue(file, section, name) {
    value = defaultValue;
}

void StringConfigValue::saveValue() const {
    file->setString(section, name, value);
}

void StringConfigValue::loadValue() {
    value = file->getString(section, name, value);
}

ArrayConfigValue::ArrayConfigValue(INIFile* file, const PGE::String& section, const PGE::String& name, const PGE::String& defaultValue)
    : ConfigValue(file, section, name) {
    value = defaultValue.split('|', true);
}

void ArrayConfigValue::saveValue() const {
    file->setString(section, name, PGE::String::join(value, '|'));
}

void ArrayConfigValue::loadValue() {
    PGE::String newVal = file->getString(section, name, "");
    if (!newVal.isEmpty()) {
        value = newVal.split('|', true);
    }
}
