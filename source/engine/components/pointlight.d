module engine.components.pointlight;

import engine.core.vector3f;
//import engine.rendering.attenuation;
import engine.rendering.renderingengine;
import engine.rendering.forwardpoint;
import engine.components.gamecomponent;
import engine.components.baselight;

public class PointLight : BaseLight
{
	private Vector3f position;
	private float constant;
	private float linear;
	private float exponent;
	private float range;

	public this(Vector3f color, float intensity, float constant, float linear, float exponent, Vector3f position, float range)
	{
		super(color, intensity);
 		this.constant = constant;
 		this.linear = linear;
 		this.exponent = exponent;
  		this.position = position;
  		this.range = range;
  		
  		setShader(new ForwardPoint());
	}
	

	public Vector3f getPosition()
	{
		return position;
	}
	public void setPosition(Vector3f position)
	{
		this.position = position;
	}

	public float getRange()
	{
		return range;
	}

	public void setRange(float range)
	{
		this.range = range;
	}

	public float getConstant() {
		return constant;
	}

	public void setConstant(float constant) {
		this.constant = constant;
	}

	public float getLinear() {
		return linear;
	}

	public void setLinear(float linear) {
		this.linear = linear;
	}

	public float getExponent() {
		return exponent;
	}

	public void setExponent(float exponent) {
		this.exponent = exponent;
	}
}