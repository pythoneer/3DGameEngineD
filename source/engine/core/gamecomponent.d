module engine.core.gamecomponent;

import engine.core.transform;
import engine.rendering.shader;

interface GameComponent
{
	public void input(Transform transform);
	public void update(Transform transform);
	public void render(Transform transform, Shader shader);
}