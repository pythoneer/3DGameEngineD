module engine.rendering.basicshader;

import engine.rendering.shader;
import engine.core.matrix;
import engine.rendering.material;
import engine.rendering.renderutil;

public class BasicShader : Shader
{
	public this()
	{
		super();
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