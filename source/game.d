module game;

import std.stdio;
import std.math;

import derelict.sdl2.sdl;
import gl3n.linalg;

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
		mesh = new Mesh();
		shader = new Shader();
	
		Vertex[] data = new Vertex[3];
		data[0] = new Vertex( vec3d(-1,-1,0));
     	data[1] = new Vertex( vec3d(0,1,0));
     	data[2] = new Vertex( vec3d(1,-1,0));
		
		mesh.addVertices(data);
		
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
		transform.setRotation(0, 0, sinTemp * 180);
		transform.setScale(sinTemp, sinTemp, sinTemp);
	}
	
	public void render()
	{
		shader.bind();
		shader.setUniform("transform", transform.getTransformation());
		mesh.draw();
	}
}

