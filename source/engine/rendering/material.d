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