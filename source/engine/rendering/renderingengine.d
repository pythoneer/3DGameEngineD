module engine.rendering.renderingengine;

import std.stdio;

import derelict.opengl3.gl3;

import engine.core.vector3f;
import engine.core.gameobject;
import engine.core.util;
import engine.rendering.shader;
import engine.rendering.basicshader;
import engine.rendering.camera;

public class RenderingEngine
{
	private Shader shader;
	private Camera mainCamera;
	
	public this()
	{
		shader = new BasicShader();
		
		glClearColor(0.15f, 0.15f, 0.15f, 0.0f);

		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);

		glEnable(GL_DEPTH_CLAMP);

		glEnable(GL_TEXTURE_2D);
		
		//TODO window width and height
		mainCamera = new Camera(cast(float)Util.toRadians(70.0f), 800.0f/600.0f, 0.01f, 1000.0f);
	}

	public void input()
 	{
 		mainCamera.input();
  	}

	public void render(GameObject object)
	{
		clearScreen();
 		shader.setRenderingEngine(this);
		object.render(shader);
	}

	private static void clearScreen()
	{
		//TODO: Stencil Buffer
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}

	private static void setTextures(bool enabled)
	{
		if(enabled)
			glEnable(GL_TEXTURE_2D);
		else
			glDisable(GL_TEXTURE_2D);
	}

	private static void unbindTextures()
	{
		glBindTexture(GL_TEXTURE_2D, 0);
	}

	private static void setClearColor(Vector3f color)
	{
		glClearColor(color.getX(), color.getY(), color.getZ(), 1.0f);
	}

	public static const (char*) getOpenGLVersion()
	{
		return glGetString(GL_VERSION);
	}
	
	public Camera getMainCamera()
 	{
 		return mainCamera;
 	}
 
 	public void setMainCamera(Camera mainCamera)
 	{
 		this.mainCamera = mainCamera;
 	}
}