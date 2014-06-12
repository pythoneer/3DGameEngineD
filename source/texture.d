module texture;

import derelict.opengl3.gl3;

class Texture
{
	private int id;

	public this(int id)
	{
		this.id = id;
	}

	public void bind()
	{
		glBindTexture(GL_TEXTURE_2D, id);
	}

	public int getID()
	{
		return id;
	}
}