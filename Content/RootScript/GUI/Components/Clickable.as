// # GUI::Clickable
// An internal panel that deals with click functionality.

namespace GUI { // open GUI namespace
shared abstract class Clickable : GUI { // open GUI::Clickable class
	// # Constructor
	Clickable(GUI@&in parent,string&in vcls="GUI::Clickable") { super(@parent,vcls); }

	// # .pressed
	// Whether this element is was clicked and the mouse is still held down.
	bool pressed;

	// #.tickInternal
	// This is why this is a mixin class.
	protected void tickInternal(int&in tick) { if(pressed && !(Input::Mouse1::isDown() || Input::Mouse1::isHit())) { pressed=false; internalStopClick(); } }

	// #.click
	// the click event.
	void clickInternal(Vector2f&in mpos) { pressed=true; internalStartClick(mpos); }

	// # .internalStopClick/StartClick.
	// Used for other baseclasses to inherit higher click functions, such as drag n drop.
	void internalStopClick() { stopClick(); }
	void internalStartClick(Vector2f&in mpos) { startClick(mpos); }

	void stopClick() { click(); if(@clickFunc!=null) { clickFunc(); } } // override
	void startClick(Vector2f&in mpos) {} // override

} // close GUI::Clickable class
} // close GUI namespace
