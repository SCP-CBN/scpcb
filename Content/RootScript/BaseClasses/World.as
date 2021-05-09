// Script: RootScript/BaseClasses/World.as
// Purpose: Generic baseclasses such as World::Model with a model and coordinates.


namespace World {

	shared class Model {
		::Model@ mesh;
		Model(string&in cpath) {
			@mesh=::Model::create(cpath);
			mesh.position=Vector3f(0,0,0);
			mesh.rotation=Vector3f(0,0,0);
			mesh.scale=Vector3f(1,1,1);
		}
		~Model() { ::Model::destroy(mesh); }
		Vector3f position { get { return mesh.position; } set { mesh.position = value; } }
		Vector3f rotation { get { return mesh.rotation; } set { mesh.rotation = value; } }
		Vector3f scale { get { return mesh.scale; } set { mesh.scale = value; } }
		void render() { mesh.render(); }

		bool physAlive;
		int physGravity = 0.5;
	}

	shared class ModelPicker : Model {
		Pickable@ picker;
		ModelPicker(string&in cpath) { super(cpath);
			@picker=Pickable();
			picker.position=Vector3f(0,0,0);
			pickable(true);
		}
		~ModelPicker() { ::Model::destroy(mesh); pickable(false); }
		Vector3f position { get { return mesh.position; } set { mesh.position = value; picker.position = value; } }
		bool picked { get { return picker.getPicked(); } }
		void pickable(bool pick) {
			if(pick) {
				Pickable::activatePickable(picker);
			} else {
				Pickable::deactivatePickable(picker);
			}
		}
	}

	shared abstract class Icon {
		// Texture must be built during execution stage.
		Texture@ texture;
		Icon() {}
	}

	shared class ModelIcon : Icon {
		string iconPath;
		float iconScale;
		Vector3f iconRot;
		Vector2f iconPos;
		ModelIcon(string&in cpath, float&in cscale, Vector3f&in crot, Vector2f&in cpos) { super();
			iconPath=cpath;
			iconScale=cscale;
			iconRot=crot;
			iconPos=cpos;
			@texture = ModelImageGenerator::generate(iconPath, iconScale, iconRot, iconPos);
		}
	}

	shared class GraphicIcon : Icon {
	}

}