#include "../NativeDefinitionRegistrar.h"

#include <deque>

#include "../ScriptManager.h"

class Memento {
    public:
        int startPos;
        // Whether the action was a deletion or a write.
        bool write;
        PGE::String content;
        // Whether the action was a deletion in addtion to a write, which need to be un-/redone together.
        bool linked;

        PGE::String execute(const PGE::String& txt, bool flip) const {
            if (write ^ flip) {
                return txt.substr(0, startPos) + txt.substr(startPos + content.length());
            } else {
                return txt.substr(0, startPos) + content + txt.substr(startPos);
            }
        }

        int getSize() const {
            return content.byteLength() + content.byteLength() * 2 + sizeof(Memento) + sizeof(PGE::String);
        }

        Memento(int startPos, PGE::String content, bool write, bool linked) {
            this->startPos = startPos;
            this->content = content;
            this->write = write;
            this->linked = linked;
        }
};

class MementoManager {
    private:
        std::deque<Memento> history;
        int position;
        int memSize;
        int maxMemSize;

        void removeBack() {
            memSize -= history.back().getSize();
            history.pop_back();
            if (position >= history.size()) {
                position = (int)history.size() - 1;
            }
        }

        void removeFront() {
            memSize -= history.front().getSize();
            history.pop_front();
            position--;
        }

    public:
        MementoManager(int mementoMaxMemSize) {
            maxMemSize = mementoMaxMemSize;
            position = -1;
            memSize = 0;
        }

        PGE::String execute(const PGE::String& txt, int& pos, bool undo) {
            if (undo) {
                if (position >= 0) {
                    PGE::String temp = history[position].execute(txt, false);
                    position--;
                    if (history[(long long)position + 1].linked) {
                        temp = history[position].execute(temp, false);
                        position--;
                    }
                    pos = 0; // TODO: Caret position setting.
                    return temp;
                } else {
                    return txt;
                }
            } else {
                if (position < (int)history.size() - 1) {
                    position++;
                    PGE::String temp = history[position].execute(txt, true);
                    if (history[position].linked) {
                        position++;
                        temp = history[position].execute(temp, true);
                    }
                    pos = 0;
                    return temp;
                } else {
                    return txt;
                }
            }
        }

        void clear() {
            history.clear();
            memSize = 0;
            position = -1;
        }

        void push(int startPos, const PGE::String& content, bool write, bool linked) {
            Memento m = Memento(startPos, content, write, linked);
            if (position < history.size() - 1) {
                while (position < history.size() - 1) { // Truncating to the current position.
                    removeBack();
                }
            }
            if (m.getSize() > maxMemSize) {
                clear();
            } else {
                memSize += m.getSize();
                while (memSize > maxMemSize) {
                    if (history.front().linked) {
                        removeFront();
                    }
                    removeFront();
                }
                history.push_back(m);
                position++;
            }
        }
};

static MementoManager* createMM(int mementoMaxMemSize) {
	return new MementoManager(mementoMaxMemSize);
}

static void destroyMM(MementoManager* mm) {
	delete mm;
}

static void registerMementoDefinitions(ScriptManager&, asIScriptEngine& engine, RefCounterManager&, const NativeDefinitionsHelpers&) {
	engine.RegisterObjectType("MementoManager", sizeof(MementoManager), asOBJ_REF | asOBJ_NOCOUNT);

	engine.RegisterObjectMethod("MementoManager", "string execute(const string&in txt, int&inout pos, bool undo)", asMETHOD(MementoManager, execute), asCALL_THISCALL);
	engine.RegisterObjectMethod("MementoManager", "void clear()", asMETHOD(MementoManager, clear), asCALL_THISCALL);
	engine.RegisterObjectMethod("MementoManager", "void push(int startPos, const string&in content, bool write, bool linked = false)", asMETHOD(MementoManager, push), asCALL_THISCALL);
	
	engine.SetDefaultNamespace("MementoManager");
	engine.RegisterGlobalFunction("MementoManager@ create(int maxMemSize)", asFUNCTION(createMM), asCALL_CDECL);
	engine.RegisterGlobalFunction("void destroy(MementoManager@ mm)", asFUNCTION(destroyMM), asCALL_CDECL);
}

static NativeDefinitionRegistrar _ { &registerMementoDefinitions };
