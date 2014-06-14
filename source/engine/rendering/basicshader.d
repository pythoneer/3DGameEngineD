module engine.rendering.basicshader;

import engine.core.matrix;
import engine.core.transform;
import engine.rendering.shader;
import engine.rendering.material;

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
	public void updateUniforms(Transform transform, Material material)
	{
		Matrix4f worldMatrix = transform.getTransformation();
 		Matrix4f projectedMatrix = getRenderingEngine().getMainCamera().getViewProjection().mul(worldMatrix);
		material.getTexture().bind();
			
		setUniform("transform", projectedMatrix);
		setUniform("color", material.getColor());
	}
}