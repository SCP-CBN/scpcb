#include <iostream>

#include <PGE/String/String.h>
#include <PGE/File/FilePath.h>
#include <PGE/File/TextWriter.h>
#include <PGE/String/Unicode.h>
#include <PGE/Exception/Exception.h>

#include <tinyxml2.h>

using namespace PGE;

static void checkDirValid(const FilePath& path) {
	PGE_ASSERT(path.exists() && path.isDirectory(), path.str() + " does not exist");
}

static void checkXmlSuccess(tinyxml2::XMLError code, const std::source_location& loc = std::source_location::current()) {
	PGE_ASSERT_AT(code == 0, "XML failed!", loc);
}

static void skipLine(String::Iterator& it) {
	while (*it != '\n') { it++; }
	it++;
}

static void skipSpace(String::Iterator& it) {
	while (Unicode::isSpace(*it)) { it++; }
}

static String getToken(const String& str, String::Iterator& it) {
	skipSpace(it);
	auto begin = it;
	char16 ch;
	while ((ch = *it) == '_' || isalnum(ch)) {
		it++;
	}
	it++;
	return str.substr(begin, it);
}

int main(int argc, char** argv) {
	auto argFromIndex = [=](int index, const String& name) -> String {
		if (argc > index) return argv[index];
		std::cout << "Enter " << name << ": ";
		String temp; std::cin >> temp; return temp;
	};

	auto include =
#ifdef _DEBUG
		FilePath::fromStr("Engine/Include/PGE/");
#else
		FilePath::fromStr(argFromIndex(1, "include dir")).makeDirectory();
#endif
	checkDirValid(include);

	auto gen =
#ifdef _DEBUG
		FilePath::fromStr("Src/Scripting/NativeDefinitions/");
#else
		FilePath::fromStr(argFromIndex(2, "gen dir")).makeDirectory();
#endif
	checkDirValid(gen);

	for (const auto& file : gen.enumerateFiles()) {
		if (file.getExtension() == "xml") {
			FilePath fileName = file.trimExtension();
			String header = (fileName + ".h").getRelativePath(gen).value();

			FilePath genFile = fileName + ".cpp";
			FilePath srcFile = include + header;
			PGE_ASSERT(srcFile.exists(), "Src file did not exist!");
			if (genFile.exists() && file.getLastModifyTime() <= genFile.getLastModifyTime()
				&& srcFile.getLastModifyTime() <= genFile.getLastModifyTime()) {
				std::cout << "File " << genFile.str() << " up to date" << std::endl;
			}

			std::cout << "Processing file " << genFile.str() << std::endl;

			tinyxml2::XMLDocument doc;
			checkXmlSuccess(doc.LoadFile(file.str().cstr()));
			// TODO: get some information idfk

			TextWriter writer(genFile);
			writer.writeLine("#include <Scripting/NativeDefinitionRegistrar.h>");
			writer.writeLine("#include <Scripting/NativeUtils.h>");
			writer.writeLine();
			writer.writeLine("#include <PGE/" + header + ">");
			writer.writeLine();
			writer.writeLine("using namespace PGE;");
			writer.writeLine();
			writer.writeLine("static void reg(class ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers&) {");

			String src = srcFile.readText();
			std::vector<String> namespaces;
			auto it = src.begin();
			/*while (it != src.end()) {
				if (*it == '#') {
					skipLine(it);
					continue;
				}
				String token = getToken(src, it);
				if (token == "namespace") {
					String ns = getToken(src, it);
					if (ns != "PGE") {
						namespaces.push_back(ns);
					}
					getToken(src, it); // {
				}
			}*/

			writer.writeLine("}");
			writer.writeLine();
			writer.writeLine("static NativeDefinitionRegistrar _{");
			writer.writeLine("\t&reg,");
			writer.writeLine("\tNativeDefinitionDependencyFlags::NONE,");
			writer.writeLine("\tNativeDefinitionDependencyFlags::MATH");
			writer.writeLine("};");
		}
	}
}
