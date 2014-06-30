module engine.rendering.resourcemanagement.mappedvalues;

import engine.core.vector3f;


class MappedValues
{
	private Vector3f[string] vector3fHashMap;
	private float[string] floatHashMap;

	public this()
	{
	}

	public void addVector3f(string name, Vector3f vector3f) { vector3fHashMap[name] = vector3f; }
	public void addFloat(string name, float floatValue) { floatHashMap[name] = floatValue; }

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
}