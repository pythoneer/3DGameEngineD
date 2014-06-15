module engine.core.quaternion;

import std.math;

import engine.core.vector3f;
import engine.core.matrix;

class Quaternion
{
	private float x;
	private float y;
	private float z;
	private float w;

	public this()
 	{
 		this(0,0,0,1);
 	}

	public this(float x, float y, float z, float w)
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public float length()
	{
		return cast(float)sqrt(x * x + y * y + z * z + w * w);
	}
	
	public Quaternion initRotation(Vector3f axis, float angle)
 	{
 		float sinHalfAngle = cast(float)sin(angle / 2);
 		float cosHalfAngle = cast(float)cos(angle / 2);
 
 		this.x = axis.getX() * sinHalfAngle;
 		this.y = axis.getY() * sinHalfAngle;
 		this.z = axis.getZ() * sinHalfAngle;
 		this.w = cosHalfAngle;
 
 		return this;
 	}
 	
 	public Matrix4f toRotationMatrix()
 	{
 		return new Matrix4f().initRotation(getForward(), getUp(), getRight());
 	}
 
 	public Vector3f getForward()
 	{
 		return new Vector3f(2.0f * (x*z - w*y), 2.0f * (y*z + w*x), 1.0f - 2.0f * (x*x + y*y));
 	}
 
 	public Vector3f getBack()
 	{
 		return new Vector3f(-2.0f * (x*z - w*y), -2.0f * (y*z + w*x), -(1.0f - 2.0f * (x*x + y*y)));
 	}
 
 	public Vector3f getUp()
 	{
 		return new Vector3f(2.0f * (x*y + w*z), 1.0f - 2.0f * (x*x + z*z), 2.0f * (y*z - w*x));
 	}
 
 	public Vector3f getDown()
 	{
 		return new Vector3f(-2.0f * (x*y + w*z), -(1.0f - 2.0f * (x*x + z*z)), -2.0f * (y*z - w*x));
 	}
 
 	public Vector3f getRight()
 	{
 		return new Vector3f(1.0f - 2.0f * (y*y + z*z), 2.0f * (x*y - w*z), 2.0f * (x*z + w*y));
 	}
 
 	public Vector3f getLeft()
 	{
 		return new Vector3f(-(1.0f - 2.0f * (y*y + z*z)), -2.0f * (x*y - w*z), -2.0f * (x*z + w*y));
 	}

	public Quaternion normalized()
	{
		float length = length();

		x /= length;
		y /= length;
		z /= length;
		w /= length;

		return new Quaternion(x / length, y / length, z / length, w / length);
	}

	public Quaternion conjugate()
	{
		return new Quaternion(-x, -y, -z, w);
	}

	public Quaternion mul(Quaternion r)
	{
		float w_ = w * r.getW() - x * r.getX() - y * r.getY() - z * r.getZ();
		float x_ = x * r.getW() + w * r.getX() + y * r.getZ() - z * r.getY();
		float y_ = y * r.getW() + w * r.getY() + z * r.getX() - x * r.getZ();
		float z_ = z * r.getW() + w * r.getZ() + x * r.getY() - y * r.getX();

		return new Quaternion(x_, y_, z_, w_);
	}

	public Quaternion mul(Vector3f r)
	{
		float w_ = -x * r.getX() - y * r.getY() - z * r.getZ();
		float x_ =  w * r.getX() + y * r.getZ() - z * r.getY();
		float y_ =  w * r.getY() + z * r.getX() - x * r.getZ();
		float z_ =  w * r.getZ() + x * r.getY() - y * r.getX();

		return new Quaternion(x_, y_, z_, w_);
	}

	public float getX()
	{
		return x;
	}

	public void setX(float x)
	{
		this.x = x;
	}

	public float getY()
	{
		return y;
	}

	public void setY(float y)
	{
		this.y = y;
	}

	public float getZ()
	{
		return z;
	}

	public void setZ(float z)
	{
		this.z = z;
	}

	public float getW()
	{
		return w;
	}

	public void setW(float w)
	{
		this.w = w;
	}
}