module game;

import std.stdio;

//import derelict.sdl2.sdl;

//import window;
import input;
import mesh;
import shader;
import vertex;
import vector3f;
import resourceLoader;

class Game
{
	private Mesh mesh;
	private Shader shader;


	this()
	{
		mesh = new Mesh();
		shader = new Shader();
	
		Vertex[] data = new Vertex[3];
		data[0] = new Vertex(new Vector3f(-1,-1,0));
     	data[1] = new Vertex(new Vector3f(0,1,0));
     	data[2] = new Vertex(new Vector3f(1,-1,0));
		
		mesh.addVertices(data);
		
		shader.addVertexShader(ResourceLoader.loadShader("basicVertex.vs"));
		shader.addFragmentShader(ResourceLoader.loadShader("basicFragment.fs"));
		shader.compileShader();

	}

	public void input()
	{


//		if(Input.isKeyPressed(SDLK_w))
//		{
//			writeln("w is pressed");
//		}
//


//		writeln("Game input triggered");

//		SDL_Event event;
//
//		SDL_PollEvent(&event);
//
//		switch(event.type)
//		{
//			case SDL_KEYDOWN:
//				if(SDLK_ESCAPE == event.key.keysym.sym)
//				{
//					//running = false;
//				}
//				break;
//			case SDL_QUIT:
//				//running = false;
//				Window.setRequestedClose(true);
//				break;
//			default:
//				break;
//				
//		}


//		if(Input.getKeyDown(Keyboard.KEY_UP))
//			System.out.println("We've just pressed up!");
//		if(Input.getKeyUp(Keyboard.KEY_UP))
//			System.out.println("We've just released up!");
//		
//		if(Input.getMouseDown(1))
//			System.out.println("We've just right clicked at " + Input.getMousePosition().toString());
//		if(Input.getMouseUp(1))
//			System.out.println("We've just released right mouse button!");
	}
	
	public void update()
	{
	}
	
	public void render()
	{
		shader.bind();
		mesh.draw();
	}
}

