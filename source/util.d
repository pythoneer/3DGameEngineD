module util;

import std.stdio;
import std.math;

//import gl3n.linalg;
//import gl3n.math;

import vertex;
import matrix;

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
	
	public static float[] createBuffer(Matrix4f matrix)
	{


		float floatValues[];
		
		for(int i = 0; i < 4; i++)
		{
			for(int j = 0; j < 4; j++)
			{
				floatValues ~= matrix.get(i, j);
			}
		}
		
		return floatValues;
	}
		
	public static float toRadians(float angle)
	{
		return ( PI / 180) * angle;
	}
	
//	public static vec3d rotate(vec3d vector, float angle, vec3d axis)
//	{
//		float sinHalfAngle = cast(float)sin(radians(angle / 2));
//		float cosHalfAngle = cast(float)cos(radians(angle / 2));
//
//		float rX = axis.x * sinHalfAngle;
//		float rY = axis.y * sinHalfAngle;
//		float rZ = axis.z * sinHalfAngle;
//		float rW = cosHalfAngle;
//
//		quat rotation = quat(rW, rX, rY, rZ);
//		quat conjugate = rotation.conjugated();
//
//		//Quaternion w = rotation.mul(this).mul(conjugate);
//		quat w = rotation * vector * conjugate;
//
////		x = w.getX();
////		y = w.getY();
////		z = w.getZ();
//
//		return vec3d(w.x, w.y, w.z);
//	}
}

