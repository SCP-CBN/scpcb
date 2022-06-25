namespace Layout {
    shared enum Exists {
        Yes,
        No
    }

    shared enum RoomType {
        None = 0,
        Room1 = 1,
        Room2 = 2,
        Room2C = 3,
        Room3 = 4,
        Room4 = 5
    }

    shared class Layout {
        array<array<Layout::Exists>> roomExistance;
        DoorGen::DoorGrid@ doors;
        private int mapSize;

        Layout(int mapSize) {
            roomExistance = array<array<Layout::Exists>>(mapSize, array<Layout::Exists>(mapSize));
            @doors = DoorGen::DoorGrid(mapSize);
            this.mapSize = mapSize;
        }

        bool RoomExists(Coord c) {
            return roomExistance[c.X][c.Y] == Layout::Exists::Yes;
        }

        bool DoorExists(Coord from, Coord to) {
            if (from.X < 0 || from.Y < 0 || from.X >= mapSize || from.Y >= mapSize) {
                //Src room is out of bounds
                return false;
            }
            if (roomExistance[from.X][from.Y] == Layout::Exists::No) {
                //Src room doesn't exist
                return false;
            }
            if (to.X < 0 || to.Y < 0 || to.X >= mapSize || to.Y >= mapSize) {
                //Dest room is out of bounds
                return false;
            }
            if (roomExistance[to.X][to.Y] == Layout::Exists::No) {
                //Dest room doesn't exist
                return false;
            }

            DoorGen::Exists exists;
            if (from.X != to.X) { exists = doors.horizontal[DoorGen::DoorConnectCoord(from.Y, from.X, to.X)]; }
            else { exists = doors.vertical[DoorGen::DoorConnectCoord(from.X, from.Y, to.Y)]; }

            return exists == DoorGen::Exists::Yes;
        }

        void SetDoorExists(Coord from, Coord to, DoorGen::Exists exists) {
            if (from.X != to.X) {
                doors.horizontal[DoorGen::DoorConnectCoord(from.Y, from.X, to.X)] = exists;
            }
            else {
                doors.vertical[DoorGen::DoorConnectCoord(from.X, from.Y, to.Y)] = exists;
            }
        }

        bool adjacentDoorExists(int x, int y, int deltaX, int deltaY) {
            return DoorExists(Coord(x, y), Coord(x + deltaX, y + deltaY));
        }

        void removeAdjacentDoor(int x, int y, int deltaX, int deltaY) {
            SetDoorExists(Coord(x, y), Coord(x + deltaX, y + deltaY), DoorGen::Exists::No);
        }

        void CorrectInvalidState() {
            for (int x = 1; x < mapSize - 1; x++) {
                for (int y = 1; y < mapSize - 1; y++) {
                    if (GetRoomType(Coord(x, y)) == RoomType::None) {
                        roomExistance[x][y] = Exists::No;
                    }

                    if (!adjacentDoorExists(x, y, -1, 0)) {
                        removeAdjacentDoor(x, y, -1, 0);
                    }
                    if (!adjacentDoorExists(x, y, +1, 0)) {
                        removeAdjacentDoor(x, y, +1, 0);
                    }

                    if (!adjacentDoorExists(x, y, 0, -1)) {
                        removeAdjacentDoor(x, y, 0, -1);
                    }
                    if (!adjacentDoorExists(x, y, 0, +1)) {
                        removeAdjacentDoor(x, y, 0, +1);
                    }
                }
            }
        }

        RoomType GetRoomType(Coord c) {
            if (roomExistance[c.X][c.Y] == Exists::No) { return RoomType::None; }

            int doorCount = 0;
            if (adjacentDoorExists(c.X, c.Y, -1, 0)) { doorCount++; }
            if (adjacentDoorExists(c.X, c.Y, +1, 0)) { doorCount++; }
            if (adjacentDoorExists(c.X, c.Y, 0, -1)) { doorCount++; }
            if (adjacentDoorExists(c.X, c.Y, 0, +1)) { doorCount++; }

            switch (doorCount) {
            case 0:
                return RoomType::None;
            case 1:
                return RoomType::Room1;
            case 2:
                if (adjacentDoorExists(c.X, c.Y, -1, 0) && adjacentDoorExists(c.X, c.Y , +1, 0)) {
                    return RoomType::Room2;
                }
                else if (adjacentDoorExists(c.X, c.Y, 0, -1) && adjacentDoorExists(c.X, c.Y, 0, +1)) {
                    return RoomType::Room2;
                }
                else {
                    return RoomType::Room2C;
                }
            case 3:
                return RoomType::Room3;
            case 4:
                return RoomType::Room4;
            default:
                Debug::error("Invalid door count: " + toString(doorCount));
                return RoomType::None;
            }
        }

        array<int> GetRoomArrayCounts() {
            array<int> roomArray = {0, 0, 0, 0, 0, 0};
            for (int y = 0; y < mapSize; y++) {
                for (int x = 0; x < mapSize; x++) {
                    RoomType roomType = GetRoomType(Coord(x, y));
                    if (roomType != RoomType::None) {
                        roomArray[roomType] += 1;
                    }
                }
            }
            return roomArray;
        }
    }
}
