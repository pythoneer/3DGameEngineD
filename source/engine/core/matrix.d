module engine.core.matrix;

import std.math;

import engine.core.util;
import engine.core.vector3f;

class Matrix4f
{
	private float[4][4] m;

	public this()
	{
		
	}

	public Matrix4f initIdentity()
	{
		m[0][0] = 1;	m[0][1] = 0;	m[0][2] = 0;	m[0][3] = 0;
		m[1][0] = 0;	m[1][1] = 1;	m[1][2] = 0;	m[1][3] = 0;
		m[2][0] = 0;	m[2][1] = 0;	m[2][2] = 1;	m[2][3] = 0;
		m[3][0] = 0;	m[3][1] = 0;	m[3][2] = 0;	m[3][3] = 1;

		return this;
	}

	public Matrix4f initTranslation(float x, float y, float z)
	{
		m[0][0] = 1;	m[0][1] = 0;	m[0][2] = 0;	m[0][3] = x;
		m[1][0] = 0;	m[1][1] = 1;	m[1][2] = 0;	m[1][3] = y;
		m[2][0] = 0;	m[2][1] = 0;	m[2][2] = 1;	m[2][3] = z;
		m[3][0] = 0;	m[3][1] = 0;	m[3][2] = 0;	m[3][3] = 1;

		return this;
	}

	public Matrix4f initScale(float x, float y, float z)
	{
		m[0][0] = x;	m[0][1] = 0;	m[0][2] = 0;	m[0][3] = 0;
		m[1][0] = 0;	m[1][1] = y;	m[1][2] = 0;	m[1][3] = 0;
		m[2][0] = 0;	m[2][1] = 0;	m[2][2] = z;	m[2][3] = 0;
		m[3][0] = 0;	m[3][1] = 0;	m[3][2] = 0;	m[3][3] = 1;

		return this;
	}

	public Matrix4f initPerspective(float fov, float aspectRatio, float zNear, float zFar)
	{
		float ar = aspectRatio;
		float tanHalfFOV = cast(float)tan(fov / 2);
		float zRange = zNear - zFar;

		m[0][0] = 1.0f / (tanHalfFOV * ar);	m[0][1] = 0;					m[0][2] = 0;						m[0][3] = 0;
		m[1][0] = 0;						m[1][1] = 1.0f / tanHalfFOV;	m[1][2] = 0;						m[1][3] = 0;
		m[2][0] = 0;						m[2][1] = 0;					m[2][2] = (-zNear -zFar)/zRange;	m[2][3] = 2 * zFar * zNear / zRange;
		m[3][0] = 0;						m[3][1] = 0;					m[3][2] = 1;						m[3][3] = 0;

		return this;
	}
	
	public Matrix4f initOrthographic(float left, float right, float bottom, float top, float near, float far)
	{
		float halfWidth = (right - left)/2.0f;
		float halfHeight = (top - bottom)/2.0f;
		float halfDepth = (far - near)/2.0f;

		m[0][0] = halfWidth;	m[0][1] = 0;			m[0][2] = 0;			m[0][3] = abs(halfWidth);
		m[1][0] = 0;			m[1][1] = halfHeight;	m[1][2] = 0;			m[1][3] = abs(halfHeight);
		m[2][0] = 0;			m[2][1] = 0;			m[2][2] = halfDepth;	m[2][3] = abs(halfDepth);
		m[3][0] = 0;			m[3][1] = 0;			m[3][2] = 0;			m[3][3] = 1;

		return this;
	}

	public Matrix4f initRotation(float x, float y, float z)
	{
		Matrix4f rx = new Matrix4f();
		Matrix4f ry = new Matrix4f();
		Matrix4f rz = new Matrix4f();

		x = cast(float)Util.toRadians(x);
		y = cast(float)Util.toRadians(y);
		z = cast(float)Util.toRadians(z);

		rz.m[0][0] = cast(float)cos(z);	rz.m[0][1] = -cast(float)sin(z);rz.m[0][2] = 0;					rz.m[0][3] = 0;
		rz.m[1][0] = cast(float)sin(z);	rz.m[1][1] = cast(float)cos(z);	rz.m[1][2] = 0;					rz.m[1][3] = 0;
		rz.m[2][0] = 0;					rz.m[2][1] = 0;					rz.m[2][2] = 1;					rz.m[2][3] = 0;
		rz.m[3][0] = 0;					rz.m[3][1] = 0;					rz.m[3][2] = 0;					rz.m[3][3] = 1;

		rx.m[0][0] = 1;					rx.m[0][1] = 0;					rx.m[0][2] = 0;					rx.m[0][3] = 0;
		rx.m[1][0] = 0;					rx.m[1][1] = cast(float)cos(x);	rx.m[1][2] = -cast(float)sin(x);rx.m[1][3] = 0;
		rx.m[2][0] = 0;					rx.m[2][1] = cast(float)sin(x);	rx.m[2][2] = cast(float)cos(x);	rx.m[2][3] = 0;
		rx.m[3][0] = 0;					rx.m[3][1] = 0;					rx.m[3][2] = 0;					rx.m[3][3] = 1;

		ry.m[0][0] = cast(float)cos(y);	ry.m[0][1] = 0;					ry.m[0][2] = -cast(float)sin(y);ry.m[0][3] = 0;
		ry.m[1][0] = 0;					ry.m[1][1] = 1;					ry.m[1][2] = 0;					ry.m[1][3] = 0;
		ry.m[2][0] = cast(float)sin(y);	ry.m[2][1] = 0;					ry.m[2][2] = cast(float)cos(y);	ry.m[2][3] = 0;
		ry.m[3][0] = 0;					ry.m[3][1] = 0;					ry.m[3][2] = 0;					ry.m[3][3] = 1;

		m = rz.mul(ry.mul(rx)).getM();

		return this;
	}

	public Matrix4f initRotation(Vector3f forward, Vector3f up)
	{
		Vector3f f = forward.normalized();

		Vector3f r = up.normalized();
		r = r.cross(f);

		Vector3f u = f.cross(r);

		return initRotation(f, u, r);
	}
	
	public Matrix4f initRotation(Vector3f forward, Vector3f up, Vector3f right)
	{
		Vector3f f = forward;
		Vector3f r = right;
		Vector3f u = up;

		m[0][0] = r.getX();	m[0][1] = r.getY();	m[0][2] = r.getZ();	m[0][3] = 0;
		m[1][0] = u.getX();	m[1][1] = u.getY();	m[1][2] = u.getZ();	m[1][3] = 0;
		m[2][0] = f.getX();	m[2][1] = f.getY();	m[2][2] = f.getZ();	m[2][3] = 0;
		m[3][0] = 0;		m[3][1] = 0;		m[3][2] = 0;		m[3][3] = 1;

		return this;
	}
	
	public Vector3f transform(Vector3f r)
 	{
 		return new Vector3f(m[0][0] * r.getX() + m[0][1] * r.getY() + m[0][2] * r.getZ() + m[0][3],
 		                    m[1][0] * r.getX() + m[1][1] * r.getY() + m[1][2] * r.getZ() + m[1][3],
 		                    m[2][0] * r.getX() + m[2][1] * r.getY() + m[2][2] * r.getZ() + m[2][3]);
 	}

	public Matrix4f mul(Matrix4f r)
	{
		Matrix4f res = new Matrix4f();

		for(int i = 0; i < 4; i++)
		{
			for(int j = 0; j < 4; j++)
			{
				res.set(i, j, m[i][0] * r.get(0, j) +
							  m[i][1] * r.get(1, j) +
							  m[i][2] * r.get(2, j) +
							  m[i][3] * r.get(3, j));
			}
		}

		return res;
	}

	public float[4][4] getM()
	{
		float[4][4] res;
 		
 		for(int i = 0; i < 4; i++)
 			for(int j = 0; j < 4; j++)
 				res[i][j] = m[i][j];
 		
 		return res;
	}

	public float get(int x, int y)
	{
		return m[x][y];
	}

	public void setM(float[4][4] m)
	{
		this.m = m;
	}

	public void set(int x, int y, float value)
	{
		m[x][y] = value;
	}
}