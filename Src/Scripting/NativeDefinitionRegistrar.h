#ifndef NATIVE_DEFINITION_REGISTRAR_H_INCLUDED
#define NATIVE_DEFINITION_REGISTRAR_H_INCLUDED

#include <vector>

#include "NativeDefinitionDependencyFlags.h"

class ScriptManager;
class RefCounterManager;
struct NativeDefinitionsHelpers;

class NativeDefinitionRegistrar {
	public:
		using NativeDefinitionFunction = void(*)(ScriptManager&, class asIScriptEngine&, RefCounterManager&, const NativeDefinitionsHelpers&);

		static void registerNativeDefs(ScriptManager& sm, RefCounterManager& refMgr, const NativeDefinitionsHelpers& helpers);

		NativeDefinitionRegistrar(NativeDefinitionFunction natDefFunc,
			NativeDefinitionDependencyFlags dependencies = NativeDefinitionDependencyFlags::NONE,
			NativeDefinitionDependencyFlags resolvesDependencies = NativeDefinitionDependencyFlags::NONE);

#ifdef DEBUG
		~NativeDefinitionRegistrar() noexcept(false);
#endif

	private:
		static std::vector<NativeDefinitionRegistrar*> registeredNativeDefs;

		NativeDefinitionFunction func;
		NativeDefinitionDependencyFlags dependencies;
		NativeDefinitionDependencyFlags resolvesDependencies;
};

#endif // NATIVE_DEFINITION_REGISTRAR_H_INCLUDED
