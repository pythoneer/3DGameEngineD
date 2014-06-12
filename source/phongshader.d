module phongshader;

import shader;
import vector3f;
import matrix;
import material;
import resourceloader;
import renderutil;
import directionallight;
import baselight;

class PhongShader : Shader
{
//	private static final PhongShader instance = new PhongShader();
//
//	public static PhongShader getInstance()
//	{
//		return instance;
//	}

	private static Vector3f ambientLight;// = new Vector3f(0.1f,0.1f,0.1f);
	private static DirectionalLight directionalLight;// = new DirectionalLight(new BaseLight(new Vector3f(0,0,0), 0), new Vector3f(0,0,0));

	public this()
	{
		super();

		addVertexShader(ResourceLoader.loadShader("phongVertex.vs"));
		addFragmentShader(ResourceLoader.loadShader("phongFragment.fs"));
		compileShader();

		addUniform("transform");
		addUniform("transformProjected");
		addUniform("baseColor");
		addUniform("ambientLight");
		
		addUniform("directionalLight.base.color");
 		addUniform("directionalLight.base.intensity");
 		addUniform("directionalLight.direction");
	}

	override
	public void updateUniforms(Matrix4f worldMatrix, Matrix4f projectedMatrix, Material material)
	{
		if(material.getTexture() !is null)
			material.getTexture().bind();
		else
			RenderUtil.unbindTextures();

		super.setUniform("transformProjected", projectedMatrix);
 		super.setUniform("transform", worldMatrix);
  		super.setUniform("baseColor", material.getColor());
  		super.setUniform("ambientLight", ambientLight);
 		setUniform("directionalLight", directionalLight);
	}

	public static Vector3f getAmbientLight()
	{
		return ambientLight;
	}

	public static void setAmbientLight(Vector3f ambientLight)
	{
		PhongShader.ambientLight = ambientLight;
	}
	
	public static void setDirectionalLight(DirectionalLight directionalLight)
	{
		PhongShader.directionalLight = directionalLight;
	}

	public void setUniform(string uniformName, BaseLight baseLight)
	{
		super.setUniform(uniformName ~ ".color", baseLight.getColor());
		setUniformf(uniformName ~ ".intensity", baseLight.getIntensity());
	}

	public void setUniform(string uniformName, DirectionalLight directionalLight)
	{
		setUniform(uniformName ~ ".base", directionalLight.getBase());
		super.setUniform(uniformName ~ ".direction", directionalLight.getDirection());
	}
}