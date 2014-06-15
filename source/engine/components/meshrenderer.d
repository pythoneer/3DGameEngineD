module engine.rendering.meshrenderer;

import engine.core.transform;
import engine.rendering.mesh;
import engine.rendering.material;
import engine.rendering.shader;
import engine.rendering.basicshader;
import engine.components.gamecomponent;

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
	public void render(Shader shader)
	{
		shader.bind();
		shader.updateUniforms(getTransform(), material);
		mesh.draw();
	}
}