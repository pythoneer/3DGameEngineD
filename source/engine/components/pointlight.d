module engine.components.pointlight;

import std.math;

import engine.core.vector3f;
import engine.rendering.shader;
import engine.rendering.attenuation;
import engine.components.baselight;

public class PointLight : BaseLight
{
	private static final int COLOR_DEPTH = 256;

	private Attenuation attenuation;
	protected float range;

	public this(Vector3f color, float intensity, Attenuation attenuation)
	{
		super(color, intensity);
		this.attenuation = attenuation;

		float a = attenuation.getExponent();
		float b = attenuation.getLinear();
		float c = attenuation.getConstant() - COLOR_DEPTH * getIntensity() * getColor().max();

		this.range = cast(float)((-b + sqrt(b * b - 4 * a * c))/(2 * a));

		setShader(new Shader("forward-point"));
	}

	public float getRange()
	{
		return range;
	}

	public void setRange(float range)
	{
		this.range = range;
	}

	public Attenuation getAttenuation()
	{
		return attenuation;
	}
}