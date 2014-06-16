module engine.rendering.meshloading.indexedmodel;

import engine.core.vector3f;
import engine.core.vector2f;

class IndexedModel
{
	private Vector3f[] positions;
	private Vector2f[] texCoords;
	private Vector3f[] normals;
	private int[] indices;

	public this()
	{
	}
	
	public void calcNormals()
 	{
 		for(int i = 0; i < indices.length; i += 3)
 		{
 			int i0 = indices[i];
 			int i1 = indices[i + 1];
 			int i2 = indices[i + 2];
 
 			Vector3f v1 = positions[i1].sub(positions[i0]);
 			Vector3f v2 = positions[i2].sub(positions[i0]);
 
 			Vector3f normal = v1.cross(v2).normalized();
 
 			normals[i0] = (normals[i0].add(normal));
 			normals[i1] = (normals[i1].add(normal));
 			normals[i2] = (normals[i2].add(normal));
 		}
 
 		for(int i = 0; i < normals.length; i++)
 			normals[i] = (normals[i].normalized());
 	}

	public ref Vector3f[] getPositions() { return positions; }
	public ref Vector2f[] getTexCoords() { return texCoords; }
	public ref Vector3f[] getNormals() { return normals; }
	public ref int[] getIndices() { return indices; }
}