module engine.rendering.material;

import std.string;

import engine.core.vector3f;
import engine.rendering.texture;
import engine.rendering.resourcemanagement.mappedvalues;

class Material : MappedValues
{
	private Texture[string] textureHashMap;

	public this()
	{
		super();
	}

	this(Texture diffuse, 
		float specularIntensity, 
		float specularPower,
		Texture normalMap = new Texture("default_normal.jpg"),
		Texture dispMap = new Texture("default_disp.png"), 
		float dispMapScale = 0.0f, 
		float dispMapOffset = 0.0f)
	{
		addTexture("diffuse", diffuse);
		addFloat("specularIntensity", specularIntensity);
		addFloat("specularPower", specularPower);
		
		addTexture("normalMap", normalMap);
		
		float baseBias = dispMapScale/2.0f;
		addTexture("dispMap", dispMap);		
		addFloat("dispMapScale", dispMapScale);
		addFloat("dispMapBias", -baseBias + baseBias * dispMapOffset);
	}
	
	public void addTexture(string name, Texture texture) 
	{
		textureHashMap[name] = texture; 
	
	}

	public Texture getTexture(string name)
	{
		if(name in textureHashMap)
		{
			return textureHashMap[name];
		}
		
		return new Texture("test.png");
	}
}