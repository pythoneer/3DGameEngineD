module engine.rendering.resourcemanagement.textureresource;

import derelict.opengl3.gl3;

class TextureResource
{
	private GLuint* textureId;
	private GLenum textureTarget;
	private int numTextures;
	private int width;
	private int height;
	
	private int refCount;

	public this(GLenum textureTarget, int width, int height, int numTextures, ubyte** data, GLint* filters)
	{	
		textureId = cast(GLuint*)new GLuint[numTextures];
		
		this.textureTarget = textureTarget;
		this.refCount = 1;
		this.numTextures = numTextures;
		
		this.width = width;
		this.height = height;
		
		initTextures(data, filters);
	}

	~this()
	{
		if(*textureId) glDeleteTextures(numTextures, textureId);
		if(textureId) delete textureId; // TODO ?? 
	}
	
	private void initTextures(ubyte** data, GLint* filters)
	{
		glGenTextures(numTextures, textureId);
		
		for(int i = 0; i < numTextures; i++)
		{				
			glBindTexture(textureTarget, textureId[i]);
			glTexParameteri(textureTarget, GL_TEXTURE_MIN_FILTER, filters[i]);
			glTexParameteri(textureTarget, GL_TEXTURE_MAG_FILTER, filters[i]); 
			
			glTexImage2D(textureTarget, 0, GL_RGBA8, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, data[i]);
		}
	}
	
	public void bind(int textureNum) 
	{
		glBindTexture(textureTarget, textureId[textureNum]);
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
//
//	public int getTextureId() { return textureId[0]; }
//	
//	public GLenum getTextureTarget() { return textureTarget; }
}