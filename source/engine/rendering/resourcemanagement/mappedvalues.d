module engine.rendering.resourcemanagement.mappedvalues;

import engine.core.vector3f;
import engine.rendering.texture;


class MappedValues
{
	private Vector3f[string] vector3fHashMap;
	private float[string] floatHashMap;
	private Texture[string] textureHashMap;

	public this()
	{
	}

	public void setVector3f(string name, Vector3f vector3f) { vector3fHashMap[name] = vector3f; }
	public void setFloat(string name, float floatValue) { floatHashMap[name] = floatValue; }

	public Vector3f getVector3f(string name)
	{
		if(name in vector3fHashMap)
		{
			return vector3fHashMap[name];
		}
		
		return new Vector3f(0,0,0);
	}

	public float getFloat(string name)
	{
		if(name in floatHashMap)
		{
			return floatHashMap[name];
		}
		
		return 0;
	}
	
	public void setTexture(string name, Texture texture) 
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