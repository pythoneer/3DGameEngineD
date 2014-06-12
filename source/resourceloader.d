module resourceLoader;

import std.stdio;
import std.file;
import std.string;
import std.conv;

//import gl3n.linalg;
import derelict.opengl3.gl3;
import derelict.freeimage.types;
import derelict.freeimage.freeimage;
import derelict.freeimage.functions;

import vertex;
import vector3f;
import mesh;
import texture;


class ResourceLoader
{
	public static string loadShader(string fileName)
	{
		string shaderPath = "./res/shaders/" ~ fileName;
		string shaderSource = "";

		if(exists(shaderPath)!=0) {
			File file = File(shaderPath, "r");
			
			while (!file.eof()) {
				string line = chomp(file.readln());
				shaderSource ~= line ~ "\n";
			}
		}
		else 
		{
			writefln("could not find shader: %s", fileName);
		}

//		writeln("\n\nshaderSource:\n");
//		writeln(shaderSource);

		return shaderSource;
	}
	
	
	public static Mesh loadMesh(string fileName)
	{
	
		Vertex[] vertices;
		int[] indices;

		string meshPath = "./res/models/" ~ fileName;
		
		if(exists(meshPath) != 0){
			
			File file = File(meshPath, "r");
			while (!file.eof()) {
				string line = chomp(file.readln());
				string[] tokens = split(line);
				
				if(tokens.length == 0 || tokens[0] == "#")
				{
					continue;
				}
				else if(tokens[0] == "v")
				{
					
					Vertex tmp = new Vertex(new Vector3f(to!float(tokens[1]),
							 							 to!float(tokens[2]),
							 							 to!float(tokens[3])));
					vertices ~= tmp;
				}
				else if(tokens[0] == "f")
				{ 
					indices ~= to!int(tokens[1]) -1;
					indices ~= to!int(tokens[2]) -1;
					indices ~= to!int(tokens[3]) -1;
				}
			}
			
		}
		else 
		{
			writeln("could not find mesh file: " ~ fileName);
		}
			
		Mesh mesh = new Mesh();
		mesh.addVertices(vertices, indices);
		
		return mesh;	
	}
	
	public static Texture loadTexture(string fileName)
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
			
			return new Texture(textureId);
		}
		else
		{
			writeln("could not find texture: " ~ fileName);
		}

		return null;

//		try
//		{		
//			int id = TextureLoader.getTexture(ext, new FileInputStream(new File("./res/textures/" + fileName))).getTextureID();
//
//			return new Texture(id);
//		}
//		catch(Exception e)
//		{
//			e.printStackTrace();
//			System.exit(1);
//		}
//
//		return null;
	}

	
	
}

