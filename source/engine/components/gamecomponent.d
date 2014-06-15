module engine.components.gamecomponent;

import engine.core.transform;
import engine.rendering.shader;
import engine.rendering.renderingengine;

class GameComponent
{
	public void input(Transform transform, float delta) {}
	public void update(Transform transform, float delta) {}
	public void render(Transform transform, Shader shader) {}

	public void addToRenderingEngine(RenderingEngine renderingEngine) {}
}