module basicshader;

import shader;
import engine.core.matrix;
import material;
//import resourceloader;
import renderutil;

public class BasicShader : Shader
{
	//private static final BasicShader instance = new BasicShader();

//	public static BasicShader getInstance()
//	{
//		return instance;
//	}

	public this()
	{
		super();

//		addVertexShader(ResourceLoader.loadShader("basicVertex.vs"));
//		addFragmentShader(ResourceLoader.loadShader("basicFragment.fs"));
		addVertexShaderFromFile("basicVertex.vs");
 		addFragmentShaderFromFile("basicFragment.fs");
		compileShader();

		addUniform("transform");
		addUniform("color");
	}
	
	override 
	public void updateUniforms(Matrix4f worldMatrix, Matrix4f projectedMatrix, Material material)
	{
		if(material.getTexture() !is null)
		{
			material.getTexture().bind();
		}			
		else
		{
			RenderUtil.unbindTextures();
		}
			

		setUniform("transform", projectedMatrix);
		setUniform("color", material.getColor());
	}
}