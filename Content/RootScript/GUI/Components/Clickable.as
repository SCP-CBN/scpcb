// # GUI::Clickable
// An internal panel that deals with click functionality.

namespace GUI { // open GUI namespace
shared abstract class Clickable : GUI { // open GUI::Clickable class
	// # Constructor
	Clickable(GUI@&in parent,string vcls="GUI::Clickable") { super(@parent,vcls); }

	// # .pressed
	// Whether this element is was clicked and the mouse is still held down.
	bool pressed;

	// #.tickInternal
	// This is why this is a mixin class.
	protected void tickInternal(int&in tick) { if(pressed && !Input::Mouse1::isDown()) { pressed=false; internalStopClick(); stopClick(); } tickClickableInternal(); tickClickable(); }

	void tickClickable() {} // override
	void tickClickableInternal() {} // override

	// #.click
	// the click event.
	void click(Vector2f&in mpos) { pressed=true; internalStartClick(mpos); startClick(mpos); }

	// # .internalStopClick/StartClick.
	// Used for other baseclasses to inherit higher click functions, such as drag n drop.
	void internalStopClick() { stopClick(); }
	void internalStartClick(Vector2f&in mpos) { startClick(mpos); }

	void stopClick() {} // override
	void startClick(Vector2f&in mpos) {} // override

} // close GUI::Clickable class
} // close GUI namespace
