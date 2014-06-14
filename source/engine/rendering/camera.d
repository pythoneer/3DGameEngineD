module engine.rendering.camera;

import std.stdio;

//import gl3n.linalg;
import derelict.sdl2.sdl;

import engine.core.time;
import engine.core.vector3f;
import engine.core.input;
import engine.core.matrix;	

class Camera
{
//	public static const Vector3f yAxis = new Vector3f(0,1,0);

	private Vector3f pos;
	private Vector3f forward;
	private Vector3f up;
	private Matrix4f projection;

	public this(float fov, float aspect, float zNear, float zFar)
	{
		this.pos = new Vector3f(0,0,0);
		this.forward = new Vector3f(0,0,1).normalized();
		this.up = new Vector3f(0,1,0).normalized();
		this.projection = new Matrix4f().initPerspective(fov, aspect, zNear, zFar);
	}
	
	public Matrix4f getViewProjection()
	{
		Matrix4f cameraRotation = new Matrix4f().initRotation(forward, up);
		Matrix4f cameraTranslation = new Matrix4f().initTranslation(-pos.getX(), -pos.getY(), -pos.getZ());

		return projection.mul(cameraRotation.mul(cameraTranslation));
	}


	public void input()
	{
		float movAmt = cast(float)(10 * Time.getDelta());
		float rotAmt = cast(float)(100 * Time.getDelta());

		if(Input.isKeyPressed(SDLK_w))
		{
			move(getForward(), movAmt);
		}
		if(Input.isKeyPressed(SDLK_s))
		{
			move(getForward(), -movAmt);
		}
		if(Input.isKeyPressed(SDLK_a))
		{
			move(getLeft(), movAmt);
		}
		if(Input.isKeyPressed(SDLK_d))
		{
			move(getRight(), movAmt);
		}


		if(Input.isKeyPressed(SDLK_i))
		{
//			writeln("-rotx");
			rotateX(-rotAmt);
		}
		if(Input.isKeyPressed(SDLK_k))
		{
//			writeln("rotx");
			rotateX(rotAmt);
		}
		if(Input.isKeyPressed(SDLK_j))
		{
//			writeln("-roty");
			rotateY(-rotAmt);
		}
		if(Input.isKeyPressed(SDLK_l))
		{
//			writeln("roty");
			rotateY(rotAmt);
		}

//		if(Input.getKey(Input.KEY_UP))
//			rotateX(-rotAmt);
//		if(Input.getKey(Input.KEY_DOWN))
//			rotateX(rotAmt);
//		if(Input.getKey(Input.KEY_LEFT))
//			rotateY(-rotAmt);
//		if(Input.getKey(Input.KEY_RIGHT))
//			rotateY(rotAmt);
	}

	public void move(Vector3f dir, float amt)
	{
		pos = pos.add(dir.mul(amt));
	}

	public void rotateY(float angle)
	{
		Vector3f hAxis = new Vector3f(0,1,0).cross(forward).normalized();

		forward = forward.rotate(angle, new Vector3f(0,1,0)).normalized();

		up = forward.cross(hAxis).normalized();
	}

	public void rotateX(float angle)
	{
		Vector3f hAxis = new Vector3f(0,1,0).cross(forward).normalized();

		forward = forward.rotate(angle, hAxis).normalized();

		up = forward.cross(hAxis).normalized();
	}

	public Vector3f getLeft()
	{
		return forward.cross(up).normalized();
	}

	public Vector3f getRight()
	{
		return up.cross(forward).normalized();
	}

	public Vector3f getPos()
	{
		return pos;
	}

	public void setPos(Vector3f pos)
	{
		this.pos = pos;
	}

	public Vector3f getForward()
	{
		return forward;
	}

	public void setForward(Vector3f forward)
	{
		this.forward = forward;
	}

	public Vector3f getUp()
	{
		return up;
	}

	public void setUp(Vector3f up)
	{
		this.up = up;
	}
}