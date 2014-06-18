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
import engine.rendering.resourcemanagement.shaderresource;
import engine.components.baselight;
import engine.components.directionallight;
import engine.components.pointlight;
import engine.components.spotlight;

class Shader
{
	private static ShaderResource[string] loadedShaders;

	private ShaderResource resource;
	private string fileName;
	 	
 	private struct GLSLStruct
	{
		public string type; 
		public string name;
	}
	
	public this(string fileName)
	{
		this.fileName = fileName;


		if(fileName in loadedShaders)
		{
			ShaderResource oldResource = loadedShaders[fileName];
			resource = oldResource;
			resource.addReference();
		}
		else
		{
			resource = new ShaderResource();

			string vertexShaderText = loadShader(fileName ~ ".vs");
			string fragmentShaderText = loadShader(fileName ~ ".fs");

			addVertexShader(vertexShaderText);
			addFragmentShader(fragmentShaderText);

			addAllAttributes(vertexShaderText);

			compileShader();

			addAllUniforms(vertexShaderText);
			addAllUniforms(fragmentShaderText);
		}
		
	}
	
	public void bind()
	{
		glUseProgram(resource.getProgram());
	}
	
	public void updateUniforms(Transform transform, Material material, RenderingEngine renderingEngine)
	{
		Matrix4f worldMatrix = transform.getTransformation();
		Matrix4f MVPMatrix = renderingEngine.getMainCamera().getViewProjection().mul(worldMatrix);

		for(int i = 0; i < resource.getUniformNames().length; i++)
		{
			string uniformName = resource.getUniformNames()[i];
			string uniformType = resource.getUniformTypes()[i];

			if(uniformType == "sampler2D")
			{
				int samplerSlot = renderingEngine.getSamplerSlot(uniformName);
				material.getTexture(uniformName).bind(samplerSlot);
				setUniformi(uniformName, samplerSlot);
			}
			else if(uniformName.startsWith("T_"))
			{
				if(uniformName == "T_MVP")
					setUniform(uniformName, MVPMatrix);
				else if(uniformName == "T_model")
					setUniform(uniformName, worldMatrix);
				else
					writeln(uniformName ~ " is not a valid component of Transform");
			}
			else if(uniformName.startsWith("R_"))
			{
				string unprefixedUniformName = uniformName[2 .. $];
				if(uniformType == "vec3")
					setUniform(uniformName, renderingEngine.getVector3f(unprefixedUniformName));
				else if(uniformType == "float")
					setUniformf(uniformName, renderingEngine.getFloat(unprefixedUniformName));
				else if(uniformType == "DirectionalLight")
					setUniformDirectionalLight(uniformName, cast(DirectionalLight)renderingEngine.getActiveLight());
				else if(uniformType == "PointLight")
					setUniformPointLight(uniformName, cast(PointLight)renderingEngine.getActiveLight());
				else if(uniformType == "SpotLight")
					setUniformSpotLight(uniformName, cast(SpotLight)renderingEngine.getActiveLight());
				else
					renderingEngine.updateUniformStruct(transform, material, this, uniformName, uniformType);
			}
			else if(uniformName.startsWith("C_"))
			{
				if(uniformName == "C_eyePos")
					setUniform(uniformName, renderingEngine.getMainCamera().getTransform().getTransformedPos());
				else
					writeln(uniformName ~ " is not a valid component of Camera");
			}
			else
			{
				if(uniformType == "vec3")
					setUniform(uniformName, material.getVector3f(uniformName));
				else if(uniformType == "float")
					setUniformf(uniformName, material.getFloat(uniformName));
				else
					writeln(uniformType ~ " is not a supported type in Material");
			}
		}
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
 			resource.getUniformNames() ~= attr[2];
			resource.getUniformTypes() ~= attr[1];
			addUniform(attr[2], attr[1], structs);
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
	
	
	private void addUniform(string uniformName, string uniformType, GLSLStruct[][string] strs)
	{
		if(uniformType in strs)
		{
			GLSLStruct[] structComponents = strs[uniformType];
			foreach(GLSLStruct str; structComponents)
			{
				addUniform(uniformName ~ "." ~ str.name, str.type, strs);
			}
		}
		else
		{
//			addUniform(uniformName);
			int uniformLocation = glGetUniformLocation(resource.getProgram(), uniformName.toStringz());
			
			if(uniformLocation == 0xFFFFFFFF)
			{
				writeln("Error: Could not find uniform: " ~ uniformName);
			}
			
			resource.getUniforms()[uniformName] = uniformLocation;
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
		
		return shaderSource;
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

		glLinkProgram(resource.getProgram());

		int status, len;
		glGetProgramiv(resource.getProgram(), GL_LINK_STATUS, &status);
		if(status==GL_FALSE){
			writeln("shader compile failed");
			glGetProgramiv(resource.getProgram(), GL_INFO_LOG_LENGTH, &len);
			writeln(len);
			char[] error = new char[len];
			glGetProgramInfoLog(resource.getProgram(), len, null, cast(char*)error);
			writeln(error);
//			Runtime.terminate();
		}

		glValidateProgram(resource.getProgram());
		glGetProgramiv(resource.getProgram(), GL_VALIDATE_STATUS, &status);
		if(status==GL_FALSE){
			writeln("shader compile failed");
			glGetProgramiv(resource.getProgram(), GL_INFO_LOG_LENGTH, &len);
			writeln(len);
			char[] error = new char[len];
			glGetProgramInfoLog(resource.getProgram(), len, null, cast(char*)error);
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

		glAttachShader(resource.getProgram(), shader);
	}
	
	private void setAttribLocation(string attributeName, int location)
 	{
 		const char* c_attribName = attributeName.toStringz();
 		glBindAttribLocation(resource.getProgram(), location, c_attribName);
 	}
	
	public void setUniformi(string uniformName, int value)
	{
		glUniform1i(resource.getUniforms()[uniformName], value);
	}
	
	public void setUniformf(string uniformName, float value)
	{
		glUniform1f(resource.getUniforms()[uniformName], value);
	}
	
	public void setUniform(string uniformName, Vector3f value)
	{
		glUniform3f(resource.getUniforms()[uniformName], value.getX(), value.getY(), value.getZ());
	}
	
	public void setUniform(string uniformName, Matrix4f value)
	{
		glUniformMatrix4fv(resource.getUniforms()[uniformName], 1, GL_TRUE, Util.createBuffer(value).ptr);
	}
	 	
 	public void setUniformBaseLight(string uniformName, BaseLight baseLight)
	{
		setUniform(uniformName ~ ".color", baseLight.getColor());
		setUniformf(uniformName ~ ".intensity", baseLight.getIntensity());
	}

	public void setUniformDirectionalLight(string uniformName, DirectionalLight directionalLight)
	{
		setUniformBaseLight(uniformName ~ ".base", directionalLight);
		setUniform(uniformName ~ ".direction", directionalLight.getDirection());
	}

	public void setUniformPointLight(string uniformName, PointLight pointLight)
	{
		setUniformBaseLight(uniformName ~ ".base", pointLight);
		setUniformf(uniformName ~ ".atten.constant", pointLight.getConstant());
		setUniformf(uniformName ~ ".atten.linear", pointLight.getLinear());
		setUniformf(uniformName ~ ".atten.exponent", pointLight.getExponent());
		setUniform(uniformName ~ ".position", pointLight.getTransform().getTransformedPos());
		setUniformf(uniformName ~ ".range", pointLight.getRange());
	}

	public void setUniformSpotLight(string uniformName, SpotLight spotLight)
	{
		setUniformPointLight(uniformName ~ ".pointLight", spotLight);
		setUniform(uniformName ~ ".direction", spotLight.getDirection());
		setUniformf(uniformName ~ ".cutoff", spotLight.getCutoff());
	}
	
}

