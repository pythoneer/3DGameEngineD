module game;

import std.stdio;
import std.math;

import derelict.sdl2.sdl;
import gl3n.linalg;
import gl3n.math;

//import window;
import input;
import mesh;
import shader;
import vertex;
//import vector3f;
import resourceLoader;
import time;
import transform;

class Game
{
	private Mesh mesh;
	private Shader shader;
	private Transform transform;


	this()
	{
		mesh = ResourceLoader.loadMesh("box.obj");//new Mesh();
		shader = new Shader();
	

//		Vertex[] data = [new Vertex(vec3d(-1,-1,0)),
//						 new Vertex(vec3d(0,1,0)),
//						 new Vertex(vec3d(1,-1,0)),
//						 new Vertex(vec3d(0,-1,1))];
//	
//		
//		
//		int[] indices = [0,1,3,
//					     3,1,2,
//					     2,1,0,
//					     0,2,3];
//		
//		mesh.addVertices(data, indices);
		
		transform = new Transform();
		
		shader.addVertexShader(ResourceLoader.loadShader("basicVertex.vs"));
		shader.addFragmentShader(ResourceLoader.loadShader("basicFragment.fs"));
		shader.compileShader();
		
		shader.addUniform("transform");

	}

	public void input()
	{
		if(Input.isKeyPressed(SDLK_w))
		{
			writeln("w is pressed");
		}

	}
	
	float temp = 0.0f;
	
	public void update()
	{
		temp += Time.getDelta();
		
		float sinTemp = cast(float)sin(temp);
		
		transform.setTranslation(sinTemp, 0, 0);
		transform.setRotation(0, sinTemp * 180, 0);
		transform.setScale(clamp(sinTemp, 0.5, 0.85), clamp(sinTemp, 0.5, 0.85), clamp(sinTemp, 0.5, 0.85));
	}
	
	public void render()
	{
		shader.bind();
		shader.setUniform("transform", transform.getTransformation());
		mesh.draw();
	}
}

