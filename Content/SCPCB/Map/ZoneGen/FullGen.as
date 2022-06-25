namespace FullGen {
    shared class MapFullGen {
        int MapSize;
        private Layout::Layout@ layout;

        MapFullGen(int mapSize) {
            this.MapSize = mapSize;
            @layout = Layout::Layout(this.MapSize);

            Debug::log("Carved");
            carveCircle();
            printRoomCount();

            Debug::log("Poked");
            pokeHoles();
            printRoomCount();

            Debug::log("Corrected States");
            layout.CorrectInvalidState();
            printRoomCount();

            Debug::log("Improved");
            ImproveMapGen(0.001f);
            layout.CorrectInvalidState();

            printExistanceType();
            printRoomCount();
        }

        void carveCircle() {
            int halfMapSize = MapSize / 2;
            for (int y = 0; y < MapSize; y++) {
                for (int x = 0; x < MapSize; x++) {
                    int nx = x - halfMapSize;
                    int ny = y - halfMapSize;
                    if ((nx * nx + ny * ny) < halfMapSize * halfMapSize) {
                        layout.roomExistance[x][y] = Layout::Exists::Yes;
                    }
                    else {
                        layout.roomExistance[x][y] = Layout::Exists::No;
                    }
                }
            }
            printExistanceType();   
        }

        void pokeHoles() {
            const float holeChance = 0.05;
            for (int y = 0; y < MapSize; y++) {
                for (int x = 0; x < MapSize; x++) {
                    float doorRemoveChance;
                    Coord @currCoord = Coord(x, y);
                    switch (layout.GetRoomType(currCoord)) {
                    case Layout::RoomType::Room2: doorRemoveChance = 0.01f; break;
                    case Layout::RoomType::Room2C: doorRemoveChance = 0.01f; break;
                    case Layout::RoomType::Room3: doorRemoveChance = 0.05f; break;
                    case Layout::RoomType::Room4: doorRemoveChance = 0.06f; break;
                    default: doorRemoveChance = 0.0f; break;
                    }

                    Random@ rng = Random();
                    if (rng.nextFloat() < holeChance) {
                        layout.roomExistance[currCoord.X][currCoord.Y] = Layout::Exists::No;
                    }

                    //remove left door
                    if (currCoord.X > 0 and (rng.nextFloat() < doorRemoveChance)) {
                        layout.doors.horizontal[DoorGen::DoorConnectCoord(currCoord.Y, currCoord.X, currCoord.X - 1)] = DoorGen::Exists::No;
                    }

                    //remove right door
                    if (currCoord.X < (MapSize - 1) and (rng.nextFloat() < doorRemoveChance)) {
                        layout.doors.horizontal[DoorGen::DoorConnectCoord(currCoord.Y, currCoord.X, currCoord.X + 1)] = DoorGen::Exists::No;
                    }

                    //remove top door
                    if (currCoord.Y > 0 and (rng.nextFloat() < doorRemoveChance)) {
                        layout.doors.vertical[DoorGen::DoorConnectCoord(currCoord.X, currCoord.Y, currCoord.Y - 1)] = DoorGen::Exists::No;
                    }

                    //remove bottom door
                    if (currCoord.Y < (MapSize - 1) and (rng.nextFloat() < doorRemoveChance)) {
                        layout.doors.vertical[DoorGen::DoorConnectCoord(currCoord.X, currCoord.Y, currCoord.Y + 1)] = DoorGen::Exists::No;
                    }
                }
            }
            printExistanceType();
        }

        void printExistance() {
            Debug::log("Printing Existence");
            for (int y = 0; y < MapSize; y++) {
                string line = "";
                for (int x = 0; x < MapSize; x++) {
                    line = line + toString(layout.roomExistance[x][y]);
                }
                Debug::log(line);
            }
        }

        void printRoomCount() {
            array<int> roomArray = {0, 0, 0, 0, 0, 0};
            float totalroomcount = 0.0f;
            for (int y = 0; y < MapSize; y++) {
                for (int x = 0; x < MapSize; x++) {
                    Layout::RoomType roomType = layout.GetRoomType(Coord(x, y));
                    if (roomType != Layout::RoomType::None) {
                        roomArray[roomType] += 1;
                        totalroomcount += 1;
                    }
                }
            }
            Debug::log("Total print count: " + toString(totalroomcount));
            for (int i = 0; i <= 5; i++) {
                string access = toString(i);
                Debug::log("Printing room " + toString(i) + " : " + toString(roomArray[i]) + " : " + toString(float(roomArray[i]) / totalroomcount));
            }
        }

        void printExistanceType() {
            Debug::log("Printing Existence Type");
            for (int y = 0; y < MapSize; y++) {
                string line = "";
                for (int x = 0; x < MapSize; x++) {
                    Coord @currCoord = Coord(x, y);
                    line = line + toString(layout.GetRoomType(currCoord));
                }
                Debug::log(line);
            }
        }

        void ImproveMapGen(float temperatureDecay) {
            Random@ rng = Random();
            
            //Had issues with AS dictionary
            //RoomArrayCounts/TargetProportions follows enum scheme
            //[0] = None, [1] = Room1, [2] = Room2, [3] = Room2C, [4] = Room3, [5] = Room4

            array<float> targetProportions = { 0, 0.1, 0.3, 0.2, 0.3, 0.1 };
            //array<float> targetProportions = { 0, 0, 0, 0, 0, 1 };

            array<int>@ roomArrayCounts = layout.GetRoomArrayCounts();
            int totalRooms = roomCount(roomArrayCounts);

            float temperature = 0.5f;
            while (temperature > 0.0f) {
                Coord@ targetCoord;
                Layout::RoomType targetType;
                do {
                    int newX = rng.nextInt(0, MapSize);
                    int newY = rng.nextInt(0, MapSize);
                    @targetCoord = Coord(newX, newY);
                    targetType = layout.GetRoomType(targetCoord);
                } while (!layout.RoomExists(targetCoord));

                Coord@ adjacentCoord;
                do {
                    int n = rng.nextInt(0, 4);
                    switch (n) {
                    case 0: @adjacentCoord = Coord(targetCoord.X - 1, targetCoord.Y); break;
                    case 1: @adjacentCoord = Coord(targetCoord.X, targetCoord.Y - 1); break;
                    case 2: @adjacentCoord = Coord(targetCoord.X + 1, targetCoord.Y); break;
                    case 3: @adjacentCoord = Coord(targetCoord.X, targetCoord.Y + 1); break;
                    }
                } while (!layout.RoomExists(adjacentCoord));

                int oldScore = score(roomArrayCounts, targetProportions);
                flipDoor(targetCoord, adjacentCoord, roomArrayCounts);

                if (score(roomArrayCounts, targetProportions) < oldScore and rng.nextFloat() >= temperature) {
                    flipDoor(targetCoord, adjacentCoord, roomArrayCounts);
                }

                temperature -= temperatureDecay;
            }
        }

        float targetRoomCount(array<float> &inout target, Layout::RoomType roomType, int roomSum) {
            return Math::floor(target[roomType] * roomSum);
        }

        int score(array<int> roomTypeCounts, array<float> targetProp) {
            int sum = 0;
            for (int i = 1; i <= 5; i++) {
                //ugly will fix
                sum = sum + Math::absFloat(targetRoomCount(targetProp, Layout::RoomType(i), roomCount(roomTypeCounts)) - int(roomTypeCounts[i]));
            }
            return roomCount(roomTypeCounts) - sum;
        }

        void flipDoor(Coord targetCoord, Coord adjacentCoord, array<int> &inout roomTypeCounts) {
            Layout::RoomType prevTargetType = layout.GetRoomType(targetCoord);
            Layout::RoomType prevAdjacentType = layout.GetRoomType(adjacentCoord);

            if (layout.DoorExists(targetCoord, adjacentCoord)) {
                layout.SetDoorExists(targetCoord, adjacentCoord, DoorGen::Exists::No);
            }
            else {
                layout.SetDoorExists(targetCoord, adjacentCoord, DoorGen::Exists::Yes);
            }

            Layout::RoomType newTargetType = layout.GetRoomType(targetCoord);
            Layout::RoomType newAdjacentType = layout.GetRoomType(adjacentCoord);

            tryDecrement(roomTypeCounts, prevTargetType);
            tryDecrement(roomTypeCounts, prevAdjacentType);
            tryIncrement(roomTypeCounts, newTargetType);
            tryIncrement(roomTypeCounts, newAdjacentType);
        }

        int roomCount(array<int> roomTypeCounts) {
            int sum = 0;
            for (int i = 1; i <= 5; i++) {
                sum += roomTypeCounts[i];
            }
            return sum;
        }

        void tryIncrement(array<int> &inout roomTypeCounts, Layout::RoomType roomType) {
            if (roomType >= 1 and roomType <= 5) {
                roomTypeCounts[roomType] = int (roomTypeCounts[roomType]) + 1;
            }
        }

        void tryDecrement(array<int>&inout roomTypeCounts, Layout::RoomType roomType) {
            if (roomType >= 1 and roomType <= 5) {
                roomTypeCounts[roomType] = int(roomTypeCounts[roomType]) - 1;
            }
        }
    }
}
