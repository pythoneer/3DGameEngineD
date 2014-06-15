module engine.components.gamecomponent;

import engine.core.transform;
import engine.core.gameobject;
import engine.rendering.shader;
import engine.rendering.renderingengine;

class GameComponent
{
	private GameObject parent;

	public void input(float delta) {}
	public void update(float delta) {}
	public void render(Shader shader, RenderingEngine renderingEngine) {}

	public void setParent(GameObject parent)
	{
		this.parent = parent;
	}

	public Transform getTransform()
	{
		return parent.getTransform();
	}

	public void addToRenderingEngine(RenderingEngine renderingEngine) {}
}