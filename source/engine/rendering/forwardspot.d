module engine.rendering.forwardspot;

import engine.core.transform;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.baselight;
import engine.rendering.spotlight;
import engine.rendering.material;
import engine.components.pointlight;

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
		setUniform("spotLight", getRenderingEngine().getSpotLight());
	}

	public void setUniform(string uniformName, BaseLight baseLight)
	{
		super.setUniform(uniformName ~ ".color", baseLight.getColor());
		setUniformf(uniformName ~ ".intensity", baseLight.getIntensity());
	}

	public void setUniform(string uniformName, PointLight pointLight)
	{
		setUniform(uniformName ~ ".base", pointLight.getBaseLight());
		setUniformf(uniformName ~ ".atten.constant", pointLight.getAtten().getConstant());
		setUniformf(uniformName ~ ".atten.linear", pointLight.getAtten().getLinear());
		setUniformf(uniformName ~ ".atten.exponent", pointLight.getAtten().getExponent());
		super.setUniform(uniformName ~ ".position", pointLight.getPosition());
		setUniformf(uniformName ~ ".range", pointLight.getRange());
	}

	public void setUniform(string uniformName, SpotLight spotLight)
	{
		setUniform(uniformName ~ ".pointLight", spotLight.getPointLight());
		super.setUniform(uniformName ~ ".direction", spotLight.getDirection());
		setUniformf(uniformName ~ ".cutoff", spotLight.getCutoff());
	}
}