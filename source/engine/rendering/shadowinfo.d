module engine.rendering.shadowinfo;

import engine.core.matrix;

class ShadowInfo 
{
	private Matrix4f projection;
	float bias;
	bool flipFaces;
	
	public this(Matrix4f projection, float bias = 0, bool flipFaces = true)
	{
		this.projection = projection;
		this.bias = bias;
		this.flipFaces = flipFaces;
	}
	
	public Matrix4f getProjection()
	{
		return projection;
	}
	
	public void setProjection(Matrix4f projection)
	{
		this.projection = projection;
	}
	
	public float getBias()
	{
		return bias;
	}
	
	public void setBias(float bias)
	{
		this.bias = bias;
	}
	
	public bool getFlipFaces()
	{
		return flipFaces;
	}
	
	public void setFlipFaces(bool flip)
	{
		this.flipFaces = flip;
	}
}