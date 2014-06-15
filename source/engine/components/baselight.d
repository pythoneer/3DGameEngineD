module engine.components.baselight;

import engine.core.vector3f;
import engine.rendering.shader;
import engine.rendering.renderingengine;
import engine.components.gamecomponent;

class BaseLight : GameComponent
{
	private Vector3f color;
	private float intensity;
	private Shader shader;

	public this(Vector3f color, float intensity)
	{
		this.color = color;
		this.intensity = intensity;
	}
	
	override
 	public void addToRenderingEngine(RenderingEngine renderingEngine)
 	{
 		renderingEngine.addLight(this);
 	}
 
 	public void setShader(Shader shader)
 	{
 		this.shader = shader;
 	}
 
 	public Shader getShader()
 	{
 		return shader;
 	}

	public Vector3f getColor()
	{
		return color;
	}

	public void setColor(Vector3f color)
	{
		this.color = color;
	}

	public float getIntensity()
	{
		return intensity;
	}

	public void setIntensity(float intensity)
	{
		this.intensity = intensity;
	}
}