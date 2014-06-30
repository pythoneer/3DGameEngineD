module engine.rendering.meshloading.objindex;

/*DEPRICATED*/

class OBJIndex
{
	public int vertexIndex;
	public int texCoordIndex;
	public int normalIndex;
	
	override
	hash_t toHash() 
	{ 
		const int BASE = 17;
		const int MULTIPLIER = 31;

		int result = BASE;

		result = MULTIPLIER * result + vertexIndex;
		result = MULTIPLIER * result + texCoordIndex;
		result = MULTIPLIER * result + normalIndex;

		return result;
	}

	override
	bool opEquals(Object obj)
	{ 
		OBJIndex index = cast(OBJIndex)obj;
		
		return vertexIndex == index.vertexIndex
				&& texCoordIndex == index.texCoordIndex
				&& normalIndex == index.normalIndex;
	}
	
	override
	int opCmp(Object obj)
	{ 
		OBJIndex index = cast(OBJIndex)obj;
		if (!index)
			return -1;
			
		if (vertexIndex == index.vertexIndex)
			return texCoordIndex - index.texCoordIndex;
			
		return vertexIndex - index.vertexIndex;
	}
	
}