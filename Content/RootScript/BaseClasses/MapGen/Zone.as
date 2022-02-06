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
        return createRoom(mapGenEntries[type][Random::gnextInt(mapGenEntries[type].length())].roomName);
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
                        Debug::log("SCPCB/Map/" + zoneName + "/" + name + "/" + name + ".rm2");
                        @mapGenEntries[i][j].mesh = RM2::load("SCPCB/Map/" + zoneName + "/" + name + "/" + name + ".rm2");
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
