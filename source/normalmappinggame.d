module normalmappinggame;

import std.math;

import engine.core.game;
import engine.core.input;
import engine.core.vector3f;
import engine.core.vector2f;
import engine.core.quaternion;
import engine.core.time;
import engine.core.transform;
import engine.core.gameobject;
import engine.core.util;
import engine.rendering.window;
import engine.rendering.mesh;
import engine.rendering.meshrenderer;
import engine.rendering.shader;
import engine.rendering.vertex;
import engine.rendering.material;
import engine.rendering.texture;
import engine.rendering.attenuation;
import engine.components.baselight;
import engine.components.directionallight;
import engine.components.pointlight;
import engine.components.spotlight;
import engine.components.camera;
import engine.components.lookatcomponent;
import engine.components.freelook;

class NormalMappingGame : Game
{	
	override
	public void init()
	{	
		GameObject planeObject = new GameObject();
		GameObject pointLightObject = new GameObject();
		GameObject spotLightObject = new GameObject();
		GameObject directionalLightObject = new GameObject();
	
		planeObject.addComponent(new MeshRenderer(new Mesh("plane4.obj"), new Material(new Texture("bricks.jpg"), 0.5f, 4, 
                                                                                       new Texture("bricks_normal.jpg"),
                                                                                       new Texture("bricks_disp.png"), 0.03f, -0.5f)));
	
		
		planeObject.getTransform().setPos(new Vector3f(0, -1, 5)); //-10
		planeObject.getTransform().setScale(4.0f); //22
	
		pointLightObject.addComponent(new PointLight(new Vector3f(0,1,0),0.4f, new Attenuation(0,0,1)));
		pointLightObject.getTransform().setPos(new Vector3f(7,0,7));
	
		spotLightObject.addComponent(new SpotLight(new Vector3f(0,1,1),0.4f,new Attenuation(0,0,0.1f),0.7f));
		spotLightObject.getTransform().setRot(new Quaternion(new Vector3f(0,1,0), Util.toRadians(90.0f)));
	
		directionalLightObject.addComponent(new DirectionalLight(new Vector3f(1,1,1), 0.4f));
	
		GameObject testMesh1 = new GameObject();
		GameObject testMesh2 = new GameObject();
	
		testMesh1.addComponent(new MeshRenderer(new Mesh("plane3.obj"), new Material(new Texture("bricks2.jpg"), 1, 8,
																					 new Texture("bricks2_normal.jpg"),
																					 new Texture("bricks2_disp.jpg"), 0.04f, -1.0f)));
		
		
		
		testMesh2.addComponent(new MeshRenderer(new Mesh("plane3.obj"), new Material(new Texture("bricks2.jpg"), 1, 8,
																					 new Texture("bricks2_normal.jpg"))));
		
		
	
		testMesh1.getTransform().setPos(new Vector3f(-15, 5, 0));
		testMesh1.getTransform().setRot(new Quaternion(new Vector3f(0,1,0), Util.toRadians(-10)));
		testMesh1.getTransform().setScale(1.0f);
	
		testMesh2.getTransform().setPos(new Vector3f(0, 0, 25));
	
		testMesh1.addChild(testMesh2);
	
		addToScene(planeObject);
//		addToScene(pointLightObject);
//		addToScene(spotLightObject);
		addToScene(directionalLightObject);
		addToScene(testMesh1);
//		testMesh2.addChild(
		
		GameObject cameraObject = new GameObject();
		cameraObject.addComponent(new FreeLook()).addComponent(new Camera(cast(float)Util.toRadians(70.0f), cast(float) Window.getWidth() / cast(float) Window.getHeight(), 0.01f, 1000.0f));
		cameraObject.getTransform().setPos(new Vector3f(0,10,0));
		cameraObject.getTransform().rotate(new Vector3f(1,0,0), Util.toRadians(20));
		addToScene(cameraObject);
  
		directionalLightObject.getTransform().setRot(new Quaternion(new Vector3f(1,0,0), Util.toRadians(-45)));
		
		
		GameObject box = new GameObject();
		box.addComponent(new MeshRenderer(new Mesh("cube.obj"), new Material(new Texture("bricks2.jpg"), 1, 8,
		                                                                                   new Texture("bricks2_normal.png"),
		                                                                                   new Texture("bricks2_disp.jpg"), 0.04f, -1.0f)));
		box.getTransform().setPos(new Vector3f(-2,0,15));
		box.getTransform().setRot(new Quaternion(new Vector3f(0,1,0), Util.toRadians(30.0f)));
		addToScene(box);
		
		GameObject mushRoom = new GameObject();
		mushRoom.addComponent(new MeshRenderer(new Mesh("mushroom.obj"), new Material(new Texture("mushroom.png"), 1, 8)));
		mushRoom.getTransform().setPos(new Vector3f(-2,1, 25));
		mushRoom.getTransform().setRot(new Quaternion(new Vector3f(1,0,0), Util.toRadians(-90)));
		mushRoom.getTransform().rotate(new Vector3f(0,1,0), Util.toRadians(180));
		addToScene(mushRoom);
				
		
	}
}