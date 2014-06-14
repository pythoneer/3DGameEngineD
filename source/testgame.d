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
import engine.rendering.camera;
import engine.rendering.material;
import engine.rendering.directionallight;
import engine.rendering.baselight;
import engine.rendering.pointlight;
import engine.rendering.attenuation;
import engine.rendering.spotlight;
import engine.rendering.texture;


class TestGame : Game
{
//	private Mesh mesh;
//	private Transform transform;
	private Camera camera;
//	private Material material;
//	private GameObject root;

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
		//		mesh = new Mesh("box.obj");//ResourceLoader.loadMesh("box.obj");//new Mesh();
		camera = new Camera();
//		material = new Material(ResourceLoader.loadTexture("test.png"), new Vector3f(1,1,1));
//		material = new Material(ResourceLoader.loadTexture("test.png"), new Vector3f(1,1,1), 1, 8);
//		material = new Material(new Texture("test.png"), new Vector3f(1,1,1), 1, 8);
// 		shader = new BasicShader();
//		shader = new PhongShader();
//		transform = new Transform();
//		root = new GameObject();
		
//		Vertex[] vertices = [new Vertex(new Vector3f(-1.0f, -1.0f, 0.5773f), new Vector2f(0,0)),
//						 	new Vertex(new Vector3f(0.0f, -1.0f, -1.15475f), new Vector2f(0.5f,0)),
//						 	new Vertex(new Vector3f(1.0f, -1.0f, 0.5773f), new Vector2f(1.0f,0)),
//						 	new Vertex(new Vector3f(0.0f, 1.0f, 0.0f), new Vector2f(0.5f,1.0f))];
//		
//		int[] indices = [0, 3, 1,
//					     1, 3, 2,
//					     2, 3, 0,
//					     1, 2, 0];
		
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

		Transform.setProjection(70f, Window.getWidth(), Window.getHeight(), 0.1f, 1000);
		Transform.setCamera(camera);			      
		
		//mesh.addVertices(vertices, indices, true);
//		mesh = new Mesh(vertices, indices, true);
		
//		Mesh mesh = new Mesh(vertices, indices, true);
// 		Material material = new Material(new Texture("test.png"), new Vector3f(1,1,1), 1, 8);
// 
// 		MeshRenderer meshRenderer = new MeshRenderer(mesh, material);
// 		root.addComponent(meshRenderer);
//		
//		Transform.setProjection(70f, Window.getWidth(), Window.getHeight(), 0.1f, 1000);		
//		Transform.setCamera(camera);
		
//		(cast(PhongShader)shader).setAmbientLight(new Vector3f(0.1f,0.1f,0.1f));
//		(cast(PhongShader)shader).setDirectionalLight(new DirectionalLight(new BaseLight(new Vector3f(1,1,1), 0.1f), new Vector3f(1,1,1)));
//		(cast(PhongShader)shader).setDirectionalLight(new DirectionalLight(new BaseLight(new Vector3f(1,1,1), 0.8f), new Vector3f(1,1,1)));
//		
//		PointLight[] lights = [pLight1, pLight2];		
//		(cast(PhongShader)shader).setPointLight(lights);
//		
//		SpotLight[] sLights = [sLight1];
//		(cast(PhongShader)shader).setSpotLights(sLights);
	}

//	override
//	public void input()
//	{
//		
//		camera.input();		
//		root.input();
//		
////		if(Input.isKeyPressed(SDLK_w))
////		{
////			writeln("w is pressed");
////		}
//
//	}
//	
////	float temp = 0.0f;
//	
//	override
//	public void update()
//	{
//		
//		root.getTransform().setTranslation(0, -1, 5);
// 		root.update();
//		
////		temp += Time.getDelta();
////		
////		float sinTemp = cast(float)sin(temp);
//////		
//////		transform.setTranslation(0, 0, 5);
////		transform.setRotation(sinTemp * 10, sinTemp * 180, sinTemp * 45);
//////		transform.setRotation(sinTemp * 10, sinTemp * 180, sinTemp * 45);
//////		transform.setScale(sinTemp, sinTemp, sinTemp);
////		
////		transform.setTranslation(sinTemp * 2, 0, 5);
////// 		transform.setTranslation(0, 0, 5);
//////  		transform.setRotation(0, sinTemp * 180, 0);
//		
////		transform.setTranslation(0, -1, 5);
////		pLight1.setPosition(new Vector3f(3,0,8.0f * cast(float)(sin(temp) + 1.0f/2.0f) + 10f));
////		pLight2.setPosition(new Vector3f(7,0,8.0f * cast(float)(cos(temp) + 1.0f/2.0f) + 10f));
////			
////			
////		sLight1.getPointLight().setPosition(camera.getPos());
//// 		sLight1.setDirection(camera.getForward());
//	}
//	
//	public void render()
//	{
//		root.render();
////		shader.bind();
////		shader.updateUniforms(transform.getTransformation(), transform.getProjectedTransformation(), material);
////		mesh.draw();
//	}
}