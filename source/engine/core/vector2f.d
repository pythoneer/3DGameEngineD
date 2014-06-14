module engine.core.vector2f;

import std.math;
import std.conv;
import std.string;

import engine.core.util;

class Vector2f 
{
	private float x;
	private float y;

	public this(float x, float y)
	{
		this.x = x;
		this.y = y;
	}

	public float length()
	{
		return cast(float)sqrt(x * x + y * y);
	}

	public float dot(Vector2f r)
	{
		return x * r.getX() + y * r.getY();
	}

	public Vector2f normalized()
	{
		float length = length();

		x /= length;
		y /= length;

		return new Vector2f(x / length, y / length);
	}

	public Vector2f rotate(float angle)
	{
		double rad = Util.toRadians(angle);
		double cos = cos(rad);
		double sin = sin(rad);

		return new Vector2f(cast(float)(x * cos - y * sin),cast(float)(x * sin + y * cos));
	}

	public Vector2f add(Vector2f r)
	{
		return new Vector2f(x + r.getX(), y + r.getY());
	}

	public Vector2f add(float r)
	{
		return new Vector2f(x + r, y + r);
	}

	public Vector2f sub(Vector2f r)
	{
		return new Vector2f(x - r.getX(), y - r.getY());
	}

	public Vector2f sub(float r)
	{
		return new Vector2f(x - r, y - r);
	}

	public Vector2f mul(Vector2f r)
	{
		return new Vector2f(x * r.getX(), y * r.getY());
	}

	public Vector2f mul(float r)
	{
		return new Vector2f(x * r, y * r);
	}

	public Vector2f div(Vector2f r)
	{
		return new Vector2f(x / r.getX(), y / r.getY());
	}

	public Vector2f div(float r)
	{
		return new Vector2f(x / r, y / r);
	}

//	public string toString()
//	{
//		return format("x: %d, y: %d", x, y);
//	}

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
}