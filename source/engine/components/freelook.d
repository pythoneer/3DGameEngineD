module engine.components.freelook;

import derelict.sdl2.sdl;

import engine.core.vector3f;
import engine.core.input;
import engine.core.util;
import engine.components.gamecomponent;

public class FreeLook : GameComponent
{
	override
	public void input(float delta)
	{
		
		float sensitivity = 0.5f;
//		float movAmt = cast(float)(10 * delta);
		
		float movAmt = cast(float)(10 * delta);
		float rotAmt = cast(float)(100 * delta);

		if(Input.isKeyPressed(SDLK_w))
		{
			move(getTransform().getRot().getForward(), movAmt);
		}
		if(Input.isKeyPressed(SDLK_s))
		{
			move(getTransform().getRot().getForward(), -movAmt);
		}
		if(Input.isKeyPressed(SDLK_a))
		{
			move(getTransform().getRot().getLeft(), movAmt);
		}
		if(Input.isKeyPressed(SDLK_d))
		{
			move(getTransform().getRot().getRight(), movAmt);
		}


		if(Input.isKeyPressed(SDLK_i))
		{
			getTransform().rotate(getTransform().getRot().getRight(), cast(float) Util.toRadians(-rotAmt * sensitivity));
		}
		if(Input.isKeyPressed(SDLK_k))
		{
			getTransform().rotate(getTransform().getRot().getRight(), cast(float) Util.toRadians(rotAmt * sensitivity));
		}
		if(Input.isKeyPressed(SDLK_j))
		{
			getTransform().rotate(new Vector3f(0,1,0), cast(float) Util.toRadians(-rotAmt * sensitivity));
		}
		if(Input.isKeyPressed(SDLK_l))
		{
			getTransform().rotate(new Vector3f(0,1,0), cast(float) Util.toRadians(rotAmt * sensitivity));
		}

	}

	public void move(Vector3f dir, float amt)
	{
		getTransform().setPos(getTransform().getPos().add(dir.mul(amt)));
	}
}