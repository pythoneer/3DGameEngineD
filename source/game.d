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

class Game
{
	private Mesh mesh;
	private Shader shader;
	private Transform transform;
	private Camera camera;
	private Material material;


	this()
	{
		mesh = new Mesh();//ResourceLoader.loadMesh("box.obj");//new Mesh();
		camera = new Camera();
		material = new Material(ResourceLoader.loadTexture("test.png"), new Vector3f(1,1,1));
// 		shader = new BasicShader();
		shader = new PhongShader();
		transform = new Transform();
		
		Vertex[] vertices = [new Vertex(new Vector3f(-1.0f, -1.0f, 0.5773f), new Vector2f(0,0)),
						 	new Vertex(new Vector3f(0.0f, -1.0f, -1.15475f), new Vector2f(0.5f,0)),
						 	new Vertex(new Vector3f(1.0f, -1.0f, 0.5773f), new Vector2f(1.0f,0)),
						 	new Vertex(new Vector3f(0.0f, 1.0f, 0.0f), new Vector2f(0.5f,1.0f))];
		
		int[] indices = [0, 3, 1,
					     1, 3, 2,
					     2, 3, 0,
					     1, 2, 0];
		
		mesh.addVertices(vertices, indices, true);
		
		Transform.setProjection(70f, Window.getWidth(), Window.getHeight(), 0.1f, 1000);
		
		Transform.setCamera(camera);
		
		
		PhongShader.setAmbientLight(new Vector3f(0.1f,0.1f,0.1f));
		PhongShader.setDirectionalLight(new DirectionalLight(new BaseLight(new Vector3f(1,1,1), 0.8f), new Vector3f(1,1,1)));
		
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
//		transform.setTranslation(0, 0, 5);
		transform.setRotation(sinTemp * 10, sinTemp * 180, sinTemp * 45);
//		transform.setRotation(sinTemp * 10, sinTemp * 180, sinTemp * 45);
//		transform.setScale(sinTemp, sinTemp, sinTemp);
		
		transform.setTranslation(sinTemp, 0, 5);
// 		transform.setTranslation(0, 0, 5);
//  		transform.setRotation(0, sinTemp * 180, 0);
			
	}
	
	public void render()
	{
		shader.bind();
		shader.updateUniforms(transform.getTransformation(), transform.getProjectedTransformation(), material);
		mesh.draw();
	}
}

