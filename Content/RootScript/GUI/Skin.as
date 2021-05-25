// # GUI::Skin ----
// Textures, colors, fonts and whathaveyou.

namespace GUI { // GUI namespace
namespace Skin { // GUI::Skin namespace
	shared Texture@ menublack = Texture::get(rootDirGFXMenu + "menublack");
	shared Texture@ menuwhite = Texture::get(rootDirGFXMenu + "menuwhite");
	shared Texture@ menuMain = Texture::get(rootDirGFXMenu + "back");
	shared Texture@ menuPause = Texture::get(rootDirGFXMenu + "pausemenu");
	shared Texture@ menuSCPLabel = Texture::get(rootDirGFXMenu + "scptext");
	shared Texture@ menuSCP173 = Texture::get(rootDirGFXMenu + "173back");

	namespace Button {
		shared Texture@ fgTexture = Texture::get(rootDirGFXMenu + "menublack");
		shared Texture@ bgTexture = Texture::get(rootDirGFXMenu + "menuwhite");
		shared const Color hoverColor = Color(70, 70, 150);
		shared const Color downColor = Color(100, 100, 175);
		shared const Color lockedColor = Color(100,100,100);
		shared const Color whiteColor = Color::White;
		shared const array<float> fgMargin = {1,1,1,1};
		shared const array<float> labelMargin = {0.5,0.5,0.5,0.5};

		shared ::Font@ font = Font::large;
		shared const Color fontColor = Color::White;
		shared const float fontScale = 0.2;
	}

	namespace Label {
		shared ::Font@ font = Font::large;
		shared const Color fontColor = Color::White;
		shared const float fontScale = 0.2;
	}

	namespace ScrollBar {
		shared Texture@ btmArrowTexture = Texture::get(rootDirGFXMenu + "arrow");
		shared Texture@ topArrowTexture = Texture::get(rootDirGFXMenu + "arrow");
		shared const float width=4;
		shared const float arrowHeight=4;

		shared Texture@ bgtexture = Texture::get(rootDirGFXMenu + "menublack");
		shared const Color bgColor = Color::White;
		shared Texture@ fgtexture = Texture::get(rootDirGFXMenu + "menuwhite");
		shared const Color fgColor = Color::White;
		shared const array<float> barfgMargin = {0.1,0.1,0.1,0.1};
		shared const array<float> fgMargin = {0.1,0.1,0.1,0.1};
		shared const array<float> arrowMargin = {0.1,0.1,0.1,0.1};

		shared Texture@ barbgtexture = Texture::get(rootDirGFXMenu + "menublack");
		shared const Color barbgColor = Color::White;
		shared Texture@ barfgtexture = Texture::get(rootDirGFXMenu + "menuwhite");
		shared const Color barfgColor = Color::White;

		shared const Color hoverColor = Color(70, 70, 150);
		shared const Color downColor = Color(100, 100, 175);
		shared const Color whiteColor = Color::White;



	}
	namespace ScrollPanel {


	}

	namespace TextEntry {
		shared ::Font@ font = Font::large;
		shared float fontScale = 0.25;

	}

} // close GUI::Skin namespace
} // close GUI namespace