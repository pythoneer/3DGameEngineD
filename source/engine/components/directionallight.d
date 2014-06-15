module engine.components.directionallight;

import engine.core.vector3f;
import engine.rendering.renderingengine;
import engine.rendering.forwarddirectional;
import engine.components.gamecomponent;
import engine.components.baselight;

class DirectionalLight : BaseLight
{
	private BaseLight base;
	private Vector3f direction;

	public this(Vector3f color, float intensity, Vector3f direction)
	{
		super(color, intensity);
		this.direction = direction.normalized();
		//TODO singleton?
		setShader(new ForwardDirectional());
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