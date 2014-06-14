module game;

import std.stdio;
import std.math;

import derelict.sdl2.sdl;
//import gl3n.linalg;
//import gl3n.math;

import window;
import input;
import mesh;
import shader;
import basicshader;
import phongshader;
import vertex;
import vector3f;
import vector2f;
import resourceloader;
import time;
import transform;
import camera;
import material;
import directionallight;
import baselight;
import pointlight;
import attenuation;

class Game
{
	private Mesh mesh;
	private Shader shader;
	private Transform transform;
	private Camera camera;
	private Material material;

	PointLight pLight1 = new PointLight(new BaseLight(new Vector3f(1,0.5f,0), 0.8f), new Attenuation(0,0,1), new Vector3f(-2,0,5f));
 	PointLight pLight2 = new PointLight(new BaseLight(new Vector3f(0,0.5f,1), 0.8f), new Attenuation(0,0,1), new Vector3f(2,0,7f));

	this()
	{
		mesh = new Mesh();//ResourceLoader.loadMesh("box.obj");//new Mesh();
		camera = new Camera();
//		material = new Material(ResourceLoader.loadTexture("test.png"), new Vector3f(1,1,1));
		material = new Material(ResourceLoader.loadTexture("test.png"), new Vector3f(1,1,1), 1, 8);
// 		shader = new BasicShader();
		shader = new PhongShader();
		transform = new Transform();
		
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
		
		mesh.addVertices(vertices, indices, true);
		
		Transform.setProjection(70f, Window.getWidth(), Window.getHeight(), 0.1f, 1000);		
		Transform.setCamera(camera);
		
		(cast(PhongShader)shader).setAmbientLight(new Vector3f(0.1f,0.1f,0.1f));
//		shader.setDirectionalLight(new DirectionalLight(new BaseLight(new Vector3f(1,1,1), 0.8f), new Vector3f(1,1,1)));
		
		PointLight[] lights = [pLight1, pLight2];		
		(cast(PhongShader)shader).setPointLight(lights);
		
	}

	public void input()
	{
		
		camera.input();
		
//		if(Input.isKeyPressed(SDLK_w))
//		{
//			writeln("w is pressed");
//		}

	}
	
	float temp = 0.0f;
	
	public void update()
	{
		temp += Time.getDelta();
		
		float sinTemp = cast(float)sin(temp);
//		
////		transform.setTranslation(0, 0, 5);
//		transform.setRotation(sinTemp * 10, sinTemp * 180, sinTemp * 45);
////		transform.setRotation(sinTemp * 10, sinTemp * 180, sinTemp * 45);
////		transform.setScale(sinTemp, sinTemp, sinTemp);
//		
//		transform.setTranslation(sinTemp * 2, 0, 5);
//// 		transform.setTranslation(0, 0, 5);
////  		transform.setRotation(0, sinTemp * 180, 0);
		
		transform.setTranslation(0, -1, 5);
		pLight1.setPosition(new Vector3f(3,0,8.0f * cast(float)(sin(temp) + 1.0f/2.0f) + 10f));
		pLight2.setPosition(new Vector3f(7,0,8.0f * cast(float)(cos(temp) + 1.0f/2.0f) + 10f));
			
	}
	
	public void render()
	{
		shader.bind();
		shader.updateUniforms(transform.getTransformation(), transform.getProjectedTransformation(), material);
		mesh.draw();
	}
}

