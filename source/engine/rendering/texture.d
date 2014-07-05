module engine.rendering.texture;

import std.stdio;
import std.string;
import std.file;

import derelict.opengl3.gl3;
import derelict.freeimage.types;
import derelict.freeimage.freeimage;
import derelict.freeimage.functions;

import engine.rendering.resourcemanagement.textureresource;

class Texture
{
	private static TextureResource[string] loadedTextures;
 	private TextureResource resource;
 	private string fileName;

	public this(string fileName, GLenum textureTarget = GL_TEXTURE_2D, GLint filter = GL_LINEAR_MIPMAP_NEAREST, GLenum internalFormat = GL_RGBA8, GLenum format = GL_BGRA, bool clamp = false, GLenum attachment = GL_NONE)
 	{
 		this.fileName = fileName;

		if(fileName in loadedTextures)
		{
			resource = loadedTextures[fileName];
			resource.addReference();
		}
		else
		{
			string texturePath = "./res/textures/" ~ fileName;
			const char *pPath = texturePath.toStringz();
						
			if(exists(texturePath) != 0)
			{
				FIBITMAP *bitmap = FreeImage_Load(FreeImage_GetFileType(pPath), pPath);
								
				FIBITMAP *pImage = FreeImage_ConvertTo32Bits(bitmap);
				int nWidth = FreeImage_GetWidth(pImage);
				int nHeight = FreeImage_GetHeight(pImage);
				ubyte* data = FreeImage_GetBits(pImage);
				
				resource = new TextureResource(textureTarget, nWidth, nHeight, 1, &data, &filter, &internalFormat, &format, clamp, &attachment);
				
				FreeImage_Unload(pImage);
			}
			else
			{
				writeln("could not find texture: " ~ fileName);
			}
		
			loadedTextures[fileName] = resource;
		}
 	}
 	
 	this(int width, int height, ubyte* data, GLenum textureTarget, GLint filter = GL_LINEAR_MIPMAP_NEAREST, GLenum internalFormat = GL_RGBA, GLenum format = GL_RGBA, bool clamp = false,  GLenum attachment = GL_NONE) 
 	{
 		this.fileName = "";
 		resource = new TextureResource(textureTarget, width, height, 1, &data, &filter, &internalFormat, &format, clamp, &attachment);
 	}

	public void bind(int samplerSlot)
	{
//		assert(samplerSlot >= 0 && samplerSlot <= 31);
		glActiveTexture(GL_TEXTURE0 + samplerSlot);
		resource.bind(0);
	}
	
	public void bindAsRenderTarget()
	{
		resource.bindAsRenderTarget();
	}
	
	public int getWidth()
	{
		return resource.getWidth();
	}
	
	public int getHight()
	{
		return resource.getHight();
	}

//	public int getID()
//	{
//		return resource.getTextureId();
//	}
}