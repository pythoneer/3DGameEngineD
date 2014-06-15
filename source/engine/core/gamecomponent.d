module engine.core.gamecomponent;

import engine.core.transform;
import engine.rendering.shader;

interface GameComponent
{
	public void input(Transform transform, float delta);
 	public void update(Transform transform, float delta);
	public void render(Transform transform, Shader shader);
}