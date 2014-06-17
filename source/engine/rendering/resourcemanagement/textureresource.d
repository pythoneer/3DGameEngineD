module engine.rendering.resourcemanagement.textureresource;

import derelict.opengl3.gl3;

class TextureResource
{
	private GLuint id;
	private int refCount;

	public this(int id)
	{
		this.id = id;
		this.refCount = 1;
	}

	~this()
	{
		glDeleteBuffers(1, &id);
	}

	public void addReference()
	{
		refCount++;
	}

	public bool removeReference()
	{
		refCount--;
		return refCount == 0;
	}

	public int getId() { return id; }
}