// # GUI::Align ----
// Alignment functions for GUI Components.

namespace GUI {
shared enum Align {

	// Dock the element in the center of the parent.
	CENTER = 0,

	// Dock the element to a side of the parent. Adds to layout.
	LEFT = 1,
	TOP = 2,
	RIGHT = 3,
	BOTTOM = 4,

	// Dock the element to a corner of the parent. Does not add to layout.
	TOP_LEFT = 5,
	TOP_RIGHT = 6,
	BOTTOM_LEFT= 7,
	BOTTOM_RIGHT = 8,

	// Dock and resize the element to the remaining area of the parent.
	FILL = 9,

	// Dock by a function
	MANUAL = 10,

	// No docking, element is positioned relative to the GUI Origin
	NONE = 11

} // close GUI::Align enum
} // close GUI namespace