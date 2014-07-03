module engine.rendering.renderingengine;

import std.stdio;

import derelict.opengl3.gl3;

import engine.core.vector3f;
import engine.core.quaternion;
import engine.core.gameobject;
import engine.core.transform;
import engine.core.util;
import engine.rendering.shader;
import engine.rendering.resourcemanagement.mappedvalues;
import engine.rendering.material;
import engine.rendering.window;
import engine.rendering.shadowinfo;
import engine.components.camera;
import engine.components.baselight;
import engine.components.directionallight; 
import engine.components.pointlight;
import engine.components.spotlight;


import engine.rendering.mesh;
import engine.rendering.texture;
import engine.core.vector3f;
import engine.core.vector2f;
import engine.rendering.vertex;
import engine.core.matrix;
import engine.core.util;




public class RenderingEngine : MappedValues
{

	private Camera mainCamera;
 	private Camera altCamera;
 	private GameObject altCameraObject;
 	
 	private Texture tempTarget;
 	private Material planeMaterial; 	
 	private Mesh planeMesh;
 	private Transform planeTransform;

	private int[string] samplerMap;	
 	private BaseLight[] lights;
 	private BaseLight activeLight;
 	
	private Shader forwardAmbient;
	private Shader shadowMapShader;

	private Shader defaultShader;
	private Shader nullFilter;
	private Shader gausBlurFilter;
	
	private Matrix4f lightMatrix;
	private Matrix4f biasMatrix = new Matrix4f().initScale(0.5, 0.5, 0.5).mul(new Matrix4f().initTranslation(1.0, 1.0, 1.0));
	
	public this()
	{
		super();
		forwardAmbient = new Shader("forward-ambient");
		
		samplerMap["diffuse"] = 0;
		samplerMap["normalMap"] = 1;
		samplerMap["dispMap"] = 2;
		samplerMap["shadowMap"] = 3;
		samplerMap["filterTexture"] = 4;
		
		setVector3f("ambient", new Vector3f(0.1f, 0.1f, 0.1f));  //temp
		setTexture("shadowMap", new Texture(1024, 1024, cast(ubyte*)0, GL_TEXTURE_2D, GL_LINEAR, GL_RG32F, GL_RGBA, true, GL_COLOR_ATTACHMENT0));
		setTexture("shadowMapTempTarget", new Texture(1024, 1024, cast(ubyte*)0, GL_TEXTURE_2D, GL_LINEAR, GL_RG32F, GL_RGBA, true, GL_COLOR_ATTACHMENT0));
		defaultShader = new Shader("forward-ambient");
		shadowMapShader = new Shader("shadowMapGenerator");
		nullFilter = new Shader("filter-null");
		gausBlurFilter = new Shader("filter-gausBlur7x1");
		
		glClearColor(0.15f, 0.15f, 0.15f, 0.0f);

		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);
		glEnable(GL_DEPTH_CLAMP);
		glEnable(GL_TEXTURE_2D);
		
		altCamera = new Camera((new Matrix4f()).initIdentity());
		altCameraObject = (new GameObject()).addComponent(altCamera);
		altCamera.getTransform().rotate(new Vector3f(0,1,0),Util.toRadians(180.0f));
		altCamera.getTransform().rotate(new Vector3f(0,0,1),Util.toRadians(-90.0f));

	  	int width = Window.getWidth();
		int height = Window.getHeight();
	
		tempTarget = new Texture(width, height, cast(ubyte*)0, GL_TEXTURE_2D, GL_NEAREST, GL_RGBA8, GL_BGRA, false, GL_COLOR_ATTACHMENT0);
	
		planeMaterial = new Material(tempTarget, 1, 8);
		planeTransform = new Transform();
		planeTransform.setScale(1.0f);
		planeMesh = new Mesh("cube.obj");
		

		
		//End Temp init
	}
	
	public void render(GameObject object)
	{
		Window.bindAsRenderTarget();		
//		tempTarget.bindAsRenderTarget();
//		glClearColor(0.0f,0.0f,0.0f,0.0f);
		
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
		object.render(forwardAmbient, this);
		

 
 		foreach(light; lights)
 		{
 			activeLight = light;
 			ShadowInfo shadowInfo = light.getShadowInfo();
 			
 			getTexture("shadowMap").bindAsRenderTarget();
 			glClear(GL_DEPTH_BUFFER_BIT);
 			
 			if(shadowInfo !is null)
 			{
 				altCamera.setProjection(shadowInfo.getProjection());
 				altCamera.getTransform().setPos(activeLight.getTransform().getTransformedPos());
 				altCamera.getTransform().setRot(activeLight.getTransform().getTransformedRot());
// 				altCamera.getTransform().rotate(new Vector3f(1,0,0), Util.toRadians(90));
 				
 				lightMatrix = biasMatrix.mul(altCamera.getViewProjection());
 								
 				setFloat("shadowBias", shadowInfo.getBias() / 1024.0f);
 				setVector3f("shadowTexelSize", new Vector3f(1.0f/1024.0f, 1.0f/1024.0f, 0));
 						
 				Camera tempCamera = mainCamera;
 				mainCamera = altCamera;	
 				
 				if(shadowInfo.getFlipFaces()){
 					glCullFace(GL_FRONT);
 				}
 				
 				object.render(shadowMapShader, this);
 				
 				if(shadowInfo.getFlipFaces()){
 					glCullFace(GL_BACK);
 				}
 				
 				mainCamera = tempCamera;
 				
 				blurShadowMap(getTexture("shadowMap"), 0.8f);
 				
 			}

 			Window.bindAsRenderTarget();		

			glEnable(GL_BLEND);
	 		glBlendFunc(GL_ONE, GL_ONE);
	 		glDepthMask(false);
	 		glDepthFunc(GL_EQUAL);
 			
 			object.render(light.getShader(), this);
 			
	 		glDepthFunc(GL_LESS);
	 		glDepthMask(true);
	 		glDisable(GL_BLEND);
 		}


 		
 		//Temp Render
//		Window.bindAsRenderTarget();
//	
//		Camera temp = mainCamera;
//		mainCamera = altCamera;
//	
//		glClearColor(0.0f,0.0f,0.5f,1.0f);
//		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//		defaultShader.bind();
//		defaultShader.updateUniforms(planeTransform, planeMaterial, this);
//		planeMesh.draw();
//	
//		mainCamera = temp;
	}
	
	private void blurShadowMap(Texture shadowMap, float blurAmount)
	{
		setVector3f("blurScale", new Vector3f(1.0f/(shadowMap.getWidth() * blurAmount), 0.0f, 0.0f));
		applyFilter(gausBlurFilter, shadowMap, getTexture("shadowMapTempTarget"));
		
		setVector3f("blurScale", new Vector3f(0.0f, 1.0f/(shadowMap.getHight() * blurAmount), 0.0f));
		applyFilter(gausBlurFilter, getTexture("shadowMapTempTarget"), shadowMap);
	}
	
	private void applyFilter(Shader filter, Texture source, Texture dest)
	{
		if(source == dest)
		{
			writeln("source can not be dest!");
			return;
		}
		
		if(dest is null)
		{
			Window.bindAsRenderTarget();
		}
		else
		{
			dest.bindAsRenderTarget();
		}
		
		setTexture("filterTexture", source);
	
		altCamera.setProjection(new Matrix4f().initIdentity());
		altCamera.getTransform().setPos(new Vector3f(0,0,0));
		altCamera.getTransform().setRot(new Quaternion( new Vector3f(0,1,0), Util.toRadians(180.0f)));
//		altCamera.getTransform().rotate(new Vector3f(0,1,0),Util.toRadians(180.0f));
		altCamera.getTransform().rotate(new Vector3f(0,0,1),Util.toRadians(-90.0f));
	
		Camera temp = mainCamera;
		mainCamera = altCamera;
	
		glClear(GL_DEPTH_BUFFER_BIT);
		filter.bind();
		filter.updateUniforms(planeTransform, planeMaterial, this);
		planeMesh.draw();
	
		mainCamera = temp;
//		setTexture("filterTexture", null);
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
 	
 	public Matrix4f getLightMatrix()
 	{
 		return lightMatrix;
 	}
}