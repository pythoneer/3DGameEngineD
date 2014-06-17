module engine.rendering.mesh;

import std.stdio;
import std.string;
import std.file;
import std.conv;

import derelict.opengl3.gl3;

import engine.core.util;
import engine.core.vector3f;
import engine.core.vector2f;
import engine.rendering.vertex;
import engine.rendering.meshloading.objmodel;
import engine.rendering.meshloading.indexedmodel;
import engine.rendering.resourcemanagement.meshresource;

class Mesh
{
	private static MeshResource[string] loadedModels;
 	private MeshResource resource;
 	private string fileName;
	
	public this(string fileName)
	{
		this.fileName = fileName;

		if(fileName in loadedModels)
		{
			resource = loadedModels[fileName];
			resource.addReference();
		}
		else
		{
			loadMesh(fileName);
			loadedModels[fileName] = resource;
		}
	}
	
	public this(Vertex[] vertices, int[] indices)
 	{
 		this(vertices, indices, false);
 	}
 	
 	public this(Vertex[] vertices, int[] indices, bool calcNormals)
 	{
 		fileName = "";
 		addVertices(vertices, indices, calcNormals);
  	}
 	
 	public ~this()
	{
		if(resource.removeReference() && fileName.length != 0)
		{
			loadedModels.remove(fileName);
		}
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

		resource = new MeshResource(cast(int)indices.length);

		float[] vertexDataArray = Util.createBuffer(vertices);
		
		glBindBuffer(GL_ARRAY_BUFFER, resource.getVbo());
		glBufferData(GL_ARRAY_BUFFER, vertexDataArray.length * float.sizeof, vertexDataArray.ptr, GL_STATIC_DRAW);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, resource.getIbo());
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * int.sizeof, indices.ptr, GL_STATIC_DRAW);
	}
	
	public void loadMesh(string fileName)
	{
		
		OBJModel test = new OBJModel(fileName);
 		IndexedModel model = test.toIndexedModel();
 		model.calcNormals();
 		
 		
 		Vertex[] vertices;

		for(int i = 0; i < model.getPositions().length; i++)
		{
			vertices ~= new Vertex(model.getPositions()[i],
					model.getTexCoords()[i],
					model.getNormals()[i]);
		}

		addVertices(vertices, model.getIndices(), false);
		
	}
	
	
	public void draw()
	{
		glEnableVertexAttribArray(0);	//pos
		glEnableVertexAttribArray(1);	//tex
		glEnableVertexAttribArray(2);	//norm
		
		glBindBuffer(GL_ARRAY_BUFFER, resource.getVbo);
		
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
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, resource.getIbo());
		glDrawElements(GL_TRIANGLES, cast(int)resource.getSize(), GL_UNSIGNED_INT, null);
		
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

