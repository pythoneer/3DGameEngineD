module engine.core.quaternion;

import std.math;

import engine.core.vector3f;
import engine.core.matrix;
import engine.core.util;

class Quaternion
{
	private float x;
	private float y;
	private float z;
	private float w;

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
	
	public this(Vector3f axis, float angle)
 	{
 		float sinHalfAngle = cast(float)sin(angle / 2);
 		float cosHalfAngle = cast(float)cos(angle / 2);
 
 		this.x = axis.getX() * sinHalfAngle;
 		this.y = axis.getY() * sinHalfAngle;
 		this.z = axis.getZ() * sinHalfAngle;
 		this.w = cosHalfAngle;
 	}
 	
 	public Matrix4f toRotationMatrix()
	{
		Vector3f forward =  new Vector3f(2.0f * (x*z - w*y), 2.0f * (y*z + w*x), 1.0f - 2.0f * (x*x + y*y));
		Vector3f up = new Vector3f(2.0f * (x*y + w*z), 1.0f - 2.0f * (x*x + z*z), 2.0f * (y*z - w*x));
		Vector3f right = new Vector3f(1.0f - 2.0f * (y*y + z*z), 2.0f * (x*y - w*z), 2.0f * (x*z + w*y));

		return new Matrix4f().initRotation(forward, up, right);
	}
	
	public float dot(Quaternion r)
 	{
 		return x * r.getX() + y * r.getY() + z * r.getZ() + w * r.getW();
 	}
 
 	public Quaternion nlerp(Quaternion dest, float lerpFactor, bool shortest)
 	{
 		Quaternion correctedDest = dest;
 
 		if(shortest && this.dot(dest) < 0)
 			correctedDest = new Quaternion(-dest.getX(), -dest.getY(), -dest.getZ(), -dest.getW());
 
 		return correctedDest.sub(this).mul(lerpFactor).add(this).normalized();
 	}
 
 	public Quaternion slerp(Quaternion dest, float lerpFactor, bool shortest)
 	{
 		const float EPSILON = 1e3f;
 
 		float cos = this.dot(dest);
 		Quaternion correctedDest = dest;
 
 		if(shortest && cos < 0)
 		{
 			cos = -cos;
 			correctedDest = new Quaternion(-dest.getX(), -dest.getY(), -dest.getZ(), -dest.getW());
 		}
 
 		if(abs(cos) >= 1 - EPSILON)
 			return nlerp(correctedDest, lerpFactor, false);
 
 		float sinVal = cast(float)sqrt(1.0f - cos * cos);
 		float angle = cast(float)atan2(sinVal, cos);
 		float invSin =  1.0f/sinVal;
 
 		float srcFactor = cast(float)sin((1.0f - lerpFactor) * angle) * invSin;
 		float destFactor = cast(float)sin((lerpFactor) * angle) * invSin;
 
 		return this.mul(srcFactor).add(correctedDest.mul(destFactor));
 	}
 
 	//From Ken Shoemake's "Quaternion Calculus and Fast Animation" article
 	public this(Matrix4f rot)
 	{
 		float trace = rot.get(0, 0) + rot.get(1, 1) + rot.get(2, 2);
 
 		if(trace > 0)
 		{
 			float s = 0.5f / cast(float)sqrt(trace+ 1.0f);
 			w = 0.25f / s;
 			x = (rot.get(1, 2) - rot.get(2, 1)) * s;
 			y = (rot.get(2, 0) - rot.get(0, 2)) * s;
 			z = (rot.get(0, 1) - rot.get(1, 0)) * s;
 		}
 		else
 		{
 			if(rot.get(0, 0) > rot.get(1, 1) && rot.get(0, 0) > rot.get(2, 2))
 			{
 				float s = 2.0f * cast(float)sqrt(1.0f + rot.get(0, 0) - rot.get(1, 1) - rot.get(2, 2));
 				w = (rot.get(1, 2) - rot.get(2, 1)) / s;
 				x = 0.25f * s;
 				y = (rot.get(1, 0) + rot.get(0, 1)) / s;
 				z = (rot.get(2, 0) + rot.get(0, 2)) / s;
 			}
 			else if(rot.get(1, 1) > rot.get(2, 2))
 			{
 				float s = 2.0f * cast(float)sqrt(1.0f + rot.get(1, 1) - rot.get(0, 0) - rot.get(2, 2));
 				w = (rot.get(2, 0) - rot.get(0, 2)) / s;
 				x = (rot.get(1, 0) + rot.get(0, 1)) / s;
 				y = 0.25f * s;
 				z = (rot.get(2, 1) + rot.get(1, 2)) / s;
 			}
 			else
 			{
 				float s = 2.0f * cast(float)sqrt(1.0f + rot.get(2, 2) - rot.get(0, 0) - rot.get(1, 1));
 				w = (rot.get(0, 1) - rot.get(1, 0) ) / s;
 				x = (rot.get(2, 0) + rot.get(0, 2) ) / s;
 				y = (rot.get(1, 2) + rot.get(2, 1) ) / s;
 				z = 0.25f * s;
 			}
 		}
 
 		float length = cast(float)sqrt(x*x + y*y + z*z +w*w);
 		x /= length;
 		y /= length;
 		z /= length;
 		w /= length;
 	}
 	
	public Vector3f getForward()
	{
		return new Vector3f(0,0,1).rotate(this);
	}

	public Vector3f getBack()
	{
		return new Vector3f(0,0,-1).rotate(this);
	}

	public Vector3f getUp()
	{
		return new Vector3f(0,1,0).rotate(this);
	}

	public Vector3f getDown()
	{
		return new Vector3f(0,-1,0).rotate(this);
	}

	public Vector3f getRight()
	{
		return new Vector3f(1,0,0).rotate(this);
	}

	public Vector3f getLeft()
	{
		return new Vector3f(-1,0,0).rotate(this);
	}
 	
 	public Quaternion set(float x, float y, float z, float w) { this.x = x; this.y = y; this.z = z; this.w = w; return this; }
	public Quaternion set(Quaternion r) { set(r.getX(), r.getY(), r.getZ(), r.getW()); return this; }

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

	public Quaternion mul(float r)
	{
		return new Quaternion(x * r, y * r, z * r, w * r);
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
	
	public Quaternion sub(Quaternion r)
 	{
 		return new Quaternion(x - r.getX(), y - r.getY(), z - r.getZ(), w - r.getW());
 	}
 
 	public Quaternion add(Quaternion r)
 	{
 		return new Quaternion(x + r.getX(), y + r.getY(), z + r.getZ(), w + r.getW());
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
	
	public bool equals(Quaternion r)
	{
		return x == r.getX() && y == r.getY() && z == r.getZ() && w == r.getW();
	}
	
}