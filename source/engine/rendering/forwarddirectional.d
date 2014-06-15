module engine.rendering.forwarddirectional;

import engine.core.transform;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.material;
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
		super();

		addVertexShaderFromFile("forward-directional.vs");
		addFragmentShaderFromFile("forward-directional.fs");

		setAttribLocation("position", 0);
		setAttribLocation("texCoord", 1);
		setAttribLocation("normal", 2);

		compileShader();

		addUniform("model");
		addUniform("MVP");

		addUniform("specularIntensity");
		addUniform("specularPower");
		addUniform("eyePos");

		addUniform("directionalLight.base.color");
		addUniform("directionalLight.base.intensity");
		addUniform("directionalLight.direction");
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
		setUniformDirectionalLight("directionalLight", cast(DirectionalLight)getRenderingEngine().getActiveLight());
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