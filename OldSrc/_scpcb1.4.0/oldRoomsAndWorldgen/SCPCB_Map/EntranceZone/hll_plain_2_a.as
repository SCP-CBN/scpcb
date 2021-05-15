class hll_plain_2_a : Room {
    hll_plain_2_a(string name, Zone@ zone) {
        super(name, zone);
    }

    void update(float deltaTime) {
        rotation += 0.01;
    }
}
