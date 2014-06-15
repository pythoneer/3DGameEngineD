module engine.core.transform;

import engine.core.util;
import engine.core.vector3f;
import engine.core.matrix;
import engine.core.quaternion;
import engine.rendering.camera;

public class Transform
{
	
	private Vector3f scale;
	private Vector3f pos;
 	private Quaternion rot;
	
	public this()
	{
		pos = new Vector3f(0f,0f,0f);
		rot = new Quaternion(0,0,0,1);
		scale = new Vector3f(1f,1f,1f);
	}
	
	public Matrix4f getTransformation()
	{
		Matrix4f translationMatrix = new Matrix4f().initTranslation(pos.getX(), pos.getY(), pos.getZ());
		Matrix4f rotationMatrix = rot.toRotationMatrix();
		Matrix4f scaleMatrix = new Matrix4f().initScale(scale.getX(), scale.getY(), scale.getZ());

		return translationMatrix.mul(rotationMatrix.mul(scaleMatrix));
	}
	
	public Vector3f getPos()
	{
		return pos;
	}

	public void setPos(Vector3f pos)
	{
		this.pos = pos;
	}

	public Quaternion getRot()
	{
		return rot;
	}

	public void setRot(Quaternion rotation)
	{
		this.rot = rotation;
	}

	public Vector3f getScale()
	{
		return scale;
	}

	public void setScale(Vector3f scale)
	{
		this.scale = scale;
	}
	
}
