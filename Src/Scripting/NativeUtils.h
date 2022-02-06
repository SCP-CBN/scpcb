#ifndef NATIVE_UTILS_H_INCLUDED
#define NATIVE_UTILS_H_INCLUDED

#include <angelscript.h>

#include <PGE/String/String.h>
#include <PGE/Exception/Exception.h>

#include "../RefCounter.h"

template <typename T, typename... Args>
static void constructGen(Args... args, void* memory) {
    new (memory) T(args...);
}

template <typename T>
static void destructGen(void* memory) {
    ((T*)memory)->~T();
}

template <typename T>
class GenericRefCounter : public RefCounter {
	private:
		std::unordered_map<void*, int> refCount;
		RefCounterManager& refCounterManager;

		void emplace(void* ptr) {
			refCount.emplace(ptr, 1);
			refCounterManager.linkPtrToCounter(ptr, this);
		}

	public:
		GenericRefCounter(RefCounterManager& mgr) : refCounterManager(mgr) { }

		template <typename... Args>
		T* factory(Args&&... args) {
			T* newVal = new T(std::forward<Args>(args)...);
			emplace(newVal);
			return newVal;
		}

		void addRef(void* ptr) override {
			PGE_ASSERT(refCount.find(ptr) != refCount.end(), "ptr was not registered");
			refCount[ptr]++;
		}

		void release(void* ptr) override {
			auto it = refCount.find(ptr);
			PGE_ASSERT(it != refCount.end(), "ptr was not registered");
			if (it->second == 0) {
				refCount.erase(it);
				refCounterManager.unlinkPtr(ptr);
				delete (T*)ptr;
			} else { it->second--; }
		}
};

static const PGE::String trimNamespaces(const PGE::String& name) {
    PGE::String::ReverseIterator it = name.findLast(":");
    return name.substr(it != name.rend() ? PGE::String::Iterator(--it) : name.begin(), name.findFirst("<"));
}

template <typename T>
static const PGE::String getTypeName() {
#if defined(_MSC_VER) && !defined(__GNUC__) && !defined(__llvm__) && !defined(__INTEL_COMPILER)
    PGE::String ret = __FUNCSIG__; // class PGE::String __cdecl getTypeName<TYPE>(void)
    auto beginPos = ret.findFirst('<');
    ret = ret.substr(beginPos + 1, ret.end() - sizeof(">(void)") + 1);
    return trimNamespaces(ret.replace("class ", "").replace("struct ", ""));
#else
    PGE::String ret = __PRETTY_FUNCTION__; // PGE::String getTypeName() [with T = TYPE]
    auto begin = ret.findFirst('=') + 2;
    return trimNamespaces(ret.substr(begin, ret.end() - 1));
#endif
}

template <typename T>
static const PGE::String getAsTypeName(bool isReturn = false) {
    PGE::String ret;
    bool isConst = std::is_const<std::remove_reference<T>::type>::value;
    if (isConst) { ret += "const "; }
    ret += getTypeName<std::remove_cvref<T>::type>();
    if (std::is_pointer<T>::value) { ret = ret.replace("*", "@"); }
    ret = ret.replace("unsigned ", "u");
    if (std::is_reference<T>::value) {
        ret += "&";
        if (!isReturn) {
            ret += isConst ? "in" : "out";
        }
    }
    return ret;
}

static bool isTypeConst(const PGE::String& type) {
    return type.findFirst("const") != type.end();
}

template <typename T, typename... Args>
static const PGE::String idfk(const PGE::String& name, T(*fu)(Args...), asECallConvTypes callConv) {
    PGE::String ret = getAsTypeName<T>(true) + " " + trimNamespaces(name) + "(";
    bool isConst = false;
    if constexpr (sizeof...(Args) > 0) {
        std::vector<PGE::String> strings; strings.reserve(sizeof...(Args));
        (strings.push_back(getAsTypeName<Args>()), ...);
        switch (callConv) {
            case asCALL_CDECL_OBJLAST: {
                isConst = isTypeConst(strings.back());
                strings.pop_back();
            } break;
            case asCALL_CDECL_OBJFIRST: {
                isConst = isTypeConst(strings.front());
                strings.erase(strings.begin());
            }
        }
        ret += PGE::String::join(strings, ", ");
    }
    return ret + ")" + (isConst ? " const" : "");
}

template <typename... Args>
static const PGE::String funcToAsFuncName(const PGE::String& cppName) {
    //using StringLiterals; // TODO: ???

    static const PGE::String OPERATOR = "operator";
    if (cppName.substr(0, std::min(OPERATOR.length(), cppName.length())) != OPERATOR) {
        return cppName;
    }

    constexpr auto prependPostPre = [](const PGE::String& op) constexpr {
        return PGE::String("op") + (sizeof...(Args) == 0 ? "Pre" : "Post") + op;
    };

    PGE::String suffix = cppName.substr(OPERATOR.length());
    // Reference: https://www.angelcode.com/angelscript/sdk/docs/manual/doc_script_class_ops.html
    if (suffix == "-") { return sizeof...(Args) == 0 ? "opNeg" : "opSub"; }
    // Unary
    else if (suffix == "~") { return "opCom"; }
    else if (suffix == "++") { return prependPostPre("Inc"); }
    else if (suffix == "--") { return prependPostPre("Dec"); }
    // Comparison
    else if (suffix == "==") { return "opEquals"; }
    else if (suffix == "<=>") { return "opCmp"; } // I didn't test this, I genuinely don't know
    // Assignment
    else if (suffix == "=") { return "opAssign"; }
    else if (suffix == "+=") { return "opAddAssign"; }
    else if (suffix == "-=") { return "opSubAssign"; }
    else if (suffix == "*=") { return "opMulAssign"; }
    else if (suffix == "/=") { return "opDivAssign"; }
    else if (suffix == "%=") { return "opModAssign"; }
    else if (suffix == "&=") { return "opAndAssign"; }
    else if (suffix == "|=") { return "opOrAssign"; }
    else if (suffix == "^=") { return "opXorAssign"; }
    else if (suffix == "<<=") { return "opShlAssign"; }
    else if (suffix == ">>=") { return "opShrAssign"; }
    // Binary
    else if (suffix == "+") { return "opAdd"; }
    else if (suffix == "*") { return "opMul"; }
    else if (suffix == "/") { return "opDiv"; }
    else if (suffix == "%") { return "opMod"; }
    else if (suffix == "&") { return "opAnd"; }
    else if (suffix == "|") { return "opOr"; }
    else if (suffix == "^") { return "opXor"; }
    else if (suffix == "<<") { return "opShl"; }
    else if (suffix == ">>") { return "opShr"; }
    // Index
    else if (suffix == "[]") { return "opIndex"; }
    // Functor
    else if (suffix == "()") { return "opCall"; }
    else { throw PGE::Exception("Invalid operator"); }
    // TODO: Casting support
}

template <bool isConst, typename Class, typename T, typename... Args>
static const PGE::String idfkProper(const PGE::String& name, bool opReversed, const std::vector<PGE::String>& defaults, bool ignoreConst) {
    PGE::String ret = getAsTypeName<T>(true) + " " + funcToAsFuncName<Args...>(name) + (opReversed ? "_r" : "") + "(";
    if constexpr (sizeof...(Args) > 0) {
        std::vector<PGE::String> strings; strings.reserve(sizeof...(Args));
        (strings.push_back(getAsTypeName<Args>()), ...);
        for (int i : PGE::Range(strings.size())) {
            if (i != 0) {
                ret += ", ";
            }
            ret += strings[i];
            if (int defaultIndex = i - (strings.size() - defaults.size()); defaultIndex >= 0) {
                ret += " = " + defaults[defaultIndex];
            }
        }
    }
    ret += ")";
    if (isConst && !ignoreConst) {
        ret += " const";
    }
    return ret;
}

template <typename Class, typename T, typename... Args>
static const PGE::String idfkMethod(const PGE::String& name, T(Class::*)(Args...) const,
    bool isReversed = false, const std::vector<PGE::String>& defaults = { }, bool ignoreConst = false) {
    return idfkProper<true, Class, T, Args...>(name, isReversed, defaults, ignoreConst);
}

template <typename Class, typename T, typename... Args>
static const PGE::String idfkMethod(const PGE::String& name, T(Class::*)(Args...),
    bool isReversed = false, const std::vector<PGE::String>& defaults = { }, bool ignoreConst = false) {
    return idfkProper<false, Class, T, Args...>(name, isReversed, defaults, ignoreConst);
}

template <typename Class, typename T, typename... Args>
constexpr auto ptrDeduceConst(T(Class::* func)(Args...)) {
    return func;
}

template <typename Class, typename T, typename... Args>
constexpr auto ptrDeduceConst(T(Class::* func)(Args...) const) {
    return func;
}

#define pgeFUNCTION(func, callConv) idfk(#func, &func, callConv).cstr(), asFUNCTION(func), callConv

#define pgeMETHOD(class, func) idfkMethod<class>(#func, &class::func).cstr(), asMETHOD(class, func), asCALL_THISCALL

#define pgeTYPE(class, ...) RegisterObjectType(#class, sizeof(class), __VA_ARGS__)
#define PGE_REGISTER_TYPE(class, ...) pgeTYPE(class, asOBJ_VALUE | asGetTypeTraits<class>() __VA_OPT__(|) __VA_ARGS__)
#define PGE_REGISTER_REF_TYPE(class) pgeTYPE(class, asOBJ_REF)

#define CLASS_FAC(class) class ## Factory

#define DEBRACE(...) __VA_ARGS__

#define PGE_REGISTER_REF_TYPE_FULL(engine, refCtr, class) \
static GenericRefCounter<class> CLASS_FAC(class){refCtr}; \
engine.PGE_REGISTER_REF_TYPE(class); \
engine.RegisterObjectBehaviour(#class, asBEHAVE_ADDREF, "void f()", asMETHOD(GenericRefCounter<class>, addRef), asCALL_THISCALL_OBJLAST, &CLASS_FAC(class)); \
engine.RegisterObjectBehaviour(#class, asBEHAVE_RELEASE, "void f()", asMETHOD(GenericRefCounter<class>, release), asCALL_THISCALL_OBJLAST, &CLASS_FAC(class))

#define PGE_REGISTER_REF_CONSTRUCTOR(class, args) \
    RegisterObjectBehaviour(#class, asBEHAVE_FACTORY, #class "@ f" #args, asMETHOD(GenericRefCounter<class>, factory<DEBRACE args>), asCALL_THISCALL_ASGLOBAL, &CLASS_FAC(class))

#define pgeOFFSET(class, property) (getAsTypeName<decltype(class::property)>() + " " #property).cstr(), asOFFSET(class, property)
#define PGE_REGISTER_PROPERTY(class, property) RegisterObjectProperty(#class, pgeOFFSET(class, property))

#define IDFK(...) __VA_OPT__(,) __VA_ARGS__
#define IDFK2(args) IDFK(DEBRACE args)
#define IHDFKATP(...) __VA_OPT__(, DEBRACE __VA_ARGS__)

#define PGE_REGISTER_METHOD_IMPL(class, func, reversedOp, ...) RegisterObjectMethod(#class, idfkMethod<class>(#func, &class::func, reversedOp, { __VA_ARGS__ }).cstr(), asMETHOD(class, func), asCALL_THISCALL)
#define PGE_REGISTER_METHOD(class, func, ...) PGE_REGISTER_METHOD_IMPL(class, func, false, __VA_ARGS__)
#define PGE_REGISTER_METHOD_R(class, func) PGE_REGISTER_METHOD_IMPL(class, func, true)

#define PGE_REGISTER_FUNCTION_AS_METHOD(class, name, func) \
    RegisterObjectMethod(#class, idfk(name, func, asCALL_CDECL_OBJFIRST).cstr(), asFUNCTION(func), asCALL_CDECL_OBJFIRST)

#define pgeMETHODPR(class, ret, func, args) \
    asSMethodPtr<sizeof(void(class::*)())>::template Convert(ptrDeduceConst<class, ret IDFK2(args)>(&class::func))

#define PGE_REGISTER_METHOD_AS_FUNCTION_EX(class, ret, func, args, instance) \
    RegisterGlobalFunction(idfkMethod<class, ret IDFK2(args)>(#func, &class::func, false).cstr(), \
    pgeMETHODPR(class, ret, func, args), asCALL_THISCALL_ASGLOBAL, &instance)

#define PGE_REGISTER_METHOD_AS_FUNCTION(class, func, instance) \
    RegisterGlobalFunction(idfkMethod(#func, &class::func, false, { }, true).cstr(), asMETHOD(class, func), asCALL_THISCALL_ASGLOBAL, &instance)

#define PGE_REGISTER_METHOD_AS_FUNCTION_EX_G(class, ret, func, args, instance) \
    RegisterGlobalFunction(idfkMethod<class, ret IDFK2(args)>("g" #func, &class::func, false).cstr(), \
    pgeMETHODPR(class, ret, func, args), asCALL_THISCALL_ASGLOBAL, &instance)

#define PGE_REGISTER_METHOD_AS_FUNCTION_G(class, func, instance) \
    RegisterGlobalFunction(idfkMethod("g" #func, &class::func, false, { }, true).cstr(), asMETHOD(class, func), asCALL_THISCALL_ASGLOBAL, &instance)


#define PGE_REGISTER_METHOD_EX_IMPL(class, ret, func, args, reversedOp) RegisterObjectMethod(#class, idfkMethod<class, ret IDFK2(args)>(#func, &class::func, reversedOp).cstr(), \
    pgeMETHODPR(class, ret, func, args), asCALL_THISCALL)
#define PGE_REGISTER_METHOD_EX(class, ret, func, args) PGE_REGISTER_METHOD_EX_IMPL(class, ret, func, args, false)
#define PGE_REGISTER_METHOD_EX_R(class, ret, func, args) PGE_REGISTER_METHOD_EX_IMPL(class, ret, func, args, true)

#define PGE_REGISTER_GLOBAL_FUNCTION_EX(ret, func, args) RegisterGlobalFunction(idfk<ret IDFK2(args)>(#func, &func, asCALL_CDECL).cstr(), \
    asFunctionPtr((void (*)())((ret (*)args)(func))), asCALL_CDECL)
#define PGE_REGISTER_GLOBAL_FUNCTION(func) RegisterGlobalFunction(pgeFUNCTION(func, asCALL_CDECL))

#define PGE_REGISTER_TO_STRING(class) RegisterObjectMethod(#class, "string toString() const", asFUNCTION(String::from<class>), asCALL_CDECL_OBJLAST)

#define PGE_REGISTER_CONSTRUCTOR(class, ...) RegisterObjectBehaviour(#class, asBEHAVE_CONSTRUCT, idfk("f", &constructGen<class IHDFKATP(__VA_ARGS__)>, \
    asCALL_CDECL_OBJLAST).cstr(), asFUNCTION((constructGen<class IHDFKATP(__VA_ARGS__)>)), asCALL_CDECL_OBJLAST)
#define PGE_REGISTER_DESTRUCTOR(class) RegisterObjectBehaviour(#class, asBEHAVE_DESTRUCT, "void f()", asFUNCTION(destructGen<class>), asCALL_CDECL_OBJLAST)

#define PGE_REGISTER_CAST_AS_CTOR(FROM, TO) RegisterObjectBehaviour(#TO, asBEHAVE_CONSTRUCT, "void f(const " #FROM "&in)", asMETHOD(FROM, operator TO), asCALL_THISCALL)

#define PGE_REGISTER_GLOBAL_PROPERTY_N(name, var) RegisterGlobalProperty((getAsTypeName<decltype(var)>(true) + " " + name).cstr(), (void*)&var)
#define PGE_REGISTER_GLOBAL_PROPERTY(var) PGE_REGISTER_GLOBAL_PROPERTY_N(trimNamespaces(#var), var)

#endif // NATIVE_UTILS_H_INCLUDED
