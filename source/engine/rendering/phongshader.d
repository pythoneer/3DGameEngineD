module engine.rendering.phongshader;

import std.stdio;
import std.string;

import engine.core.vector3f;
import engine.core.matrix;
import engine.core.transform;
import engine.rendering.material;
import engine.rendering.renderutil;
import engine.rendering.directionallight;
import engine.rendering.baselight;
import engine.rendering.shader;

import engine.rendering.pointlight;
import engine.rendering.spotlight;	

class PhongShader : Shader
{
	private static const int MAX_POINT_LIGHTS = 4;
	private static final int MAX_SPOT_LIGHTS = 4;
	private PointLight[] pointLights;
	private SpotLight[] spotLights;

	private  Vector3f ambientLight = new Vector3f(0.1f,0.1f,0.1f);
	private  DirectionalLight directionalLight = new DirectionalLight(new BaseLight(new Vector3f(0,0,0), 0), new Vector3f(0,0,0));

	public this()
	{
		super();
		addVertexShaderFromFile("phongVertex.vs");
 		addFragmentShaderFromFile("phongFragment.fs");
		compileShader();

		addUniform("transform");
		addUniform("transformProjected");
		addUniform("baseColor");
		addUniform("ambientLight");
		
		addUniform("specularIntensity");
 		addUniform("specularPower");
 		addUniform("eyePos");
		
		addUniform("directionalLight.base.color");
 		addUniform("directionalLight.base.intensity");
 		addUniform("directionalLight.direction");
 		
 		for(int i = 0; i < MAX_POINT_LIGHTS; i++)
 		{
 			addUniform(format("pointLights[%d].base.color", i));
 			addUniform(format("pointLights[%d].base.intensity", i));
 			addUniform(format("pointLights[%d].atten.constant", i));
 			addUniform(format("pointLights[%d].atten.linear", i));
 			addUniform(format("pointLights[%d].atten.exponent", i));
 			addUniform(format("pointLights[%d].position", i));
 			addUniform(format("pointLights[%d].range",i));
 		}
 		
 		for(int i = 0; i < MAX_SPOT_LIGHTS; i++)
 		{
 			addUniform(format("spotLights[%d].pointLight.base.color", i));
 			addUniform(format("spotLights[%d].pointLight.base.intensity", i));
 			addUniform(format("spotLights[%d].pointLight.atten.constant", i));
 			addUniform(format("spotLights[%d].pointLight.atten.linear", i));
 			addUniform(format("spotLights[%d].pointLight.atten.exponent", i));
 			addUniform(format("spotLights[%d].pointLight.position", i));
 			addUniform(format("spotLights[%d].pointLight.range", i));
 			addUniform(format("spotLights[%d].direction", i));
 			addUniform(format("spotLights[%d].cutoff", i));
  		}
 		
	}

	override
	public void updateUniforms(Matrix4f worldMatrix, Matrix4f projectedMatrix, Material material)
	{
		if(material.getTexture() !is null)
			material.getTexture().bind();
		else
			RenderUtil.unbindTextures();

		super.setUniform("transformProjected", projectedMatrix);
 		super.setUniform("transform", worldMatrix);
  		super.setUniform("baseColor", material.getColor());
  		super.setUniform("ambientLight", ambientLight);
 		setUniform("directionalLight", directionalLight);
 		
 		super.setUniformf("specularIntensity", material.getSpecularIntensity());
 		super.setUniformf("specularPower", material.getSpecularPower());
 		
 		super.setUniform("eyePos", Transform.getCamera().getPos());
 		
 		for(int i = 0; i < pointLights.length; i++)
 		{
 			setUniform(format("pointLights[%d]",i), pointLights[i]);
 		}
 		
 		for(int i = 0; i < spotLights.length; i++)
 		{
 			setUniform(format("spotLights[%d]",i), spotLights[i]);
 		}		
 			
	}

	public Vector3f getAmbientLight()
	{
		return ambientLight;
	}

	public void setAmbientLight(Vector3f ambientLight)
	{
		PhongShader.ambientLight = ambientLight;
	}
	
	public void setDirectionalLight(DirectionalLight directionalLight)
	{
		PhongShader.directionalLight = directionalLight;
	}
	
	public void setPointLight(PointLight[] pointLights)
 	{
 		if(pointLights.length > MAX_POINT_LIGHTS)
 		{
 			writefln("Error: You passed in too many point lights. Max allowed is %d , you passed in %d" ,MAX_POINT_LIGHTS, pointLights.length  );	
 			return;
 		}
 		
 		PhongShader.pointLights = pointLights;
 	}
 	
 	public void setSpotLights(SpotLight[] spotLights)
 	{
 		if(spotLights.length > MAX_SPOT_LIGHTS)
 		{
 			writefln("Error: You passed in too many spot lights. Max allowed is %d, you passed in %d" , MAX_SPOT_LIGHTS, spotLights.length);
 			return;
 		}
 		
 		PhongShader.spotLights = spotLights;
 	}

	public void setUniform(string uniformName, BaseLight baseLight)
	{
		super.setUniform(uniformName ~ ".color", baseLight.getColor());
		setUniformf(uniformName ~ ".intensity", baseLight.getIntensity());
	}

	public void setUniform(string uniformName, DirectionalLight directionalLight)
	{
		setUniform(uniformName ~ ".base", directionalLight.getBase());
		super.setUniform(uniformName ~ ".direction", directionalLight.getDirection());
	}
	
	public void setUniform(string uniformName, PointLight pointLight)
 	{
 		setUniform(uniformName ~ ".base", pointLight.getBaseLight());
 		setUniformf(uniformName ~ ".atten.constant", pointLight.getAtten().getConstant());
 		setUniformf(uniformName ~ ".atten.linear", pointLight.getAtten().getLinear());
 		setUniformf(uniformName ~ ".atten.exponent", pointLight.getAtten().getExponent());
 		super.setUniform(uniformName ~ ".position", pointLight.getPosition());
 		setUniformf(uniformName ~ ".range", pointLight.getRange());
 	}
 	
 	public void setUniform(string uniformName, SpotLight spotLight)
 	{
 		setUniform(uniformName ~ ".pointLight", spotLight.getPointLight());
 		super.setUniform(uniformName ~ ".direction", spotLight.getDirection());
 		setUniformf(uniformName ~ ".cutoff", spotLight.getCutoff());
 	}
}