module engine.rendering.meshrenderer;

import engine.core.transform;
import engine.core.gamecomponent;
import engine.rendering.mesh;
import engine.rendering.material;
import engine.rendering.shader;
import engine.rendering.basicshader;


class MeshRenderer : GameComponent
{
	private Mesh mesh;
	private Material material;
//	private Shader shader;

	public this(Mesh mesh, Material material)
	{
		this.mesh = mesh;
		this.material = material;
//		this.shader = new BasicShader();
	}

	override
	public void input(Transform transform, float delta) {}

	override
	public void update(Transform transform, float delta) {}

	override
	public void render(Transform transform, Shader shader)
	{
		shader.bind();
		shader.updateUniforms(transform, material);
		mesh.draw();
	}
}