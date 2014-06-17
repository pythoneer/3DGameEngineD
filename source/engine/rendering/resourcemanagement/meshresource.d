module engine.rendering.resourcemanagement.meshresource;

import derelict.opengl3.gl3;


class MeshResource
{
	private GLuint vbo;
	private GLuint ibo;
	private int size;
	private int refCount;

	public this(int size)
	{
 		glGenBuffers(1, &vbo);
 		glGenBuffers(1, &ibo);
		this.size = size;
		this.refCount = 1;
	}
	
	public ~this()
	{
		glDeleteBuffers(1, &vbo);
		glDeleteBuffers(1, &ibo);
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

	public int getVbo() {
		return vbo;
	}

	public int getIbo() {
		return ibo;
	}

	public int getSize() {
		return size;
	}
}