#include <Scripting/NativeDefinitionRegistrar.h>
#include <Scripting/NativeUtils.h>

#include <PGE/Math/Math.h>

using namespace PGE;

static void reg(class ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers&) {
}

static NativeDefinitionRegistrar _{
	&reg,
	NativeDefinitionDependencyFlags::NONE,
	NativeDefinitionDependencyFlags::MATH
};
