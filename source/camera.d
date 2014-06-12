module camera;

import std.stdio;

//import gl3n.linalg;
import derelict.sdl2.sdl;

import time;
import vector3f;
import input;

class Camera
{
//	public static const Vector3f yAxis = new Vector3f(0,1,0);

	private Vector3f pos;
	private Vector3f forward;
	private Vector3f up;

	public this()
	{
		this( new Vector3f(0,0,0), new Vector3f(0,0,1), new Vector3f(0,1,0));
	}

	public this(Vector3f pos, Vector3f forward, Vector3f up)
	{
		this.pos = pos;
		this.forward = forward;
		this.up = up;

		up.normalize();
		forward.normalize();
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
		Vector3f hAxis = new Vector3f(0,1,0).cross(forward);
		hAxis.normalize();

		forward.rotate(angle, new Vector3f(0,1,0));
		forward.normalize();

		up = forward.cross(hAxis);
		up.normalize();
	}

	public void rotateX(float angle)
	{
		Vector3f hAxis = new Vector3f(0,1,0).cross(forward);
		hAxis.normalize();

		forward.rotate(angle, hAxis);
		forward.normalize();

		up = forward.cross(hAxis);
		up.normalize();
	}

	public Vector3f getLeft()
	{
		Vector3f left = forward.cross(up);
		left.normalize();
		return left;
	}

	public Vector3f getRight()
	{
		Vector3f right = up.cross(forward);
		right.normalize();
		return right;
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