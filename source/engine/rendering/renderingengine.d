module engine.rendering.renderingengine;

import std.stdio;

import derelict.opengl3.gl3;

import engine.core.vector3f;
import engine.core.gameobject;
import engine.core.util;
import engine.rendering.shader;
import engine.rendering.forwardambient;
import engine.rendering.forwarddirectional;
import engine.rendering.forwardpoint;
import engine.rendering.forwardspot;
import engine.components.camera;
import engine.components.baselight;
import engine.components.directionallight; 
import engine.components.pointlight;
import engine.components.spotlight;

public class RenderingEngine
{
	private Shader forwardAmbient;
	private Camera mainCamera;
	private Vector3f ambientLight;
 	
 	private BaseLight[] lights;
 	private BaseLight activeLight;
	
	public this()
	{
		forwardAmbient = new ForwardAmbient();
		
		glClearColor(0.15f, 0.15f, 0.15f, 0.0f);

		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);

		glEnable(GL_DEPTH_CLAMP);

		glEnable(GL_TEXTURE_2D);

		ambientLight = new Vector3f(0.2f, 0.2f, 0.2f);	
	}
	
	public Vector3f getAmbientLight()
 	{
 		return ambientLight;
  	}

	public void addCamera(Camera camera)
 	{
 		mainCamera = camera;
 	}

	public void render(GameObject object)
	{
		clearScreen();
		
		lights.clear();
		object.addToRenderingEngine(this);
		
 		forwardAmbient.setRenderingEngine(this);
		
		object.render(forwardAmbient, this);
		
		glEnable(GL_BLEND);
 		glBlendFunc(GL_ONE, GL_ONE);
 		glDepthMask(false);
 		glDepthFunc(GL_EQUAL);
 
 		foreach(light; lights)
 		{
 			light.getShader().setRenderingEngine(this);
 			activeLight = light;
 			object.render(light.getShader(), this);
 		}

 		glDepthFunc(GL_LESS);
 		glDepthMask(true);
 		glDisable(GL_BLEND);
		
		
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
 	
 	public void addLight(BaseLight light)
 	{
 		this.lights ~= light;
 	}
 	
 	public BaseLight getActiveLight()
 	{
 		return this.activeLight;
 	}
 	
}