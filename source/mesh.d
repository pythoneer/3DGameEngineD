module mesh;

import derelict.opengl3.gl3;

import vertex;
import util;

class Mesh
{
	private GLuint vbo;
	private GLuint ibo;
	private long size;
	
	public this()
	{
		glGenBuffers(1, &vbo);
		glGenBuffers(1, &ibo);
		size = 0;
	}
	
	public void addVertices(Vertex[] vertices, int[] indices)
	{
		size = indices.length;

		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * 3 * float.sizeof, Util.createBuffer(vertices).ptr, GL_STATIC_DRAW);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * int.sizeof, indices.ptr, GL_STATIC_DRAW);
		
	}
	
	public void draw()
	{
		glEnableVertexAttribArray(0);
		glEnableVertexAttribArray(1);
		
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glVertexAttribPointer(cast(uint)0, 3, GL_FLOAT, GL_FALSE, 0, null);		
		glVertexAttribPointer(cast(uint)1, 2, GL_FLOAT, GL_FALSE, 12, null);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
		glDrawElements(GL_TRIANGLES, cast(int)size, GL_UNSIGNED_INT, null);
		
//		glDrawArrays(GL_TRIANGLES, 0, cast(int)size);
//		glDrawArrays(GL_TRIANGLES, 0, 3);
		
		glDisableVertexAttribArray(0);
		glDisableVertexAttribArray(1);
	}
}

