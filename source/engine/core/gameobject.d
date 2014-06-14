module engine.core.gameobject;

import engine.core.gamecomponent;
import engine.core.transform;

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
	}

	public void addComponent(GameComponent component)
	{
		components ~= component;
	}

	public void input()
	{
		foreach(component; components)
		{
			component.input(transform);
		}

		foreach(child; children)
		{
			child.input();
		}
			
	}

	public void update()
	{
		foreach(component; components)
		{
			component.update(transform);
		}

		foreach(child; children)
		{
			child.update();
		}			
	}

	public void render()
	{
		foreach(component; components)
		{
			component.render(transform);
		}

		foreach(child; children)
		{
			child.render();
		}
	}

	public Transform getTransform()
	{
		return transform;
	}
}