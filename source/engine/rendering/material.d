module engine.rendering.material;

import std.string;

import engine.core.vector3f;
import engine.rendering.texture;
import engine.rendering.resourcemanagement.mappedvalues;

class Material : MappedValues
{
//	private Texture[string] textureHashMap;

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
		setTexture("diffuse", diffuse);
		setFloat("specularIntensity", specularIntensity);
		setFloat("specularPower", specularPower);
		
		setTexture("normalMap", normalMap);
		
		float baseBias = dispMapScale/2.0f;
		setTexture("dispMap", dispMap);		
		setFloat("dispMapScale", dispMapScale);
		setFloat("dispMapBias", -baseBias + baseBias * dispMapOffset);
	}
	
//	public void addTexture(string name, Texture texture) 
//	{
//		textureHashMap[name] = texture; 
//	
//	}
//
//	public Texture getTexture(string name)
//	{
//		if(name in textureHashMap)
//		{
//			return textureHashMap[name];
//		}
//		
//		return new Texture("test.png");
//	}
}