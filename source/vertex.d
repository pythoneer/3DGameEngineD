module vertex;

import gl3n.linalg;

//import vector3f;

class Vertex
{
	public static final int SIZE = 3;
	
	private vec3d pos;
	
	public this(vec3d pos)
	{
		this.pos = pos;
	}
	
	public vec3d getPos()
	{
		return pos;
	}
	
	public void setPos(vec3d pos)
	{
		this.pos = pos;
	}
}

