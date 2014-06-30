module engine.components.directionallight;

import engine.core.vector3f;
import engine.rendering.shader;
import engine.components.baselight;

class DirectionalLight : BaseLight
{
	public this(Vector3f color, float intensity)
	{
		super(color, intensity);

		setShader(new Shader("forward-directional"));
	}

	public Vector3f getDirection()
	{
		return getTransform().getTransformedRot().getForward();
	}
}