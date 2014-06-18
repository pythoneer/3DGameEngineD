module engine.rendering.forwardspot;

import engine.core.transform;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.material;
import engine.rendering.renderingengine;
import engine.components.pointlight;
import engine.components.baselight;
import engine.components.spotlight;

class ForwardSpot : Shader
{
	public this()
	{
		super("forward-spot");
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
 		setUniformSpotLight("spotLight", cast(SpotLight)renderingEngine.getActiveLight());
	}

	public void setUniformBaseLight(string uniformName, BaseLight baseLight)
	{
		super.setUniform(uniformName ~ ".color", baseLight.getColor());
		setUniformf(uniformName ~ ".intensity", baseLight.getIntensity());
	}

	public void setUniformPointLight(string uniformName, PointLight pointLight)
	{
		setUniformBaseLight(uniformName ~ ".base", pointLight);
 		setUniformf(uniformName ~ ".atten.constant", pointLight.getConstant());
 		setUniformf(uniformName ~ ".atten.linear", pointLight.getLinear());
 		setUniformf(uniformName ~ ".atten.exponent", pointLight.getExponent());
		super.setUniform(uniformName ~ ".position", pointLight.getTransform().getTransformedPos());
		setUniformf(uniformName ~ ".range", pointLight.getRange());
	}

	public void setUniformSpotLight(string uniformName, SpotLight spotLight)
	{
		setUniformPointLight(uniformName ~ ".pointLight", spotLight);
		super.setUniform(uniformName ~ ".direction", spotLight.getDirection());
		setUniformf(uniformName ~ ".cutoff", spotLight.getCutoff());
	}
}