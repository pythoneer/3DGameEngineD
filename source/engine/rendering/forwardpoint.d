module engine.rendering.forwardpoint;

import engine.core.transform;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.material;
import engine.components.baselight;
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
		setUniformPointLight("pointLight", cast(PointLight)getRenderingEngine().getActiveLight());
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


}