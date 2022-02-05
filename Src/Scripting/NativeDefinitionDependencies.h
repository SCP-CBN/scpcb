#ifndef NATIVE_DEFINITION_DEPENDENCIES_H_INCLUDED
#define NATIVE_DEFINITION_DEPENDENCIES_H_INCLUDED

#include <PGE/Types/FlagEnum.h>

enum class NativeDefinitionDependencyFlagBits {
	NONE = 0,
	MATH = 1 << 0,
	COLLISION = 1 << 1,
};
using NativeDefinitionDependencies = PGE::FlagEnum<NativeDefinitionDependencyFlagBits>;

#endif // NATIVE_DEFINITION_DEPENDENCIES_H_INCLUDED
