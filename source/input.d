module input;

import std.stdio;

import derelict.sdl2.sdl;

import window;

class Input
{
	this()
	{
		// Constructor code
	}

	private static bool[] keysHeld = new bool[500];
	private static bool[] mouseButtonsHeld = new bool[10];

	public static void update()
	{
		SDL_Event event;
		
		while(SDL_PollEvent(&event))
		{

			if(event.key.keysym.sym < 500)
			{
				keysHeld[event.key.keysym.sym] = event.type == SDL_KEYDOWN;
			}

			switch(event.type)
			{
				case SDL_KEYDOWN:
					if(SDLK_ESCAPE == event.key.keysym.sym)
					{
						//running = false;
					}
					break;
				case SDL_QUIT:
					//running = false;
					Window.setRequestedClose(true);
					break;
				default:
					break;
					
			}
		}
	}

	public static bool isKeyPressed(int keyCode)
	{
//		writefln("kc: %d", keyCode);
		return keysHeld[keyCode];
	}

	public static bool isMouseButtonPressed(int keyCode)
	{
		return mouseButtonsHeld[keyCode];
	}

}

