module shader;

import std.stdio;
import core.runtime;
import std.string;

import derelict.opengl3.gl3;
//import gl3n.linalg;

import vector3f;
import matrix;
import util;

class Shader
{
	private int program;
	private int[string] uniforms;
	
	public this()
	{
		program = glCreateProgram();
		
		if(program == 0)
		{
			writeln("Shader creation failed: Could not find valid memory location in constructor");
//			Runtime.terminate();
		}
	}
	
	public void bind()
	{
		glUseProgram(program);
	}
	
	public void addVertexShader(string text)
	{
		addProgram(text, GL_VERTEX_SHADER);
	}
	
	public void addGeometryShader(string text)
	{
		addProgram(text, GL_GEOMETRY_SHADER);
	}
	
	public void addFragmentShader(string text)
	{
		addProgram(text, GL_FRAGMENT_SHADER);
	}
	
	public void compileShader()
	{

		glLinkProgram(program);

		int status, len;
		glGetProgramiv(program, GL_LINK_STATUS, &status);
		if(status==GL_FALSE){
			writeln("shader compile failed");
			glGetProgramiv(program, GL_INFO_LOG_LENGTH, &len);
			writeln(len);
			char[] error = new char[len];
			glGetProgramInfoLog(program, len, null, cast(char*)error);
			writeln(error);
//			Runtime.terminate();
		}

		glValidateProgram(program);
		glGetProgramiv(program, GL_VALIDATE_STATUS, &status);
		if(status==GL_FALSE){
			writeln("shader compile failed");
			glGetProgramiv(program, GL_INFO_LOG_LENGTH, &len);
			writeln(len);
			char[] error = new char[len];
			glGetProgramInfoLog(program, len, null, cast(char*)error);
			writeln(error);
//			Runtime.terminate();
		}

	}
	
	private void addProgram(string text, int type)
	{
		uint shader = glCreateShader(type);
		
		if(shader == 0)
		{
			writeln("Shader creation failed: Could not find valid memory location when adding shader");
			Runtime.terminate();
		}

		const char *src = text.toStringz(); 
		glShaderSource(shader, 1, &src, null);
		glCompileShader(shader);

		int status, len;
		glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
		if(status==GL_FALSE){
			writeln("addProgram failed");
			glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &len);
			char[] error=new char[len];
			glGetShaderInfoLog(shader, len, null, cast(char*)error);
			writeln(error);
//			Runtime.terminate();
		}

		glAttachShader(program, shader);
	}
	
	public void addUniform(string uniform)
	{
		int uniformLocation = glGetUniformLocation(program, uniform.toStringz());
		
		if(uniformLocation == 0xFFFFFFFF)
		{
			writeln("Error: Could not find uniform: " ~ uniform);
		}
		
		uniforms[uniform] = uniformLocation;
	}
	
	public void setUniformi(string uniformName, int value)
	{
		glUniform1i(uniforms[uniformName], value);
	}
	
	public void setUniformf(string uniformName, float value)
	{
		glUniform1f(uniforms[uniformName], value);
	}
	
	public void setUniform(string uniformName, Vector3f value)
	{
		glUniform3f(uniforms[uniformName], value.getX(), value.getY(), value.getZ());
	}
	
	public void setUniform(string uniformName, Matrix4f value)
	{
		glUniformMatrix4fv(uniforms[uniformName], 1, GL_TRUE, Util.createBuffer(value).ptr);
	}
	
}

