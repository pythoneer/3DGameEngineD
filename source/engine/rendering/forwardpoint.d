module engine.rendering.forwardpoint;

import engine.core.transform;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.baselight;
import engine.rendering.material;
import engine.components.pointlight;

class ForwardPoint : Shader
{
	public this()
	{
		super();

		addVertexShaderFromFile("forward-point.vs");
		addFragmentShaderFromFile("forward-point.fs");

		setAttribLocation("position", 0);
		setAttribLocation("texCoord", 1);
		setAttribLocation("normal", 2);

		compileShader();

		addUniform("model");
		addUniform("MVP");

		addUniform("specularIntensity");
		addUniform("specularPower");
		addUniform("eyePos");

		addUniform("pointLight.base.color");
		addUniform("pointLight.base.intensity");
		addUniform("pointLight.atten.constant");
		addUniform("pointLight.atten.linear");
		addUniform("pointLight.atten.exponent");
		addUniform("pointLight.position");
		addUniform("pointLight.range");
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
		setUniform("pointLight", getRenderingEngine().getActivePointLight());
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


}