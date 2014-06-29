module engine.core.game;

import engine.core.gameobject;
import engine.core.coreengine;
import engine.rendering.renderingengine;

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

	public void render(RenderingEngine renderingEngine)
	{
		renderingEngine.render(getRootObject());
	}

	public void addObject(GameObject object)
	{
		getRootObject().addChild(object);
	}

	protected void addToScene(GameObject child) 
	{ 
		root.addChild(child);
	}

	private GameObject getRootObject()
	{
		if(root is null)
			root = new GameObject();

		return root;
	}
	
	public void setEngine(CoreEngine engine) { getRootObject().setEngine(engine); }

}

