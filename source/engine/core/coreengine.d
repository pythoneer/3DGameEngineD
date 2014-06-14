module engine.core.coreengine;

import std.stdio;
import std.string;

import derelict.opengl3.gl;

import engine.core.game;
import engine.core.time;
import engine.core.input;
import engine.rendering.renderingengine;
import engine.rendering.window;

class CoreEngine
{
	public static const int WIDTH = 800;
	public static const int HEIGHT = 600;
	public static const string TITLE = "3D Engine";
	public static const double FRAME_CAP = 5000.0f;

	private RenderingEngine renderingEngine;
	private bool m_isRunning; 
	private Game m_game;
	private int m_width;
	private int m_height;
	private double m_frameTime;

//	public this() 
//	{
//		printf("opengl version: '%s'\n", RenderUtil.getOpenGLVersion());
//		RenderUtil.initGraphics();
//
//		m_isRunning = false;
//		m_game = new TestGame();
//		m_game.init();
//	}

	public this(int width, int height, double framerate, Game game)
	{
		m_isRunning = false;
		m_game = game;
		m_width = width;
		m_height = height;
		m_frameTime = 1.0/framerate;
	}
	
//	private void initializeRenderingSystem()
//	{
//		writeln(RenderUtil.getOpenGLVersion());
//		RenderUtil.initGraphics();
//	}

	public void createWindow(string title)
	{
		Window.createWindow(m_width, m_height, title);
		this.renderingEngine = new RenderingEngine();
	}

	public void start()
	{
		if(m_isRunning)
			return;
		
		run();
	}
	
	public void stop()
	{
		if(!m_isRunning)
			return;
		
		m_isRunning = false;
	}

	private void run()
	{
		m_isRunning = true;

		int frames = 0;
		long frameCounter = 0;
		
		//const double frameTime = 1.0f / FRAME_CAP;
		m_game.init();
		
		long lastTime = Time.getTime();
		double unprocessedTime = 0;
		
		while(m_isRunning)
		{
			bool shouldRender = false;
			
			long startTime = Time.getTime();
			long passedTime = startTime - lastTime;
			lastTime = startTime;
			
			unprocessedTime += cast(double)passedTime / cast(double)Time.SECOND;
			frameCounter += passedTime;


			while(unprocessedTime > m_frameTime)
			{
				shouldRender = true;
				
				unprocessedTime -= m_frameTime;
				
				if(Window.isCloseRequested())
					stop();
				
				Time.setDelta(m_frameTime);
				Input.update();
				renderingEngine.input();
				m_game.input();
				m_game.update();

				if(frameCounter >= Time.SECOND)
				{				
					writefln("FPS: %d",frames);
					write("\33[1A\33[2K");
					frames = 0;
					frameCounter = 0;
				}
			}
			if(shouldRender)
			{
				renderingEngine.render(m_game.getRootObject());
 				Window.render();
				frames++;
			}
			else
			{
				Window.delay();
			}
		}
		
		cleanUp();
	}//run


//	private void render()
//	{
//		RenderUtil.clearScreen();
//		m_game.render();
//		Window.render();
//	}
	
	private void cleanUp()
	{
		Window.dispose();
	}

}//CoreEngine