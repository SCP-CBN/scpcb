#ifndef INI_H_INCLUDED
#define INI_H_INCLUDED

#include <vector>
#include <map>

#include <Misc/FilePath.h>

class INIFile {
    public:
        struct Section {
            std::vector<PGE::String> names;
            std::vector<PGE::String> keys;
            std::vector<PGE::String> values;
        };

    private:
        bool unsavedChanges;

        std::vector<Section*> sections;

        PGE::String getValue(const PGE::String& section, const PGE::String& key, const PGE::String& defaultValue);
        void setValue(const PGE::String& section, const PGE::String& key, const PGE::String& value);

    public:
        PGE::FilePath name;
        
        INIFile(const PGE::FilePath& filename);
        ~INIFile();

        void save();

        PGE::String getString(const PGE::String& section, const PGE::String& key, const PGE::String& defaultValue = "");
        bool getBool(const PGE::String& section, const PGE::String& key, bool defaultValue = false);
        int getInt(const PGE::String& section, const PGE::String& key, int defaultValue = 0);
        float getFloat(const PGE::String& section, const PGE::String& key, float defaultValue = 0.f);

        void setString(const PGE::String& section, const PGE::String& key, const PGE::String& value);
        void setBool(const PGE::String& section, const PGE::String& key, bool value);
        void setInt(const PGE::String& section, const PGE::String& key, int value);
        void setFloat(const PGE::String& section, const PGE::String& key, float value);

        std::vector<INIFile::Section*> getAllSections();
};

#endif // INI_H_INCLUDED
