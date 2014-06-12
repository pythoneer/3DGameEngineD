module phongshader;

import shader;
import vector3f;
import matrix;
import material;
import resourceloader;
import renderutil;

class PhongShader : Shader
{
//	private static final PhongShader instance = new PhongShader();
//
//	public static PhongShader getInstance()
//	{
//		return instance;
//	}

	private static Vector3f ambientLight;

	public this()
	{
		super();

		addVertexShader(ResourceLoader.loadShader("phongVertex.vs"));
		addFragmentShader(ResourceLoader.loadShader("phongFragment.fs"));
		compileShader();

		addUniform("transform");
		addUniform("baseColor");
		addUniform("ambientLight");
	}

	override
	public void updateUniforms(Matrix4f worldMatrix, Matrix4f projectedMatrix, Material material)
	{
		if(material.getTexture() !is null)
			material.getTexture().bind();
		else
			RenderUtil.unbindTextures();

		setUniform("transform", projectedMatrix);
		setUniform("baseColor", material.getColor());
		setUniform("ambientLight", ambientLight);
	}

	public static Vector3f getAmbientLight()
	{
		return ambientLight;
	}

	public static void setAmbientLight(Vector3f ambientLight)
	{
		PhongShader.ambientLight = ambientLight;
	}
}