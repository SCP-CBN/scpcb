#include "NativeDefinitionRegistrar.h"

#include "NativeDefinitionHelpers.h"

#include "ScriptManager.h"

using namespace PGE;

std::vector<NativeDefinitionRegistrar*> NativeDefinitionRegistrar::registeredNativeDefs;

void NativeDefinitionRegistrar::registerNativeDefs(ScriptManager& sm, RefCounterManager& refMgr, const NativeDefinitionsHelpers& helpers) {
	NativeDefinitionDependencies current = NativeDefinitionDependencyFlagBits::NONE;
	NativeDefinitionDependencies prev;
	do {
		prev = current;
		for (auto it = registeredNativeDefs.begin(); it != registeredNativeDefs.end();) {
			const NativeDefinitionRegistrar& natDef = **it;
			if (!(~current & natDef.dependencies)) {
				natDef.func(sm, *sm.getAngelScriptEngine(), refMgr, helpers);
				// Already resolved dependencies can't be resolved again
				PGE_ASSERT(natDef.resolvesDependencies == NativeDefinitionDependencyFlagBits::NONE ||
					current != (natDef.resolvesDependencies | current),
					"Dependency " + String::from<NativeDefinitionDependencies::UnderlyingType>(natDef.resolvesDependencies) + " already resolved");
				current |= natDef.resolvesDependencies;
				it = registeredNativeDefs.erase(it);
			} else {
				it++;
			}
		}
	} while (!registeredNativeDefs.empty() || current != prev);
	PGE_ASSERT(registeredNativeDefs.empty(), "Not all dependencies were resolved");
}

NativeDefinitionRegistrar::NativeDefinitionRegistrar(NativeDefinitionFunction natDefFunc,
	NativeDefinitionDependencies dependencies, NativeDefinitionDependencies resolvesDependencies)
	: func(natDefFunc), dependencies(dependencies), resolvesDependencies(resolvesDependencies) {
	registeredNativeDefs.push_back(this);
}

NativeDefinitionRegistrar::~NativeDefinitionRegistrar() {
#ifdef DEBUG
	PGE_ASSERT(registeredNativeDefs.empty(), "Not all registered native definitions were consumed");
#endif
}
