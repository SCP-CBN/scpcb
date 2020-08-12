#ifndef GUITEXT_H_INCLUDED
#define GUITEXT_H_INCLUDED

#include "GUIComponent.h"

class Font;
class TxtManager;

class GUIText : public GUIComponent {
    private:
        Font* font;
        float scale;
        TxtManager* txtMng;

        void updateInternal(PGE::Vector2f mousePos) override;
        void renderInternal() override;

    public:
        struct RichText {
            PGE::String text = "";
            PGE::Color color = PGE::Color::White;
            float rotation = 0.f;
        };
        RichText rt;

        GUIText(UIMesh* um, KeyBinds* kb, Config* con, TxtManager* tm, Font* font, float x, float y, Alignment alignment = Alignment::CenterXY);

        using GUIComponent::setX;
        using GUIComponent::setY;
    
        void setScale(float sc);
};

#endif // GUITEXT_H_INCLUDED
