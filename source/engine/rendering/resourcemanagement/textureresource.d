module engine.rendering.resourcemanagement.textureresource;

import std.stdio;

import derelict.opengl3.gl3;

class TextureResource
{
	private GLuint* textureId;
	private GLenum textureTarget;
	private int numTextures;
	private int width;
	private int height;
	private GLuint frameBuffer;
	
	private int refCount;

	public this(GLenum textureTarget, int width, int height, int numTextures, ubyte** data, GLint* filters, GLenum* attachments)
	{	
		textureId = cast(GLuint*)new GLuint[numTextures];
		
		this.textureTarget = textureTarget;
		this.refCount = 1;
		this.numTextures = numTextures;
		
		this.width = width;
		this.height = height;
		
		this.frameBuffer = 0;
		
		initTextures(data, filters);
		initRenderTargets(attachments);
	}

	~this()
	{
		if(*textureId) glDeleteTextures(numTextures, textureId);
		if(frameBuffer) glDeleteFramebuffers(1, &frameBuffer);
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
	
	private void initRenderTargets(GLenum* attachments)
	{
		if(attachments is null)
		{
			return;
		}
		
		GLenum[] drawBuffers;
		
		for(int i = 0; i < numTextures; i++)
		{
			if(attachments[i] == GL_DEPTH_ATTACHMENT) // Stencil?
			{
				drawBuffers ~= GL_NONE;
			}
			else
			{
				drawBuffers ~= attachments[i];
			}
			
			if(attachments[i] == GL_NONE)
			{
				continue;
			}
			
			if(frameBuffer == 0)
			{
				glGenFramebuffers(1, &frameBuffer);
				glBindFramebuffer(GL_DRAW_FRAMEBUFFER, frameBuffer);
			}
			
			glFramebufferTexture2D(GL_DRAW_FRAMEBUFFER, attachments[i], textureTarget, textureId[i], 0);
		}
		
		if(frameBuffer == 0)
		{
			return;
		}
		
		glDrawBuffers(textureTarget, drawBuffers.ptr);
		
		if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
		{
			writeln("Framebuffer creation failed!");
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