
shared class Vector2d { // : Vector2f
	float x=0;
	float y=0;
	Vector2d(Vector2f vec) { this.x=vec.x; this.y=vec.y; }
	Vector2d(Vector2d vec) { this.x=vec.x; this.y=vec.y; }
	Vector2d(float x=0, float y=0) { this.x=x; this.y=y; }

	Vector2f opCall() { return Vector2f(x,y); }

	float get_opIndex(int idx) const { return ( idx==0 ? x : y ); }
	void set_opIndex(int idx, float value) { if(idx==0) { x=value; } else { y=value; } }

	Vector2d opNeg() { return Vector2d(-x,-y); }
	Vector2d@ opCom() { return @this; } // What does this even do?

	Vector2d@ opPreInc() { return @this; }
	Vector2d@ opPostInc() { return this.opAddAssign(1); }
	Vector2d@ opPreDec() { return @this; }
	Vector2d@ opPostDec() { return this.opSubAssign(1); }

	bool opEquals(const Vector2d@&in other) { return (x==other.x && y==other.y); }
	// int opCmp(const Vector2d@&in other) { return (x**2+y**2); } // unused - do distances manually. 

	// # Vector2d op Vector2d {

	Vector2d@ opAssign(const Vector2d@&in other) { x=other.x; y=other.y; return @this; }
	Vector2d@ opAddAssign(const Vector2d@&in other) { x+=other.x; y+=other.y; return @this; }
	Vector2d@ opSubAssign(const Vector2d@&in other) { x-=other.x; y-=other.y; return @this; }
	Vector2d@ opMulAssign(const Vector2d@&in other) { x*=other.x; y*=other.y; return @this; }
	Vector2d@ opDivAssign(const Vector2d@&in other) { x/=other.x; y/=other.y; return @this; }
	Vector2d@ opModAssign(const Vector2d@&in other) { x%=other.x; y%=other.y; return @this; }
	Vector2d@ opPowAssign(const Vector2d@&in other) { x**=other.x; y**=other.y; return @this; }
	//Vector2d@ opAndAssign(const Vector2d@&in other) { x&=other.x; y&=other.y; return @this; }
	//Vector2d@ opOrAssign(const Vector2d@&in other) { x|=other.x; y|=other.y; return @this; }
	//Vector2d@ opXorAssign(const Vector2d@&in other) { x^=other.x; y^=other.y; return @this; }
	//Vector2d@ opShlAssign(const Vector2d@&in other) { x<<=other.x; y<<=other.y; return @this; }
	//Vector2d@ opShrAssign(const Vector2d@&in other) { x>>=other.x; y>>=other.y; return @this; }
	//Vector2d@ opUShrAssign(const Vector2d@&in other) { x>>>=other.x; y>>>=other.y; return @this; }

	Vector2d opAdd(const Vector2d@&in other) { return Vector2d(x+other.x,y+other.y); }
	Vector2d opSub(const Vector2d@&in other) { return Vector2d(x-other.x,y-other.y); }
	Vector2d opMul(const Vector2d@&in other) { return Vector2d(x*other.x,y*other.y); }
	Vector2d opDiv(const Vector2d@&in other) { return Vector2d(x/other.x,y/other.y); }
	Vector2d opMod(const Vector2d@&in other) { return Vector2d(x%other.x,y%other.y); }
	Vector2d opPow(const Vector2d@&in other) { return Vector2d(x**other.x,y**other.y); }
	//Vector2d opAnd(const Vector2d@&in other) { return Vector2d(x&other.x,y&other.y); }
	//Vector2d opOr(const Vector2d@&in other) { return Vector2d(x|other.x,y|other.y); }
	//Vector2d opXor(const Vector2d@&in other) { return Vector2d(x^other.x,y^other.y); }
	//Vector2d opShl(const Vector2d@&in other) { return Vector2d(x<<other.x,y<<other.y); }
	//Vector2d opShr(const Vector2d@&in other) { return Vector2d(x>>other.x,y>>other.y); }
	//Vector2d opUShr(const Vector2d@&in other) { return Vector2d(x>>>other.x,y>>>other.y); }

	Vector2d opAdd_r(const Vector2d@&in other) { return Vector2d(x+other.x,y+other.y); }
	Vector2d opSub_r(const Vector2d@&in other) { return Vector2d(x-other.x,y-other.y); }
	Vector2d opMul_r(const Vector2d@&in other) { return Vector2d(x*other.x,y*other.y); }
	Vector2d opDiv_r(const Vector2d@&in other) { return Vector2d(x/other.x,y/other.y); }
	Vector2d opMod_r(const Vector2d@&in other) { return Vector2d(x%other.x,y%other.y); }
	Vector2d opPow_r(const Vector2d@&in other) { return Vector2d(x**other.x,y**other.y); }
	//Vector2d opAnd_r(const Vector2d@&in other) { return Vector2d(x&other.x,y&other.y); }
	//Vector2d opOr_r(const Vector2d@&in other) { return Vector2d(x|other.x,y|other.y); }
	//Vector2d opXor_r(const Vector2d@&in other) { return Vector2d(x^other.x,y^other.y); }
	//Vector2d opShl_r(const Vector2d@&in other) { return Vector2d(x<<other.x,y<<other.y); }
	//Vector2d opShr_r(const Vector2d@&in other) { return Vector2d(x>>other.x,y>>other.y); }
	//Vector2d opUShr_r(const Vector2d@&in other) { return Vector2d(x>>>other.x,y>>>other.y); }

	// # Vector2d op float {

	Vector2d@ opAssign(const float other) { x=other; y=other; return @this; }
	Vector2d@ opAddAssign(const float other) { x+=other; y+=other; return @this; }
	Vector2d@ opSubAssign(const float other) { x-=other; y-=other; return @this; }
	Vector2d@ opMulAssign(const float other) { x*=other; y*=other; return @this; }
	Vector2d@ opDivAssign(const float other) { x/=other; y/=other; return @this; }
	Vector2d@ opModAssign(const float other) { x%=other; y%=other; return @this; }
	Vector2d@ opPowAssign(const float other) { x**=other; y**=other; return @this; }

	Vector2d opAdd(const float other) { return Vector2d(x+other,y+other); }
	Vector2d opSub(const float other) { return Vector2d(x-other,y-other); }
	Vector2d opMul(const float other) { return Vector2d(x*other,y*other); }
	Vector2d opDiv(const float other) { return Vector2d(x/other,y/other); }
	Vector2d opMod(const float other) { return Vector2d(x%other,y%other); }
	Vector2d opPow(const float other) { return Vector2d(x**other,y**other); }

	Vector2d opAdd_r(const float other) { return Vector2d(x+other,y+other); }
	Vector2d opSub_r(const float other) { return Vector2d(x-other,y-other); }
	Vector2d opMul_r(const float other) { return Vector2d(x*other,y*other); }
	Vector2d opDiv_r(const float other) { return Vector2d(x/other,y/other); }
	Vector2d opMod_r(const float other) { return Vector2d(x%other,y%other); }
	Vector2d opPow_r(const float other) { return Vector2d(x**other,y**other); }

	// # Vector2d op int {

	Vector2d@ opAssign(const int other) { x=other; y=other; return @this; }
	Vector2d@ opAddAssign(const int other) { x+=other; y+=other; return @this; }
	Vector2d@ opSubAssign(const int other) { x-=other; y-=other; return @this; }
	Vector2d@ opMulAssign(const int other) { x*=other; y*=other; return @this; }
	Vector2d@ opDivAssign(const int other) { x/=other; y/=other; return @this; }
	Vector2d@ opModAssign(const int other) { x%=other; y%=other; return @this; }
	Vector2d@ opPowAssign(const int other) { x**=other; y**=other; return @this; }

	Vector2d opAdd(const int other) { return Vector2d(x+other,y+other); }
	Vector2d opSub(const int other) { return Vector2d(x-other,y-other); }
	Vector2d opMul(const int other) { return Vector2d(x*other,y*other); }
	Vector2d opDiv(const int other) { return Vector2d(x/other,y/other); }
	Vector2d opMod(const int other) { return Vector2d(x%other,y%other); }
	Vector2d opPow(const int other) { return Vector2d(x**other,y**other); }

	Vector2d opAdd_r(const int other) { return Vector2d(x+other,y+other); }
	Vector2d opSub_r(const int other) { return Vector2d(x-other,y-other); }
	Vector2d opMul_r(const int other) { return Vector2d(x*other,y*other); }
	Vector2d opDiv_r(const int other) { return Vector2d(x/other,y/other); }
	Vector2d opMod_r(const int other) { return Vector2d(x%other,y%other); }
	Vector2d opPow_r(const int other) { return Vector2d(x**other,y**other); }

	string toString() { return "Vector2d(" + ::toString(x) + ", " + ::toString(y) + ")"; }

	// # Vector2d Library Functions {

	bool within(Vector2d@&in tl, Vector2d@&in br) { return (x>=tl.x && y>=tl.y && x<=br.x && y<=br.y); }
}


shared class Vector3d { // : Vector3f
	float x=0;
	float y=0;
	float z=0;
	Vector3d(Vector3f vec) { this.x=vec.x; this.y=vec.y; this.z=vec.z; }
	Vector3d(Vector3d vec) { this.x=vec.x; this.y=vec.y; this.z=vec.z; }
	Vector3d(float x=0, float y=0, float z=0) { this.x=x; this.y=y; this.z=z; }

	Vector3f opCall() { return Vector3f(x,y,z); }

	float get_opIndex(int idx) const { return ( idx==0 ? x : (idx==1 ? y : z) ); }
	void set_opIndex(int idx, float value) { if(idx==0) { x=value; } else if(idx==1) { y=value; } else { z=value; } }

	Vector3d opNeg() { return Vector3d(-x,-y,-z); }
	Vector3d@ opCom() { return @this; } // What does this even do?

	Vector3d@ opPreInc() { return @this; }
	Vector3d@ opPostInc() { return this.opAddAssign(1); }
	Vector3d@ opPreDec() { return @this; }
	Vector3d@ opPostDec() { return this.opSubAssign(1); }

	bool opEquals(const Vector2d@&in other) { return (x==other.x && y==other.y); }
	// int opCmp(const Vector2d@&in other) { return (x**2+y**2); } // unused - do distances manually. 

	// # Vector3d op Vector3d {

	Vector3d@ opAssign(const Vector3d@&in other) { x=other.x; y=other.y; z=other.z; return @this; }
	Vector3d@ opAddAssign(const Vector3d@&in other) { x+=other.x; y+=other.y; z+=other.z; return @this; }
	Vector3d@ opSubAssign(const Vector3d@&in other) { x-=other.x; y-=other.y; z-=other.z; return @this; }
	Vector3d@ opMulAssign(const Vector3d@&in other) { x*=other.x; y*=other.y; z*=other.z; return @this; }
	Vector3d@ opDivAssign(const Vector3d@&in other) { x/=other.x; y/=other.y; z/=other.z; return @this; }
	Vector3d@ opModAssign(const Vector3d@&in other) { x%=other.x; y%=other.y; z%=other.z; return @this; }
	Vector3d@ opPowAssign(const Vector3d@&in other) { x**=other.x; y**=other.y; z**=other.z; return @this; }
	//Vector3d@ opAndAssign(const Vector3d@&in other) { x&=other.x; y&=other.y; z&=other.z; return @this; }
	//Vector3d@ opOrAssign(const Vector3d@&in other) { x|=other.x; y|=other.y; z|=other.z; return @this; }
	//Vector3d@ opXorAssign(const Vector3d@&in other) { x^=other.x; y^=other.y; z^=other.z; return @this; }
	//Vector3d@ opShlAssign(const Vector3d@&in other) { x<<=other.x; y<<=other.y; z<<=other.z; return @this; }
	//Vector3d@ opShrAssign(const Vector3d@&in other) { x>>=other.x; y>>=other.y; z>>=other.z; return @this; }
	//Vector3d@ opUShrAssign(const Vector3d@&in other) { x>>>=other.x; y>>>=other.y; z>>>=other.z; return @this; }

	Vector3d opAdd(const Vector3d@&in other) { return Vector3d(x+other.x,y+other.y,z+other.z); }
	Vector3d opSub(const Vector3d@&in other) { return Vector3d(x-other.x,y-other.y,z+other.z); }
	Vector3d opMul(const Vector3d@&in other) { return Vector3d(x*other.x,y*other.y,z+other.z); }
	Vector3d opDiv(const Vector3d@&in other) { return Vector3d(x/other.x,y/other.y,z+other.z); }
	Vector3d opMod(const Vector3d@&in other) { return Vector3d(x%other.x,y%other.y,z+other.z); }
	Vector3d opPow(const Vector3d@&in other) { return Vector3d(x**other.x,y**other.y,z+other.z); }
	//Vector3d opAnd(const Vector3d@&in other) { return Vector3d(x&other.x,y&other.y,z+other.z); }
	//Vector3d opOr(const Vector3d@&in other) { return Vector3d(x|other.x,y|other.y,z+other.z); }
	//Vector3d opXor(const Vector3d@&in other) { return Vector3d(x^other.x,y^other.y,z+other.z); }
	//Vector3d opShl(const Vector3d@&in other) { return Vector3d(x<<other.x,y<<other.y,z+other.z); }
	//Vector3d opShr(const Vector3d@&in other) { return Vector3d(x>>other.x,y>>other.y,z+other.z); }
	//Vector3d opUShr(const Vector3d@&in other) { return Vector3d(x>>>other.x,y>>>other.y,z+other.z); }

	Vector3d opAdd_r(const Vector3d@&in other) { return Vector3d(x+other.x,y+other.y,z+other.z); }
	Vector3d opSub_r(const Vector3d@&in other) { return Vector3d(x-other.x,y-other.y,z-other.z); }
	Vector3d opMul_r(const Vector3d@&in other) { return Vector3d(x*other.x,y*other.y,z*other.z); }
	Vector3d opDiv_r(const Vector3d@&in other) { return Vector3d(x/other.x,y/other.y,z/other.z); }
	Vector3d opMod_r(const Vector3d@&in other) { return Vector3d(x%other.x,y%other.y,z%other.z); }
	Vector3d opPow_r(const Vector3d@&in other) { return Vector3d(x**other.x,y**other.y,z**other.z); }
	//Vector3d opAnd_r(const Vector3d@&in other) { return Vector3d(x&other.x,y&other.y,z&other.z); }
	//Vector3d opOr_r(const Vector3d@&in other) { return Vector3d(x|other.x,y|other.y,z|other.z); }
	//Vector3d opXor_r(const Vector3d@&in other) { return Vector3d(x^other.x,y^other.y,z^other.z); }
	//Vector3d opShl_r(const Vector3d@&in other) { return Vector3d(x<<other.x,y<<other.y,z<<other.z); }
	//Vector3d opShr_r(const Vector3d@&in other) { return Vector3d(x>>other.x,y>>other.y,z>>other.z); }
	//Vector3d opUShr_r(const Vector3d@&in other) { return Vector3d(x>>>other.x,y>>>other.y,z>>>other.z); }

	// # Vector3d op float {

	Vector3d@ opAssign(const float other) { x=other; y=other; z=other; return @this; }
	Vector3d@ opAddAssign(const float other) { x+=other; y+=other; z+=other; return @this; }
	Vector3d@ opSubAssign(const float other) { x-=other; y-=other; z-=other; return @this; }
	Vector3d@ opMulAssign(const float other) { x*=other; y*=other; z*=other; return @this; }
	Vector3d@ opDivAssign(const float other) { x/=other; y/=other; z/=other; return @this; }
	Vector3d@ opModAssign(const float other) { x%=other; y%=other; z%=other; return @this; }
	Vector3d@ opPowAssign(const float other) { x**=other; y**=other; z**=other; return @this; }

	Vector3d opAdd(const float other) { return Vector3d(x+other,y+other,z+other); }
	Vector3d opSub(const float other) { return Vector3d(x-other,y-other,z-other); }
	Vector3d opMul(const float other) { return Vector3d(x*other,y*other,z*other); }
	Vector3d opDiv(const float other) { return Vector3d(x/other,y/other,z/other); }
	Vector3d opMod(const float other) { return Vector3d(x%other,y%other,z%other); }
	Vector3d opPow(const float other) { return Vector3d(x**other,y**other,z**other); }

	Vector3d opAdd_r(const float other) { return Vector3d(x+other,y+other,z+other); }
	Vector3d opSub_r(const float other) { return Vector3d(x-other,y-other,z-other); }
	Vector3d opMul_r(const float other) { return Vector3d(x*other,y*other,z*other); }
	Vector3d opDiv_r(const float other) { return Vector3d(x/other,y/other,z/other); }
	Vector3d opMod_r(const float other) { return Vector3d(x%other,y%other,z%other); }
	Vector3d opPow_r(const float other) { return Vector3d(x**other,y**other,z**other); }

	// # Vector3d op int {

	Vector3d@ opAssign(const int other) { x=other; y=other; z=other; return @this; }
	Vector3d@ opAddAssign(const int other) { x+=other; y+=other; z+=other; return @this; }
	Vector3d@ opSubAssign(const int other) { x-=other; y-=other; z-=other; return @this; }
	Vector3d@ opMulAssign(const int other) { x*=other; y*=other; z*=other; return @this; }
	Vector3d@ opDivAssign(const int other) { x/=other; y/=other; z/=other; return @this; }
	Vector3d@ opModAssign(const int other) { x%=other; y%=other; z%=other; return @this; }
	Vector3d@ opPowAssign(const int other) { x**=other; y**=other; z**=other; return @this; }

	Vector3d opAdd(const int other) { return Vector3d(x+other,y+other,z+other); }
	Vector3d opSub(const int other) { return Vector3d(x-other,y-other,z-other); }
	Vector3d opMul(const int other) { return Vector3d(x*other,y*other,z*other); }
	Vector3d opDiv(const int other) { return Vector3d(x/other,y/other,z/other); }
	Vector3d opMod(const int other) { return Vector3d(x%other,y%other,z%other); }
	Vector3d opPow(const int other) { return Vector3d(x**other,y**other,z**other); }

	Vector3d opAdd_r(const int other) { return Vector3d(x+other,y+other,z+other); }
	Vector3d opSub_r(const int other) { return Vector3d(x-other,y-other,z-other); }
	Vector3d opMul_r(const int other) { return Vector3d(x*other,y*other,z*other); }
	Vector3d opDiv_r(const int other) { return Vector3d(x/other,y/other,z/other); }
	Vector3d opMod_r(const int other) { return Vector3d(x%other,y%other,z%other); }
	Vector3d opPow_r(const int other) { return Vector3d(x**other,y**other,z**other); }

	string toString() { return "Vector3d(" + ::toString(x) + ", " + ::toString(y) + ", " + ::toString(z) + ")"; }

	// # Vector3d Library Functions {


}


shared class Vector4d { // : Vector4f
	// # Vector4d op Vector3d {
	// # Vector4d op float {
	// void opCall() {}
	// # Vector4d Library Functions {
}


shared class Square { // : Rectanglef
}

shared class Angle {
}