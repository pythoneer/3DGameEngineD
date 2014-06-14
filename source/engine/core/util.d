﻿module engine.core.util;

import std.stdio;
import std.math;

import engine.rendering.vertex;
import engine.core.matrix;

class Util
{
	public static float[] createBuffer(Vertex[] vertices)
	{
		long size = vertices.length * Vertex.SIZE;

		float floatVertices[] = new float[size];
		for(int i = 0; i < vertices.length; i++)
		{
			floatVertices[i * Vertex.SIZE	 ] = vertices[i].getPos().getX();
			floatVertices[i * Vertex.SIZE + 1] = vertices[i].getPos().getY();
			floatVertices[i * Vertex.SIZE + 2] = vertices[i].getPos().getZ();
			
			floatVertices[i * Vertex.SIZE + 3] = vertices[i].getTexCoord().getX();
			floatVertices[i * Vertex.SIZE + 4] = vertices[i].getTexCoord().getY();
			
			floatVertices[i * Vertex.SIZE + 5] = vertices[i].getNormal().getX();
			floatVertices[i * Vertex.SIZE + 6] = vertices[i].getNormal().getY();
			floatVertices[i * Vertex.SIZE + 7] = vertices[i].getNormal().getZ();
		
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

