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
import engine.rendering.window;
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

	//Temp variables
 Texture g_tempTarget;
 Mesh g_mesh;
 Transform g_transform;
 Material g_material;
 Camera g_camera;
 GameObject g_cameraObject;




	private int[string] samplerMap;	
 	private BaseLight[] lights;
 	private BaseLight activeLight;
 	
	private Shader forwardAmbient;
	private Camera mainCamera;
	private Shader defaultShader;
	
	public this()
	{
		super();
		forwardAmbient = new Shader("forward-ambient");
		
		samplerMap["diffuse"] = 0;
		samplerMap["normalMap"] = 1;
		samplerMap["dispMap"] = 2;
		
//		addVector3f("ambient", new Vector3f(0.1f, 0.1f, 0.1f));  //temp
		addVector3f("ambient", new Vector3f(0.2f, 0.2f, 0.2f));
		defaultShader = new Shader("forward-ambient");
		
		glClearColor(0.15f, 0.15f, 0.15f, 0.0f);

		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);

		glEnable(GL_DEPTH_CLAMP);

		glEnable(GL_TEXTURE_2D);
		
		
		
		
		//Begin Temp init

	  	int width = Window.getWidth() / 3;
		int height = Window.getHeight() / 3;
		int dataSize = width * height * 4;
	
		ubyte* data = cast(ubyte*)new ubyte[dataSize];
		//memset(data, 0, dataSize);
	
		g_tempTarget = new Texture(width, height, data, GL_TEXTURE_2D, GL_NEAREST, GL_COLOR_ATTACHMENT0);
	
//		delete[] data;
	
		Vertex vertices[] = [ new Vertex(new Vector3f(-1,-1,0),new Vector2f(1,0)),
		                      new Vertex(new Vector3f(-1,1,0),new Vector2f(1,1)),
		                      new Vertex(new Vector3f(1,1,0),new Vector2f(0,1)),
		                      new Vertex(new Vector3f(1,-1,0),new Vector2f(0,0)) ];
	
		int indices[] = [ 2, 1, 0,
		                  3, 2, 0 ];
	
		g_material = new Material(g_tempTarget, 1, 8);
		g_transform = new Transform();
		g_transform.setScale(0.9f);
		g_mesh = new Mesh(vertices, indices, true);
	
		g_camera = new Camera((new Matrix4f()).initIdentity());
		g_cameraObject = (new GameObject()).addComponent(g_camera);
	
		g_camera.getTransform().rotate(new Vector3f(0,1,0),Util.toRadians(180.0f));
		
		//End Temp init
	}
	
	public void render(GameObject object)
	{
//		Window.bindAsRenderTarget();
		
		g_tempTarget.bindAsRenderTarget();
		glClearColor(0.0f,0.0f,0.0f,0.0f);
		
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
 		
 		//Temp Render
		Window.bindAsRenderTarget();
	
		Camera temp = mainCamera;
		mainCamera = g_camera;
	
		glClearColor(0.0f,0.0f,0.5f,1.0f);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		defaultShader.bind();
		defaultShader.updateUniforms(g_transform, g_material, this);
		g_mesh.draw();
	
		mainCamera = temp;
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