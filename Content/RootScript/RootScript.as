// # RootScript
// angelscript platform

GUI::Panel@ testPanel;

void renderMenu(float interp) {
	GUI::render(interp);
}
void tickMenu(float interp) {
	GUI::tick(0);
}

void main() {
	GUI::initialize();
	@testPanel=GUI::Panel();
	GUI::Panel@ a = GUI::Panel(@testPanel);
	a.align=GUI::Align::TOP;
	a.height=5;
	a.color=Color::Blue;
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

	testPanel.performRecursiveLayout();

	PerFrameMenu::register(renderMenu);
	PerTick::register(tickMenu);
}