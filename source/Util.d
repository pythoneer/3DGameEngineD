module util;

import std.stdio;

import vertex;

class Util
{
	public static float[] createBuffer(Vertex[] vertices)
	{
		long size = vertices.length * 3;

		float floatVertices[] = new float[size];
		for(int i = 0; i < vertices.length; i++)
		{
			floatVertices[i * 3] = vertices[i].getPos.getX();
			floatVertices[i * 3 + 1] = vertices[i].getPos().getY();
			floatVertices[i * 3 + 2] = vertices[i].getPos().getZ();
		}

		return floatVertices;
	}
}

