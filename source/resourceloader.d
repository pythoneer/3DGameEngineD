module resourceLoader;

import std.stdio;
import std.file;
import std.string;

import gl3n.linalg;

import vertex;
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
					Vertex tmp = new Vertex(vec3d(to!double(tokens[1]), to!double(tokens[2]), to!double(tokens[3])));
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
			
//			while((line = meshReader.readLine()) != null)
//			{
//				String[] tokens = line.split(" ");
//				tokens = Util.removeEmptyStrings(tokens);
//				
//				if(tokens.length == 0 || tokens[0].equals("#"))
//					continue;
//				else if(tokens[0].equals("v"))
//				{
//					vertices.add(new Vertex(new Vector3f(Float.valueOf(tokens[1]),
//														 Float.valueOf(tokens[2]),
//														 Float.valueOf(tokens[3]))));
//				}
//				else if(tokens[0].equals("f"))
//				{
//					indices.add(Integer.parseInt(tokens[1]) - 1);
//					indices.add(Integer.parseInt(tokens[2]) - 1);
//					indices.add(Integer.parseInt(tokens[3]) - 1);
//				}
//			}
//			
//			meshReader.close();
//			
//			Mesh res = new Mesh();
//			Vertex[] vertexData = new Vertex[vertices.size()];
//			vertices.toArray(vertexData);
//			
//			Integer[] indexData = new Integer[indices.size()];
//			indices.toArray(indexData);
//			
//			res.addVertices(vertexData, Util.toIntArray(indexData));
//			
//			return res;

		

	}
	
	
}

