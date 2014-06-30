module engine.rendering.resourcemanagement.shaderresource;

import std.stdio;

import derelict.opengl3.gl3;

public class ShaderResource
{
	private GLuint program;
	private int[string] uniforms;
	private string[] uniformNames;
	private string[] uniformTypes;
	private int refCount;

	public this()
	{
		this.program = glCreateProgram();
		this.refCount = 1;

		if(program == 0)
		{
			writeln("Shader creation failed: Could not find valid memory location in constructor");
		}
	}

	public ~this()
	{
		glDeleteBuffers(1, &program);
	}

	public void addReference()
	{
		refCount++;
	}

	public bool removeReference()
	{
		refCount--;
		return refCount == 0;
	}

	public int getProgram() { return program; }

	public ref int[string] getUniforms() {
		return uniforms;
	}

	public ref string[] getUniformNames() {
		return uniformNames;
	}

	public ref string[] getUniformTypes() {
		return uniformTypes;
	}
}