module engine.rendering.shadowinfo;

import engine.core.matrix;

class ShadowInfo 
{
	private Matrix4f projection;
	private float shadowSoftness;
	private int shadowMapSizeAsPowerOf2;
	private float lightBleedingReductionAmount;
	private float varianceMin;
	private bool flipFaces;
	
	public this(Matrix4f projection, 
				bool flipFaces = true, 
				int shadowMapSizeAsPowerOf2 = 5, 
				float shadowSoftness = 1.0f, 
				float lightBleedingReductionAmount = 0.2f, 
				float minVariance = 0.00002f)
	{
		this.projection = projection;
		this.flipFaces = flipFaces;
		this.shadowMapSizeAsPowerOf2 = shadowMapSizeAsPowerOf2;
		this.shadowSoftness = shadowSoftness;
		this.lightBleedingReductionAmount = lightBleedingReductionAmount;
		this.varianceMin = varianceMin;
	}
	
	public Matrix4f getProjection()
	{
		return projection;
	}
	
	public void setProjection(Matrix4f projection)
	{
		this.projection = projection;
	}
	
	public bool getFlipFaces()
	{
		return flipFaces;
	}
	
	public void setFlipFaces(bool flip)
	{
		this.flipFaces = flip;
	}
		
	public int getShadowMapSizeAsPowerOf2()
	{
		return shadowMapSizeAsPowerOf2;
	}	
	
	public float getShadowSoftness()
	{
		return shadowSoftness;
	}
	
	public void setShadowSoftness(float softness)
	{
		this.shadowSoftness = softness;
	}	
	
	public float getLightBleedingReductionAmount()
	{
		return lightBleedingReductionAmount;
	}
	
	public void setLightBleedingReductionAmount(float lightBleedingReductionAmount)
	{
		this.lightBleedingReductionAmount = lightBleedingReductionAmount;
	}	
	
	public float getVarianceMin()
	{
		return varianceMin;
	}
	
	public void setVarianceMin(float varianceMin)
	{
		this.varianceMin = varianceMin;
	}
	
	
}