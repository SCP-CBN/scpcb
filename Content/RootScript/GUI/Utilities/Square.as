// # GUI::Square ----
// Rectangles, but for the gui system.

namespace GUI { // GUI namespace
shared class Square { // GUI::Square class

	// # Public properties
	Vector2f position;
	float x { get { return position.x; } set { position.x=value; } }
	float y { get { return position.y; } set { position.y=value; } }

	Vector2f size;
	float width { get { return size.x; } set { size.x=value; } }
	float height { get { return size.y; } set { size.y=value; } }
	float w { get { return size.x; } set { size.x=value; } }; // alias
	float h { get { return size.y; } set { size.y=value; } }; // alias

	// # Const derived properties
	Vector2f mins { get const { return position; } }
	Vector2f maxs { get const { return position+size; } }

	// # Constructors
	Square(const Square@&in other) { position=other.position; size=other.size; }
	Square(const float&in posX=0, const float&in posY=0, const float&in sizeX=0, const float&in sizeY=0) { position=Vector2f(posX,posY); size=Vector2f(sizeX,sizeY); }
	Square(const Vector2f&in pos, const Vector2f&in sz=Vector2f()) { position=pos; size=sz; }
	Square(const Vector2f&in pos, const float&in sizeX, const float&in sizeY) { position=pos; size=Vector2f(sizeX,sizeY); }
	Square(const float&in posX, const float&in posY, const Vector2f&in sz) { position=Vector2f(posX,posY); size=sz; }
	Square(const array<float>&in margins) { position=Vector2f(margins[0],margins[1]); size=Vector2f(margins[0]+margins[2],margins[1]+margins[3]); }

	// # Assignment
	Square@ opAssign(const Square@&in other) { position=other.position; size=other.size; return @this; }
	Square@ opAssign(const array<float>&in margins) { position=Vector2f(margins[0],margins[1]); size=Vector2f(margins[0]+margins[2],margins[1]+margins[3]); return @this; }

	// # Comparitors
	bool opEquals(const Square@&in other) { return (position==other.position && size==other.size); }
	bool contains(Square@&in other) { return ( x<=other.x&&y<=other.y && maxs.x>=other.maxs.x&&maxs.y>=other.maxs.y ); }
	bool contains(const Vector2f&in other) { return ( x<=other.x&&y<=other.y && maxs.x>=other.x&&maxs.y>=other.y ); }

	// # Translational/sliding functions that affect position
	Square@ opAddAssign(const Vector2f&in other) { x+=other.x; y+=other.y; return @this; }
	Square@ opSubAssign(const Vector2f&in other) { x-=other.x; y-=other.y; return @this; }
	Square opAdd(const Vector2f&in other) { return Square(x+other.x,y+other.y,w,h); }
	Square opSub(const Vector2f&in other) { return Square(x-other.x,y-other.y,w,h); }
	Square opAdd_r(const Vector2f&in other) { return Square(x+other.x,y+other.y,w,h); }
	Square opSub_r(const Vector2f&in other) { return Square(x-other.x,y-other.y,w,h); }

	// # Resizing functions
	Square@ opMulAssign(const Vector2f&in other) { w+=other.x; h+other.y; return @this; }
	Square@ opDivAssign(const Vector2f&in other) { w-=other.x; h-=other.y; return @this; }
	Square opMul(const Vector2f&in other) { return Square(x,y,w+other.x,h+other.y); }
	Square opDiv(const Vector2f&in other) { return Square(x,y,w-other.x,h-other.y); }
	Square opMul_r(const Vector2f&in other) { return Square(x,y,w+other.x,h+other.y); }
	Square opDiv_r(const Vector2f&in other) { return Square(x,y,w-other.x,h-other.y); }

	// # Margin functions
	Square@ opAddAssign(const array<float>&in margins) { x+=margins[0]; y+=margins[2]; w+=margins[0]+margins[3]; h+=margins[1]+margins[3]; return @this; }
	Square@ opSubAssign(const array<float>&in margins) { x-=margins[0]; y-=margins[2]; w-=margins[0]+margins[3]; h-=margins[1]+margins[3]; return @this; }
	Square opAdd(const array<float>&in margins) { return Square(x+(margins[0]), y+(margins[1]), w+(margins[0]+margins[2]), h+(margins[1]+margins[3])); }
	Square opSub(const array<float>&in margins) { return Square(x-(margins[0]), y-(margins[1]), w-(margins[0]+margins[2]), h-(margins[1]+margins[3])); }
	Square opAdd_r(const array<float>&in margins) { return Square(x+(margins[0]), y+(margins[1]), w+(margins[0]+margins[2]), h+(margins[1]+margins[3])); }
	Square opSub_r(const array<float>&in margins) { return Square(x-(margins[0]), y-(margins[1]), w-(margins[0]+margins[2]), h-(margins[1]+margins[3])); }

	// # Relational functions typically for margins.
	Square@ opAddAssign(Square@&in other) { x-=other.x; y-=other.y; w+=other.w; h+=other.h; return @this; }
	Square@ opSubAssign(Square@&in other) { x+=other.x; y+=other.y; w-=other.w; h-=other.h; return @this; }
	Square opAdd(Square@&in other) { return Square(x-other.x, y-other.y, w+other.w, h+other.h); }
	Square opSub(Square@&in other) { return Square(x+other.x, y+other.y, w-other.w, h-other.h); }
	Square opAdd_r(Square@&in other) { return Square(x-other.x, y-other.y, w+other.w, h+other.h); }
	Square opSub_r(Square@&in other) { return Square(x+other.x, y+other.y, w-other.w, h-other.h); }

	// # Absolute functions typically for resizing and scaling.
	Square@ opAddAssign(const float&in other) { x+=other; y+=other; w+=other; h+=other; return @this; }
	Square@ opSubAssign(const float&in other) { x-=other; y-=other; w-=other; h-=other; return @this; }
	Square opAdd(const float&in other) { return Square(x+other, y+other, w+other, h+other); }
	Square opSub(const float&in other) { return Square(x-other, y-other, w-other, h-other); }
	Square opAdd_r(const float&in other) { return Square(x+other, y+other, w+other, h+other); }
	Square opSub_r(const float&in other) { return Square(x-other, y-other, w-other, h-other); }
	Square opMul(const float&in other) { return Square(x*other, y*other, w*other,h*other); }
	Square opDiv(const float&in other) { return Square(x/other, y/other, w/other, h/other); }
	Square opMul_r(const float&in other) { return Square(x*other, y*other, w*other, h*other); }
	Square opDiv_r(const float&in other) { return Square(x/other ,y/other, w/other, h/other); }

	// # toString
	const string toString() { return "GUI::Square(x " + ::toString(x) + ", y " + ::toString(y) + ", w " + ::toString(width) + ", h " + ::toString(height) + ")"; }

	// # Call to get a paintable rectangle out of the square
	Rectanglef opCall() { return Rectanglef(mins-GUI::center,maxs-GUI::center); }

} // close GUI::Square class
} // close GUI namespace