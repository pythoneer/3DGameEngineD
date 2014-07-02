module engine.components.directionallight;

import engine.core.vector3f;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.shadowinfo;
import engine.components.baselight;

class DirectionalLight : BaseLight
{
	public this(Vector3f color, float intensity)
	{
		super(color, intensity);

		setShader(new Shader("forward-directional"));		
		setShadowInfo( new ShadowInfo(new Matrix4f().initOrthographic(-40, 40,-40, 40,-40, 40)));
	}

	public Vector3f getDirection()
	{
		return getTransform().getTransformedRot().getForward();
	}
}