﻿module game;

import std.stdio;
import std.math;

import derelict.sdl2.sdl;
//import gl3n.linalg;
//import gl3n.math;

import window;
import input;
import mesh;
import shader;
import vertex;
import vector3f;
import resourceLoader;
import time;
import transform;
import camera;

class Game
{
	private Mesh mesh;
	private Shader shader;
	private Transform transform;
	private Camera camera;


	this()
	{
		mesh = ResourceLoader.loadMesh("box.obj");//new Mesh();
		shader = new Shader();
		camera = new Camera();
	
//
//		Vertex[] data = [new Vertex(new Vector3f(-1,-1,0)),
//						 new Vertex(new Vector3f(0,1,0)),
//						 new Vertex(new Vector3f(1,-1,0)),
//						 new Vertex(new Vector3f(0,-1,1))];
//	
//		
//		
//		int[] indices = [0,1,3,
//					     3,1,2,
//					     2,1,0,
//					     0,2,3];
//		
//		mesh.addVertices(data, indices);
		
		Transform.setProjection(70f, Window.getWidth(), Window.getHeight(), 0.1f, 1000);
		transform = new Transform();
		Transform.setCamera(camera);
		
		
		shader.addVertexShader(ResourceLoader.loadShader("basicVertex.vs"));
		shader.addFragmentShader(ResourceLoader.loadShader("basicFragment.fs"));
		shader.compileShader();
		
		shader.addUniform("transform");
//		shader.addUniform("uni");

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
		transform.setTranslation(sinTemp * 2, 0, 5);
		transform.setRotation(sinTemp * 10, sinTemp * 180, sinTemp * 45);
//		transform.setScale(sinTemp, sinTemp, sinTemp);
	}
	
	public void render()
	{
		shader.bind();
		shader.setUniform("transform", transform.getProjectedTransformation());
//		shader.setUniform("transform", transform.getTransformation());
//		shader.setUniformf("uni", cast(float)sin(temp));
		mesh.draw();
	}
}

