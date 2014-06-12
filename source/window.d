module window;

import std.stdio;
import std.string;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;
import derelict.freeimage.freeimage;

class Window
{
	private static SDL_Window *m_window;
	private static SDL_GLContext m_context;
	
	private static bool isRequestingClose;
	
	
	private static int width;
	private static int height;

	this()
	{
		isRequestingClose = false;
	}

	public static void createWindow(int width, int height, string title)
	{
		Window.width = width;
		Window.height = height;
		
		// Load OpenGL versions 1.0 and 1.1.
		DerelictGL3.load();

		// Load the SDL 2 library.
		DerelictSDL2.load();

		if (SDL_Init(SDL_INIT_VIDEO) < 0) {  //SDL_INIT_VIDEO  SDL_INIT_EVERYTHING
//			throw new Exception("Failed to initialize SDL: " ~ to!string(SDL_GetError()));
			writeln("Could not create sdl");
		}
		
		// Set OpenGL version
//		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
//		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 4);
		
		// Set OpenGL attributes
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
		SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
		
		m_window = SDL_CreateWindow(
			title.toStringz(),                  	// window title
			SDL_WINDOWPOS_UNDEFINED,           		// initial x position
			SDL_WINDOWPOS_UNDEFINED,           		// initial y position
			width,                               	// width, in pixels
			height,                               	// height, in pixels
			SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL    // flags - see below  // SDL_WINDOW_OPENGL
			);
					
		if (m_window == null) {
			// In the event that the window could not be made...
			writefln("Could not create window: %s\n", SDL_GetError());
			return;
		}
		else
		{
			writeln("SDL window created");
		}

		//create a valid SDL context for opengl e.g. to allow derelic.reload();
		m_context = SDL_GL_CreateContext(m_window);
		// Load versions 1.2+ and all supported ARB and EXT extensions.
		DerelictGL3.reload();


		//load freeimage
		DerelictFI.load();
	}
	
	public static void render()
	{
		SDL_GL_SwapWindow(m_window);
	}

	public static void delay()
	{
		SDL_Delay(1);
	}
	
	public static void dispose()
	{
		SDL_GL_DeleteContext(m_context);
		SDL_DestroyWindow(m_window);
		SDL_Quit();
	}
	
	public static bool isCloseRequested()
	{
		return isRequestingClose;
	}

	public static void setRequestedClose(bool close)
	{
		this.isRequestingClose = close;
	}
	
	public static int getWidth()
	{
		return Window.width;
	}
	
	public static int getHeight()
	{
		return Window.height;
	}
	
//	public static string getTitle()
//	{
////		return Display.getTitle();
//		return "window title";
//	}
}

