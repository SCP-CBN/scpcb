#include <Init/Init.h>
#include <iostream>
#include <tinyxml2.h>

#include "World/World.h"
#include "Serialize/IntProperty.h"

int PGEMain::Main() {
    // TODO: Remove.
//    IntProperty ip = IntProperty("test");
//    tinyxml2::XMLDocument doc;
//    PGE::String filename = PGE::FilePath::fromStr("GFX/test.xml").cstr();
//    doc.LoadFile(filename.cstr());
//    for (tinyxml2::XMLElement* ele = doc.FirstChildElement()->FirstChildElement(); ele != NULL; ele = ele->NextSiblingElement()) {
//        const PGE::String& type = PGE::String(ele->Name());
//        if (type.equals(ip.getXMLName())) {
//            ip.readXML(ele);
//            std::cout << "The value is: " << PGE::String(ip.getValue()) << std::endl;
//            ip.setValue(ip.getValue() - 1);
//            ip.writeXML(ele);
//        }
//    }
//    doc.SaveFile(filename.cstr());
    
    World* world = new World();
    while (world->run());
    
    delete world;
    return 0;
}
