module engine.rendering.shadowinfo;

import engine.core.matrix;

class ShadowInfo 
{
	private Matrix4f projection;
	
	public this(Matrix4f projection)
	{
		this.projection = projection;
	}
	
	public Matrix4f getProjection()
	{
		return projection;
	}
	
	public void setProjection(Matrix4f projection)
	{
		this.projection = projection;
	}
}