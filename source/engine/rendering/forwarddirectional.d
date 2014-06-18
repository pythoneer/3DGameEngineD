module engine.rendering.forwarddirectional;

import engine.core.transform;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.material;
import engine.rendering.renderingengine;
import engine.components.baselight;
import engine.components.directionallight;

class ForwardDirectional : Shader
{
//	private static final ForwardDirectional instance = new ForwardDirectional();
//
//	public static ForwardDirectional getInstance()
//	{
//		return instance;
//	}

	public this()
	{
		super("forward-directional");
	}
	
	override
	public void updateUniforms(Transform transform, Material material, RenderingEngine renderingEngine)
	{
		Matrix4f worldMatrix = transform.getTransformation();
		Matrix4f projectedMatrix = renderingEngine.getMainCamera().getViewProjection().mul(worldMatrix);
 		material.getTexture("diffuse").bind();

		super.setUniform("model", worldMatrix);
		super.setUniform("MVP", projectedMatrix);

		setUniformf("specularIntensity", material.getFloat("specularIntensity"));
 		setUniformf("specularPower", material.getFloat("specularPower"));

		super.setUniform("eyePos", renderingEngine.getMainCamera().getTransform().getTransformedPos());
 		setUniformDirectionalLight("directionalLight", cast(DirectionalLight)renderingEngine.getActiveLight());
	}

	public void setUniformBaseLight(string uniformName, BaseLight baseLight)
	{
		super.setUniform(uniformName ~ ".color", baseLight.getColor());
		setUniformf(uniformName ~ ".intensity", baseLight.getIntensity());
	}

	public void setUniformDirectionalLight(string uniformName, DirectionalLight directionalLight)
	{
		setUniformBaseLight(uniformName ~ ".base", directionalLight);
		super.setUniform(uniformName ~ ".direction", directionalLight.getDirection());
	}
}