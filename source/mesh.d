module mesh;

import std.stdio;
import std.string;
import std.file;
import std.conv;

import derelict.opengl3.gl3;

import vertex;
import util;
import vector3f;
import vector2f;

class Mesh
{
	private GLuint vbo;
	private GLuint ibo;
	private long size;
	
	public this(string fileName)
	{
		initMeshData();
 		loadMesh(fileName);
	}
	
	public this(Vertex[] vertices, int[] indices)
 	{
 		this(vertices, indices, false);
 	}
 	
 	public this(Vertex[] vertices, int[] indices, bool calcNormals)
 	{
 		initMeshData();
 		addVertices(vertices, indices, calcNormals);
  	}
 	
 	private void initMeshData()
  	{
 		glGenBuffers(1, &vbo);
 		glGenBuffers(1, &ibo);
 		size = 0;
  	}
 	
	
	private void addVertices(Vertex[] vertices, int[] indices)
	{
		addVertices(vertices, indices, false);
	}

	private void addVertices(Vertex[] vertices, int[] indices, bool calcNormals)
	{
		if(calcNormals)
		{
			this.calcNormals(vertices, indices);
		}

		size = indices.length;

		float[] vertexDataArray = Util.createBuffer(vertices);
		
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glBufferData(GL_ARRAY_BUFFER, vertexDataArray.length * float.sizeof, vertexDataArray.ptr, GL_STATIC_DRAW);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * int.sizeof, indices.ptr, GL_STATIC_DRAW);
	}
	
	public void loadMesh(string fileName)
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
			
		addVertices(vertices, indices, true);
	}
	
	
	public void draw()
	{
		glEnableVertexAttribArray(0);	//pos
		glEnableVertexAttribArray(1);	//tex
		glEnableVertexAttribArray(2);	//norm
		
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		
		glVertexAttribPointer(cast(uint)0, 
							  3, 
							  GL_FLOAT, 
							  GL_FALSE, 
							  8 * float.sizeof, 
							  cast(GLvoid*)0);	//pos
							  
		glVertexAttribPointer(cast(uint)1, 
							  2, 
							  GL_FLOAT, 
							  GL_FALSE, 
							  8 * float.sizeof, 
							  cast(GLvoid*)(3 * float.sizeof));	//tex
							  
		glVertexAttribPointer(cast(uint)2, 
							  3, 
							  GL_FLOAT, 
							  GL_FALSE, 
							  8 * float.sizeof, 
							  cast(GLvoid*)(3 * float.sizeof + 2 * float.sizeof));	//norm
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
		glDrawElements(GL_TRIANGLES, cast(int)size, GL_UNSIGNED_INT, null);
		
		glDisableVertexAttribArray(0);	//pos
		glDisableVertexAttribArray(1);	//tex
		glDisableVertexAttribArray(2);	//norm
	}
	
	private void calcNormals(Vertex[] vertices, int[] indices)
	{
		for(int i = 0; i < indices.length; i += 3)
		{
			int i0 = indices[i];
			int i1 = indices[i + 1];
			int i2 = indices[i + 2];

			Vector3f v1 = vertices[i1].getPos().sub(vertices[i0].getPos());
			Vector3f v2 = vertices[i2].getPos().sub(vertices[i0].getPos());

			Vector3f normal = v1.cross(v2).normalized();

			vertices[i0].setNormal(vertices[i0].getNormal().add(normal));
			vertices[i1].setNormal(vertices[i1].getNormal().add(normal));
			vertices[i2].setNormal(vertices[i2].getNormal().add(normal));
		}

		for(int i = 0; i < vertices.length; i++)
		{
			vertices[i].setNormal(vertices[i].getNormal().normalized());
		}
	}

}

