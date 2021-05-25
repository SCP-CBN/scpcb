#include <filesystem>
#include <unordered_set>
#include <iostream>

#include <Misc/FilePath.h>
#include <String/Key.h>
#include <Exception/Exception.h>

using namespace PGE;

namespace fs = std::filesystem;

std::unordered_set<String::Key> extensions;

bool check(const fs::directory_entry& file) {
    if (file.is_directory()) {
        return false;
    }
    if (extensions.empty()) {
        return true;
    }
    if (extensions.find(file.path().extension()) != extensions.end()) {
        return true;
    }
    return false;
}

int main(int argc, const char** argv) {
    FilePath src;
    FilePath bin;

    if (argc > 2) {
        src = FilePath::fromStr(argv[1]);
        bin = FilePath::fromStr(argv[2]);
    } else {
        String input;
        std::cout << "src: ";
        std::cin >> input;
        src = FilePath::fromStr(input);
        input = String();
        std::cout << "bin: ";
        std::cin >> input;
        bin = FilePath::fromStr(input);
    }
    src = src.makeDirectory();
    bin = bin.makeDirectory();

    if (argc > 3) {
        // : because it's illegal in filenames.
        std::vector<String> ext = String(argv[3]).split(":", false);
        extensions.insert(ext.begin(), ext.end());
    }

    std::unordered_set<String::Key> sources;
    for (const fs::directory_entry& file : fs::recursive_directory_iterator(src.cstr())) {
        if (check(file)) {
            sources.insert(file.path().string().substr(src.length()));
        }
    }

    for (const fs::directory_entry& file : fs::recursive_directory_iterator(bin.cstr())) {
        if (check(file) && sources.find(file.path().string().substr(bin.length())) == sources.end()) {
            std::cout << "Deleting leftover: " << file.path() << std::endl;
            fs::remove(file);
        }
    }
}
