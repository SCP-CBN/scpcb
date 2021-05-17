#include "Config.h"

#include "../Utils/INI.h"
#include "../Input/Input.h"
#include "../Graphics/GraphicsResources.h"

const PGE::String CORP_FOLDER = "Undertow Games";
const PGE::String GAME_FOLDER = "SCP - Containment Breach";

const PGE::String SEC_GEN = "general";
const PGE::String SEC_GFX = "graphics";
const PGE::String SEC_CON = "controls";
const PGE::String SEC_MOD = "mods";

PGE::FilePath getConfigDir() {
    // return ""; // Uncomment this if you want options.ini in the root game folder.
    return PGE::FilePath::getDataPath() + CORP_FOLDER + '/' + GAME_FOLDER + '/';
}

Config::Config(const PGE::String& file) :
        filename(getConfigDir() + file),
        optionsFile(new INIFile(filename)),
        vsync(new BoolConfigValue(optionsFile, SEC_GFX, "vsync", true)),
        vr(new BoolConfigValue(optionsFile, SEC_GFX, "vr", false)),
        sensitivity(new IntConfigValue(optionsFile, SEC_GEN, "sensitivity", 100)),
        languageCode(new StringConfigValue(optionsFile, SEC_GEN, "language", "en")),
        windowType(new IntConfigValue(optionsFile, SEC_GFX, "window", WindowType::Windowed)),
        width(new IntConfigValue(optionsFile, SEC_GFX, "width", 1280)),
        height(new IntConfigValue(optionsFile, SEC_GFX, "height", 720)),
        enabledMods(new ArrayConfigValue(optionsFile, SEC_MOD, "enabledmods", "RootScript|SCPCB")),
        resourcePackLocations(new ArrayConfigValue(optionsFile, SEC_MOD, "resourcepacklocations", "ResourcePacks")),
        enabledResourcePacks(new ArrayConfigValue(optionsFile, SEC_MOD, "enabledresourcepacks", "HIGH|hahahaha")) {
    values.push_back(vsync);
    values.push_back(vr);
    values.push_back(sensitivity);
    values.push_back(languageCode);
    values.push_back(windowType);
    values.push_back(width);
    values.push_back(height);
    values.push_back(enabledMods);
    values.push_back(resourcePackLocations);
    values.push_back(enabledResourcePacks);

    setResolution(width->value, height->value);

    // Generating default keyboard bindings.
    kbBinds.emplace(Input::FORWARD, PGE::KeyboardInput::Keycode::W);
    kbBinds.emplace(Input::BACKWARD, PGE::KeyboardInput::Keycode::S);
    kbBinds.emplace(Input::LEFT, PGE::KeyboardInput::Keycode::A);
    kbBinds.emplace(Input::RIGHT, PGE::KeyboardInput::Keycode::D);
    kbBinds.emplace(Input::SPRINT, PGE::KeyboardInput::Keycode::LSHIFT);
    kbBinds.emplace(Input::CROUCH, PGE::KeyboardInput::Keycode::LCTRL);
    kbBinds.emplace(Input::BLINK, PGE::KeyboardInput::Keycode::SPACE);
    kbBinds.emplace(Input::INTERACT, PGE::KeyboardInput::Keycode::E);
    kbBinds.emplace(Input::INVENTORY, PGE::KeyboardInput::Keycode::TAB);
    kbBinds.emplace(Input::TOGGLE_CONSOLE, PGE::KeyboardInput::Keycode::F3);

    if (filename.exists()) {
        loadFile();
    } else {
        (PGE::FilePath::getDataPath() + CORP_FOLDER).createDirectory();
        getConfigDir().createDirectory();

        saveFile();
    }
}

Config::~Config() {
    // Deleting all entries in the list, as we own them.
    for (int i = 0; i < values.size(); i++) {
        delete values[i];
    }

    delete optionsFile;
}

void Config::setGraphicsResources(GraphicsResources* grm) {
    gfxResMgr = grm;
}

void Config::loadFile() {
    for (int i = 0; i < values.size(); i++) {
        values[i]->loadValue();
    }

    setResolution(width->value, height->value);

    loadKeyboardInput(Input::FORWARD);
    loadKeyboardInput(Input::BACKWARD);
    loadKeyboardInput(Input::LEFT);
    loadKeyboardInput(Input::RIGHT);
    loadKeyboardInput(Input::SPRINT);
    loadKeyboardInput(Input::CROUCH);
    loadKeyboardInput(Input::BLINK);
    loadKeyboardInput(Input::INTERACT);
    loadKeyboardInput(Input::INVENTORY);
}

void Config::loadKeyboardInput(Input input) {
    PGE::String name = getBindingName(input) + "_keyboard";
    PGE::String bindings = optionsFile->getString(SEC_CON, name, "");
    if (bindings.isEmpty()) {
        return;
    }

    std::pair<KeyBindsMap::iterator, KeyBindsMap::iterator> bindingsRange = kbBinds.equal_range(input);
    kbBinds.erase(bindingsRange.first, bindingsRange.second);

    std::vector<PGE::String> bindVect = bindings.split(',', true);
    for (int i = 0; i < (int)bindVect.size(); i++) {
        kbBinds.emplace(input, (PGE::KeyboardInput::Keycode)bindVect[i].toInt());
    }
}

void Config::saveFile() const {
    for (int i = 0; i < values.size(); i++) {
        values[i]->saveValue();
    }

    Input currInput = Input::NONE;
    std::vector<PGE::String> strToJoin;
    for (const auto& it : kbBinds) {
        if (it.first != currInput) {
            optionsFile->setString(SEC_CON, getBindingName(currInput) + "_keyboard", PGE::String::join(strToJoin, ","));
            strToJoin.clear();
            currInput = it.first;
        }
        strToJoin.push_back(PGE::String::fromInt((int)it.second));
    }
    optionsFile->setString(SEC_CON, getBindingName(currInput) + "_keyboard", PGE::String::join(strToJoin, ","));

    optionsFile->save();
}

void Config::setResolution(int width, int height) {
    PGE_ASSERT(width > 0 && height > 0, "Invalid display resolution. (width: " + PGE::String::fromInt(width) + ", height: " + PGE::String::fromInt(height) + ")");

    this->width->value = width;
    this->height->value = height;
    aspectRatio = (float)width / height;

    if (gfxResMgr != nullptr) { gfxResMgr->updateOrthoMat(aspectRatio); }
}

int Config::getWidth() const {
    return width->value;
}

int Config::getHeight() const {
    return height->value;
}

float Config::getAspectRatio() const {
    return aspectRatio;
}

const Config::KeyBindsMap& Config::getKeyboardBindings() const {
    return kbBinds;
}
