module engine.core.game;

import engine.core.gameobject;

class Game
{
	
	private GameObject root;

	public abstract void init();

	public void input()
	{
		getRootObject().input();
	}

	public void update()
	{
		getRootObject().update();
	}

	public GameObject getRootObject()
	{
		if(root is null)
			root = new GameObject();

		return root;
	}

}

