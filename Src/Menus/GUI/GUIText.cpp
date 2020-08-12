#include "GUIText.h"
#include "../../Graphics/Font.h"
#include "../../Utils/TextMgmt.h"

GUIText::GUIText(UIMesh* um, KeyBinds* kb, Config* con, TxtManager* tm, Font* font, float x, float y, Alignment alignment)
: GUIComponent(um, kb, con, x, y, 0.f, 0.f, alignment) {
    this->font = font;
    setScale(1.f);

    txtMng = tm;
}

void GUIText::setScale(float sc) {
    scale = sc;
}

void GUIText::updateInternal(PGE::Vector2f mousePos) { }

void GUIText::renderInternal() {
    PGE::Vector2f txtScale = PGE::Vector2f(0.1388f * scale);
    PGE::String local = txtMng->getLocalTxt(rt.text);

    font->draw(local, PGE::Vector2f(getX(), getY()), txtScale, rt.rotation, rt.color);
}
