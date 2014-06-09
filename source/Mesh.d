module mesh;

import derelict.opengl3.gl3;

import vertex;
import util;

class Mesh
{
	private GLuint vbo;
	private long size;
	public this()
	{
		glGenBuffers(1, &vbo);
		size = 0;
	}
	
	public void addVertices(Vertex[] vertices)
	{
		size = vertices.length;

		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * 3 * float.sizeof, Util.createBuffer(vertices).ptr, GL_STATIC_DRAW);
	}
	
	public void draw()
	{
		glEnableVertexAttribArray(0);
		
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glVertexAttribPointer(cast(uint)0, 3, GL_FLOAT, GL_FALSE, 0, null);		
		glDrawArrays(GL_TRIANGLES, 0, cast(int)size);
//		glDrawArrays(GL_TRIANGLES, 0, 3);
		
		glDisableVertexAttribArray(0);
	}
}

