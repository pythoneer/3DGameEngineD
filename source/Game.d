module game;

import std.stdio;

import derelict.sdl2.sdl;

//import window;
import input;

class Game
{

	this()
	{
	}

	public void input()
	{


		if(Input.isKeyPressed(SDLK_w))
		{
			writeln("w is pressed");
		}



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
	}
}

