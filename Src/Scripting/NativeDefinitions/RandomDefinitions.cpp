#include "../NativeDefinitionRegistrar.h"
#include "../NativeUtils.h"

#include <PGE/Math/Random.h>

using namespace PGE;

#include <iostream>

static void registerRandomDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager& refCtr, const NativeDefinitionsHelpers&) {
	static Random genericRandom;

	engine.SetDefaultNamespace("Random");
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_G(Random, next, genericRandom);
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_G(Random, nextBool, genericRandom);
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_G(Random, nextFloat, genericRandom);
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_EX_G(Random, float, nextGaussian, (), genericRandom);
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_EX_G(Random, float, nextGaussian, (float, float), genericRandom);
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_EX_G(Random, float, nextGaussian, (float, float, float, float), genericRandom);
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_G(Random, nextGaussianInRange, genericRandom);
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_EX_G(Random, u32, nextInt, (u32), genericRandom);
	engine.PGE_REGISTER_METHOD_AS_FUNCTION_EX_G(Random, i32, nextInt, (i32, i32), genericRandom);

	engine.SetDefaultNamespace("");
	PGE_REGISTER_REF_TYPE_FULL(Random, engine, refCtr);
	engine.PGE_REGISTER_REF_CONSTRUCTOR(Random, ());
	engine.PGE_REGISTER_REF_CONSTRUCTOR(Random, (u64));
	engine.PGE_REGISTER_METHOD(Random, next);
	engine.PGE_REGISTER_METHOD(Random, nextBool);
	engine.PGE_REGISTER_METHOD(Random, nextFloat);
	engine.PGE_REGISTER_METHOD_EX(Random, float, nextGaussian, ());
	engine.PGE_REGISTER_METHOD_EX(Random, float, nextGaussian, (float, float));
	engine.PGE_REGISTER_METHOD(Random, nextGaussianInRange);
	engine.PGE_REGISTER_METHOD_EX(Random, float, nextGaussian, (float, float, float, float));
	engine.PGE_REGISTER_METHOD_EX(Random, u32, nextInt, (u32));
	engine.PGE_REGISTER_METHOD_EX(Random, i32, nextInt, (i32, i32));
}

static NativeDefinitionRegistrar _ { &registerRandomDefinitions };
