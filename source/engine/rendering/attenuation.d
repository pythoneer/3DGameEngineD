module engine.rendering.attenuation;

import engine.core.vector3f;

public class Attenuation : Vector3f
{
	public this(float constant, float linear, float exponent) {
		super(constant, linear, exponent);
	}

	public float getConstant()
	{
		return getX();
	}

	public float getLinear()
	{
		return getY();
	}

	public float getExponent()
	{
		return getZ();
	}
}