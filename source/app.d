import std.stdio;
import std.string;

import derelict.opengl3.gl;

import engine.core.coreengine;
//import testgame; 
import normalmappinggame;

int main()
{

	CoreEngine engine = new CoreEngine(800, 600, 60, new NormalMappingGame());
	engine.createWindow("3D Game Engine");
	engine.start();

	return 0;
}
