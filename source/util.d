module util;

import std.stdio;
import std.math;

import gl3n.linalg;
import gl3n.math;

import vertex;

class Util
{
	public static float[] createBuffer(Vertex[] vertices)
	{
		long size = vertices.length * 3;

		float floatVertices[] = new float[size];
		for(int i = 0; i < vertices.length; i++)
		{
			floatVertices[i * 3] = vertices[i].getPos.x;
			floatVertices[i * 3 + 1] = vertices[i].getPos().y;
			floatVertices[i * 3 + 2] = vertices[i].getPos().z;
		}

		return floatVertices;
	}
	
	public static mat4 initProjection(float fov, float width, float height, float zNear, float zFar)
	{
		mat4 m;
		
		float ar = width/height;
		float tanHalfFOV = cast(float)tan(radians(fov / 2));
		float zRange = zNear - zFar;

		m[0][0] = 1.0f / (tanHalfFOV * ar);	m[0][1] = 0;					m[0][2] = 0;	m[0][3] = 0;
		m[1][0] = 0;						m[1][1] = 1.0f / tanHalfFOV;	m[1][2] = 0;	m[1][3] = 0;
		m[2][0] = 0;						m[2][1] = 0;					m[2][2] = (-zNear -zFar)/zRange;	m[2][3] = 2 * zFar * zNear / zRange;
		m[3][0] = 0;						m[3][1] = 0;					m[3][2] = 1;	m[3][3] = 0;

		return m;
	}
}

