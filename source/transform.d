module transform;

import gl3n.linalg;
import gl3n.math;

public class Transform
{
	private vec3d translation;
	private vec3d rotation;
	private vec3d scale;
	
	public this()
	{
		translation = vec3d(0f,0f,0f);
		rotation = vec3d(0f,0f,0f);
		scale = vec3d(1f,1f,1f);
	}
	
	public mat4 getTransformation()
	{
		mat4 translationMatrix =  mat4.translation(translation.x, translation.y, translation.z);
		mat4 rotationMatrix =  mat4.translation(0f,0f,0f).rotatex(rotation.x).rotatey(rotation.y).rotatez(rotation.z);
		mat4 scaleMatrix = mat4.scaling(scale.x, scale.y, scale.z);
		
		return translationMatrix * rotationMatrix * scaleMatrix;
	}
	
	public vec3d getTranslation()
	{
		return translation;
	}

	public void setTranslation(vec3d translation)
	{
		this.translation = translation;
	}
	
	public void setTranslation(float x, float y, float z)
	{
		this.translation =  vec3d(x, y, z);
	}

	public vec3d getRotation()
	{
		return rotation;
	}

	public void setRotation(vec3d rotation)
	{
		this.rotation = rotation;
	}
	
	public void setRotation(float x, float y, float z)
	{
		this.rotation =  vec3d(radians(x) * 2, radians(y) * 2, radians(z) * 2);
	}
	
	public vec3d getScale()
	{
		return scale;
	}

	public void setScale(vec3d scale)
	{
		this.scale = scale;
	}
	
	public void setScale(float x, float y, float z)
	{
		this.scale = vec3d(x, y, z);
	}
}
