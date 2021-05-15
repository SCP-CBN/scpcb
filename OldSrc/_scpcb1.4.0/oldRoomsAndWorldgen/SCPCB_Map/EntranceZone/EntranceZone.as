external class Zone;

class EntranceZone : Zone {
    //TODO: refactor
    array<array<array<Collision::Instance>>> collisionInstances;

    void generate() {
        zoneName = "EntranceZone";

        rooms = array<array<Room@>>(10);
        collisionInstances = array<array<array<Collision::Instance>>>(10);
        for (int x=0;x<10;x++) {
            Debug::log("Creating column "+toString(x));
            rooms[x] = array<Room@>(10);
            collisionInstances[x] = array<array<Collision::Instance>>(10);
            for (int y=0;y<10;y++) {
                Debug::log("Creating element "+toString(x)+","+toString(y));
                if (y % 2 == 0) {
                    if (x % 2 == 0) {
                        @rooms[x][y] = createRoom("hll_plain_4_a");
                    } else {
                        @rooms[x][y] = createRoom("hll_plain_2_a");
                        rooms[x][y].rotation = 90;
                    }
                } else {
                    if (x % 2 == 0) {
                        @rooms[x][y] = createRoom("hll_plain_2_a");
                    } else {
                        // Do nothing
                    }
                }
                if (rooms[x][y] != null) {
                    rooms[x][y].position = Vector3f(x*204.8,0,y*204.8);
                    if (rooms[x][y].rotation == 0) { rooms[x][y].rotation = 0; }

                    RM2@ mesh = rooms[x][y].mesh;
                    collisionInstances[x][y] = array<Collision::Instance>(mesh.collisionMeshCount());
                    Matrix4x4f worldMatrix = rooms[x][y].worldMatrix;
                    for (int i=0;i<mesh.collisionMeshCount();i++) {
                        collisionInstances[x][y][i] = testCollCollection.addInstance(mesh.getCollisionMesh(i), worldMatrix);
                        testCollCollection.updateInstance(collisionInstances[x][y][i], worldMatrix);
                    }
                }
            }
        }
    }

    void update(float deltaTime) {
        Zone::update(deltaTime);
    }
}
