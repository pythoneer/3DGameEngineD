module engine.components.directionallight;

import engine.core.vector3f;
import engine.rendering.baselight;
import engine.rendering.renderingengine;
import engine.components.gamecomponent;

class DirectionalLight : GameComponent
{
	private BaseLight base;
	private Vector3f direction;

	public this(BaseLight base, Vector3f direction)
	{
		this.base = base;
		this.direction = direction.normalized();
	}
	
	override
 	public void addToRenderingEngine(RenderingEngine renderingEngine)
 	{
 		renderingEngine.addDirectionalLight(this);
 	}

	public BaseLight getBase()
	{
		return base;
	}

	public void setBase(BaseLight base)
	{
		this.base = base;
	}

	public Vector3f getDirection()
	{
		return direction;
	}

	public void setDirection(Vector3f direction)
	{
		this.direction = direction.normalized();
	}
}