#ifndef NATIVE_DEFINITION_DEPENDENCIES_H_INCLUDED
#define NATIVE_DEFINITION_DEPENDENCIES_H_INCLUDED

#include <PGE/Types/FlagEnum.h>

enum class NativeDefinitionDependencyFlags {
	NONE = 0,
	MATH = 1 << 0,
	COLLISION = 1 << 1,
	TEXTURE = 1 << 2,
	COLOR = 1 << 3,
};
template <> struct PGE::IsFlagEnum<NativeDefinitionDependencyFlags> : Meta, std::true_type { };

#endif // NATIVE_DEFINITION_DEPENDENCIES_H_INCLUDED
