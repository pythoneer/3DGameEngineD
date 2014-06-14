module testgame;

import std.math;

import engine.core.game;
import engine.core.input;
import engine.core.vector3f;
import engine.core.vector2f;
import engine.core.time;
import engine.core.transform;
import engine.core.gameobject;
import engine.rendering.window;
import engine.rendering.mesh;
import engine.rendering.meshrenderer;
import engine.rendering.shader;
import engine.rendering.basicshader;
import engine.rendering.phongshader;
import engine.rendering.vertex;
import engine.rendering.material;
import engine.rendering.directionallight;
import engine.rendering.baselight;
import engine.rendering.pointlight;
import engine.rendering.attenuation;
import engine.rendering.spotlight;
import engine.rendering.texture;


class TestGame : Game
{

	PointLight pLight1 = new PointLight(new BaseLight(new Vector3f(1,0.5f,0), 0.8f), new Attenuation(0,0,1), new Vector3f(-2,0,5f), 10f);
 	PointLight pLight2 = new PointLight(new BaseLight(new Vector3f(0,0.5f,1), 0.8f), new Attenuation(0,0,1), new Vector3f(2,0,7f), 10f);
 	
 	SpotLight sLight1 = new SpotLight(new PointLight(new BaseLight(new Vector3f(0,1f,1f), 0.8f), new Attenuation(0,0,0.1f), new Vector3f(-2,0,5f), 30f),
 									  new Vector3f(1,1,1), 0.7f);

	this()
	{
	}
	
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
		planeObject.getTransform().setTranslation(0, -1, 5);

		getRootObject().addChild(planeObject);
		      
				
	}

}