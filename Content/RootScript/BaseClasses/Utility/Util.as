// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: RootScript/Utility/Util.as					//
// Source: https://github.com/juanjp600/scpcb/Content/			//
// Script File Author(s): Pyro-Fire					//
// Purpose:								//
//	- Player Manager						//
//									//
//									//
// -------------------------------------------------------------------- \\
// Documentation
//
//	SECTION 1. AngelMath
//		- Alignment : Alignment enumerator
//		- Util::FloatInterpolator : Number smoother
//
//	SECTION 2. AngelString
//		- Icon <class> : Abstractable Icon@ generator definition.
//		- Icon::Model : Icon@ which generates a texture from a model.
//
//	SECTION 3. AngelUI
//		- drawSquare : Draws a textured, colored Rectanglef.
//
//	SECTION 3. Icon Handler
//		- Util::Icon <class> : Abstractable Icon@ generator definition.
//		- Util::Icon::Model : Icon@ which generates a texture from a model.
//
//	SECTION 4. Hook
//		- Hook <namespace> : Create and destroy hooks
//		- Hook@ : call hooks, and add to hook.
//		Usage:
//			Hook::fetch(name).add(@Hook::Function);
//
//	SECTION 5. Timer
//		- Timer <namespace> : Create and destroy timed functions
//		- Timer@ : A repeating timer.
//		- TickTimer@ : A one-use timer.
//		Usage:
//			Timer::start(n_ticks_from_now, Timer::Function)
//			Timer::on(nth_tick, Timer::function)
//			Timer::repeat(every_nth_tick, Timer::Repeater(Timer@ tmr))
//			Timer@.stop();
//
//									//
// -------------------------------------------------------------------- \\
// Begin Script

namespace Util { shared funcdef void Function(); }


// #### SECTION 1. AngelMath ----

// # AngelMath ----
// Numeracy functions, definitions, libraries etc

shared enum Alignment {
    Center = 0x0,

    Left = 0x1,
    Right = 0x2,
    Top = 0x4,
    Bottom = 0x8,

    Forward = 0x10,
    Backward = 0x20,

    Fill = 0x10,
    Manual = 0x20,

    None = 0x40,
}



// # Util::FloatInterpolator@ ----
// Number smoother
namespace Util { shared class FloatInterpolator {
	private float prevValue = 0.f;
	private float currValue = 0.f;


	void update(float value) {prevValue = currValue;currValue = value;}

	float lerp(float interpolation) {return prevValue + (currValue - prevValue) * interpolation;}

} }


// #### SECTION 2.AngelString ----

// # AngelString ----
// String manipulation functions
namespace String {
	shared int findFirstChar(string&in str,string&in delim) { for(int i=0; i<str.length(); i++) { if(str[i]==delim) { return i; } } return -1; }
	shared string substr(string&in str, int&in start, int&in end) { string phrase=""; for(int i=start; i<=end; i++) { phrase+=str[i]; } return phrase; }
	shared array<string> explode(string&in str,string&in delim) {
		int f=findFirstChar(str,delim);
		if(f<0) { return {str};}
		array<string> words;
		string phrase=str;
		while(f>-1) {
			string w=phrase.substr(0,f);
			words.insertLast(w);
			phrase=substr(phrase,f+1,phrase.length());
			f=findFirstChar(phrase,delim);
			if(f<0) { words.insertLast(phrase); break; }
		}
		return words;
	}

	shared string implode(array<string>&in words, string&in delim) {
		return "todo";
	}
}


// #### SECTION 3. Icon Handler ----

namespace UI {
	shared void drawSquare(Rectanglef&in square, Color&in col=Color::White, Texture@&in tex=null, bool tileTexture=false) {
		if(@tex==null) { UI::setTextureless(); } else { UI::setTextured(tex,tileTexture); }
		UI::setColor(col);
		UI::addRect(square);
	}
}

// #### SECTION 4. Icon Handler ----

// # Util::Icon@ ----
// Generic texture icon
namespace Util { shared class Icon { Texture@ texture; Icon() {}; void generate() {}; } }

// # Util::Icon::Model@ ----
// IconModel
namespace Util { namespace Icon { shared class Model : Icon {
	string path;
	float scale;
	Vector3f rotation;
	Vector2f pos;
	string skin;
	Model(string&in iPath, float&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") { super();
		path=iPath; scale=iScale; pos=iPos; rotation=iRotation; skin=iSkin;
		generate();
	}
	void generate() { @texture = ModelImageGenerator::generate(path, scale, rotation, pos); } // , skin);
} } }



// #### SECTION 5. Hook ----

// # Hook:: ----
// Function call replicator.
namespace Hook {
	shared array<Hook@> hooks;
	shared Hook@ fetch(string&in name) {
		for(int i=0; i<hooks.length(); i++) { if(hooks[i].name==name) { return @hooks[i]; } }
		return null;
	}
	shared void destroy(Hook@&in h) { for(int i=0; i<hooks.length(); i++) { if(@hooks[i]==@h) { hooks.removeAt(i); return; } } }
}

// # Hook@ ----
// Replicator class for .call();
shared class Hook {
	Hook(string&in nm) { Hook::hooks.insertLast(@this); name=nm; }
	string name;
	array<Util::Function@> funcs;
	void add(Util::Function@&in func) { funcs.insertLast(@func); }
	void call() { for(int i=0; i<funcs.length(); i++) { funcs[i](); } }
	void remove(Util::Function@&in func) { for(int i=0; i<funcs.length(); i++) { if(@func==@funcs[i]) { funcs.removeAt(i); return; } } }
}

