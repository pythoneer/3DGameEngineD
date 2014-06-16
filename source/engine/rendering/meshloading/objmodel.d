module engine.rendering.meshloading.objmodel;

import std.stdio;
import std.string;
import std.array;
import std.conv;
import std.file;

import engine.core.vector3f;
import engine.core.vector2f;
import engine.rendering.meshloading.objindex;
import engine.rendering.meshloading.indexedmodel;

public class OBJModel
{
	private Vector3f[] positions;
	private Vector2f[] texCoords;
	private Vector3f[] normals;
	private OBJIndex[] indices;
	private bool hasTexCoords;
	private bool hasNormals;

	public this(string fileName)
	{
		hasTexCoords = false;
		hasNormals = false;
		
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
					positions ~= (new Vector3f(to!float(tokens[1]),
											to!float(tokens[2]),
											to!float(tokens[3])));

				}
				else if(tokens[0] ==("vt"))
				{
					texCoords ~= (new Vector2f(to!float(tokens[1]),
									to!float(tokens[2])));
				}
				else if(tokens[0] == ("vn"))
				{
					normals ~= (new Vector3f(to!float(tokens[1]),
											to!float(tokens[2]),
											to!float(tokens[3])));
				}
				else if(tokens[0] == ("f"))
				{
					for(int i = 0; i < tokens.length - 3; i++)
					{
						indices ~= (parseOBJIndex(tokens[1]));
						indices ~= (parseOBJIndex(tokens[2 + i]));
						indices ~= (parseOBJIndex(tokens[3 + i]));
					}
				}
			}
			
		}
		else 
		{
			writeln("could not find mesh file: " ~ fileName);
		}
	}
	
	
	public IndexedModel toIndexedModel()
	{
		IndexedModel result = new IndexedModel();
		IndexedModel normalModel = new IndexedModel();
		int[OBJIndex] resultIndexMap;
		int[int] normalIndexMap;
		int[int] indexMap;

		for(int i = 0; i < indices.length; i++)
		{
			OBJIndex currentIndex = indices[i];

			Vector3f currentPosition = positions[currentIndex.vertexIndex];
			Vector2f currentTexCoord;
			Vector3f currentNormal;

			if(hasTexCoords)
				currentTexCoord = texCoords[currentIndex.texCoordIndex];
			else
				currentTexCoord = new Vector2f(0,0);

			if(hasNormals)
				currentNormal = normals[currentIndex.normalIndex];
			else
				currentNormal = new Vector3f(0,0,0);


			int modelVertexIndex;

			if(currentIndex !in resultIndexMap)
			{
				
				modelVertexIndex = cast(int)result.getPositions().length;
				resultIndexMap[currentIndex] = modelVertexIndex;

				result.getPositions() ~= currentPosition;
				result.getTexCoords() ~= currentTexCoord;
				if(hasNormals)
					result.getNormals() ~= currentNormal;
			}
			else
			{
				modelVertexIndex = resultIndexMap[currentIndex];
			}

			int normalModelIndex;

			if(currentIndex.vertexIndex !in normalIndexMap)
			{
				
				normalModelIndex = cast(int)normalModel.getPositions().length;
				normalIndexMap[currentIndex.vertexIndex] = normalModelIndex;

				normalModel.getPositions() ~= currentPosition;
				normalModel.getTexCoords() ~= currentTexCoord;
				normalModel.getNormals() ~= currentNormal;
			}
			else
			{
				normalModelIndex = normalIndexMap[currentIndex.vertexIndex];
			}

			result.getIndices() ~= modelVertexIndex;
			normalModel.getIndices() ~= normalModelIndex;
			indexMap[modelVertexIndex] = normalModelIndex;
		}

		if(!hasNormals)
		{
			normalModel.calcNormals();

			for(int i = 0; i < result.getPositions().length; i++)
				result.getNormals() ~= (normalModel.getNormals()[indexMap[i]]);
		}

		return result;
	}
	
	private OBJIndex parseOBJIndex(string token)
	{
		string[] values = token.split("/");

		OBJIndex result = new OBJIndex();
		result.vertexIndex = to!int(values[0]) -1; 

		if(values.length > 1)
		{
			hasTexCoords = true;
			result.texCoordIndex = to!int(values[1]) -1;

			if(values.length > 2)
			{
				hasNormals = true;
				result.normalIndex = to!int(values[2]) -1;
			}
		}

		return result;
	}
}