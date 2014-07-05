module engine.components.directionallight;

import engine.core.vector3f;
import engine.core.matrix;
import engine.core.quaternion;
import engine.rendering.shader;
import engine.rendering.shadowinfo;
import engine.rendering.shadowcameratransform;
import engine.components.baselight;

class DirectionalLight : BaseLight
{
	private float shadowArea;
	private float halfShadowArea;
	
	public this(Vector3f color, 
				float intensity, 
				int shadowMapSizeAsPowerOf2 = 0, 
				float shadowArea = 80.0f, 
				float shadowSoftness = 1.0f, 
				float lightBleedReductionAmount = 0.2f, 
				float minVariance = 0.00002f)
	{
		super(color, intensity);
		
		this.shadowArea = shadowArea;
		this.halfShadowArea = shadowArea / 2;
		
		setShader(new Shader("forward-directional"));	
		
		if(shadowMapSizeAsPowerOf2 != 0)
		{
			setShadowInfo( new ShadowInfo(new Matrix4f().initOrthographic(-halfShadowArea, 
																		  halfShadowArea, 
																		  -halfShadowArea, 
																		  halfShadowArea, 
																		  -halfShadowArea, 
																		  halfShadowArea), 
										  false, 
										  shadowMapSizeAsPowerOf2,
										  shadowSoftness, 
										  lightBleedReductionAmount, 
										  minVariance)); 
		}
	}
	
	override
	public ShadowCameraTransform calcShadowCameraTransform(Vector3f mainCameraPos, Quaternion mainCameraRot)
	{
		ShadowCameraTransform result;
		result.pos = mainCameraPos.add(mainCameraRot.getForward().mul(cast(float)this.halfShadowArea)); 
		result.rot = getTransform().getTransformedRot();
		return result;
	}

	public Vector3f getDirection()
	{
		return getTransform().getTransformedRot().getForward();
	}
}