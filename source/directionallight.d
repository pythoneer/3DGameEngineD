module directionallight;

import vector3f;
import baselight;

class DirectionalLight
{
	private BaseLight base;
	private Vector3f direction;

	public this(BaseLight base, Vector3f direction)
	{
		this.base = base;
		this.direction = direction.normalized();
	}

	public BaseLight getBase()
	{
		return base;
	}

	public void setBase(BaseLight base)
	{
		this.base = base;
	}

	public Vector3f getDirection()
	{
		return direction;
	}

	public void setDirection(Vector3f direction)
	{
		this.direction = direction.normalized();
	}
}