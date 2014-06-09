module resourceLoader;

import std.stdio;
import std.file;
import std.string;

class ResourceLoader
{
	public static string loadShader(string fileName)
	{
		string shaderPath = "./res/shaders/" ~ fileName;
		string shaderSource = "";

		if(exists(shaderPath)!=0) {
			File file = File(shaderPath, "r");
			
			while (!file.eof()) {
				string line = chomp(file.readln());
				shaderSource ~= line ~ "\n";
			}
		}
		else 
		{
			writefln("could not find resource: %s", fileName);
		}

//		writeln("\n\nshaderSource:\n");
//		writeln(shaderSource);

		return shaderSource;
	}
}

