// # RootScript
// angelscript platform

shared string rootDirAssets	= "SCPCB/";
shared string rootDirGFX	= rootDirAssets + "GFX/";
shared string rootDirLoadscreens = rootDirGFX + "Loadingscreens/";
shared string rootDirGFXMenu	= rootDirGFX + "Menu/";

GUI::Panel@ testPanel;

void renderMenu(float interp) {
	GUI::runRender(interp);

	//testPanel.performRecursiveLayout(interp);
}
void tickMenu(float interp) {
	GUI::runTick(0);
}

// Menu objects are temporarily placed in the RootScript folder.
// They should really be moved to SCPCB, as they are game related files.

void main() {
	GUI::initialize();
	@testPanel=GUI::Panel();
	GUI::Panel@ abcd = GUI::Panel(@testPanel);
	abcd.align=GUI::Align::TOP;
	abcd.height=5;
	abcd.color=Color::Blue;



	GUI::Panel@ b = GUI::Panel(@testPanel);
	b.align=GUI::Align::LEFT;
	b.width=5;
	b.color=Color::Green;
	GUI::Panel@ c = GUI::Panel(@testPanel);
	c.align=GUI::Align::RIGHT;
	c.width=5;
	c.color=Color::Red;
	GUI::Panel@ d = GUI::Panel(@testPanel);
	d.align=GUI::Align::BOTTOM;
	d.height=5;
	d.color=Color::Orange;
	GUI::ButtonLabel@ testbtn = GUI::ButtonLabel(@c);
	testbtn.align=GUI::Align::FILL;
	testbtn.margin={4,8,12,16};
	testbtn.text="tuch my butten";

	GUI::Label@ testmsg = GUI::Label(@abcd);
	testmsg.align=GUI::Align::FILL;
	testmsg.alignText=GUI::Align::CENTER;
	testmsg.text="Cheese";

	GUI::Panel@ ba = GUI::Panel(@testPanel);
	ba.align=GUI::Align::TOP;
	ba.height=5;
	ba.color=Color::Yellow;
	GUI::Panel@ bb = GUI::Panel(@testPanel);
	bb.align=GUI::Align::LEFT;
	bb.width=5;
	bb.color=Color::Cyan;
	GUI::Panel@ bc = GUI::Panel(@testPanel);
	bc.align=GUI::Align::RIGHT;
	bc.width=5;
	bc.color=Color::Magenta;
	GUI::Panel@ bd = GUI::Panel(@testPanel);
	bd.align=GUI::Align::BOTTOM;
	bd.height=5;
	bd.color=Color::Gray;

	//testPanel.invalidateLayout();

	PerFrameMenu::register(renderMenu);
	PerTick::register(tickMenu);
}