module engine.core.game;

import engine.core.gameobject;

class Game
{
	
	private GameObject root;

	public abstract void init();

	public void input(float delta)
	{
		getRootObject().input(delta);
	}

	public void update(float delta)
	{
		getRootObject().update(delta);
	}

	public GameObject getRootObject()
	{
		if(root is null)
			root = new GameObject();

		return root;
	}

}

