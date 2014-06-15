module engine.core.gameobject;

import engine.core.transform;
import engine.rendering.shader;
import engine.rendering.renderingengine;
import engine.components.gamecomponent;

class GameObject
{
	private GameObject[] children;
	private GameComponent[] components;
	private Transform transform;

	public this()
	{
		transform = new Transform();
	}

	public void addChild(GameObject child)
	{
		children ~= child;
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

	public void render(Shader shader)
	{
		foreach(component; components)
		{
			component.render(shader);
		}

		foreach(child; children)
		{
			child.render(shader);
		}
	}
	
	public void addToRenderingEngine(RenderingEngine renderingEngine)
	{
		foreach(component; components)
		{
			component.addToRenderingEngine(renderingEngine);
		}

		foreach(child; children)
		{
			child.addToRenderingEngine(renderingEngine);
		}
	}

	public Transform getTransform()
	{
		return transform;
	}
}