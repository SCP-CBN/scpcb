#ifndef NATIVE_UTILS_H_INCLUDED
#define NATIVE_UTILS_H_INCLUDED

#include <angelscript.h>

#include <PGE/String/String.h>

template <typename T, typename... Args>
static void constructGen(Args... args, void* memory) {
    new (memory) T(args...);
}

template <typename T>
static void destructGen(void* memory) {
    ((T*)memory)->~T();
}

template <typename T>
const PGE::String getTypeName() {
    // I will demangle other compilers if necessary
    // Why is this shit not standardized
    PGE::String name = typeid(T).name();
    PGE::String::ReverseIterator it = name.findLast(":");
    return name.substr(it != name.rend() ? String::Iterator(--it) : name.begin());
}

template <typename T>
const PGE::String getAsTypeName(bool isReturn = false) {
    String ret;
    bool isConst = std::is_const<std::remove_reference<T>::type>::value;
    if (isConst) { ret += "const "; }
    ret += getTypeName<std::remove_cvref<T>::type>();
    if (std::is_reference<T>::value) {
        ret += "&";
        if (!isReturn) {
            ret += isConst ? "in" : "out";
        }
    }
    return ret;
}

template <typename T, typename... Args>
const PGE::String idfk(const PGE::String& name, T(*fu)(Args...), asECallConvTypes callConv) {
    String ret = getAsTypeName<T>(true) + " " + name + "(";
    if constexpr (sizeof...(Args) > 0) {
        std::vector<String> strings; strings.reserve(sizeof...(Args));
        (strings.push_back(getAsTypeName<Args>()), ...);
        switch (callConv) {
            case asCALL_CDECL_OBJLAST: {
                strings.pop_back();
            } break;
            case asCALL_CDECL_OBJFIRST: {
                strings.erase(strings.begin());
            }
        }
        ret += String::join(strings, ", ");
    }
    return ret + ")";
}

template <typename T, typename M, typename... Args>
concept ConstInvokable = requires(const T& t, M m, Args&&... args) {
    (t.*m)(std::forward<Args>(args)...);
};

template <size_t I, typename... Args>
struct AtIndex {
    using Type = decltype(std::get<I>(std::tuple<Args...>()));
};

template <typename... Args>
static const PGE::String funcToAsFuncName(const PGE::String& cppName) {
    //using StringLiterals; // TODO: ???

    static const String OPERATOR = "operator";
    if (cppName.substr(0, std::min(OPERATOR.length(), cppName.length())) != OPERATOR) {
        return cppName;
    }

    constexpr auto prependPostPre = [](const String& op) constexpr {
        return String("op") + (sizeof...(Args) == 0 ? "Pre" : "Post") + op;
    };

    String suffix = cppName.substr(OPERATOR.length());
    // Reference: https://www.angelcode.com/angelscript/sdk/docs/manual/doc_script_class_ops.html
    if (suffix == "-") {
        return sizeof...(Args) == 0 ? "opNeg" : "opSub";
    // Unary
    } else if (suffix == "~") {
        return "opCom";
    } else if (suffix == "++") {
        return prependPostPre("Inc");
    } else if (suffix == "--") {
        return prependPostPre("Dec");
    // Comparison
    } else if (suffix == "==") {
        return "opEquals";
    } else if (suffix == "<=>") {
        return "opCmp"; // I didn't test this, I genuinely don't know
    // Assignment
    } else if (suffix == "=") {
        return "opAssign";
    } else if (suffix == "+=") {
        return "opAddAssign";
    } else if (suffix == "-=") {
        return "opSubAssign";
    } else if (suffix == "*=") {
        return "opMulAssign";
    } else if (suffix == "/=") {
        return "opDivAssign";
    } else if (suffix == "%=") {
        return "opModAssign";
    } else if (suffix == "&=") {
        return "opAndAssign";
    } else if (suffix == "|=") {
        return "opOrAssign";
    } else if (suffix == "^=") {
        return "opXorAssign";
    } else if (suffix == "<<=") {
        return "opShlAssign";
    } else if (suffix == ">>=") {
        return "opShrAssign";
    // Binary
    } else if (suffix == "+") {
        return "opAdd";
    } else if (suffix == "*") {
        return "opMul";
    } else if (suffix == "/") {
        return "opDiv";
    } else if (suffix == "%") {
        return "opMod";
    } else if (suffix == "&") {
        return "opAnd";
    } else if (suffix == "|") {
        return "opOr";
    } else if (suffix == "^") {
        return "opXor";
    } else if (suffix == "<<") {
        return "opShl";
    } else if (suffix == ">>") {
        return "opShr";
    // Index
    } else if (suffix == "[]") {
        return "opIndex";
    // Functor
    } else if (suffix == "()") {
        return "opCall";
    } else {
        throw Exception("Invalid operator");
    }
    // TODO: Casting support
}

template <bool isConst, typename Class, typename T, typename... Args>
const PGE::String idfkProper(const PGE::String& name, bool opReversed) {
    String ret = getAsTypeName<T>(true) + " " + funcToAsFuncName<Args...>(name) + (opReversed ? "_r" : "") + "(";
    if constexpr (sizeof...(Args) > 0) {
        std::vector<String> strings; strings.reserve(sizeof...(Args));
        (strings.push_back(getAsTypeName<Args>()), ...);
        ret += String::join(strings, ", ");
    }
    ret += ")";
    if constexpr (isConst) {
        ret += " const";
    }
    return ret;
}

template <typename Class, typename T, typename... Args>
const PGE::String idfkMethod(const PGE::String& name, T(Class::*)(Args...) const, bool isReversed = false) {
    return idfkProper<true, Class, T, Args...>(name, isReversed);
}

template <typename Class, typename T, typename... Args>
const PGE::String idfkMethod(const PGE::String& name, T(Class::*)(Args...), bool isReversed = false) {
    return idfkProper<false, Class, T, Args...>(name, isReversed);
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

#define PGE_REGISTER_TYPE(class, ...) RegisterObjectType(#class, sizeof(class), asOBJ_VALUE | asGetTypeTraits<PGE::Vector2f>() __VA_OPT__(|) __VA_ARGS__)

#define pgeOFFSET(class, property) (getAsTypeName<decltype(class::property)>() + " " #property).cstr(), asOFFSET(class, property)
#define PGE_REGISTER_PROPERTY(class, property) RegisterObjectProperty(#class, pgeOFFSET(class, property))

#define DEBRACE(...) __VA_ARGS__

#define IDFK(...) __VA_OPT__(,) __VA_ARGS__

#define PGE_REGISTER_METHOD_IMPL(class, func, reversedOp) RegisterObjectMethod(#class, idfkMethod<class>(#func, &class::func, reversedOp).cstr(), asMETHOD(class, func), asCALL_THISCALL)
#define PGE_REGISTER_METHOD(class, func) PGE_REGISTER_METHOD_IMPL(class, func, false)
#define PGE_REGISTER_METHOD_R(class, func) PGE_REGISTER_METHOD_IMPL(class, func, true)

#define PGE_REGISTER_METHOD_EX_IMPL(class, ret, func, args, reversedOp) RegisterObjectMethod(#class, idfkMethod<class, ret IDFK(DEBRACE args)>(#func, &class::func, reversedOp).cstr(), \
    asSMethodPtr<sizeof(void(class::*)())>::template Convert(ptrDeduceConst<class, ret IDFK(DEBRACE args)>(&class::func)), asCALL_THISCALL)
#define PGE_REGISTER_METHOD_EX(class, ret, func, args) PGE_REGISTER_METHOD_EX_IMPL(class, ret, func, args, false)
#define PGE_REGISTER_METHOD_EX_R(class, ret, func, args) PGE_REGISTER_METHOD_EX_IMPL(class, ret, func, args, true)


#define PGE_REGISTER_TO_STRING(class) RegisterObjectMethod(#class, "string toString() const", asFUNCTION(String::from<class>), asCALL_CDECL_OBJLAST)

#define PGE_REGISTER_CONSTRUCTOR(class, ...) RegisterObjectBehaviour(#class, asBEHAVE_CONSTRUCT, idfk("f", &constructGen<class __VA_OPT__(, DEBRACE __VA_ARGS__)>, \
    asCALL_CDECL_OBJLAST).cstr(), asFUNCTION((constructGen<class __VA_OPT__(, DEBRACE __VA_ARGS__)>)), asCALL_CDECL_OBJLAST)
#define PGE_REGISTER_DESTRUCTOR(class) RegisterObjectBehaviour(#class, asBEHAVE_DESTRUCT, "void f()", asFUNCTION(destructGen<class>), asCALL_CDECL_OBJLAST)


#endif // NATIVE_UTILS_H_INCLUDED
