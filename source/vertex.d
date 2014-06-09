module vertex;

import vector3f;

class Vertex
{
	public static final int SIZE = 3;
	
	private Vector3f pos;
	
	public this(Vector3f pos)
	{
		this.pos = pos;
	}
	
	public Vector3f getPos()
	{
		return pos;
	}
	
	public void setPos(Vector3f pos)
	{
		this.pos = pos;
	}
}

