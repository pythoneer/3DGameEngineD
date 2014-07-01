module engine.rendering.mesh;

import std.stdio;
import std.string;
import std.file;
import std.conv;

import derelict.opengl3.gl3;
import derelict.assimp3.assimp;
import derelict.assimp3.types;

import engine.core.util;
import engine.core.vector3f;
import engine.core.vector2f;
import engine.rendering.vertex;
//import engine.rendering.meshloading.objmodel;
//import engine.rendering.meshloading.indexedmodel;
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
		
		string meshPath = "./res/models/" ~ fileName;
		
		const aiScene* scene = aiImportFile(meshPath.toStringz(),
											aiProcess_Triangulate |
											aiProcess_GenSmoothNormals | 
											aiProcess_FlipUVs |
											aiProcess_CalcTangentSpace);
		
		if(!scene)
		{
			writeln( "Mesh load failed!: " , fileName );
//			assert(0 == 0);
		}
		else
		{
			writeln( "Mesh successfully loaded: " , fileName);
		}

		const aiMesh* model = scene.mMeshes[0];  //->mMeshes[0];
		
		Vertex[] vertices;
		int[] indices;
		
		bool hasTexCoords = model.mTextureCoords[0] !is null ;
		
		const aiVector3D aiZeroVector = aiVector3D(0.0f, 0.0f, 0.0f);
		for(uint i = 0; i < model.mNumVertices; i++) 
		{
			const aiVector3D* pPos = &(model.mVertices[i]);
			const aiVector3D* pNormal = &(model.mNormals[i]);
			const aiVector3D* pTexCoord = hasTexCoords ? &(model.mTextureCoords[0][i]) : &aiZeroVector;
			const aiVector3D* pTangent = &(model.mTangents[i]);
			
//			writeln("tx: ", pTangent.x, " ty: " , pTangent.y, " tz: ", pTangent.z);
			
			Vertex vert = new Vertex(new Vector3f(pPos.x, pPos.y, pPos.z),
					      			 new Vector2f(pTexCoord.x, pTexCoord.y),
					      			 new Vector3f(pNormal.x, pNormal.y, pNormal.z),
					      			 new Vector3f(pTangent.x, pTangent.y, pTangent.z));

			vertices ~= vert;
		}

		for(uint i = 0; i < model.mNumFaces; i++)
		{
			const aiFace face = model.mFaces[i];
			//assert(face.mNumIndices == 3);
			if(face.mNumIndices != 3) 
			{
				writeln("number of faces is not 3");
			}
			indices ~= face.mIndices[0];
			indices ~= face.mIndices[1];
			indices ~= face.mIndices[2];
		}
		
		addVertices(vertices, indices, false);
		
		aiReleaseImport(scene);		
	}
	
	
	public void draw()
	{
		int vertexSize = cast(int)(Vertex.SIZE * float.sizeof);
		
		glEnableVertexAttribArray(0);	//pos
		glEnableVertexAttribArray(1);	//tex
		glEnableVertexAttribArray(2);	//norm
		glEnableVertexAttribArray(3);	//tang
		
		glBindBuffer(GL_ARRAY_BUFFER, resource.getVbo);
		
		glVertexAttribPointer(cast(uint)0, 
							  3, 
							  GL_FLOAT, 
							  GL_FALSE, 
							  vertexSize, 
							  cast(GLvoid*)0);	//pos
							  
		glVertexAttribPointer(cast(uint)1, 
							  2, 
							  GL_FLOAT, 
							  GL_FALSE, 
							  vertexSize, 
							  cast(GLvoid*)(3 * float.sizeof));	//tex
							  
		glVertexAttribPointer(cast(uint)2, 
							  3, 
							  GL_FLOAT, 
							  GL_FALSE, 
							  vertexSize, 
							  cast(GLvoid*)(3 * float.sizeof + 2 * float.sizeof));	//norm
							  
	  	glVertexAttribPointer(cast(uint)3, 
							  3, 
							  GL_FLOAT, 
							  GL_FALSE, 
							  vertexSize, 
							  cast(GLvoid*)(3 * float.sizeof + 2 * float.sizeof + 3 * float.sizeof));	//tang
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, resource.getIbo());
		glDrawElements(GL_TRIANGLES, cast(int)resource.getSize(), GL_UNSIGNED_INT, null);
		
		glDisableVertexAttribArray(0);	//pos
		glDisableVertexAttribArray(1);	//tex
		glDisableVertexAttribArray(2);	//norm
		glDisableVertexAttribArray(3);	//tang
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

