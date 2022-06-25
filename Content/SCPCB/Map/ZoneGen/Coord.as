shared class Coord {
    int X;
    int Y;

    Coord(int X, int Y) {
        this.X = X;
        this.Y = Y;
    }

    Coord@ opAssign(const Coord &in other){
        this.X = other.X;
        this.Y = other.Y;
        return this;
    }


    Coord(const Coord &in copy) {
        X = copy.X;
        Y = copy.Y;
    }
}
