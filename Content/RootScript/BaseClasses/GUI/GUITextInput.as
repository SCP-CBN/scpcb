namespace GUITextInput {
    shared GUITextInput@ subscriber;
    shared const float caretBreathingSpace = 0.25;
    shared string word = "\\w";
    shared string leftBoundWord = "(\\b)\\w+$|\\w(\\b)\\W+$";
    shared string rightBoundWord = "^\\w+(\\b)|^\\W+(\\b)\\w";
}

shared class GUITextInput : GUIComponent {
    private GUIFrame@ frame;
    private GUIText@ text;

    private MementoManager@ mementoManager;

    // Apple only
    // Basically shift+arrow key after a drag or multi-click on macOS has different behavior than on Windows.
    // On macOS after a select drag or multi-click select the first shift+arrow combo you hit determines which side of the selection you're manipulating.
    // So this boolean determines when exactly to trigger that behavior because other types of highlighting/text-modifying don't do that.
    bool selectionWasDraggedOrClicked = false;

    // Determines if the box should track the mouse's movement as a drag action for selecting text.
    private bool draggable = false;

    // Current position of the caret.
    private int caretPosition = 0;
    // Current position of the start and end points of the selection.
    private int selectionStartPosition = 0;
    private int selectionEndPosition = 0;

    // Cached positions for coordinate updates.
    private int oldCaretPosition = -1;
    private int oldSelectionStartPosition = -1;
    private int oldSelectionEndPosition = -1;

    // Various coordinates of the caret and selection in UI space.
    private float caretTop;
    private float caretBottom;
    private float caretX;
    private float selectionStartX;
    private float selectionEndX;

    private bool defaultTextDisplayed = true;
    private string defaultTxt;

    // Max amount of characters the input box can have.
    private int charLimit;

    string txt {
        get { return text.text; }
        set {
            // Selecting to correctly deal with defaultTxt.
            select();
            mementoManager.push(0, text.text, false, true);
            mementoManager.push(0, value, true, true);
            text.text = value;
            setCaretAndSelection(value.length());
            deselect();
        }
    }

    GUITextInput(Menu@ menu, float x, float y, float width, float height, bool alignLeft, int mementoMaxSize = 1048576, const string&in defaultTxt = "", int charLimit = 2147483647, const string&in pattern = "", Alignment alignment = Alignment::CenterXY) {
        super(menu, x, y, width, height, alignment);
        @frame = GUIFrame(null, x, y, width, height, alignment);
        @text = GUIText(menu , alignLeft ? x + GUIComponent::borderThickness * 2 : x + width/2, y + height/2, !alignLeft, true, false, alignment);

        @mementoManager = MementoManager::create(mementoMaxSize);

        float textHeight = text.getHeight();
        caretTop = y + (height - textHeight)/2 - GUITextInput::caretBreathingSpace;
        caretBottom = caretTop + textHeight + GUITextInput::caretBreathingSpace * 2;

        updateCoordinates();

        this.defaultTxt = defaultTxt;
        text.text = defaultTxt;
        text.color = Color::Gray;

        this.charLimit = charLimit;
    }

    ~GUITextInput() {
        MementoManager::destroy(mementoManager);
    }

    private void setCaretAndSelection(int pos) {
        caretPosition = pos;
        selectionStartPosition = pos;
        selectionEndPosition = pos;
    }

    private bool anyTextSelected() const {
        return selectionStartPosition != selectionEndPosition;
    }

    private int getFirstLeftWordBoundary(int startingPosition) const {
        if (startingPosition > 0) {
            return GUITextInput::leftBoundWord.regexMatchPosition(text.text.substr(0, startingPosition));
        }

        return startingPosition;
    }

    private int getFirstRightWordBoundary(int startingPosition) const {
        if (startingPosition < text.text.length()) {
            return GUITextInput::rightBoundWord.regexMatchPosition(text.text.substr(startingPosition, text.text.length() - startingPosition)) + startingPosition;
        }

        return startingPosition;
    }

    // This is one of the three functions that must be used internally in order for mementos to work correctly.
    private void addText(string append) {
        // Truncate the string if it's over the capacity.
        int newSize = text.text.length() + append.length();
        if (newSize > charLimit) {
            append = append.substr(0, charLimit - text.text.length());
        }

        if (selectionStartPosition != selectionEndPosition) {
            mementoManager.push(selectionStartPosition, text.text.substr(selectionStartPosition, selectionEndPosition - selectionStartPosition), false, true);
        }
        mementoManager.push(selectionStartPosition, append, true, selectionStartPosition != selectionEndPosition);

        // If any text was selected then delete it.
        if (selectionEndPosition >= text.text.length()) {
            text.text = text.text.substr(0, selectionStartPosition) + append;
        } else {
            text.text = text.text.substr(0, selectionStartPosition) + append + text.text.substr(selectionEndPosition);
        }

        setCaretAndSelection(selectionStartPosition + append.length());
    }

    // This is one of the three functions that must be used internally in order for mementos to work correctly.
    private void deleteSelectedText() {
        removeText(selectionStartPosition, selectionEndPosition);

        setCaretAndSelection(selectionStartPosition);
    }

    // This is one of the three functions that must be used internally in order for mementos to work correctly.
    private void removeText(int start, int end) {
        mementoManager.push(start, text.text.substr(start, end - start), false);
        text.text = text.text.substr(0, start) + text.text.substr(end);
    }

    void clearTextAndMementos() {
        text.text = "";
        setCaretAndSelection(0);
        mementoManager.clear();
    }

    private int getCaretPosition(float mouseX) {
        float caretX = text.getTextPos().x + text.getWidth();
        for (int newCaret = text.text.length(); newCaret > 0; newCaret--) {
            float charWidth = text.getWidth(text.text[newCaret - 1]);
            if (mouseX > caretX - charWidth / 2.f) {
                return newCaret;
            }
            caretX -= charWidth;
        }

        return 0;
    }

    private void setCaretPositionFromMouse(float mouseX) {
        setCaretAndSelection(getCaretPosition(mouseX));
    }

    private void updateCoordinates() {
        if (caretPosition == oldCaretPosition && selectionStartPosition == oldSelectionStartPosition && selectionEndPosition == oldSelectionEndPosition) {
            return;
        }

        oldCaretPosition = caretPosition;
        oldSelectionStartPosition = selectionStartPosition;
        oldSelectionEndPosition = selectionEndPosition;

        float textX = text.getTextPos().x;

        caretX = textX;
        if (text.text != "") {
            caretX += text.getWidth(text.text.substr(0, caretPosition));
        }

        selectionStartX = textX;
        if (text.text != "") {
            selectionStartX += text.getWidth(text.text.substr(0, selectionStartPosition));
        }

        selectionEndX = selectionStartX + text.getWidth(text.text.substr(selectionStartPosition, selectionEndPosition - selectionStartPosition));
    }

    void select() {
        if (@GUITextInput::subscriber != null) {
            GUITextInput::subscriber.deselect();
        }

        @GUITextInput::subscriber = this;
        Input::startTextInputCapture();

        if (defaultTextDisplayed) {
            text.text = "";
            text.color = Color::White;
            defaultTextDisplayed = false;
        }
    }

    void deselect() {
        Input::stopTextInputCapture();
        @GUITextInput::subscriber = null;

        if (text.text == "") {
            text.text = defaultTxt;
            text.color = Color::Gray;
            defaultTextDisplayed = true;
        }
    }

    void update() override {
        Vector2f mousePos = Input::getMousePosition();
        // Are we selected?
        if (@GUITextInput::subscriber != this) {
            // Check if the mouse selected us.
            if (mousePos.x >= x && mousePos.y >= y && mousePos.x <= x2 && mousePos.y <= y2) {
                if (Input::Mouse1::isHit()) {
                    select();
                    // Move caret to mouse position.
                    setCaretPositionFromMouse(mousePos.x);
                    draggable = true;
                    updateCoordinates();
                }
            }
        } else {

        // Text actions.
            string append = Input::getTextInput();
            if (append != "" && text.text.length() < charLimit) {
                addText(append);
                if (World::Platform::active == World::Platform::Apple) {
                    selectionWasDraggedOrClicked = false;
                }
            }

        // Delete key actions.
            if (Input::Backspace::isHit() || Input::Delete::isHit()) {
                // Delete selected text.
                if (anyTextSelected()) {
                    deleteSelectedText();
                } else {
                    // Remove preceeding character if backspace, suceeding if delete.
                    if (Input::Backspace::isHit() && caretPosition > 0) {
                        int deletionStart = Input::anyShortcutDown() ? getFirstLeftWordBoundary(caretPosition) : caretPosition - 1;
                        removeText(deletionStart, caretPosition);
                        setCaretAndSelection(deletionStart);
                    } else if (Input::Delete::isHit() && caretPosition < text.text.length()) {
                        removeText(caretPosition, Input::anyShortcutDown() ? getFirstRightWordBoundary(caretPosition) : caretPosition + 1);
                    }
                }
            }

        // Arrow actions.
            if (Input::LeftArrow::isHit() || Input::RightArrow::isHit()) {
                bool right = Input::RightArrow::isHit();
                if (!Input::anyShiftDown()) {
                    if (anyTextSelected()) {
                        // Snap to one side of the selection.
                        setCaretAndSelection(right ? selectionEndPosition : selectionStartPosition);
                    } else {
                        // Shift caret position.
                        if (Input::anyShortcutDown()) {
                            if (right) {
                                setCaretAndSelection(getFirstRightWordBoundary(caretPosition));
                            } else {
                                setCaretAndSelection(getFirstLeftWordBoundary(caretPosition));
                            }
                        } else {
                            setCaretAndSelection(Math::clamp(right ? caretPosition + 1 : caretPosition - 1, 0, text.text.length()));
                        }
                    }
                    if (World::Platform::active == World::Platform::Apple) {
                        selectionWasDraggedOrClicked = false;
                    }
                } else {
                    if (selectionWasDraggedOrClicked) {
                        caretPosition = right ? selectionStartPosition : selectionEndPosition;
                        selectionWasDraggedOrClicked = false;
                    }
                    // Shift the selection index.
                    if (Input::anyShortcutDown()) {
                        if (right) {
                            if (selectionStartPosition != caretPosition) {
                                selectionStartPosition = getFirstRightWordBoundary(selectionStartPosition);
                            } else {
                                selectionEndPosition = getFirstRightWordBoundary(selectionEndPosition);
                            }
                        } else {
                            if (selectionEndPosition != caretPosition) {
                                selectionEndPosition = getFirstLeftWordBoundary(selectionEndPosition);
                            } else {
                                selectionStartPosition = getFirstLeftWordBoundary(selectionStartPosition);
                            }
                        }

                        // If the selection areas overlapped while looking for boundaries swap them.
                        if (selectionStartPosition > selectionEndPosition) {
                            int buff = selectionStartPosition;
                            selectionStartPosition = selectionEndPosition;
                            selectionEndPosition = buff;
                        }
                    } else {
                        if (right) {
                            if (selectionStartPosition != caretPosition) {
                                selectionStartPosition++;
                            } else {
                                selectionEndPosition++;
                            }
                        } else {
                            if (selectionEndPosition != caretPosition) {
                                selectionEndPosition--;
                            } else {
                                selectionStartPosition--;
                            }
                        }
                    }
                    if (selectionStartPosition < 0) { selectionStartPosition = 0; }
                    if (selectionEndPosition > text.text.length()) { selectionEndPosition = text.text.length(); }
                }
            }

        // Mouse actions.
            if (Input::Mouse1::getClickCount() == 2) {
                // Prevents selectionEndPosition from assuming an illegal value.
                if (text.text != "") {
                    selectionStartPosition = caretPosition;
                    selectionEndPosition = caretPosition;

                    // What direction are we going in?
                    bool right = (mousePos.x >= caretX && caretPosition != text.text.length()) || caretPosition == 0;

                    // Select all word-based characters until either the end or a boundary.
                    // Unless the first character found IS a boundary, then we ONLY select that.
                    // Let's check for that first character being a boundary first.
                    bool boundaryContact = false;
                    if (right) {
                        boundaryContact = !GUITextInput::word.regexMatchAny(text.text[selectionEndPosition]);
                        selectionEndPosition++;
                    } else {
                        boundaryContact = !GUITextInput::word.regexMatchAny(text.text[selectionStartPosition - 1]);
                        selectionStartPosition--;
                    }

                    if (!boundaryContact) {
                        // Scan both left and right sides of the caret for word characters.
                        while (selectionEndPosition < text.text.length()) {
                            if (GUITextInput::word.regexMatchAny(text.text[selectionEndPosition])) {
                                selectionEndPosition++;
                            } else {
                                break;
                            }
                        }
                        while (selectionStartPosition > 0) {
                            if (GUITextInput::word.regexMatchAny(text.text[selectionStartPosition - 1])) {
                                selectionStartPosition--;
                            } else {
                                break;
                            }
                        }
                    }
                    draggable = false; // Prevents a double click from being registered as a drag action.

                    if (World::Platform::active == World::Platform::Apple) {
                        selectionWasDraggedOrClicked = true;
                    } else if (World::Platform::active == World::Platform::Windows) {
                        // If you shift+arrow after a click selection on Windows, it defaults to manipulating the right-hand side.
                        // So move the caret to the left to replicate that behavior.
                        caretPosition = selectionStartPosition;
                    }
                }
            } else if (Input::Mouse1::getClickCount() >= 3) {
                // Select all.
                selectionStartPosition = 0;
                selectionEndPosition = text.text.length();
                caretPosition = 0;
                draggable = false; // Prevents a triple click from being registered as a drag action.

                if (World::Platform::active == World::Platform::Apple) {
                    selectionWasDraggedOrClicked = true;
                } else if (World::Platform::active == World::Platform::Windows) {
                    // If you shift+arrow after a click selection on Windows, it defaults to manipulating the right-hand side.
                    // So move the caret to the left to replicate that behavior.
                    caretPosition = selectionStartPosition;
                }

                // If you shift+arrow after a click selection on Windows, it defaults to manipulating the right-hand side.
                // So move the caret to the left to replicate that behavior.
                caretPosition = selectionStartPosition;
            } else if (Input::Mouse1::isHit()) {
                // If we're still in the textbox move the caret to the mouse's position.
                if (mousePos.x >= x && mousePos.y >= y && mousePos.x <= x2 && mousePos.y <= y2) {
                    if (Input::anyShiftDown()) {
                        // Select text under cursor to caret.
                        int mouseSnap = getCaretPosition(mousePos.x);
                        if (mouseSnap != caretPosition) {
                            if (mouseSnap > caretPosition) {
                                selectionEndPosition = mouseSnap;
                                selectionStartPosition = caretPosition;
                            } else {
                                selectionStartPosition = mouseSnap;
                                selectionEndPosition = caretPosition;
                            }
                        }
                    } else {
                        // Move caret to mouse position.
                        setCaretPositionFromMouse(mousePos.x);
                        draggable = true;
                    }
                } else {
                    // Mouse click outside of textbox.
                    deselect();
                }
                if (World::Platform::active == World::Platform::Apple) {
                    selectionWasDraggedOrClicked = false;
                }
            } else if (draggable && Input::Mouse1::isDown()) {
                // If we're dragging then select any text between the cursor and the caret.
                int mouseSnap = getCaretPosition(mousePos.x);
                if (mouseSnap != caretPosition) {
                    if (mouseSnap > caretPosition) {
                        selectionEndPosition = mouseSnap;
                        selectionStartPosition = caretPosition;
                    } else {
                        selectionStartPosition = mouseSnap;
                        selectionEndPosition = caretPosition;
                    }
                    if (World::Platform::active == World::Platform::Apple) {
                        selectionWasDraggedOrClicked = true;
                    }
                } else {
                    selectionStartPosition = caretPosition;
                    selectionEndPosition = caretPosition;
                }
            }

        // Shortcut actions.
            if (Input::copyIsHit() && anyTextSelected()) {
                Input::setClipboardText(text.text.substr(selectionStartPosition, selectionEndPosition - selectionStartPosition));
            } else if (Input::cutIsHit() && anyTextSelected()) {
                Input::setClipboardText(text.text.substr(selectionStartPosition, selectionEndPosition - selectionStartPosition));
                deleteSelectedText();
            } else if (Input::pasteIsHit()) {
                string append = Input::getClipboardText();
                if (append != "" && text.text.length() < charLimit) {
                    if (anyTextSelected()) {
                        deleteSelectedText();
                    }
                    addText(append);
                }
            } else if (Input::undoIsHit() || Input::redoIsHit()) {
                text.text = mementoManager.execute(text.text, caretPosition, Input::undoIsHit());
                setCaretAndSelection(caretPosition);
                oldCaretPosition = -1;
            } else if (Input::selectAllIsHit()) {
                selectionStartPosition = 0;
                selectionEndPosition = text.text.length();
            }

            updateCoordinates();
        }
    }

    void render() override {
        frame.render();

        // Render caret.
        if (selectionStartPosition == selectionEndPosition) {
            if (@GUITextInput::subscriber == this) {
                UI::setTextureless();
                UI::addRect(Rectanglef(caretX, caretTop, caretX + 0.3f, caretBottom));
                UI::setColor(Color::White); // TODO: Why do we need this??
            }
        // Render selection backdrop.
        } else {
            UI::setTextureless();
            UI::setColor(@GUITextInput::subscriber == this ? Color(0.75f, 0.75f, 0.75f) : Color(0.25f, 0.25f, 0.25f)); // TODO: Transparency broken.
            UI::addRect(Rectanglef(selectionStartX, caretTop - 0.2f, selectionEndX, caretBottom + 0.2f));
            UI::setColor(Color::White);
        }
    }
}
