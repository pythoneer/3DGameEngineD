module engine.components.camera;

import std.stdio;

import derelict.sdl2.sdl;

import engine.core.time;
import engine.core.vector3f;
import engine.core.input;
import engine.core.matrix;	
import engine.core.util;
import engine.core.quaternion;
import engine.rendering.renderingengine;
import engine.components.gamecomponent;

class Camera : GameComponent
{
//	public static const Vector3f yAxis = new Vector3f(0,1,0);

	private Matrix4f projection;

	public this(float fov, float aspect, float zNear, float zFar)
	{
		this.projection = new Matrix4f().initPerspective(fov, aspect, zNear, zFar);
	}
	
	public Matrix4f getViewProjection()
	{
		Matrix4f cameraRotation = getTransform().getTransformedRot().conjugate().toRotationMatrix();
		Vector3f cameraPos = getTransform().getTransformedPos().mul(-1);

		Matrix4f cameraTranslation = new Matrix4f().initTranslation(cameraPos.getX(), cameraPos.getY(), cameraPos.getZ());

		return projection.mul(cameraRotation.mul(cameraTranslation));
	}
	
	override
	public void addToRenderingEngine(RenderingEngine renderingEngine)
	{
		renderingEngine.addCamera(this);
	}

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