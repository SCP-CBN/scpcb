#include "CachedArgument.h"

CachedArgument::CachedArgument(const PGE::String& nm, Type* t) {
    name = nm;
    type = t;
}

CachedArgument::Value::Value() {
    truthy = false;
    i32 = 0;
    u32 = 0;
    f = 0;
    d = 0;
    ptr = nullptr;
}
