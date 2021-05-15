shared enum RoomType {
    Room1 = 1,
    Room2 = 2,
    Room2C = 3,
    Room3 = 4,
    Room4 = 5
}

shared class MapGenEntry {
    RoomType roomType;
    string roomName;
    RM2@ mesh;
}


shared class Room {
    Room(string name, Zone@ zone_) {
        @_mesh = zone_.getMesh(name);
    }

    protected RM2@ _mesh;
    RM2@ mesh {
        get {
            return _mesh;
        }
    }

    protected Zone@ zone;

    protected Vector3f _position;
    Vector3f position {
        get {
            return _position;
        }
        set {
            _position = value;
            recalculateWorldMatrix();
        }
    }

    // in degrees
    protected float _rotation;
    float rotation {
        get {
            return _rotation;
        }
        set {
            _rotation = value;
            recalculateWorldMatrix();
        }
    }

    protected Matrix4x4f _worldMatrix;
    Matrix4x4f worldMatrix {
        get {
            return _worldMatrix;
        }
    }

    protected void recalculateWorldMatrix() {
        _worldMatrix = Matrix4x4f::constructWorldMat(position, Vector3f(0.1, 0.1, 0.1), Vector3f(0.0, Math::degToRad(rotation), 0.0));
    }

    void update(float deltaTime) {}

    void render(float interpolation) {
        mesh.render(worldMatrix);
    }
}



shared abstract class Zone {
    protected string zoneName;
    protected array<array<MapGenEntry>> mapGenEntries = array<array<MapGenEntry>>(Room4 + 1);
    protected array<array<Room@>> rooms;

    void registerRoom(const string name, const RoomType type) {
        Debug::log("Registering "+name);
        MapGenEntry entry;
        entry.roomName = name;
        entry.roomType = type;
        mapGenEntries[type].insertLast(entry);
    }

    Room@ createRandomRoom(RoomType type) {
        return createRoom(mapGenEntries[type][Random::getInt(mapGenEntries[type].length())].roomName);
    }

    Room@ createRoom(string name) {
        Debug::log("Creating room "+name);
        Reflection<Room> reflection;
        reflection.setConstructorArgument(0, name);
        reflection.setConstructorArgument(1, this);
        Room@ result = reflection.callConstructor(name);
        if (result == null) {
            Debug::log("Constructor not found");
            return Room(name, this);
        }
        Debug::log("Constructor found");
        return result;
    }

    RM2@ getMesh(const string name) {
        for (int i = 0; i < mapGenEntries.length(); i++) {
            for (int j = 0; j < mapGenEntries[i].length(); j++) {
                if (mapGenEntries[i][j].roomName == name) {
                    if (mapGenEntries[i][j].mesh == null) {
                        Debug::log(rootDirCBR + zoneName + "/" + name + "/" + name + ".rm2");
                        @mapGenEntries[i][j].mesh = RM2::load(rootDirCBR + zoneName + "/" + name + "/" + name + ".rm2");
                    }
                    return mapGenEntries[i][j].mesh;
                }
            }
        }
        Debug::log("Null for " + name);
        return null;
    }

    void generate() {}

    void update(float deltaTime) {
        for (int x=0;x<rooms.length();x++) {
            for (int y=0;y<rooms[x].length();y++) {
                if (rooms[x][y] == null) { continue; }
                rooms[x][y].update(deltaTime);
            }
        }
    }

    void render(float interpolation) {
        testCounter++;
        if (testCounter > 60000) {
            Debug::log("IT'S GONE");
            @test_shared_global = null;
        }
        for (int x=0;x<rooms.length();x++) {
            for (int y=0;y<rooms[x].length();y++) {
                //Debug::log("DRAW "+toString(x)+" "+toString(y));
                if (rooms[x][y] == null) { continue; }
                rooms[x][y].render(interpolation);
            }
        }
    }
}

shared int testCounter = 0;
shared Zone@ test_shared_global;

