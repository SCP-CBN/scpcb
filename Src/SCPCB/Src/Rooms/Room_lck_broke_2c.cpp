#include <bbblitz3d.h>
#include <bbmath.h>
#include <bbgraphics.h>
#include <bbaudio.h>

#include "../GameMain.h"
#include "../MapSystem.h"
#include "../Doors.h"
#include "../Items/Items.h"
#include "../Decals.h"
#include "../Particles.h"
#include "../Events.h"
#include "../Player.h"
#include "../NPCs/NPCs.h"
#include "../Audio.h"
#include "../MathUtils/MathUtils.h"
#include "../Menus/Menu.h"
#include "../Objects.h"
#include "Room_lck_broke_2c.h"

namespace CBN {

// Functions.
void FillRoom_lck_broke_2c(Room* r) {
    Door* d;
    Door* d2;
    SecurityCam* sc;
    Decal* de;
    Room* r2;
    SecurityCam* sc2;
    Item* it;
    int i;
    int xtemp;
    int ytemp;
    int ztemp;

    //, Bump
    int t1;

    d = CreateDoor(r->x - 736.0 * RoomScale, 0, r->z - 104.0 * RoomScale, 0, r, true);
    d->timer = 70 * 5;
    d->autoClose = false;
    d->open = false;
    d->locked = true;

    bbEntityParent(d->buttons[0], 0);
    bbPositionEntity(d->buttons[0], r->x - 288.0 * RoomScale, 0.7, r->z - 640.0 * RoomScale);
    bbEntityParent(d->buttons[0], r->obj);

    bbFreeEntity(d->buttons[1]);
    d->buttons[1] = 0;

    d2 = CreateDoor(r->x + 104.0 * RoomScale, 0, r->z + 736.0 * RoomScale, 270, r, true);
    d2->timer = 70 * 5;
    d2->autoClose = false;
    d2->open = false;
    d2->locked = true;
    bbEntityParent(d2->buttons[0], 0);
    bbPositionEntity(d2->buttons[0], r->x + 640.0 * RoomScale, 0.7, r->z + 288.0 * RoomScale);
    bbRotateEntity(d2->buttons[0], 0, 90, 0);
    bbEntityParent(d2->buttons[0], r->obj);

    bbFreeEntity(d2->buttons[1]);
    d2->buttons[1] = 0;

    d->linkedDoor = d2;
    d2->linkedDoor = d;

    float scale = RoomScale * 4.5 * 0.4;

    r->objects[0] = bbCopyMeshModelEntity(Monitor);
    bbScaleEntity(r->objects[0],scale,scale,scale);
    bbPositionEntity(r->objects[0],r->x+668*RoomScale,1.1,r->z-96.0*RoomScale,true);
    bbRotateEntity(r->objects[0],0,90,0);
    bbEntityParent(r->objects[0],r->obj);

    r->objects[1] = bbCopyMeshModelEntity(Monitor);
    bbScaleEntity(r->objects[1],scale,scale,scale);
    bbPositionEntity(r->objects[1],r->x+96.0*RoomScale,1.1,r->z-668.0*RoomScale,true);
    bbEntityParent(r->objects[1],r->obj);
}

}
