module engine.components.spotlight;

import std.math;

import engine.core.vector3f;
import engine.core.matrix;
import engine.core.util;
import engine.rendering.shader;
import engine.rendering.attenuation;
import engine.rendering.shadowinfo;
import engine.components.pointlight;

class SpotLight : PointLight
{
	private float cutoff;

	public this(Vector3f color, 
				float intensity, 
				Attenuation attenuation, 
				float viewAngle = Util.toRadians(170.0f), 
				int shadowMapSizeAsPowerOf2 = 8, 
				float shadowSoftness = 1.0f, 
				float lightBleedingReductionAmount = 0.2f, 
				float minVariance = 0.00002f)
	{
		super(color, intensity, attenuation);
		this.cutoff = cos(viewAngle/2);

		setShader(new Shader("forward-spot"));
		
		if(shadowMapSizeAsPowerOf2 != 0)
		{
			setShadowInfo( new ShadowInfo(new Matrix4f().initPerspective(viewAngle, 1.0f, 0.1f, this.range), 
										  false, 
										  shadowMapSizeAsPowerOf2,
										  shadowSoftness, 
										  lightBleedingReductionAmount, 
										  minVariance));
		}
		
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