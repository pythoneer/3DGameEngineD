﻿module vector3f;

import std.math : sqrt;


class Vector3f
{
	private float x;
	private float y;
	private float z;
	
	public this(float x, float y, float z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public float length()
	{
		return cast(float) sqrt(x * x + y * y + z * z);
	}
	
	public float dot(Vector3f r)
	{
		return x * r.getX() + y * r.getY() + z * r.getZ();
	}
	
	public Vector3f cross(Vector3f r)
	{
		float x_ = y * r.getZ() - z * r.getY();
		float y_ = z * r.getX() - x * r.getZ();
		float z_ = x * r.getY() - y * r.getX();
		
		return new Vector3f(x_, y_, z_);
	}
	
	public Vector3f normalize()
	{
		float length = length();
		
		x /= length;
		y /= length;
		z /= length;
		
		return this;
	}
	
	public Vector3f rotate(float angle, Vector3f axis)
	{
//		float sinHalfAngle = const(float)sin(Math.toRadians(angle / 2));
//		float cosHalfAngle = const(float)cos(Math.toRadians(angle / 2));
//
//		float rX = axis.getX() * sinHalfAngle;
//		float rY = axis.getY() * sinHalfAngle;
//		float rZ = axis.getZ() * sinHalfAngle;
//		float rW = cosHalfAngle;
//
//		Quaternion rotation = new Quaternion(rX, rY, rZ, rW);
//		Quaternion conjugate = rotation.conjugate();
//
//		Quaternion w = rotation.mul(this).mul(conjugate);
//
//		x = w.getX();
//		y = w.getY();
//		z = w.getZ();
//
//		return this;
	
		return null;
	}
	
	public Vector3f add(Vector3f r)
	{
		return new Vector3f(x + r.getX(), y + r.getY(), z + r.getZ());
	}
	
	public Vector3f add(float r)
	{
		return new Vector3f(x + r, y + r, z + r);
	}
	
	public Vector3f sub(Vector3f r)
	{
		return new Vector3f(x - r.getX(), y - r.getY(), z - r.getZ());
	}
	
	public Vector3f sub(float r)
	{
		return new Vector3f(x - r, y - r, z - r);
	}
	
	public Vector3f mul(Vector3f r)
	{
		return new Vector3f(x * r.getX(), y * r.getY(), z * r.getZ());
	}
	
	public Vector3f mul(float r)
	{
		return new Vector3f(x * r, y * r, z * r);
	}
	
	public Vector3f div(Vector3f r)
	{
		return new Vector3f(x / r.getX(), y / r.getY(), z / r.getZ());
	}
	
	public Vector3f div(float r)
	{
		return new Vector3f(x / r, y / r, z / r);
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
}

