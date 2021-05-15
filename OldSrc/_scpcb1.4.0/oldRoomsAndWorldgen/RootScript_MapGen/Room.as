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
