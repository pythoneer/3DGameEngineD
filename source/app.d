import std.stdio;
import std.string;

import derelict.glfw3.glfw3;
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
//				Input.update();
				
				m_game.input();
				m_game.update();

				if(frameCounter >= Time.SECOND)
				{
//					writeln(frames);
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
//				try 
//				{
//					Thread.sleep(1);
//				} 
//				catch (InterruptedException e) 
//				{
//					e.printStackTrace();
//				}
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
	writeln("Hello World");
	Window.createWindow(MainComponent.WIDTH, MainComponent.HEIGHT, MainComponent.TITLE);

	MainComponent game = new MainComponent();
	game.start();

	return 0;

//	char[] buf;
//	while (stdin.readln(buf))
//		write(buf);


//	scope(exit) writeln("Have a nice day!");
//	
//	DerelictGL3.load();
//	DerelictGLFW3.load();
//	
//	write("Creating main window... ");
//	if(!glfwInit()) {
//		writeln("FAILED");
//		return -1;
//	}
//	
//	scope(exit) glfwTerminate();
//	
//	GLFWwindow* window = glfwCreateWindow(800, 600, "TTGL", null, null);
//	if(!window) {
//		writeln("FAILED");
//		return -2;
//	} else
//		writeln("DONE");
//	
//	scope(exit) {
//		writeln("Destroying main window...");
//		glfwDestroyWindow(window);
//	}
//	
//	glfwMakeContextCurrent(window);
//	
//	DerelictGL3.reload();
//	//##################################
//	//##################################
//	
//	float vertices[] = [
//		0.0f,  0.5f, // Vertex 1 (X, Y)
//		0.5f, -0.5f, // Vertex 2 (X, Y)
//		-0.5f, -0.5f,  // Vertex 3 (X, Y)
//	];
//	
//	const char* vertexSource = `
//			#version 130
//
//			in vec2 position;
//
//			void main()
//			{
//			    gl_Position = vec4( position, 0.0, 1.0 );
//			}
//		`;
//	
//	const char* fragmentSource = `
//			#version 130
//
//			out vec4 outColor;
//
//			void main()
//			{
//			    outColor = vec4( 1.0, 1.0, 1.0, 1.0 );
//			}
//		`;
//	
//	GLuint vao;
//	glGenVertexArrays(1, &vao);
//	scope(exit) glDeleteVertexArrays(1, &vao);
//	
//	glBindVertexArray(vao);
//	
//	GLuint vbo;
//	glGenBuffers(1, &vbo);
//	scope(exit) glDeleteBuffers(1, &vbo);
//	
//	glBindBuffer(GL_ARRAY_BUFFER, vbo);
//	glBufferData(GL_ARRAY_BUFFER, vertices.length*float.sizeof, vertices.ptr, GL_STATIC_DRAW);
//	
//	writeln("Compiling shaders...");
//	GLint status;
//	
//	write("\tVertex... ");
//	GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
//	scope(exit) glDeleteShader(vertexShader);
//	glShaderSource(vertexShader, 1, &vertexSource, null);
//	
//	glCompileShader(vertexShader);
//	glGetShaderiv( vertexShader, GL_COMPILE_STATUS, &status );
//	if(!status) {
//		char[512] buffer;
//		glGetShaderInfoLog(vertexShader, 512, null, buffer.ptr);
//		writeln("E: " ~ buffer);
//		return -3;
//	} else
//		writeln("DONE");
//	
//	write("\tFragment... ");
//	GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
//	scope(exit) glDeleteShader(fragmentShader);
//	glShaderSource(fragmentShader, 1, &fragmentSource, null);
//	
//	glCompileShader(fragmentShader);
//	glGetShaderiv( fragmentShader, GL_COMPILE_STATUS, &status );
//	if(!status) {
//		char[512] buffer;
//		glGetShaderInfoLog(fragmentShader, 512, null, buffer.ptr);
//		writeln("E: " ~ buffer);
//		return -3;
//	} else
//		writeln("DONE");
//	
//	GLuint shaderProgram = glCreateProgram();
//	scope(exit) glDeleteProgram(shaderProgram);
//	glAttachShader(shaderProgram, vertexShader);
//	glAttachShader(shaderProgram, fragmentShader);
//	
//	glBindFragDataLocation(shaderProgram, 0, "outColor");
//	glLinkProgram(shaderProgram);
//	glUseProgram(shaderProgram);
//	
//	GLuint posAttrib = glGetAttribLocation(shaderProgram, "position");
//	glVertexAttribPointer(posAttrib, 2, GL_FLOAT, GL_FALSE, 0, null);
//	glEnableVertexAttribArray(posAttrib);
//	
//	//##################################
//	//##################################
//	writeln("Entering main loop...");
//	while(!glfwWindowShouldClose(window)) {
//		//##############
//		
//		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
//		glClear(GL_COLOR_BUFFER_BIT);
//		
//		glDrawArrays(GL_TRIANGLES, 0, 3);
//		
//		//##############
//		glfwSwapBuffers(window);
//		glfwPollEvents();
//	}
//	
//	writeln("Exiting...");
//	return 0;
//

}
