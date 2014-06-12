module material;

import vector3f;
import texture;

class Material
{
	private Texture texture;
	private Vector3f color;

	public this(Texture texture)
	{
		this(texture, new Vector3f(1,1,1));
	}

	public this(Texture texture, Vector3f color)
	{
		this.texture = texture;
		this.color = color;
	}

	public Texture getTexture()
	{
		return texture;
	}

	public void setTexture(Texture texture)
	{
		this.texture = texture;
	}

	public Vector3f getColor()
	{
		return color;
	}

	public void setColor(Vector3f color)
	{
		this.color = color;
	}
}