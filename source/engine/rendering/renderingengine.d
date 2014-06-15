module engine.rendering.renderingengine;

import std.stdio;

import derelict.opengl3.gl3;

import engine.core.vector3f;
import engine.core.gameobject;
import engine.core.util;
import engine.rendering.shader;
import engine.rendering.basicshader;
import engine.rendering.forwardambient;
import engine.rendering.forwarddirectional;
import engine.rendering.forwardpoint;
import engine.rendering.forwardspot;
import engine.rendering.camera;
import engine.rendering.baselight;
import engine.rendering.directionallight;
import engine.rendering.spotlight;
import engine.rendering.pointlight;
import engine.rendering.attenuation;

public class RenderingEngine
{
	private Shader forwardAmbient;
	private Shader forwardDirectional;
	private Shader forwardPoint;
	private Shader forwardSpot;
	private Camera mainCamera;
	private Vector3f ambientLight;
	private DirectionalLight directionalLight;
 	private DirectionalLight directionalLight2;
 	
 	private PointLight pointLight;
 	private SpotLight spotLight;
 
 	private PointLight[] pointLightList;
	
	public this()
	{
		forwardAmbient = new ForwardAmbient();
		forwardDirectional = new ForwardDirectional();
		forwardPoint = new ForwardPoint();
 		forwardSpot = new ForwardSpot();
		
		glClearColor(0.15f, 0.15f, 0.15f, 0.0f);

		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);

		glEnable(GL_DEPTH_CLAMP);

		glEnable(GL_TEXTURE_2D);
		
		//TODO window width and height
		mainCamera = new Camera(cast(float)Util.toRadians(70.0f), 800.0f/600.0f, 0.01f, 1000.0f);
		ambientLight = new Vector3f(0.2f, 0.2f, 0.2f);
		directionalLight = new DirectionalLight(new BaseLight(new Vector3f(0,0,1), 0.4f), new Vector3f(1,1,1));
 		directionalLight2 = new DirectionalLight(new BaseLight(new Vector3f(1,0,0), 0.4f), new Vector3f(-1,1,-1));
 		
 		
 		int lightFieldWidth = 5;
 		int lightFieldDepth = 5;
 
 		float lightFieldStartX = 0;
 		float lightFieldStartY = 0;
 		float lightFieldStepX = 7;
 		float lightFieldStepY = 7;
 
 		pointLightList = new PointLight[lightFieldWidth * lightFieldDepth];
 
 		for(int i = 0; i < lightFieldWidth; i++)
 		{
 			for(int j = 0; j < lightFieldDepth; j++)
 			{
 				pointLightList[i * lightFieldWidth + j] = new PointLight(new BaseLight(new Vector3f(0,1,0), 0.4f),
 						new Attenuation(0,0,1),
 						new Vector3f(lightFieldStartX + lightFieldStepX * i,0,lightFieldStartY + lightFieldStepY * j), 100);
 			}
 		}
 
 		pointLight = pointLightList[0];//new PointLight(new BaseLight(new Vector3f(0,1,0), 0.4f), new Attenuation(0,0,1), new Vector3f(5,0,5), 100);
 
 		spotLight = new SpotLight(new PointLight(new BaseLight(new Vector3f(0,1,1), 0.4f),
 				new Attenuation(0,0,0.1f),
 				new Vector3f(lightFieldStartX,0,lightFieldStartY), 100),
 				new Vector3f(1,0,0), 0.7f);
  	
	}
	
	public Vector3f getAmbientLight()
 	{
 		return ambientLight;
  	}
 	
 	public DirectionalLight getDirectionalLight()
 	{
 		return directionalLight;
 	}
 	
 	public PointLight getPointLight()
 	{
 		return pointLight;
 	}
 
 	public SpotLight getSpotLight()
 	{
 		return spotLight;
 	}

	public void input(float delta)
 	{
 		mainCamera.input(delta);
  	}

	public void render(GameObject object)
	{
		clearScreen();
 		forwardAmbient.setRenderingEngine(this);
 		forwardDirectional.setRenderingEngine(this);
 		forwardPoint.setRenderingEngine(this);
 		forwardSpot.setRenderingEngine(this);
 		
		object.render(forwardAmbient);
		
		glEnable(GL_BLEND);
 		glBlendFunc(GL_ONE, GL_ONE);
 		glDepthMask(false);
 		glDepthFunc(GL_EQUAL);
 
		object.render(forwardDirectional);

		DirectionalLight temp = directionalLight;
		directionalLight = directionalLight2;
		directionalLight2 = temp;

		object.render(forwardDirectional);

		temp = directionalLight;
		directionalLight = directionalLight2;
		directionalLight2 = temp;

		for(int i = 0; i < pointLightList.length; i++)
		{
			pointLight = pointLightList[i];
			object.render(forwardPoint);
		}

		object.render(forwardSpot);
 
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
}