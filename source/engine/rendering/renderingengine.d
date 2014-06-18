module engine.rendering.renderingengine;

import std.stdio;

import derelict.opengl3.gl3;

import engine.core.vector3f;
import engine.core.gameobject;
import engine.core.transform;
import engine.core.util;
import engine.rendering.shader;
import engine.rendering.resourcemanagement.mappedvalues;
import engine.rendering.material;
import engine.components.camera;
import engine.components.baselight;
import engine.components.directionallight; 
import engine.components.pointlight;
import engine.components.spotlight;


public class RenderingEngine : MappedValues
{

	private int[string] samplerMap;	
 	private BaseLight[] lights;
 	private BaseLight activeLight;
 	
	private Shader forwardAmbient;
	private Camera mainCamera;
	
	public this()
	{
		super();
		forwardAmbient = new Shader("forward-ambient");
		samplerMap["diffuse"] = 0;
		addVector3f("ambient", new Vector3f(0.1f, 0.1f, 0.1f));
		
		glClearColor(0.15f, 0.15f, 0.15f, 0.0f);

		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);

		glEnable(GL_DEPTH_CLAMP);

		glEnable(GL_TEXTURE_2D);
	}
	
	public void render(GameObject object)
	{
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		
		object.render(forwardAmbient, this);
		
		glEnable(GL_BLEND);
 		glBlendFunc(GL_ONE, GL_ONE);
 		glDepthMask(false);
 		glDepthFunc(GL_EQUAL);
 
 		foreach(light; lights)
 		{
 			activeLight = light;
 			object.render(light.getShader(), this);
 		}

 		glDepthFunc(GL_LESS);
 		glDepthMask(true);
 		glDisable(GL_BLEND);
	}
	
	public void updateUniformStruct(Transform transform, Material material, Shader shader, string uniformName, string uniformType)
	{
//		throw new IllegalArgumentException(uniformType + " is not a supported type in RenderingEngine");
	}
	
	public static const (char*) getOpenGLVersion()
	{
		return glGetString(GL_VERSION);
	}
	
	public void addLight(BaseLight light)
	{
		lights ~= light;
	}

	public void addCamera(Camera camera)
	{
		mainCamera = camera;
	}

	public int getSamplerSlot(string samplerName)
	{
		return samplerMap[samplerName];
	}

	public BaseLight getActiveLight()
	{
		return activeLight;
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