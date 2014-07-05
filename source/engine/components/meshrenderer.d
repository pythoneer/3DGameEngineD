module engine.components.meshrenderer;

import engine.core.transform;
import engine.rendering.mesh;
import engine.rendering.material;
import engine.rendering.shader;
import engine.components.gamecomponent;
import engine.rendering.renderingengine;

class MeshRenderer : GameComponent
{
	private Mesh mesh;
	private Material material;

	public this(Mesh mesh, Material material)
	{
		this.mesh = mesh;
		this.material = material;
	}

	override
	public void render(Shader shader, RenderingEngine renderingEngine)
	{
		shader.bind();
		shader.updateUniforms(getTransform(), material, renderingEngine);
		mesh.draw();
	}
}