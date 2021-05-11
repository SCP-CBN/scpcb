#ifndef NATIVEDEFINITION_H_INCLUDED
#define NATIVEDEFINITION_H_INCLUDED

#include <angelscript.h>

class NativeDefinition {
    public:
        // Virtual so we can safely call delete on children.
        virtual ~NativeDefinition() = default;

    protected:
        template<class BASE, class DERIVED>
		void registerInheritance(const char* base, const char* derived);
        template<class BASE, class DERIVED>
        void registerInheritanceCount(const char* base, const char* derived);
        
        asIScriptEngine* engine;
};

#endif // NATIVEDEFINITION_H_INCLUDED
