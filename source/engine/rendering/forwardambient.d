module engine.rendering.forwardambient;

import derelict.opengl3.gl3;

import engine.core.transform;
import engine.core.matrix;
import engine.rendering.shader;
import engine.rendering.material;
import engine.rendering.renderingengine;

class ForwardAmbient : Shader
{
	public this()
	{
		super("forward-ambient");
	}

	override
	public void updateUniforms(Transform transform, Material material, RenderingEngine renderingEngine)
	{
		Matrix4f worldMatrix = transform.getTransformation();
		Matrix4f projectedMatrix = renderingEngine.getMainCamera().getViewProjection().mul(worldMatrix);
 		material.getTexture("diffuse").bind();

		setUniform("MVP", projectedMatrix);
		setUniform("ambientIntensity", renderingEngine.getAmbientLight());
	}
}