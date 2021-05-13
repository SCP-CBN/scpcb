shared bool vectorIsInSquare(Vector2f vec, Vector2f tl, Vector2f br) { return (vec.x >= tl.x && vec.y >= tl.y && vec.x <= br.x && vec.y <= br.y); }

shared enum Alignment {
    Center = 0x0,
    Left = 0x1,
    Right = 0x2,
    Top = 0x4,
    Bottom = 0x8,
    Fill = 0x10,
    None = 0x20,
    Manual = 0x40
}

namespace Vector2d {
	bool inSquare(Vector2f vec, Vector2f tl, Vector2f br) { return (vec.x >= tl.x && vec.y >= tl.y && vec.x <= br.x && vec.y <= br.y); }
}
