module resourceLoader;

import std.stdio;
import std.file;
import std.string;
import std.conv;

//import gl3n.linalg;

import vertex;
import vector3f;
import mesh;


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
			writefln("could not find resource: %s", fileName);
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
			writeln("could not find resource file: " ~ fileName);
		}
			
		Mesh mesh = new Mesh();
		mesh.addVertices(vertices, indices);
		
		return mesh;	
	}
	
	
}

