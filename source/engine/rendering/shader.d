module engine.rendering.shader;

import std.stdio;
import std.file;
import core.runtime;
import std.string;
import std.conv;
import std.algorithm;
import std.regex;

import derelict.opengl3.gl3;

import engine.core.vector3f;
import engine.core.matrix;
import engine.core.util;
import engine.core.transform;
import engine.rendering.material;
import engine.rendering.renderingengine;

class Shader
{
	private int program;
	private int[string] uniforms;
	private RenderingEngine renderingEngine;
	
	 	
 	private struct GLSLStruct
	{
		public string type;
		public string name;
	}
	
	public this(string shaderName)
	{
		program = glCreateProgram();
		
		if(program == 0)
		{
			writeln("Shader creation failed: Could not find valid memory location in constructor");
//			Runtime.terminate();
		}
		
		string vertexShaderText = loadShader(shaderName ~ ".vs");
		string fragmentShaderText = loadShader(shaderName ~ ".fs");

		addVertexShader(vertexShaderText);
		addFragmentShader(fragmentShaderText);

		addAllAttributes(vertexShaderText);

		compileShader();

		addAllUniforms(vertexShaderText);
		addAllUniforms(fragmentShaderText);
		
	}
	
	
	private void addAllAttributes(string shaderText)
 	{
 		auto attrRegex = regex(r"attribute\s+(\w+)\s+(\w+)\s*;", "gm");
 		auto m = match(shaderText, attrRegex);
 		int i = 0;
 		foreach(attr; m)
 		{	
 			setAttribLocation(attr[2], i++);		
 		}
 	}
 	
 	private void addAllUniforms(string shaderText)
	{
		GLSLStruct[][string] structs = findUniformStructs(shaderText);

		auto attrRegex = regex(r"uniform\s+(\w+)\s+(\w+)\s*;", "gm");
 		auto m = match(shaderText, attrRegex);
 		
 		foreach(attr; m)
 		{
 			addUniformWithStructCheck(attr[2], attr[1], structs);
 		}
	}


	private GLSLStruct[][string] findUniformStructs(string shaderText)
	{
		
		GLSLStruct[][string] result;
		
		auto structRegex = regex(r"struct\s+(\w+)\s*\{((.*\s*)+?)\};", "gm");
		auto attrRegex = regex(r"\s*(\w+)\s+(\w+)\s*;", "gm");
		auto m = match(shaderText, structRegex);
		
		foreach(str; m)
		{
			auto mattr = match(str[2], attrRegex);
			
			GLSLStruct[] glslStructs;
			
			foreach(attr; mattr)
			{
				GLSLStruct glslStruct;			
				glslStruct.type = attr[1];
				glslStruct.name = attr[2];	
				
				glslStructs ~= glslStruct;			
			}
			
			result[str[1]] = glslStructs;
		}
				
		return result;
	}
	
	
	private void addUniformWithStructCheck(string uniformName, string uniformType, GLSLStruct[][string] strs)
	{
		if(uniformType in strs)
		{
			GLSLStruct[] structComponents = strs[uniformType];
			foreach(GLSLStruct str; structComponents)
			{
				addUniformWithStructCheck(uniformName ~ "." ~ str.name, str.type, strs);
			}
		}
		else
		{
			addUniform(uniformName);
		}
	}
 	
	private static string loadShader(string fileName)
	{
		const string INCLUDE_DIRECTIVE = "#include";
		
		string shaderPath = "./res/shaders/" ~ fileName;
		string shaderSource = "";

		if(exists(shaderPath)!=0) {
			File file = File(shaderPath, "r");
			
			while (!file.eof()) {
				string line = chomp(file.readln());
//				shaderSource ~= line ~ "\n";
				
				if(line.startsWith(INCLUDE_DIRECTIVE))
 				{
 					auto index = indexOf(line, INCLUDE_DIRECTIVE);
 					auto src = loadShader(line[index + 10 .. $-1]);
 					shaderSource ~= src;
 				}
 				else
 				{
 					shaderSource ~= line ~ "\n";
 				}				
			}
		}
		else 
		{
			writefln("could not find shader: %s", fileName);
		}

//		writeln("\n\nshaderSource:\n");
//		writeln(shaderSource);

		return shaderSource;
	}
	
	public void bind()
	{
		glUseProgram(program);
	}
	
	private void addVertexShader(string text)
	{
		addProgram(text, GL_VERTEX_SHADER);
	}
	
	private void addGeometryShader(string text)
	{
		addProgram(text, GL_GEOMETRY_SHADER);
	}
	
	private void addFragmentShader(string text)
	{
		addProgram(text, GL_FRAGMENT_SHADER);
	}
	
	private void compileShader()
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
	
	private void addUniform(string uniform)
	{
		int uniformLocation = glGetUniformLocation(program, uniform.toStringz());
		
		if(uniformLocation == 0xFFFFFFFF)
		{
			writeln("Error: Could not find uniform: " ~ uniform);
		}
		
		uniforms[uniform] = uniformLocation;
	}
	
	private void setAttribLocation(string attributeName, int location)
 	{
 		const char* c_attribName = attributeName.toStringz();
 		glBindAttribLocation(program, location, c_attribName);
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
	
	public void updateUniforms(Transform transform, Material material, RenderingEngine renderingEngine)
	{

	}
	
	public void setRenderingEngine(RenderingEngine renderingEngine)
 	{
 		this.renderingEngine = renderingEngine;
 	}
 
 	public RenderingEngine getRenderingEngine()
 	{
 		return renderingEngine;
 	}
	
}

