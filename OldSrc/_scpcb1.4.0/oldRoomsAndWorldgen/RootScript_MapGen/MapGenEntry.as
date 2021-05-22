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
