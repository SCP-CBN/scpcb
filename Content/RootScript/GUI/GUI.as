// #### Includes ----
// # include("Utilities/Dock.as");
// # include("Utilities/Square.as");
// # include("Utilities/Font.as");
// # include("Utilities/String.as");
// # include("Skin.as");

// # GUI Namespace --------
// Gui central.

namespace GUI { // open GUI namespace

	// #### Resolution Scaling

	// # ::tileScale
	// The weird GUI scaling factor thingy. Use GUI::scale instead of this.
	shared const float TILESCALE=0.04f;

	// # ::OriginResolution
	// An enumerator with scalings relative to the original resolution the GUI was designed at.
	namespace OriginalResolution {
		shared const Vector2f SIZE = Vector2f(1280,720);
		shared const float ASPECT = 1280.f/720.f;
		shared const Vector2f GUISIZE = Vector2f(1280,720)*TILESCALE*(1280.f/720.f)*2.f;
	}

	// # ::scale
	// the GUI aspect scale
	shared float scale;

	// # ::resolution
	// the current screen bounds relative to the GUI Scale.
	shared Vector2f resolution;

	// # ::center
	// the center position of the screen relative to the GUI Origin. (resolution/2)
	shared Vector2f center; // the gooey::center of SCP-999.

	// # ::updateResolution
	// Triggers a resolution change event
	shared void updateResolution(const int&in screenWidth=UI::getScreenWidth(), const int&in screenHeight=UI::getScreenHeight()) {
		scale=TILESCALE*UI::getAspectRatio()*2.f;
		resolution=Vector2f(screenWidth*scale,screenHeight*scale);
		center=resolution/2.f;
		for(int i=0; i<baseInstances.length(); i++) { baseInstances[i].invalidateLayout(); } // trigger layout update event
	}


	// #### Layout

	// # ::baseInstances
	// All of the GUI elements that do not have a parent.
	shared array<GUI@> baseInstances;

	// # ::invalidElements
	// Elements that have been marked for a layout update.
	shared array<GUI@> invalidElements;
	shared void markInvalid(GUI@&in element) { invalidElements.insertLast(@element); }

	// # ::triggerRecursiveLayout
	// spawns a layout update event for all elements marked as invalid.
	shared void triggerRecursiveLayout() { while(invalidElements.length()>0) { invalidElements[0].performRecursiveLayout(); invalidElements.removeAt(0); } }

	// #### Text entering

	// # ::textEntryFocus
	// The currently focused text entry, if any.
	shared GUI@ textEntryFocus;
	shared void setTextEntryFocus(GUI@&in value) { @textEntryFocus=@value; if(@value!=null) { Input::startTextInputCapture(); } else { Input::stopTextInputCapture(); } }

	// # ::validTextEntering()
	// Closes the text entry focus if the text entry becomes hidden or invisible.
	shared bool validTextEntering() { if(@textEntryFocus!=null) { if(!textEntryFocus.visible || textEntryFocus.hidden) { @textEntryFocus=null; return false; } return true; } return false; }

	// # ::clickedTextEntering()
	// A function that monitors whether a click happened outside the text entry focus.
	shared void clickedTextEntering(Vector2f&in mpos) { if(validTextEntering() && !textEntryFocus.frame.contains(mpos)) { @textEntryFocus=null; } }

	// # ::tickTextEntering()
	// Validates the text entering (if its still visible) and runs a special update function for it.
	shared void tickTextEntering() {} // ### !!! comment until GUITextEntry is done !!! ### if(validTextEntering()) { textEntryFocus.tickTextEntering(); } }

	// # ::TextEnteredFunc()
	// The function to call when the enter key is pressed.
	// return true to clear the text, false to not clear it.
	shared funcdef bool TextEnteredFunc(string&in input);

	// #### Mouse & Clicking

	// # ::mouse
	// The mouse position relative to the GUI origin
	shared Vector2f mouse() { return Input::getMousePosition()+center; }

	// # ::ClickFunction
	// @element.clickFunc=@function_name or @element=GUI::ClickFunction(@func);
	// It's a variable function used as an alternative to element.doClick().
	shared funcdef void ClickFunction(Vector2f&in mpos);

	// # ::triggerRecursiveClick
	// spawns a click event for all visible base elements.
	shared void triggerRecursiveClick() {
		Vector2f mpos=mouse();
		clickedTextEntering(mpos); // Update text entering (defocusing if click outside)
		// If a menu changes the menu, new elements could be clicked, so this deals with this.
		array<GUI@> clickables;
		for(int i=0; i<baseInstances.length(); i++) { if(baseInstances[i].visible) { baseInstances[i].performRecursiveClick(mpos,clickables); } }
		for(int i=0; i<clickables.length(); i++) { clickables[i].performClick(mpos); }
	}

	// # ::tickMouse()
	// Monitor the mouse for clicks.
	shared bool wasMouse1Down;
	shared void tickMouse() {
		if(Input::Mouse1::isDown() || Input::Mouse1::isHit()) { if(!wasMouse1Down) { wasMouse1Down=true; triggerRecursiveClick(); } }
		else if(wasMouse1Down) { wasMouse1Down=false; }
	}


	// #### Rendering and Ticking
	// Both are simple recursive functions.

	shared void triggerRecursiveTick(int&in tick) { for(int i=0; i<baseInstances.length(); i++) { if(baseInstances[i].visible) { baseInstances[i].performRecursiveTick(tick); } } }
	shared void triggerRecursiveRender(float&in interp) { for(int i=0; i<baseInstances.length(); i++) { if(baseInstances[i].visible) { baseInstances[i].performRecursiveRender(interp); } } }

	// #### Initialize
	// Just sets the resolution for now.
	shared void initialize() {
		updateResolution();
	}

	// # tick(int&in tick)
	// entrypoint for the tick event function.
	shared void runTick(int&in tick=0) {
		tickMouse();
		tickTextEntering();
		triggerRecursiveTick(tick);
	}

	// # render(float&in interp)
	// entrypoint for the renderMenu event function.
	shared void runRender(float&in interp) {
		triggerRecursiveRender(interp);
	}

} // close GUI namespace

// #### Dependents
// # include("Baseclass.as");
// # include_all("Components/*.as");