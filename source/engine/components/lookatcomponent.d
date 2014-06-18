module engine.components.lookatcomponent;

import engine.core.quaternion;
import engine.core.vector3f;
import engine.rendering.shader;
import engine.rendering.renderingengine;
import engine.components.gamecomponent;

public class LookAtComponent : GameComponent
{
	RenderingEngine renderingEngine;

	override
	public void update(float delta)
	{
		if(renderingEngine !is null)
		{
			Quaternion newRot = getTransform().getLookAtDirection(renderingEngine.getMainCamera().getTransform().getTransformedPos(),
					new Vector3f(0,1,0));
					//getTransform().getRot().getUp());

			getTransform().setRot(getTransform().getRot().nlerp(newRot, delta * 5.0f, true));
			//getTransform().setRot(getTransform().getRot().slerp(newRot, delta * 5.0f, true));
		}
	}

	override
	public void render(Shader shader, RenderingEngine renderingEngine)
	{
		this.renderingEngine = renderingEngine;
	}
}