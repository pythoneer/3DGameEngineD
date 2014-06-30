module engine.components.spotlight;

import engine.core.vector3f;
import engine.components.pointlight;
import engine.rendering.shader;
import engine.rendering.attenuation;

class SpotLight : PointLight
{
	private float cutoff;

	public this(Vector3f color, float intensity, Attenuation attenuation, float cutoff)
	{
		super(color, intensity, attenuation);
		this.cutoff = cutoff;

		setShader(new Shader("forward-spot"));
	}

	public Vector3f getDirection()
	{
		return getTransform().getTransformedRot().getForward();
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