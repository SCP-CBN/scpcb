// # HUD (namespace) ----
namespace HUD {

}


// # HUD::Skin (namespace) ----
namespace HUD { namespace Skin {
	Texture@ iconBlink;
	Texture@ barBlinkTex;
	Color barBlinkColor=Color::White;
	Texture@ iconSprint;
	Texture@ barSprintTex;
	Color barSprintColor=Color::Black;

} }
// # HUD::Frame@ ----

namespace HUD { class Frame : GUI {
	Frame(string vcls="HUD") { super(vcls);

	}


} }