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

	public Vector3f[] getPositions() { return positions; }
	public Vector2f[] getTexCoords() { return texCoords; }
	public Vector3f[] getNormals() { return normals; }
	public int[] getIndices() { return indices; }
}