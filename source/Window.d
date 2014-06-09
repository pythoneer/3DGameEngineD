module window;

import std.stdio;

//import derelict.sdl2.sdl;
import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;

class Window
{
//	private static SDL_Window *m_window;
	private static GLFWwindow* m_window;
//	private static SDL_GLContext m_context;
	private static bool isRequestingClose;
	//private SDL_GLContext *m_context;

	this()
	{
		isRequestingClose = false;
	}

	public static void createWindow(int width, int height, string title)
	{


		DerelictGL3.load();
		DerelictGLFW3.load();
		
		write("Creating main window... ");
		if(!glfwInit()) {
			writeln("FAILED");
//			return -1;
		}
		
//		scope(exit) glfwTerminate();
		
		m_window = glfwCreateWindow(800, 600, "TTGL", null, null);
		if(!m_window) {
			writeln("FAILED");
//			return -2;
		} else
			writeln("DONE");
		
//		scope(exit) {
//			writeln("Destroying main window...");
//			glfwDestroyWindow(window);
//		}
		
		glfwMakeContextCurrent(m_window);
		
		DerelictGL3.reload();





//		// Load OpenGL versions 1.0 and 1.1.
//		DerelictGL3.load();
//
//		// Load the SDL 2 library.
//		DerelictSDL2.load();
//
//		if (SDL_Init(SDL_INIT_VIDEO) < 0) {
////			throw new Exception("Failed to initialize SDL: " ~ to!string(SDL_GetError()));
//			writeln("Could not create sdl");
//		}
//		
//		// Set OpenGL version
//		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
//		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
//		
//		// Set OpenGL attributes
//		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
//		SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
//		
//		m_window = SDL_CreateWindow(
//			"An SDL2 window",                  // window title
//			SDL_WINDOWPOS_UNDEFINED,           // initial x position
//			SDL_WINDOWPOS_UNDEFINED,           // initial y position
//			width,                               // width, in pixels
//			height,                               // height, in pixels
//			SDL_WINDOW_OPENGL                  // flags - see below
//			);
//					
//		if (m_window == null) {
//			// In the event that the window could not be made...
//			writefln("Could not create window: %s\n", SDL_GetError());
//			return;
//		}
//		else
//		{
//			writeln("SDL window created");
//		}
//
//		//create a valid SDL context for opengl e.g. to allow derelic.reload();
//		m_context = SDL_GL_CreateContext(m_window);
//		// Load versions 1.2+ and all supported ARB and EXT extensions.
//		DerelictGL3.reload();


	}
	
	public static void render()
	{

		glfwSwapBuffers(m_window);
		glfwPollEvents();





		/* Clear our buffer with a red background */
//		glClearColor ( 1.0, 0.0, 0.0, 1.0 );
//		glClear ( GL_COLOR_BUFFER_BIT );
		/* Swap our back buffer to the front */




//
//
//		SDL_GL_SwapWindow(m_window);
//		SDL_GL_SwapBuffers();
//
//



		/* Wait 2 seconds */
		//SDL_Delay(2000);
//		
//		/* Same as above, but green */
//		glClearColor ( 0.0, 1.0, 0.0, 1.0 );
//		glClear ( GL_COLOR_BUFFER_BIT );
//		SDL_GL_SwapWindow(m_window);
//		//SDL_Delay(2000);
//		
//		/* Same as above, but blue */
//		glClearColor ( 0.0, 0.0, 1.0, 1.0 );
//		glClear ( GL_COLOR_BUFFER_BIT );
//		SDL_GL_SwapWindow(m_window);
//		//SDL_Delay(2000);

	}

	public static void delay()
	{
//		SDL_Delay(1);
	}
	
	public static void dispose()
	{
//		Display.destroy();
//		Keyboard.destroy();
//		Mouse.destroy();

//		SDL_GL_DeleteContext(m_context);
//		SDL_DestroyWindow(m_window);
//		SDL_Quit();
	}
	
	public static bool isCloseRequested()
	{
//		return Display.isCloseRequested();
		return isRequestingClose;
	}

	public static void setRequestedClose(bool close)
	{
		this.isRequestingClose = close;
	}
	
//	public static int getWidth()
//	{
////		return Display.getDisplayMode().getWidth();
//		return 1;
//	}
//	
//	public static int getHeight()
//	{
////		return Display.getDisplayMode().getHeight();
//		return 1;
//	}
//	
//	public static string getTitle()
//	{
////		return Display.getTitle();
//		return "window title";
//	}
}

