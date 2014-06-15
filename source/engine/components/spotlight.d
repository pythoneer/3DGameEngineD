module engine.components.spotlight;

import engine.core.vector3f;
import engine.components.pointlight;
import engine.rendering.forwardspot;

class SpotLight : PointLight
{
	private Vector3f direction;
	private float cutoff;

	public this(Vector3f color, float intensity, Vector3f attenuation, Vector3f direction, float cutoff)
	{
		super(color, intensity, attenuation);
		this.direction = direction.normalized();
		this.cutoff = cutoff;

		setShader(new ForwardSpot());
	}

	public Vector3f getDirection()
	{
		return direction;
	}
	public void setDirection(Vector3f direction)
	{
		this.direction = direction.normalized();
	}
	public float getCutoff()
	{
		return cutoff;
	}
	public void setCutoff(float cutoff)
	{
		this.cutoff = cutoff;
	}
}