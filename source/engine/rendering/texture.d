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

	public this(string fileName)
 	{
 		this.fileName = fileName;

		if(fileName in loadedTextures)
		{
			resource = loadedTextures[fileName];
			resource.addReference();
		}
		else
		{
			resource = new TextureResource(loadTexture(fileName));
			loadedTextures[fileName] = resource;
		}
 	}
	
	public static int loadTexture(string fileName)
	{

		string texturePath = "./res/textures/" ~ fileName;
		const char *pPath = texturePath.toStringz();
		
		
		if(exists(texturePath) != 0)
		{
			FIBITMAP *bitmap = FreeImage_Load(FreeImage_GetFileType(pPath), pPath);
			
			GLuint textureId;
			glGenTextures(1, &textureId);
			
			glBindTexture(GL_TEXTURE_2D, textureId);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); 
			
			FIBITMAP *pImage = FreeImage_ConvertTo32Bits(bitmap);
			int nWidth = FreeImage_GetWidth(pImage);
			int nHeight = FreeImage_GetHeight(pImage);
			
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, nWidth, nHeight,
			    0, GL_BGRA, GL_UNSIGNED_BYTE, FreeImage_GetBits(pImage));
			
			FreeImage_Unload(pImage);
			
			return textureId;
		}
		else
		{
			writeln("could not find texture: " ~ fileName);
		}

		return 0;
	}

//	public void bind()
//	{
//		bind(0);
//	}

	public void bind(int samplerSlot)
	{
//		assert(samplerSlot >= 0 && samplerSlot <= 31);
		glActiveTexture(GL_TEXTURE0 + samplerSlot);
		glBindTexture(GL_TEXTURE_2D, resource.getId());
	}

	public int getID()
	{
		return resource.getId();
	}
}