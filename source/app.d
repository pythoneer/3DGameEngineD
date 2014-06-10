import std.stdio;
import std.string;

import derelict.opengl3.gl;

import game;
import window;
import time;
import input;
import renderUtil;
 
class MainComponent
{
	public static const int WIDTH = 800;
	public static const int HEIGHT = 600;
	public static const string TITLE = "3D Engine";
	public static const double FRAME_CAP = 5000.0;

	private bool m_isRunning; 
	private Game m_game;

	public this() 
	{
		printf("opengl version: '%s'\n", RenderUtil.getOpenGLVersion());
		RenderUtil.initGraphics();

		m_isRunning = false;
		m_game = new Game();
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
		
		const double frameTime = 1.0 / FRAME_CAP;
		
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


			while(unprocessedTime > frameTime)
			{
				shouldRender = true;
				
				unprocessedTime -= frameTime;
				
				if(Window.isCloseRequested())
					stop();
				
				Time.setDelta(frameTime);
				Input.update();
				
				m_game.input();
				m_game.update();

				if(frameCounter >= Time.SECOND)
				{
					writeln(frames);
					frames = 0;
					frameCounter = 0;
				}
			}
			if(shouldRender)
			{
				render();
				frames++;
			}
			else
			{
				Window.delay();
			}
		}
		
		cleanUp();
	}//run


	private void render()
	{
		RenderUtil.clearScreen();
		m_game.render();
		Window.render();
	}
	
	private void cleanUp()
	{
		Window.dispose();
	}

}//MainComponent


int main()
{
	Window.createWindow(MainComponent.WIDTH, MainComponent.HEIGHT, MainComponent.TITLE);

	MainComponent game = new MainComponent();
	game.start();

	return 0;
}
