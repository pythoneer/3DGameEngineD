module engine.rendering.renderutil;

import derelict.opengl3.gl3;

import engine.core.vector3f;

class RenderUtil
{
	public static void clearScreen()
	{
		//TODO: Stencil Buffer
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}
	
	public static void initGraphics()
	{
		glClearColor(0.15f, 0.15f, 0.15f, 1.0f);
		
		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);
		
//		glEnable(GL_DEPTH_CLAMP);
		
		glEnable(GL_TEXTURE_2D);
//		glEnable(GL_FRAMEBUFFER_SRGB);
	}
	
	public static const (char*) getOpenGLVersion()
	{
		return glGetString(GL_VERSION);
	}
	
	public static void setTextures(bool enabled)
	{
		if(enabled)
			glEnable(GL_TEXTURE_2D);
		else
			glDisable(GL_TEXTURE_2D);
	}

	public static void unbindTextures()
	{
		glBindTexture(GL_TEXTURE_2D, 0);
	}
 	
 	public static void setClearColor(Vector3f color)
 	{
 		glClearColor(color.getX(), color.getY(), color.getZ(), 1.0f);
 	}
}

