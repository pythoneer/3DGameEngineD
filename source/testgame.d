module testgame;

import std.math;

import engine.core.game;
import engine.core.input;
import engine.core.vector3f;
import engine.core.vector2f;
import engine.core.quaternion;
import engine.core.time;
import engine.core.transform;
import engine.core.gameobject;
import engine.core.util;
import engine.rendering.window;
import engine.rendering.mesh;
import engine.rendering.meshrenderer;
import engine.rendering.shader;
import engine.rendering.basicshader;
import engine.rendering.vertex;
import engine.rendering.material;
import engine.rendering.texture;
import engine.components.baselight;
import engine.components.directionallight;
import engine.components.pointlight;
import engine.components.spotlight;

class TestGame : Game
{	
	override
	public void init()
	{	
		float fieldDepth = 10.0f;
		float fieldWidth = 10.0f;

		Vertex[] vertices = [ 	new Vertex( new Vector3f(-fieldWidth, 0.0f, -fieldDepth), new Vector2f(0.0f, 0.0f)),
				new Vertex( new Vector3f(-fieldWidth, 0.0f, fieldDepth * 3), new Vector2f(0.0f, 1.0f)),
				new Vertex( new Vector3f(fieldWidth * 3, 0.0f, -fieldDepth), new Vector2f(1.0f, 0.0f)),
				new Vertex( new Vector3f(fieldWidth * 3, 0.0f, fieldDepth * 3), new Vector2f(1.0f, 1.0f))];

		int indices[] = [ 0, 1, 2,
				2, 1, 3];

		Mesh mesh = new Mesh(vertices, indices, true);
		Material material = new Material(new Texture("test.png"), new Vector3f(1,1,1), 1, 8);

		MeshRenderer meshRenderer = new MeshRenderer(mesh, material);

		GameObject planeObject = new GameObject();
		planeObject.addComponent(meshRenderer);
		planeObject.getTransform().getPos().set(0, -1, 5);

		GameObject directionalLightObject = new GameObject();
		DirectionalLight directionalLight = new DirectionalLight(new Vector3f(0,0,1), 0.4f, new Vector3f(1,1,1));
		directionalLightObject.addComponent(directionalLight);

		GameObject pointLightObject = new GameObject();
		pointLightObject.addComponent(new PointLight(new Vector3f(0,1,0), 0.4f, new Vector3f(0,0,1)));

		SpotLight spotLight = new SpotLight(new Vector3f(0,1,1), 0.4f,
				new Vector3f(0,0,0.1f), 0.7f);

		GameObject spotLightObject = new GameObject();
		spotLightObject.addComponent(spotLight);

		spotLightObject.getTransform().getPos().set(5, 0, 5);
		spotLightObject.getTransform().setRot(new Quaternion().initRotation(new Vector3f(0,1,0), cast(float)Util.toRadians(-90.0f)));

		getRootObject().addChild(planeObject);
		getRootObject().addChild(directionalLightObject);
		getRootObject().addChild(pointLightObject);
		getRootObject().addChild(spotLightObject);
	}
}