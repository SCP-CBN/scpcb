#ifndef NATIVE_DEFINITION_REGISTRAR_H_INCLUDED
#define NATIVE_DEFINITION_REGISTRAR_H_INCLUDED

#include <vector>

#include "NativeDefinitionDependencies.h"

class RefCounterManager;
struct NativeDefinitionsHelpers;

class NativeDefinitionRegistrar {
	public:
		using NativeDefinitionFunction = void(*)(class asIScriptEngine&, RefCounterManager&, const NativeDefinitionsHelpers&);

		static void registerNativeDefs(class ScriptManager& sm, RefCounterManager& refMgr, const NativeDefinitionsHelpers& helpers);

		NativeDefinitionRegistrar(NativeDefinitionFunction natDefFunc,
			NativeDefinitionDependencies dependencies = NativeDefinitionDependencyFlagBits::NONE,
			NativeDefinitionDependencies resolvesDependencies = NativeDefinitionDependencyFlagBits::NONE);

		~NativeDefinitionRegistrar();

	private:
		static std::vector<NativeDefinitionRegistrar*> registeredNativeDefs;

		NativeDefinitionFunction func;
		NativeDefinitionDependencies dependencies;
		NativeDefinitionDependencies resolvesDependencies;
};

#endif // NATIVE_DEFINITION_REGISTRAR_H_INCLUDED
