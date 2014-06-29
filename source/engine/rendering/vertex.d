module engine.rendering.vertex;

//import gl3n.linalg;

import engine.core.vector3f;
import engine.core.vector2f;

class Vertex
{
	public static final int SIZE = 11;
	
	private Vector3f pos;
	private Vector2f texCoord;
	private Vector3f normal;
	private Vector3f tangent;
	
	public this(Vector3f pos)
	{
		this(pos, new Vector2f(0,0));
	}
	
	public this(Vector3f pos, Vector2f texCoord)
	{
		this(pos, texCoord, new Vector3f(0,0,0));
	}

	public this(Vector3f pos, Vector2f texCoord, Vector3f normal = new Vector3f(0,0,0), Vector3f tangent = new Vector3f(0,0,0))
	{
		this.pos = pos;
		this.texCoord = texCoord;
		this.normal = normal;
		this.tangent = tangent;
	}

	
	public Vector3f getPos()
	{
		return pos;
	}
	
	public void setPos(Vector3f pos)
	{
		this.pos = pos;
	}
	
	public Vector2f getTexCoord()
	{
		return texCoord;
	}

	public void setTexCoord(Vector2f texCoord)
	{
		this.texCoord = texCoord;
	}
	
	public Vector3f getNormal()
	{
		return normal;
	}

	public void setNormal(Vector3f normal)
	{
		this.normal = normal;
	}
	
	public Vector3f getTangent()
	{
		return tangent;
	}

	public void setTangent(Vector3f tangent)
	{
		this.tangent = tangent;
	}
}

