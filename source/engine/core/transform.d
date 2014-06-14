module engine.core.transform;

import engine.core.util;
import engine.core.vector3f;
import engine.core.matrix;
import engine.rendering.camera;

public class Transform
{
	
	private Vector3f translation;
	private Vector3f rotation;
	private Vector3f scale;
	
	public this()
	{
		translation = new Vector3f(0f,0f,0f);
		rotation = new Vector3f(0f,0f,0f);
		scale = new Vector3f(1f,1f,1f);
	}
	
	public Matrix4f getTransformation()
	{
		Matrix4f translationMatrix = new Matrix4f().initTranslation(translation.getX(), translation.getY(), translation.getZ());
		Matrix4f rotationMatrix = new Matrix4f().initRotation(rotation.getX(), rotation.getY(), rotation.getZ());
		Matrix4f scaleMatrix = new Matrix4f().initScale(scale.getX(), scale.getY(), scale.getZ());

		return translationMatrix.mul(rotationMatrix.mul(scaleMatrix));
	}
	
	public Vector3f getTranslation()
	{
		return translation;
	}

	public void setTranslation(Vector3f translation)
	{
		this.translation = translation;
	}
	
	public void setTranslation(float x, float y, float z)
	{
		this.translation = new Vector3f(x, y, z);
	}

	public Vector3f getRotation()
	{
		return rotation;
	}

	public void setRotation(Vector3f rotation)
	{
		this.rotation = rotation;
	}
	
	public void setRotation(float x, float y, float z)
	{
		this.rotation = new Vector3f(x, y, z);
	}
	
	public Vector3f getScale()
	{
		return scale;
	}

	public void setScale(Vector3f scale)
	{
		this.scale = scale;
	}
	
	public void setScale(float x, float y, float z)
	{
		this.scale = new Vector3f(x, y, z);
	}
	
}
