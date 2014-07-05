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
	private GLuint renderBuffer;
	
	private int refCount;

	public this(GLenum textureTarget, int width, int height, int numTextures, ubyte** data, GLint* filters, GLenum* internalFormat, GLenum* format, bool clamp, GLenum* attachments)
	{	
		textureId = cast(GLuint*)new GLuint[numTextures];
		
		this.textureTarget = textureTarget;
		this.refCount = 1;
		this.numTextures = numTextures;
		
		this.width = width;
		this.height = height;
		
		this.frameBuffer = 0;
		this.renderBuffer = 0;
				
		initTextures(data, filters, internalFormat, format, clamp);
		initRenderTargets(attachments);		
	}

	~this()
	{
		if(*textureId) glDeleteTextures(numTextures, textureId);
		if(frameBuffer) glDeleteFramebuffers(1, &frameBuffer);
		if(renderBuffer) glDeleteRenderbuffers(1, &renderBuffer);
		//if(textureId) delete textureId; // TODO ?? 
	}
	
	private void initTextures(ubyte** data, GLint* filters, GLenum* internalFormat, GLenum* format, bool clamp)
	{
		glGenTextures(numTextures, textureId);
		
		for(int i = 0; i < numTextures; i++)
		{				
			glBindTexture(textureTarget, textureId[i]);
			glTexParameteri(textureTarget, GL_TEXTURE_MIN_FILTER, filters[i]);
			glTexParameteri(textureTarget, GL_TEXTURE_MAG_FILTER, filters[i]); 
			
			if(clamp)
			{
				glTexParameteri(textureTarget, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER); 
				glTexParameteri(textureTarget, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER); 
			}
			
			glTexImage2D(textureTarget, 0, internalFormat[i], width, height, 0, format[i], GL_UNSIGNED_BYTE, data[i]);
			
			if( filters[i] == GL_NEAREST_MIPMAP_NEAREST ||
				filters[i] == GL_NEAREST_MIPMAP_LINEAR ||
				filters[i] == GL_LINEAR_MIPMAP_NEAREST ||
				filters[i] == GL_LINEAR_MIPMAP_LINEAR)
			{
				glGenerateMipmap(GL_TEXTURE_2D);
			}
			else
			{
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
			}
		}
	}
	
	private void initRenderTargets(GLenum* attachments)
	{
		if(attachments is null)
		{
			return;
		}
		
		GLenum[] drawBuffers;
		bool hasDepth = false;
		
		for(int i = 0; i < numTextures; i++)
		{
			if(attachments[i] == GL_DEPTH_ATTACHMENT) // Stencil?
			{
				drawBuffers ~= GL_NONE;
				hasDepth = true;
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
		
		if(!hasDepth)
		{
			glGenRenderbuffers(1, &renderBuffer);
			glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
			glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, width, height);
			glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, renderBuffer);
		}
		
		glDrawBuffers(textureTarget, drawBuffers.ptr);
		
		if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
		{
			writeln("Framebuffer creation failed!");
		}
		
		//glBindFramebuffer(GL_FRAMEBUFFER, 0);
	}
	
	
	public void bind(int textureNum) 
	{
		glBindTexture(textureTarget, textureId[textureNum]);
	}
	
	public void bindAsRenderTarget()
	{
		glBindTexture(GL_TEXTURE_2D,0);
		glBindFramebuffer(GL_DRAW_FRAMEBUFFER, frameBuffer);
		glViewport(0, 0, width, height);
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
	
	public int getWidth()
	{
		return this.width;
	}
	
	public int getHight()
	{
		return this.height;
	}
//
//	public int getTextureId() { return textureId[0]; }
//	
//	public GLenum getTextureTarget() { return textureTarget; }
}