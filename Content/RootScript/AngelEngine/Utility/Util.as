// -------------------------------------------------------------------- //
//									//
//			SCP : Containment Breach			//
//									//
// -------------------------------------------------------------------- //
// Script: RootScript/Utility/Util.as					//
// Source: https://github.com/juanjp600/scpcb/Content/			//
// Script File Author(s): Pyro-Fire					//
// Purpose:								//
//	- General purpose utilities					//
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

// # Util::Function@, TickFunction and RenderFunction, and noops ----
namespace Util {
	shared funcdef void Function();
	shared void noop() {}
	shared funcdef void TickFunction(uint32 tick, float interp);
	shared void noopTick(uint32 tick, float interp) {}
	shared funcdef void RenderFunction(float interp);
	shared void noopRender(float interp) {}
}

// #### SECTION 1. AngelMath ----

// # AngelMath ----
// Numeracy functions, definitions, libraries etc

namespace Util {
	shared float fpsFactor(float interp) { return Math::maxFloat(Math::minFloat(interp*70.f,5.f),0.2f); } // Original math
}

// # Util::Vector2f::rotate(vec,ang/Math::PI); ----
namespace Util { namespace Vector2f {
	shared Vector2f rotate(Vector2f&in vec, float&in angle) {
		float ang=((angle+Math::PI)%(Math::PI*2))-Math::PI; // Wraparound PI
		return Vector2f((vec.x*Math::cos(ang)) - (vec.y*Math::sin(ang)), (vec.x*Math::sin(ang)) + (vec.y*Math::cos(ang)));
	}
} }

// # Util::Vector3f::rotate(vec,ang/Math::PI); ----
namespace Util { namespace Vector3f {
	shared Vector3f rotate(Vector3f&in vec, float&in angle) {
		float ang=((angle+Math::PI)%(Math::PI*2))-Math::PI; // Wraparound PI
		return Vector3f((vec.x*Math::cos(ang)) - (vec.z*Math::sin(ang)), vec.y, (vec.x*Math::sin(ang)) + (vec.z*Math::cos(ang)));
	}
	shared Vector3f rotate(Vector3f&in vec, Vector3f&in angle) {
		float ang=((angle.y+Math::PI)%(Math::PI*2))-Math::PI; // Wraparound PI
		return Vector3f((vec.x*Math::cos(ang)) - (vec.z*Math::sin(ang)), vec.y, (vec.x*Math::sin(ang)) + (vec.z*Math::cos(ang)));
	}

	shared Vector3f localToWorldPos(Vector3f&in origin, Vector3f&in originAng, Vector3f&in localPos) { return localToWorldPos(origin,originAng.y,localPos); }
	shared Vector3f localToWorldPos(Vector3f&in origin, float&in originAng, Vector3f&in localPos) {
		return Vector3f();
	}
} }

// # Util::rotate(float ang, float rot); rotate by amount rotation.y/Math::PI ----
namespace Util {
	float rotate(float ang, float rot) {
		return (((ang+Math::PI*rot)%Math::PI*2)-Math::PI)/Math::PI;
	}
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

	shared class Glitch {
		string orig;
		string lastText;
		array<bool> locks;
		int lockCount;
		int duration;
		int tick;
		float strength;
		float speed;
		int nextTick;
		Random@ rnjesus;
		Glitch() {}
		Glitch(string&in gOrig,int gDuration=300,float gStrength=0.9, float gSpeed=0.5) { start(gOrig,gDuration,gStrength,gSpeed); }
		void start(string&in gOrig="test",int gDuration=300,float gStrength=0.9, float gSpeed=0.5) {
			orig=gOrig; duration=gDuration; strength=gStrength; speed=gSpeed; @rnjesus=Random(); tick=0; nextTick=1; lockCount=0;
			locks={}; for(int i=0; i<orig.length(); i++) { locks.insertLast(false); }
		}
		bool update(string&out txt) { tick++;
			if(tick>duration) { txt=orig; return true; }
			float elapsed=float(tick)/float(duration);
			float remaining=1-elapsed;
			if(tick<nextTick) { txt=lastText; return false; }
			nextTick=Math::floor(tick+(duration*(elapsed**4))**speed);
			string newStr="";
			bool shouldLock=(lockCount<( ((elapsed-0.25)*0.8)*orig.length() ));
			for(int i=0; i<orig.length(); i++) {
				float rng=rnjesus.nextFloat();
				if(locks[i]) { if(rnjesus.nextFloat()>Math::maxFloat(remaining,0.75)) { locks[i]=false; } }
				if(locks[i]) {  newStr+=orig[i]; }
				else if(rng<=(remaining+0.1)) { newStr+=orig[i]+(rnjesus.nextBool() ? 1 : -1)*rnjesus.nextInt(Math::floor(24*remaining*strength)); }
				else { newStr+=orig[i]; }
				if(shouldLock && !locks[i] && rnjesus.nextFloat()<elapsed) { lockCount++; locks[i]=true; }
			}
			txt=newStr;
			lastText=newStr;
			return false;
		}	
	}
}


// #### SECTION 3. Generic ----

namespace UI {
	shared void drawSquare(Rectanglef&in square, Color&in col=Color::White, Texture@&in tex=null, bool tileTexture=false) {
		if(@tex==null) { UI::setTextureless(); } else { UI::setTextured(tex,tileTexture); }
		UI::setColor(col);
		UI::addRect(square);
	}
}

// #### SECTION 4. Resource Handlers ----

// # Utility Icons ----
namespace Util {
	// Primary purpose is to store resource data without actually loading the resource.
	// Secondary purpose is to abstractify this resource data and generate instances of the resources without creating new copies.

	// # Util::Icon@ ----
	// Generic texture icon
	shared class Icon {
		string path;
		Texture@ texture;
		Icon() {};
		Icon(string&in texPath) { path=texPath; };
		Icon(Texture@&in tex) { @texture=@tex; }
		void generate() { @texture=@Texture::get(path); };
	}

	// # Util::Icon::Model@ ----
	// IconModel
	namespace Icon { shared class Model : Icon {
		float scale;
		Vector3f rotation;
		Vector2f pos;
		string skin;
		Model(string&in iPath, float&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") { super();
			path=iPath; scale=iScale; pos=iPos; rotation=iRotation; skin=iSkin;
		}
		Model(string&in iPath, Vector3f&in iScale, Vector3f&in iRotation, Vector2f&in iPos, string&in iSkin="") { super();
			path=iPath; scale=(iScale.x+iScale.y+iScale.z)/3; pos=iPos; rotation=iRotation; skin=iSkin;
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

