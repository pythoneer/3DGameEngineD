module engine.components.baselight;

import engine.core.vector3f;
import engine.core.quaternion;
import engine.core.coreengine;
import engine.rendering.shader;
import engine.rendering.renderingengine;
import engine.rendering.shadowinfo;
import engine.rendering.shadowcameratransform;
import engine.components.gamecomponent;

class BaseLight : GameComponent
{
	private Vector3f color;
	private float intensity;
	private Shader shader;
	private ShadowInfo shadowInfo;

	public this(Vector3f color, float intensity)
	{
		this.color = color;
		this.intensity = intensity;
		this.shader = null;
		this.shadowInfo = null;
	}
	
	public ShadowCameraTransform calcShadowCameraTransform(Vector3f mainCameraPos, Quaternion mainCameraRot)
	{
		ShadowCameraTransform result;
		result.pos = getTransform().getTransformedPos();
		result.rot = getTransform().getTransformedRot();
		return result;
	}

	
	override
	public void addToEngine(CoreEngine engine)
	{
		engine.getRenderingEngine().addLight(this);
	}
 
 	public void setShader(Shader shader)
 	{
 		this.shader = shader;
 	}
 
 	public Shader getShader()
 	{
 		return shader;
 	}

	public Vector3f getColor()
	{
		return color;
	}

	public void setColor(Vector3f color)
	{
		this.color = color;
	}

	public float getIntensity()
	{
		return intensity;
	}

	public void setIntensity(float intensity)
	{
		this.intensity = intensity;
	}
	
	public ShadowInfo getShadowInfo()
	{
		return this.shadowInfo;
	}
	
	public void setShadowInfo(ShadowInfo shadowInfo)
	{
		this.shadowInfo = shadowInfo;
	}
}