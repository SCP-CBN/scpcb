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
//		- GUI::Align : GUI::Align enumerator
//		- Util::FloatInterpolator : Number smoother
//
//	SECTION 2. AngelString
//		- Icon <class> : Abstractable Icon@ generator definition.
//		- Icon::Model : Icon@ which generates a texture from a model.
//
//	SECTION 3. AngelUI
//		- drawSquare : Draws a textured, colored Rectanglef.
//
//	SECTION 4. Icon Handler
//		- Util::Icon <class> : Abstractable Icon@ generator definition.
//		- Util::Icon::Model : Icon@ which generates a texture from a model.
//
//	SECTION 5. Hook
//		- Hook <namespace> : Create and destroy hooks
//		- Hook@ : call hooks, and add to hook.
//		Usage:
//			Hook::fetch(name).add(@Hook::Function);
//
//
//									//
// -------------------------------------------------------------------- \\
// Begin Script

namespace Util { shared funcdef void Function(); }


// #### SECTION 1. AngelMath ----

// # AngelMath ----
// Numeracy functions, definitions, libraries etc


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

// # Utility Icons ----
namespace Util {

	// # Util::Icon@ ----
	// Generic texture icon
	shared class Icon { Texture@ texture;
		Icon() {};
		Icon(string&in texPath) { @texture=Texture::get(texPath); };
		Icon(Texture@&in tex) { @texture=@tex; }
		void generate() {};
	}

	// # Util::Icon::Model@ ----
	// IconModel
	namespace Icon { shared class Model : Icon {
		string path;
		float scale;
		Vector3f rotation;
		Vector2f pos;
		string skin;
		Model(string&in iPath, float&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") { super();
			path=iPath; scale=iScale; pos=iPos; rotation=iRotation; skin=iSkin;
			//generate();
		}
		void generate() { @texture = ModelImageGenerator::generate(path, scale, rotation, pos); } // , skin);
	} }
}



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

