module engine.rendering.forwardspot;

import engine.core.transform;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.material;
import engine.components.pointlight;
import engine.components.baselight;
import engine.components.spotlight;

class ForwardSpot : Shader
{
	public this()
	{
		super();

		addVertexShaderFromFile("forward-spot.vs");
		addFragmentShaderFromFile("forward-spot.fs");

		setAttribLocation("position", 0);
		setAttribLocation("texCoord", 1);
		setAttribLocation("normal", 2);

		compileShader();

		addUniform("model");
		addUniform("MVP");

		addUniform("specularIntensity");
		addUniform("specularPower");
		addUniform("eyePos");

		addUniform("spotLight.pointLight.base.color");
		addUniform("spotLight.pointLight.base.intensity");
		addUniform("spotLight.pointLight.atten.constant");
		addUniform("spotLight.pointLight.atten.linear");
		addUniform("spotLight.pointLight.atten.exponent");
		addUniform("spotLight.pointLight.position");
		addUniform("spotLight.pointLight.range");
		addUniform("spotLight.direction");
		addUniform("spotLight.cutoff");
	}

	override
	public void updateUniforms(Transform transform, Material material)
	{
		Matrix4f worldMatrix = transform.getTransformation();
		Matrix4f projectedMatrix = getRenderingEngine().getMainCamera().getViewProjection().mul(worldMatrix);
		material.getTexture().bind();

		super.setUniform("model", worldMatrix);
		super.setUniform("MVP", projectedMatrix);

		setUniformf("specularIntensity", material.getSpecularIntensity());
		setUniformf("specularPower", material.getSpecularPower());

		super.setUniform("eyePos", getRenderingEngine().getMainCamera().getPos());
		setUniformSpotLight("spotLight", cast(SpotLight)getRenderingEngine().getActiveLight());
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
		super.setUniform(uniformName ~ ".position", pointLight.getPosition());
		setUniformf(uniformName ~ ".range", pointLight.getRange());
	}

	public void setUniformSpotLight(string uniformName, SpotLight spotLight)
	{
		setUniformPointLight(uniformName ~ ".pointLight", spotLight);
		super.setUniform(uniformName ~ ".direction", spotLight.getDirection());
		setUniformf(uniformName ~ ".cutoff", spotLight.getCutoff());
	}
}