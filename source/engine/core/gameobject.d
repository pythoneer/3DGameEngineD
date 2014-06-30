module engine.core.gameobject;

import engine.core.transform;
import engine.core.coreengine;
import engine.rendering.shader;
import engine.rendering.renderingengine;
import engine.components.gamecomponent;

class GameObject
{
	private GameObject[] children;
	private GameComponent[] components;
	private Transform transform;
	private CoreEngine engine;

	public this()
	{
		transform = new Transform();
		engine = null;
	}

	public void addChild(GameObject child)
	{
		children ~= child;
		child.setEngine(engine);
		child.getTransform().setParent(transform);
	}

	public GameObject addComponent(GameComponent component)
	{
		components ~= component;
		component.setParent(this);
		
		return this;
	}

	public void input(float delta)
	{
		transform.update();
		
		foreach(component; components)
		{
			component.input(delta);
		}

		foreach(child; children)
		{
			child.input(delta);
		}
			
	}

	public void update(float delta)
	{
		foreach(component; components)
		{
			component.update(delta);
		}

		foreach(child; children)
		{
			child.update(delta);
		}			
	}

	public void render(Shader shader, RenderingEngine renderingEngine)
	{
		foreach(component; components)
		{
			component.render(shader, renderingEngine);
		}

		foreach(child; children)
		{
			child.render(shader, renderingEngine);
		}
	}
	
	public void setEngine(CoreEngine engine)
	{
		if(this.engine != engine)
		{
			this.engine = engine;

			foreach(component; components)
			{
				component.addToEngine(engine);
				}
			
			foreach(child; children)
			{
				child.setEngine(engine);
			}
				
		}
	}

	public Transform getTransform()
	{
		return transform;
	}
}