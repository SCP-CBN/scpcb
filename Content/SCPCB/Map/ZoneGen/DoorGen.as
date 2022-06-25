namespace DoorGen {
    shared enum Exists {
        Yes,
        No
    }

    shared class DoorConnectCoord {
        int axis;
        int toCoord;
        int fromCoord;

        DoorConnectCoord(int axis, int toCoord, int fromCoord) {
            this.axis = axis;
            if (toCoord < fromCoord) {
                this.toCoord = toCoord;
                this.fromCoord = fromCoord;
            }
            else {
                this.fromCoord = toCoord;
                this.toCoord = fromCoord;
            }
            ValidateIndices();
        }

        private void ValidateIndices() {
            if (fromCoord - toCoord != 1) {
                Debug::error("Can't find the door between" + toString(toCoord) + " and " + toString(fromCoord) + " on axis: " + toString(axis));
            }
        }
    }

    shared class DoorArray {
        array<array<DoorGen::Exists>> states;

        DoorArray(int MapSize) {
            states = array<array<Exists>>(MapSize, array<Exists>(MapSize - 1));
        }

        DoorGen::Exists get_opIndex(DoorConnectCoord connectAxis) property {
            return states[connectAxis.axis][connectAxis.toCoord];
        }
        void set_opIndex(DoorConnectCoord@ connectAxis, const DoorGen::Exists &in value) property {
            states[connectAxis.axis][connectAxis.toCoord] = value;
        }

        DoorArray& opAssign(const DoorArray& in other) { 
            states = other.states;
            return this;
        }
    }
    
    shared class DoorGrid {
        DoorArray@ horizontal;
        DoorArray@ vertical;

        DoorGrid(int mapSize) {
            @horizontal = DoorArray(mapSize);
            @vertical = DoorArray(mapSize);
        }
    }
}
